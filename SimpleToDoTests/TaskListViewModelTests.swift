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
@testable import SimpleToDo

class TaskListViewModelTests: XCTestCase {
    
    var layout: UICollectionViewFlowLayout?
    var cv: UICollectionView?
    var sut: TasksListViewModel?
    
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "InMemoryRealm"
        layout = UICollectionViewFlowLayout()
        cv = UICollectionView(frame: .zero, collectionViewLayout: layout!)
        sut = TasksListViewModel(collectionView: cv!)
    }
    
    func testSUT_AfterInit_ShouldBeDataSourceOfCollectionView() {
        XCTAssert(sut != nil)
        XCTAssert(cv?.dataSource != nil)
        XCTAssert(cv!.dataSource! === sut!)
    }
    
    func testSUT_With3TasksInRealm_ShouldLoadThemToTasksProperty() {
        setupRealmWith3Tasks()
        sut = TasksListViewModel(collectionView: cv!)
        sut!.reloadTasks(completion: { [weak sut] in
            XCTAssert(sut!.tasks.count == 3)
        })
        
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
