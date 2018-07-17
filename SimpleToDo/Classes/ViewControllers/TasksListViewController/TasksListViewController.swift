//
//  TasksListViewController.swift
//  SimpleToDo
//
//  Created by Danis Ziganshin on 17/07/2018.
//  Copyright © 2018 ziganshin. All rights reserved.
//

import Foundation
import UIKit
import HGPlaceholders

class TasksListViewController: UIViewController {
    
    private var viewModel: TasksListViewModel!
    @IBOutlet weak var collectionView: CollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        setupViewModelWithCollectionView()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        title = "Simple ToDo"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTaskTapped))
    }
    
    private func setupCollectionView() {
        collectionView.placeholderDelegate = self
        collectionView.delegate = self
        collectionView.placeholdersProvider = .basic
        collectionView.showNoResultsPlaceholder()
    }
    
    private func setupViewModelWithCollectionView() {
        viewModel = TasksListViewModel(collectionView: collectionView)
    }
    
    // MARK: - Actions
    
    @objc private func addNewTaskTapped() {
        let taskEditVC = TaskEditViewController(state: .creating)
        navigationController?.pushViewController(taskEditVC, animated: true)
    }
    
}

extension TasksListViewController: UICollectionViewDelegate {
    
}

extension TasksListViewController: PlaceholderDelegate {

    func view(_ view: Any, actionButtonTappedFor placeholder: Placeholder) {
        if placeholder.key == .noResultsKey {
            collectionView.showLoadingPlaceholder()
            viewModel.reloadTasks()
        }
    }
}
