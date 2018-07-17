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
    
    init(textStream: Observable<String?>) {
        self.textStream = textStream
        maintainNewTaskSaving()
    }
    
    // MARK: - Setup
    
    private func maintainNewTaskSaving() {
        newTaskSignal.withLatestFrom(textStream) { $1 }
            .unwrap()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMapLatest({ [weak self] text -> Observable<Task> in
                guard let sSelf = self else { throw NSError.deallocatedReference }
                return try sSelf.saveTaskToRealm(text: text)
            })
            .debug()
            .subscribe()
            .disposed(by: db)
    }
    
    // MARK: - Actions
    
    func createNewTask() {
        newTaskSignal.onNext(())
    }
    
    private func saveTaskToRealm(text: String) throws -> Observable<Task> {
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
}
