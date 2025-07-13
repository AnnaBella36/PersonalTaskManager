//
//  Model.swift
//  PersonalTaskManager
//
//  Created by Olga Dragon on 30.06.2025.
//

import Foundation

struct TaskModel: Hashable, Equatable {
    var id: UUID
    var title: String
    var isCompleted: Bool
    var priority: TaskPriority
    var category: TaskCategory
    
    init(id: UUID, title: String, isCompleted: Bool, priority: TaskPriority, category: TaskCategory) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.priority = priority
        self.category = category
    }
}

extension TaskModel{
    static var demoTasks: [TaskModel] {
        [
            TaskModel(id: UUID(), title: "Buy milk", isCompleted: false, priority: .medium, category: .shopping),
            TaskModel(id: UUID(), title: "Finish project", isCompleted: false, priority: .high, category: .work),
            TaskModel(id: UUID(), title: "Walk with dogs", isCompleted: true, priority: .low, category: .personal)
        ]
        
    }
}
