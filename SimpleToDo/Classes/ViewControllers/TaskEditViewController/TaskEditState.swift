//
//  TaskEditState.swift
//  SimpleToDo
//
//  Created by Danis Ziganshin on 17/07/2018.
//  Copyright © 2018 ziganshin. All rights reserved.
//

import Foundation

enum TaskEditState {
    case creating
    case editing
    
    var navigationTitle: String {
        get {
            if self == .creating {
                return R.string.localizable.newTask()
            } else if self == .editing {
                return R.string.localizable.editTask()
            } else {
                assertionFailure("Unknown message for enum value")
                return "Undefined"
            }
        }
    }
}


