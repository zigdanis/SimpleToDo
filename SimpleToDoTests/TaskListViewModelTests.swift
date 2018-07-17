//
//  TaskListViewModelTests.swift
//  SimpleToDoTests
//
//  Created by Danis Ziganshin on 17/07/2018.
//  Copyright © 2018 ziganshin. All rights reserved.
//

import XCTest
import UIKit
@testable import SimpleToDo

class TaskListViewModelTests: XCTestCase {
    
    var layout: UICollectionViewFlowLayout?
    var cv: UICollectionView?
    var sut: TasksListViewModel?
    
    override func setUp() {
        super.setUp()
        layout = UICollectionViewFlowLayout()
        cv = UICollectionView(frame: .zero, collectionViewLayout: layout!)
        sut = TasksListViewModel(collectionView: cv!)
    }
    
    func testSUT_AfterInit_ShouldBeDataSourceOfCollectionView() {
        XCTAssert(sut != nil)
        XCTAssert(cv?.dataSource != nil)
        XCTAssert(cv!.dataSource! === sut!)
    }
    
    
}
