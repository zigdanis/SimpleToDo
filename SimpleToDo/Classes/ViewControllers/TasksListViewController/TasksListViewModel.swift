//
//  TasksListViewModel.swift
//  SimpleToDo
//
//  Created by Danis Ziganshin on 17/07/2018.
//  Copyright © 2018 ziganshin. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import RxSwift
import RxCocoa
import RxRealm

class TasksListViewModel: NSObject {
    
    private let db = DisposeBag()
    private let tableView: UITableView
    let tasks = BehaviorRelay<[Task]>(value: [])
    let reloadSignal = PublishSubject<Void>()
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        setupTableView()
        maintainLoadingTasks()
    }
    
    // MARK: - Setup
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func maintainLoadingTasks() {
        let fetchedTasks = reloadSignal
            .startWith(())
            .flatMapLatest({ [weak self] _ -> Observable<Results<Task>> in
                guard let sSelf = self else { throw NSError.deallocatedReference }
                return sSelf.reloadTasks()
            })
            .map({ Array($0) })
            
        fetchedTasks
            .bind(to: tasks)
            .disposed(by: db)
        fetchedTasks
            .subscribe(onNext: { [weak tableView] _ in
                tableView?.reloadData()
            })
            .disposed(by: db)
    }
    
    // MARK: - Actions
    
    func reloadTasks() -> Observable<Results<Task>> {
        
        let realmObjectsReference = Observable<ThreadSafeReference<Results<Task>>>.create { observer -> Disposable in
            do {
                let realm = try Realm()
                let tasksEntities = realm.objects(Task.self)
                    .sorted(byKeyPath: #keyPath(Task.editedAt))
                let tasksReference = ThreadSafeReference(to: tasksEntities)
                observer.onNext(tasksReference)
                observer.onCompleted()
            } catch {
                observer.onError(RxRealmError.unknown)
            }
            return Disposables.create()
        }
        return realmObjectsReference
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .map({ reference -> Results<Task>? in
                let realm = try Realm()
                return realm.resolve(reference)
            })
            .unwrap()
    }
    
    func addNewTask() {
        // TODO: - Add new Task
    }
    
}

extension TasksListViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = R.nib.taskCell.identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TaskCell
        let task = tasks.value[indexPath.row]
        cell.setup(with: task)
        return cell
    }
}
