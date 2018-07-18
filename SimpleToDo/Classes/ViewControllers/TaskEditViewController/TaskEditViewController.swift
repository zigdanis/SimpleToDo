//
//  TaskEditViewController.swift
//  SimpleToDo
//
//  Created by Danis Ziganshin on 17/07/2018.
//  Copyright © 2018 ziganshin. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

private let placeholderColor = UIColor.lightGray
private let placeholderText = R.string.localizable.description()

class TaskEditViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    private let state: TaskEditState
    private var viewModel: TaskEditViewModel!
    private var task: Task?
    
    init(state: TaskEditState, task: Task? = nil) {
        self.state = state
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTextView()
        setupViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    // MARK: - Setup
    
    private func setupTextView() {
        textView.text = task?.text ?? nil
    }
    
    private func setupNavigationBar() {
        title = state.navigationTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
    }
    
    private func setupViewModel() {
        let stream = textView.rx.text.asObservable()
        viewModel = TaskEditViewModel(textStream: stream, task: task)
    }
    
    // MARK: - Actions
    
    @objc private func saveButtonTapped() {
        if state == .creating {
            viewModel.createNewTask()
        } else {
            viewModel.editTask()
        }
        navigationController?.popViewController(animated: true)
    }

}
