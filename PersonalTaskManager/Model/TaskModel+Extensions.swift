//
//  TaskModel+Extensions.swift
//  PersonalTaskManager
//
//  Created by Olga Dragon on 04.08.2025.
//

import Foundation
extension Array where Element == TaskModel {
    
    func sortedByPriority() -> [TaskModel] {
        self.sorted{$0.priority.sortOrder > $1.priority.sortOrder}
    }
    
    func filtred(by category: TaskCategory?) -> [TaskModel] {
        guard let category = category else {return self }
        return self.filter { $0.category == category}
    }
}
