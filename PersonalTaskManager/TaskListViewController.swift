//
//  TaskListViewController.swift
//  PersonalTaskManager
//
//  Created by Olga Dragon on 30.06.2025.
//

import UIKit

final class TaskListViewController:  UIViewController{
    
    private var tasks: [TaskModel] = TaskModel.demoTasks
    private var completionState: [UUID: Bool] = [:]
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseID)
        return table
    }()
    
    private let emptyStateView = EmptyStateView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Tasks"
        view.backgroundColor = .systemBackground
        
        updateEmptyStateView()
        setupTableView()
        setupNavigationBar()
        setupConstraints()
        updateEmptyStateVisibility()
        
    }
    
    private func updateEmptyStateVisibility(){
        let isEmpty = tasks.isEmpty
        emptyStateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }
    
    private func updateEmptyStateView(){
        view.addSubview(emptyStateView)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupNavigationBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskTapped))
    }
    
    @objc private func addTaskTapped(){
        let addVC = AddTaskViewController(delegate: self)
        navigationController?.pushViewController(addVC, animated: true)
    }
}

extension TaskListViewController {
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseID, for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        let task = tasks[indexPath.row]
        let isCompleted = completionState[task.id] ?? task.isCompleted
        cell.configure(with: tasks[indexPath.row], isCompleted: isCompleted)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var task = tasks[indexPath.row]
        let current = completionState[task.id] ?? task.isCompleted
        completionState[task.id] = !current
        tableView.reloadRows(at: [indexPath], with: .automatic)
        updateEmptyStateVisibility()
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let id = tasks[indexPath.row].id
            tasks.remove(at: indexPath.row)
            completionState.removeValue(forKey: id)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            updateEmptyStateVisibility()
        }
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let editVC = AddTaskViewController(taskToEdit: tasks[indexPath.row], delegate: self)
        navigationController?.pushViewController(editVC, animated: true)
    }
}


extension TaskListViewController: AddTaskDelegate{
    func didSaveTask(_ task: TaskModel) {
        if let index = tasks.firstIndex(where: {$0.id == task.id}){
            tasks[index] = task
        } else {
            tasks.append(task)
        }
        tableView.reloadData()
        updateEmptyStateVisibility()
    }
}
