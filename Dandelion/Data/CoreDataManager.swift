//
//  Persistence.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/07/28.
//

import Foundation
import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()

    let container: NSPersistentContainer
    let context: NSManagedObjectContext

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Dandelion")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        context = container.viewContext
    }
    
    func save() {
        do {
            try context.save()
        } catch let error {
            print("Error saving Core Data \(error)")
        }
    }
}
