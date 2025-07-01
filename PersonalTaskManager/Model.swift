//
//  Model.swift
//  PersonalTaskManager
//
//  Created by Olga Dragon on 30.06.2025.
//

import Foundation

enum TaskPriority: String, CaseIterable{
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

enum TaskCategory: String, CaseIterable{
    case personal = "Personal"
    case work = "Work"
    case shopping = "Shopping"
    case other = "Other"
}

struct Task {
    var title: String
    var isCompleted: Bool
    var priority: TaskPriority
    var category: TaskCategory
}
