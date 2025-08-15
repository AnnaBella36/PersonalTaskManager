//
//  TaskListViewController.swift
//  PersonalTaskManager
//
//  Created by Olga Dragon on 30.06.2025.
//

import UIKit
import CoreData

final class TaskListViewController:  UIViewController{
    
    private var tasks: [TaskModel] = TaskModel.demoTasks
    private var completionState: [UUID: Bool] = [:]
    
    private let repository = TaskRepository()
    
    private let emptyStateView = EmptyStateView()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseID)
        return table
    }()
    
    private let categorySegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["All"] + TaskCategory.allCases.map{$0.rawValue})
        return control
    }()
    
    private var sortByPriority: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Tasks"
        view.backgroundColor = .systemBackground
        
        setupEmptyStateView()
        setupCategoryControl()
        setupTableView()
        setupNavigationBar()
        setupConstraints()
        loadTasksFromCoreData()
        updateEmptyStateVisibility()
        
    }
    
    private func updateEmptyStateVisibility() {
        emptyStateView.isHidden = !tasks.isEmpty
        tableView.isHidden = tasks.isEmpty
    }
    
    private func setupEmptyStateView() {
        view.addSubview(emptyStateView)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(toggleSort)),
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskTapped))]
    }
    
    @objc private func addTaskTapped() {
        let addVC = AddTaskViewController(delegate: self)
        navigationController?.pushViewController(addVC, animated: true)
    }
    
    @objc func toggleSort() {
        sortByPriority.toggle()
        loadTasksFromCoreData()
    }
    
    private func setupCategoryControl() {
        view.addSubview(categorySegmentedControl)
        categorySegmentedControl.selectedSegmentIndex = 0
        categorySegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        categorySegmentedControl.addTarget(self, action: #selector(categoryChanged), for: .valueChanged)
    }
    
    @objc private func categoryChanged() {
        loadTasksFromCoreData()
    }
    
    //изменить этот метод
    private func loadTasksFromCoreData() {
<<<<<<< HEAD
        
=======
>>>>>>> feature/unit_tests_models
        let selectedIndex = categorySegmentedControl.selectedSegmentIndex
        let selectedCategory: TaskCategory? = selectedIndex > 0
            ? TaskCategory.allCases[selectedIndex - 1] : nil

        tasks = repository.fetchTasks(category: selectedCategory, sortByPriority: sortByPriority) 
        tableView.reloadData()
        updateEmptyStateVisibility()
    }
}

extension TaskListViewController {
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            categorySegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: LayoutConstraints.verticalSpacing),
            categorySegmentedControl.leadingAnchor.constraint(equalTo: view
                .leadingAnchor, constant: LayoutConstraints.cellSideInset),
            categorySegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstraints.cellSideInset),
            tableView.topAnchor.constraint(equalTo: categorySegmentedControl.bottomAnchor),
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
        let task = tasks[indexPath.row]
        let current = completionState[task.id] ?? task.isCompleted
        completionState[task.id] = !current
        tableView.reloadRows(at: [indexPath], with: .automatic)
        updateEmptyStateVisibility()
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = tasks[indexPath.row]
            tasks.remove(at: indexPath.row)
            completionState.removeValue(forKey: taskToDelete.id)
            repository.delete(taskToDelete)
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
            repository.update(task)
        } else {
            tasks.append(task)
            repository.save(task)
        }
        tableView.reloadData()
        updateEmptyStateVisibility()
    }
}
