//
//  Task.swift
//  SimpleToDo
//
//  Created by Danis Ziganshin on 17/07/2018.
//  Copyright © 2018 ziganshin. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var text: String = ""
    @objc dynamic var editedAt: Date?
    @objc dynamic var isCompleted = false
}
