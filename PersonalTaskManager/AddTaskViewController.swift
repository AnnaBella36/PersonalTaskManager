//
//  AddTaskViewController.swift
//  PersonalTaskManager
//
//  Created by Olga Dragon on 30.06.2025.
//

import UIKit

protocol AddTaskDelegate: AnyObject{
    func didAddTask(_ task: TaskModel)
    func didEditTask(_ task: TaskModel, at index: Int)
}

final class AddTaskViewController: UIViewController{
    
    weak var delegate: AddTaskDelegate?
    var taskToEdit: TaskModel?
    var taskIndex: Int?
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "enter task"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let priorityControl: UISegmentedControl = {
        let control = UISegmentedControl(items: TaskPriority.allCases.map{$0.rawValue})
        control.selectedSegmentIndex = 1
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    private let categoryControl: UISegmentedControl = {
        let control = UISegmentedControl(items: TaskCategory.allCases.map{$0.rawValue})
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = taskToEdit == nil ? "New Task" : "Edit Task"
        
        view.addSubview(titleTextField)
        view.addSubview(priorityControl)
        view.addSubview(categoryControl)
        view.addSubview(saveButton)
        
        setConstraints()
        
        if let task = taskToEdit{
            titleTextField.text = task.title
            priorityControl.selectedSegmentIndex = TaskPriority.allCases.firstIndex(of: task.priority) ?? 1
            categoryControl.selectedSegmentIndex = TaskCategory.allCases.firstIndex(of: task.category) ?? 0
        }
    }
    
    @objc func saveTapped(){
        guard let title = titleTextField.text, !title.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Field should not be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let selectedPriority = TaskPriority.allCases[priorityControl.selectedSegmentIndex]
        let selectedCategory = TaskCategory.allCases[categoryControl.selectedSegmentIndex]
        
        let task = TaskModel(title: title, isCompleted: taskToEdit?.isCompleted ?? false , priority: selectedPriority, category: selectedCategory)
        
        if let index = taskIndex{
            delegate?.didEditTask(task, at: index)
        }else{
            delegate?.didAddTask(task)
        }
        navigationController?.popViewController(animated: true)
    }
}

extension AddTaskViewController{
    func setConstraints(){
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            priorityControl.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            priorityControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            priorityControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            categoryControl.topAnchor.constraint(equalTo: priorityControl.bottomAnchor, constant: 20),
            categoryControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoryControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            saveButton.topAnchor.constraint(equalTo: categoryControl.bottomAnchor, constant: 30),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
