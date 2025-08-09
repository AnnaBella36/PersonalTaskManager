//
//  PersonalTaskManagerTests.swift
//  PersonalTaskManager
//
//  Created by Olga Dragon on 09.08.2025.
//

import XCTest
import CoreData
@testable import PersonalTaskManager

final class InMemoryCoreDataStack {
    let container: NSPersistentContainer
    var context: NSManagedObjectContext { container.viewContext }
    
    init(modelName: String = "TaskModel") {
        container = NSPersistentContainer(name: modelName)
        let desc = NSPersistentStoreDescription()
        desc.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [desc]
        
        var loadError: Error?
        container.loadPersistentStores { _, error in loadError = error }
        if let error = loadError {
            fatalError("Failed to load in-memory store: \(error)")
        }
    }
    func saveIfNeeded() {
        if context.hasChanges { try? context.save() }
    }
}



final class TaskFactoryTests: XCTestCase {
    
    func testRejectsEmptyOrWhitespaceTitle() {
        XCTAssertNil(TaskFactory.makeTask(title: nil, description: "d", taskToEdit: nil, priority: .low, category: .other))
        XCTAssertNil(TaskFactory.makeTask(title: "", description: "d", taskToEdit: nil, priority: .low, category: .other))
        XCTAssertNil(TaskFactory.makeTask(title: " \n\t ", description: "d", taskToEdit: nil, priority: .low, category: .other))
    }
    
    func testTrimsTitleAndTruncatesDescriptionTo300() {
        let long = String(repeating: "x", count: 1000)
        let task = TaskFactory.makeTask(title: "  Buy milk  ",
                                        description: long,
                                        taskToEdit: nil,
                                        priority: .medium,
                                        category: .shopping)
        
        XCTAssertNotNil(task)
        XCTAssertEqual(task?.title, "Buy milk")
        XCTAssertEqual(task?.description.count, 300)
    }
    
    func testEditingPreservesIdAndCompletion() {
        let original = TaskModel(id: UUID(), title: "A", description: "", isCompleted: true, priority: .low, category: .personal)
        let edited = TaskFactory.makeTask(title: "A+", description: nil, taskToEdit: original, priority: .high, category: .work)
        XCTAssertEqual(edited?.id, original.id)
        XCTAssertEqual(edited?.isCompleted, true)
    }
}

final class TaskModelMappingTests: XCTestCase {
    
    func testInitFromEntitySuccess() {
        let stack = InMemoryCoreDataStack()
        let entity = TaskEntity(context: stack.context)
        entity.id = UUID()
        entity.title = "Test"
        entity.taskDescription = "Desc"
        entity.isCompleted = false
        entity.priority = TaskPriority.high.rawValue
        entity.category = TaskCategory.work.rawValue
        stack.saveIfNeeded()
        
        let model = TaskModel(entity: entity)
        XCTAssertNotNil(model)
        XCTAssertEqual(model?.title, "Test")
        XCTAssertEqual(model?.priority, .high)
        XCTAssertEqual(model?.category, .work)
    }
    
    func testInitFromEntityMissingRequiredReturnsNil() {
        let stack = InMemoryCoreDataStack()
        let entity = TaskEntity(context: stack.context)
        stack.saveIfNeeded()
        XCTAssertNil(TaskModel(entity: entity))
    }
}

final class TaskCollectionExtensionsTests: XCTestCase {
    
    func testSortedByPriorityHighFirst() {
        let t1 = TaskModel(id: UUID(), title: "L", description: "", isCompleted: false, priority: .low, category: .other)
        let t2 = TaskModel(id: UUID(), title: "H", description: "", isCompleted: false, priority: .high, category: .other)
        let t3 = TaskModel(id: UUID(), title: "M", description: "", isCompleted: false, priority: .medium, category: .other)

        let sorted = [t1, t2, t3].sortedByPriority()
        XCTAssertEqual(sorted.map { $0.priority }, [.high, .medium, .low])
    }
    
    func testFiltredByCategoryAndNil() {
        let work1 = TaskModel(id: UUID(), title: "A", description: "", isCompleted: false, priority: .low, category: .work)
        let pers1 = TaskModel(id: UUID(), title: "B", description: "", isCompleted: false, priority: .low, category: .personal)
        let work2 = TaskModel(id: UUID(), title: "C", description: "", isCompleted: false, priority: .low, category: .work)

        XCTAssertEqual([work1, pers1, work2].filtred(by: nil).count, 3)
        let onlyWork = [work1, pers1, work2].filtred(by: .work)
        XCTAssertEqual(onlyWork.count, 2)
        XCTAssertTrue(onlyWork.allSatisfy { $0.category == .work })
    }
}

final class TaskRepositoryFlowTest: XCTestCase {
    
    func testSaveFetchSortUpdateFilterDeleteFlow() {
        let stack = InMemoryCoreDataStack()
        let repo = TaskRepository(context: stack.context)
        
        //save
        let a = TaskModel(id: UUID(), title: "A", description: "", isCompleted: false, priority: .low, category: .work)
        let b = TaskModel(id: UUID(), title: "B", description: "", isCompleted: false, priority: .high, category: .work)
        repo.save(a)
        repo.save(b)
        
        //Fetch
        var fetched = repo.fetchTasks(category: nil, sortByPriority: false)
        XCTAssertEqual(Set(fetched.map { $0.id }), Set([a.id, b.id]))
        
        //Fetc without sort
        fetched = repo.fetchTasks(category: nil, sortByPriority: true)
        XCTAssertEqual(fetched.map { $0.priority }, [.high, .low])
        
        //Update
        var updatedB = b
        updatedB.title = "B+"
        updatedB.isCompleted = true
        repo.update(updatedB)

        fetched = repo.fetchTasks(category: nil, sortByPriority: false)
        let bFromDB = fetched.first(where: { $0.id == b.id })
        XCTAssertEqual(bFromDB?.title, "B+")
        XCTAssertEqual(bFromDB?.isCompleted, true)
        
        //Filter
        let onlyWork = repo.fetchTasks(category: .work, sortByPriority: false)
        XCTAssertEqual(onlyWork.count, 2)
        
        //Delete
        repo.delete(a)
        fetched = repo.fetchTasks(category: nil, sortByPriority: false)
        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first?.id, b.id)
    }
}
