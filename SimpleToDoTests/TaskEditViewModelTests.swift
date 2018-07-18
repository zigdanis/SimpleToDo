//
//  TaskEditViewModelTests.swift
//  SimpleToDoTests
//
//  Created by Danis Ziganshin on 18/07/2018.
//  Copyright © 2018 ziganshin. All rights reserved.
//

import XCTest
import UIKit
import RealmSwift
import RxSwift
import RxBlocking
@testable import SimpleToDo

class TaskEditViewModelTests: XCTestCase {
    
    let textStream = PublishSubject<String?>()
    var sut: TaskEditViewModel!
    
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "InMemoryRealm1"
        sut = TaskEditViewModel(textStream: textStream)
    }
    
    func testSUT_WillSaveNewTask_inRealm() {
        
        textStream.onNext("Hello")
        sut.createNewTask()
        
        let expectation = XCTestExpectation(description: "Save object to Realm")

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.4) {
            let realm = try! Realm()
            let task = realm.objects(Task.self).first
            XCTAssert(task!.text == "Hello")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 4)
    }
    
    
}
