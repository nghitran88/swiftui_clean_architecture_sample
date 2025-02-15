//
//  CoreDataStack.swift
//  PhotoListSample
//
//  Created by Nghi Tran on 19/1/25.
//

import Foundation
import CoreData

protocol CoreDataStackProtocol: AnyObject {
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void)
}

final class CoreDataStack {
    static let shared = CoreDataStack()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Photo")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
           }
           return container
       }()

    private init() {}
}

// MARK: - CoreDataStackProtocol
extension CoreDataStack: CoreDataStackProtocol {
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
}
