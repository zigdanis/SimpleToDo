//
//  TaskEditViewController.swift
//  SimpleToDo
//
//  Created by Danis Ziganshin on 17/07/2018.
//  Copyright © 2018 ziganshin. All rights reserved.
//

import Foundation
import UIKit

private let placeholderColor = UIColor.lightGray
private let placeholderText = "Description"

class TaskEditViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    private let state: TaskEditState
    
    init(state: TaskEditState) {
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTextView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    // MARK: - Setup
    
    private func setupTextView() {
        textView.delegate = self
        textView.text = placeholderText
        textView.textColor = placeholderColor
    }
    
    private func setupNavigationBar() {
        title = state.navigationTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
    }
    
    @objc private func saveButtonTapped() {
        // TODO: - Create or Edit Task
    }

}

extension TaskEditViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeholderColor {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = UIColor.lightGray
        }
    }

}
