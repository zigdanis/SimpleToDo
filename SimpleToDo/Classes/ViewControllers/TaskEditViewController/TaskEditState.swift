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
            return self == .creating ? "New Task" : "Edit Task"
        }
    }
}


