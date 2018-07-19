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
    
    private func setupReminder(for task: Task) {
        let title = R.string.localizable.remindMeAfter()
        let actionSheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: R.string.localizable.oneMinute() , style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: R.string.localizable.fiveMinutes() , style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: R.string.localizable.oneHour() , style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: R.string.localizable.cancel(), style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    
}

extension TasksListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = viewModel.tasks.value[indexPath.row]
        let editVC = TaskEditViewController(state: .editing, task: task)
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let reminderAction = setReminderAction(at: indexPath, for: tableView)
        return UISwipeActionsConfiguration(actions: [reminderAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let flagAction = toggleFlagAction(at: indexPath, for: tableView)
        let delAction = deleteAction(at: indexPath, for: tableView)
        return UISwipeActionsConfiguration(actions: [delAction, flagAction])
    }
    
    private func deleteAction(at indexPath: IndexPath, for table: UITableView) -> UIContextualAction {
        let task = viewModel.tasks.value[indexPath.row]
        let action = UIContextualAction(style: .normal, title: R.string.localizable.delete()) { [weak self] (_, _, completion) in
            do {
                try self?.viewModel.delete(task: task)
                completion(true)
            } catch {
                completion(false)
            }
        }
        action.backgroundColor = .red
        return action
    }
    
    private func toggleFlagAction(at indexPath: IndexPath, for table: UITableView) -> UIContextualAction {
        let task = viewModel.tasks.value[indexPath.row]
        let title = task.isCompleted ? "⚪️" : "✅"
        let action = UIContextualAction(style: .normal, title: title) { [weak viewModel] (_, _, completion) in
            do {
                try viewModel?.toggleCompletedState(for: task)
                completion(true)
            } catch {
                completion(false)
            }
        }
        action.backgroundColor = task.isCompleted ? UIColor.gray : UIColor.orange
        return action
    }
    
    private func setReminderAction(at indexPath: IndexPath, for table: UITableView) -> UIContextualAction {
        let task = viewModel.tasks.value[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "🔔") { [weak self] (_, _, completion) in
            self?.setupReminder(for: task)
            completion(true)
        }
        action.backgroundColor = .blue
        return action
    }
    
    
}

extension TasksListViewController: PlaceholderDelegate {

    func view(_ view: Any, actionButtonTappedFor placeholder: Placeholder) {
        if placeholder.key == .noResultsKey {
            tableView.showLoadingPlaceholder()
            viewModel.reloadTasksList()
        }
    }
}
