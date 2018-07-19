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
import HGPlaceholders

class TasksListViewModel: NSObject {
    
    private let db = DisposeBag()
    private let tableView: UITableView
    let tasks = BehaviorRelay<[Task]>(value: [])
    let reloadSignal = PublishSubject<Void>()
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        setupTableView()
        maintainTasksList()
    }
    
    // MARK: - Setup
    
    private func setupTableView() {
        tableView.dataSource = self
    }
    
    private func maintainTasksList() {
        
        let fetchedTasks = reloadSignal
            .startWith(())
            .flatMapLatest({ [weak self] _ -> Observable<Array<Task>> in
                guard let sSelf = self else { throw NSError.deallocatedReference }
                return try sSelf.tasksArray()
            })
            .share(replay: 1, scope: .whileConnected)
        
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
    
    private func tasksArray() throws -> Observable<Array<Task>> {
        let realm = try Realm()
        let tasksEntities = realm.objects(Task.self)
            .sorted(byKeyPath: #keyPath(Task.editedAt))
        return Observable.array(from: tasksEntities)
    }
    
    func toggleCompletedState(for task: Task) throws {
        let realm = try Realm()
        guard task.realm == realm, !task.isInvalidated else { throw RxRealmError.unknown }
        try realm.write {
            task.isCompleted = !task.isCompleted
        }
    }
    
    func delete(task: Task) throws {
        let realm = try Realm()
        guard task.realm == realm, !task.isInvalidated else { throw RxRealmError.unknown }
        try realm.write {
            realm.delete(task)
        }
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
