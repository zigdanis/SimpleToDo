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
    @IBOutlet weak var tableView: TableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        setupViewModel()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        title = "STD"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: R.string.localizable.back(), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTaskTapped))
    }
    
    private func setupTableView() {
        tableView.showNoResultsPlaceholder()
        tableView.delegate = self
        tableView.register(R.nib.taskCell)
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.placeholderDelegate = self
        tableView.placeholdersProvider = .basic
    }
    
    private func setupViewModel() {
        viewModel = TasksListViewModel(tableView: tableView)
    }
    
    // MARK: - Actions
    
    @objc private func addNewTaskTapped() {
        let taskEditVC = TaskEditViewController(state: .creating)
        navigationController?.pushViewController(taskEditVC, animated: true)
    }
    
}

extension TasksListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = viewModel.tasks.value[indexPath.row]
        let editVC = TaskEditViewController(state: .editing, task: task)
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let flagAction = toggleFlagAction(at: indexPath, for: tableView)
        return UISwipeActionsConfiguration(actions: [flagAction])
    }
    
    private func toggleFlagAction(at indexPath: IndexPath, for table: UITableView) -> UIContextualAction {
        let task = viewModel.tasks.value[indexPath.row]
        let title = task.isCompleted ? "⚪️" : "✅"
        let action = UIContextualAction(style: .normal, title: title) { [weak viewModel] (_, _, completion) in
            do {
                try viewModel?.toggleCompletedState(for: task)
            } catch {
                completion(false)
            }
            table.reloadRows(at: [indexPath], with: .none)
            completion(true)
        }
        action.backgroundColor = task.isCompleted ? UIColor.gray : UIColor.orange
        return action
    }
}

extension TasksListViewController: PlaceholderDelegate {

    func view(_ view: Any, actionButtonTappedFor placeholder: Placeholder) {
        if placeholder.key == .noResultsKey {
            tableView.showLoadingPlaceholder()
            viewModel.reloadSignal.onNext(())
        }
    }
}
