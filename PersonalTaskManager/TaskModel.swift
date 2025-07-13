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
