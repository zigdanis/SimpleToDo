//
//  TaskListViewModelTests.swift
//  SimpleToDoTests
//
//  Created by Danis Ziganshin on 17/07/2018.
//  Copyright © 2018 ziganshin. All rights reserved.
//

import XCTest
import UIKit
import RealmSwift
import RxBlocking
@testable import SimpleToDo

class TaskListViewModelTests: XCTestCase {
    
    var tv: UITableView?
    var sut: TasksListViewModel?
    
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "InMemoryRealm"
        tv = UITableView(frame: .zero, style: .plain)
        sut = TasksListViewModel(tableView: tv!)
    }
    
    func testSUT_AfterInit_ShouldBeDataSourceOfCollectionView() {
        XCTAssert(sut != nil)
        XCTAssert(tv?.dataSource != nil)
        XCTAssert(tv!.dataSource! === sut!)
    }
    
    func testSUT_With3TasksInRealm_ShouldLoadThemToTasksProperty() {
        setupRealmWith3Tasks()
        sut?.reloadTasksList()
        do {
            let result = try sut!.tasks.toBlocking(timeout: 1).first()
            XCTAssertEqual(result!.count, 3)
        } catch {
            XCTAssert(false, error.localizedDescription)
        }
    }
    
    // MARK: - Helpers
    
    private func setupRealmWith3Tasks() {
        let realm = try! Realm()
        try! realm.write {
            realm.add(Task(text: "Hello World 1"))
            realm.add(Task(text: "Hello World 2"))
            realm.add(Task(text: "Hello World 3"))
        }
    }
    
    
}
