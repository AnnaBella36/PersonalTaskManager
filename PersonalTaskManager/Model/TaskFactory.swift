//
//  TaskFactory.swift
//  PersonalTaskManager
//
//  Created by Olga Dragon on 04.08.2025.
//

import Foundation

struct TaskFactory {
    
    static func makeTask(title: String?,
                         description: String?,
                         taskToEdit: TaskModel?,
                         priority: TaskPriority,
                         category: TaskCategory
                         ) -> TaskModel? {
        guard let title = title?.trimmingCharacters(in: .whitespacesAndNewlines), !title.isEmpty else {
            return nil
        }
        let trimmeDescription = (description ?? "").prefix(300)
        
        return TaskModel(id: taskToEdit?.id ?? UUID(),
                         title: title,
                         description: String(trimmeDescription),
                         isCompleted: taskToEdit?.isCompleted ?? false,
                         priority: priority,
                         category: category)
    }
}
