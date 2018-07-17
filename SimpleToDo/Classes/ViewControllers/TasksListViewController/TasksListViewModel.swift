//
//  TasksListViewModel.swift
//  SimpleToDo
//
//  Created by Danis Ziganshin on 17/07/2018.
//  Copyright © 2018 ziganshin. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class TasksListViewModel: NSObject, UICollectionViewDataSource {
    
    var tasks = [Task]()
    let collectionView: UICollectionView
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        setupCollectionView()
        reloadTasks()
    }
    
    // MARK: - Setup
    
    private func setupCollectionView() {
        collectionView.dataSource = self
    }
    
    // MARK: - Actions
    
    func reloadTasks(completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            do {
                let realm = try Realm()
                self?.tasks = Array(realm.objects(Task.self))
            } catch {
                print("Error occured when tried to load data from Realm")
            }
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
            completion?()
        }
    }
    
    func addNewTask() {
        
    }
    
    // MARK: - UICollectionView DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = R.nib.taskCell.identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        return cell
    }
}
