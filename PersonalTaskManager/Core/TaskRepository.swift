//
//  TaskRepository.swift
//  PersonalTaskManager
//
//  Created by Olga Dragon on 04.08.2025.
//

import Foundation
import CoreData

final class TaskRepository {
    private let context: NSManagedObjectContext
    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }
    
    func fetchTasks(category: TaskCategory?, sortByPriority: Bool) -> [TaskModel] {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        
        if let category = category {
            request.predicate = NSPredicate(format: "category == %@", category.rawValue)
        }
        
        do {
            var results = try context.fetch(request).compactMap{ TaskModel(entity: $0) }
            if sortByPriority {
                results = results.sortedByPriority()
            }
            return results
        } catch {
            print("loading error: \(error)")
            return []
        }
    }
    
    func save(_ task: TaskModel) {
       let entity = TaskEntity(context: context)
        entity.id = task.id
        entity.title = task.title
        entity.taskDescription = task.description
        entity.isCompleted = task.isCompleted
        entity.priority = task.priority.rawValue
        entity.category = task.category.rawValue
        
        CoreDataManager.shared.saveContext()
    }
    
    func update(_ task: TaskModel) {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        
        do {
            if let entity = try context.fetch(request).first {
                entity.title = task.title
                entity.taskDescription = task.description
                entity.isCompleted = task.isCompleted
                entity.priority = task.priority.rawValue
                entity.category = task.category.rawValue
                
                CoreDataManager.shared.saveContext()
            }
        } catch {
            print("Update error: \(error)")
        }
    }
    
    func delete(_ task: TaskModel) {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        
        do{
            if let entity = try context.fetch(request).first {
                context.delete(entity)
                CoreDataManager.shared.saveContext()
            }
        } catch {
            print("Deletion error: \(error)")
        }
    }
}
