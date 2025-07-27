//
//  CoreDataManager.swift
//  PersonalTaskManager
//
//  Created by Olga Dragon on 26.07.2025.
//

import Foundation
import CoreData

final class CoreDataManager{
    
    static let shared = CoreDataManager()
    
    private init(){}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskModel")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Error - \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges{
            do{
                try context.save()
            } catch {
                fatalError("Error - \(error)")
            }
        }
    }
}
