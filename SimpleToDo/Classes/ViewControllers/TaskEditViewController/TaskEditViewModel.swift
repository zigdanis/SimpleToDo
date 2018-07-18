//
//  TaskEditViewModel.swift
//  SimpleToDo
//
//  Created by Danis Ziganshin on 17/07/2018.
//  Copyright © 2018 ziganshin. All rights reserved.
//

import Foundation
import RxSwift
import RxSwiftExt
import RealmSwift
import RxRealm

class TaskEditViewModel {
    
    private let db = DisposeBag()
    private let textStream: Observable<String?>
    private let newTaskSignal = PublishSubject<Void>()
    private let editTaskSignal = PublishSubject<Void>()
    private var taskId: ThreadSafeReference<Task>?
    
    init(textStream: Observable<String?>, task: Task? = nil) {
        self.textStream = textStream
        if let task = task {
            self.taskId = ThreadSafeReference(to: task)
        }
        maintainNewTaskSaving()
        maintainEditingTask()
    }
    
    // MARK: - Setup
    
    private func maintainNewTaskSaving() {
        newTaskSignal.withLatestFrom(textStream) { $1 }
            .unwrap()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMapLatest({ [weak self] text -> Observable<Task> in
                guard let sSelf = self else { throw NSError.deallocatedReference }
                return try sSelf.saveNewTaskToRealm(text: text)
            })
            .subscribe()
            .disposed(by: db)
    }
    
    private func maintainEditingTask() {
        editTaskSignal.withLatestFrom(textStream) { $1 }
            .unwrap()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMapLatest({ [weak self] text -> Observable<Task> in
                guard let sSelf = self else { throw NSError.deallocatedReference }
                guard let taskId = sSelf.taskId else { throw NSError.missingValue }
                return try sSelf.editTaskInRealm(text: text, taskId: taskId)
            })
            .subscribe()
            .disposed(by: db)
    }
    
    // MARK: - Actions
    
    func createNewTask() {
        newTaskSignal.onNext(())
    }
    
    func editTask() {
        editTaskSignal.onNext(())
    }
    
    private func saveNewTaskToRealm(text: String) throws -> Observable<Task> {
        return Observable<Task>.create { observer -> Disposable in
            do {
                let task = Task(text: text)
                let realm = try Realm()
                try realm.write {
                    realm.add(task)
                }
                observer.onNext(task)
                observer.onCompleted()
            } catch {
                observer.onError(RxRealmError.unknown)
            }
            return Disposables.create()
        }
        
    }

    private func editTaskInRealm(text: String, taskId: ThreadSafeReference<Task>) throws -> Observable<Task> {
        return Observable<Task>.create { observer -> Disposable in
            do {
                let realm = try Realm()
                guard let realmTask = realm.resolve(taskId) else { throw NSError.missingValue }
                try realm.write {
                    realmTask.text = text
                }
                observer.onNext(realmTask)
                observer.onCompleted()
            } catch {
                observer.onError(RxRealmError.unknown)
            }
            return Disposables.create()
        }
        
    }

}
