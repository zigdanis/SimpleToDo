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
        setupViewModelWithTextView()
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
    
    private func setupViewModelWithTextView() {
        let stream = textView.rx.text.asObservable()
        viewModel = TaskEditViewModel(textStream: stream)
    }
    
    // MARK: - Actions
    
    @objc private func saveButtonTapped() {
        viewModel.createNewTask()
        navigationController?.popViewController(animated: true)
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
