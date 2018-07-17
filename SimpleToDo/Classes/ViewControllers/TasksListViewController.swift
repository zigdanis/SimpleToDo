//
//  TasksListViewController.swift
//  SimpleToDo
//
//  Created by Danis Ziganshin on 17/07/2018.
//  Copyright © 2018 ziganshin. All rights reserved.
//

import Foundation
import UIKit

class TasksListViewController: UIViewController {
    
    private var viewModel: TasksListViewModel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModelWithCollectionView()
    }
    
    // MARK: - Setup
    
    private func setupViewModelWithCollectionView() {
        viewModel = TasksListViewModel(collectionView: collectionView)
    }
    
}
