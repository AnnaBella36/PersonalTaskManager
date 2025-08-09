//
//  TaskPriority.swift
//  PersonalTaskManager
//
//  Created by Olga Dragon on 06.07.2025.
//

import Foundation

enum TaskPriority: String, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var sortOrder: Int {
        switch self {
        case .low: 0
        case .medium: 1
<<<<<<< HEAD:PersonalTaskManager/Model/TaskPriority.swift
        case .high: 2 
=======
        case .high: 2
>>>>>>> origin/feature/filter_and_sort:PersonalTaskManager/TaskPriority.swift
        }
    }
}
