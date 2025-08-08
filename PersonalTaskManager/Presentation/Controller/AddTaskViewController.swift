//
//  AddTaskViewController.swift
//  PersonalTaskManager
//
//  Created by Olga Dragon on 30.06.2025.
//

import UIKit

protocol AddTaskDelegate: AnyObject{
    func didSaveTask(_ task: TaskModel)
}

final class AddTaskViewController: UIViewController{
    
    weak var delegate: AddTaskDelegate?
    private let taskToEdit: TaskModel?
   
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter a task title"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let descriptionTextField: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 6
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let priorityControl: UISegmentedControl = {
        let control = UISegmentedControl(items: TaskPriority.allCases.map{$0.rawValue})
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let categoryControl: UISegmentedControl = {
        let control = UISegmentedControl(items: TaskCategory.allCases.map{$0.rawValue})
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(taskToEdit: TaskModel? = nil, delegate: AddTaskDelegate?){
        self.taskToEdit = taskToEdit
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = taskToEdit == nil ? "New Task" : "Edit Task"
      
        setupUI()
        setConstraints()
        configureInitialValues()
     
    }
    private func configureInitialValues(){
        
        if let task = taskToEdit{
            titleTextField.text = task.title
            descriptionTextField.text = task.description
            priorityControl.selectedSegmentIndex = TaskPriority.allCases.firstIndex(of: task.priority) ?? 1
            categoryControl.selectedSegmentIndex = TaskCategory.allCases.firstIndex(of: task.category) ?? 0
        } else {
            priorityControl.selectedSegmentIndex = 1
            categoryControl.selectedSegmentIndex = 0
        }
    }
    
    private func setupUI(){
        view.addSubview(titleTextField)
        view.addSubview(descriptionTextField)
        view.addSubview(priorityControl)
        view.addSubview(categoryControl)
        view.addSubview(saveButton)
        descriptionTextField.font = UIFont.systemFont(ofSize: 16)
        descriptionTextField.textContainer.maximumNumberOfLines = 3
        descriptionTextField.isScrollEnabled = true
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
    @objc func saveTapped(){
        let selectedPriority = TaskPriority.allCases[priorityControl.selectedSegmentIndex]
        let selectedCategory = TaskCategory.allCases[categoryControl.selectedSegmentIndex]
       
        guard let task = TaskFactory.makeTask(title: titleTextField.text, description: descriptionTextField.text, taskToEdit: taskToEdit, priority: selectedPriority, category: selectedCategory) else {
            showErrorAlert()
            return
        }
        delegate?.didSaveTask(task)
        navigationController?.popViewController(animated: true)
    }
    private func showErrorAlert(){
        let alert = UIAlertController(title: "Error", message: "Title cannot be empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AddTaskViewController{
    func setConstraints(){
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: LayoutConstraints.verticalSpacing),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstraints.horizontalPadding),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstraints.horizontalPadding),
            
            descriptionTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: LayoutConstraints.verticalSpacing),
            descriptionTextField.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            descriptionTextField.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 70),
            
            priorityControl.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: LayoutConstraints.verticalSpacing),
            priorityControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstraints.horizontalPadding),
            priorityControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstraints.horizontalPadding),
            
            categoryControl.topAnchor.constraint(equalTo: priorityControl.bottomAnchor, constant: LayoutConstraints.verticalSpacing),
            categoryControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LayoutConstraints.horizontalPadding),
            categoryControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -LayoutConstraints.horizontalPadding),
            
            saveButton.topAnchor.constraint(equalTo: categoryControl.bottomAnchor, constant: LayoutConstraints.bottomSpacing),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
}
