//
//  TaskListViewController.swift
//  PersonalTaskManager
//
//  Created by Olga Dragon on 30.06.2025.
//

import UIKit

class TaskListViewController:  UIViewController{
    
    private var tasks: [Task] = [
        Task(title: "Buy milk", isCompleted: false, priority: .medium, category: .shopping),
        Task(title: "Finish project", isCompleted: false, priority: .high, category: .work),
        Task(title: "Walk with dogs", isCompleted: true, priority: .low, category: .personal)
    ]
    
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseID)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Tasks"
        view.backgroundColor = .systemBackground
        
        setupTableView()
        setupNavigationBar()
        setupConstraints()
        
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
        let addVC = AddTaskViewController()
        addVC.delegate = self
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
        cell.configure(with: tasks[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var task = tasks[indexPath.row]
        task.isCompleted.toggle()
        tasks[indexPath.row] = task
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let editVC = AddTaskViewController()
        editVC.taskToEdit = tasks[indexPath.row]
        editVC.taskIndex = indexPath.row
        editVC.delegate = self
        navigationController?.pushViewController(editVC, animated: true)
    }
}


extension TaskListViewController: AddTaskDelegate{
    
    func didAddTask(_ task: Task) {
        tasks.append(task)
        tableView.reloadData()
    }
    
    func didEditTask(_ task: Task, at index: Int) {
        tasks[index] = task
        tableView.reloadData()
    }
    
}
