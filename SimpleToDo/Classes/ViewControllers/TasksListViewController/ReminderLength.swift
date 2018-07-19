//
//  ReminderLength.swift
//  SimpleToDo
//
//  Created by Danis Ziganshin on 19/07/2018.
//  Copyright © 2018 ziganshin. All rights reserved.
//

import Foundation

enum ReminderLength {
    case oneMinute
    case fiveMinutes
    case oneHour
    
    var seconds: TimeInterval {
        get {
            switch self {
            case .oneMinute:
                return 60
            case .fiveMinutes:
                return 5*60
            case .oneHour:
                return 60*60
            }
        }
    }
}
