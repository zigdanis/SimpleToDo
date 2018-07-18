//
//  TaskCell.swift
//  SimpleToDo
//
//  Created by Danis Ziganshin on 17/07/2018.
//  Copyright © 2018 ziganshin. All rights reserved.
//

import Foundation
import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var taskTextLabel: UILabel!
    @IBOutlet weak var checkmarkLabel: UILabel!
    
    private let formatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupDateFormatter()
    }
    
    private func setupDateFormatter() {
        formatter.dateStyle = .short
        formatter.timeStyle = .short
    }
    
    func setup(with task: Task) {
        if let date = task.editedAt {
            dateLabel.text = formatter.string(from: date)
        } else {
            dateLabel.text = R.string.localizable.noDate()
        }
        taskTextLabel.text = task.text
        checkmarkLabel.text = task.isCompleted ? "✅" : "⚪️"
    }
    
}
