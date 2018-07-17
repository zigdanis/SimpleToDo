//
//  NSError+Helpers.swift
//  SimpleToDo
//
//  Created by Danis Ziganshin on 17/07/2018.
//  Copyright © 2018 ziganshin. All rights reserved.
//

import Foundation

extension NSError {
    
    static let domainName = "pro.ziganshin.SimpleToDo"
    
    static var deallocatedReference: NSError {
        get {
            return NSError(domain: domainName, code: 1000, userInfo: [NSLocalizedDescriptionKey: "Referenced object were deallocated"])
        }
    }
}
