//
//  ChuckNorrisStorage.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 25/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import UIKit
import CoreData

class ChuckNorrisStorage {
    
    // MARK: Property
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func save(at identifierEntity: IdentifierEntity,
              withThe key: IdentifierProperty,
              withValue value: [String]) {
        let entity = NSEntityDescription.entity(forEntityName: identifierEntity.rawValue, in: context)
        guard let entitySuggestion = entity else { return }
        
        let contextValue = NSManagedObject(entity: entitySuggestion, insertInto: context)
        contextValue.setValue(value, forKey: key.rawValue)
        do {
            try context.save()
        } catch let error as NSError  {
             print("Unresolved error: \(error), \(error.userInfo)")
        }
    }
    
    func contains(at entity: IdentifierEntity,
                  withThe key: IdentifierProperty,
                  withValue value: String) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity.rawValue)
        request.predicate = NSPredicate(format: "\(key.rawValue) = %@", value)
        request.returnsObjectsAsFaults = false
        do {
            guard let result = try context.fetch(request) as? [NSManagedObject] else { return false }
            for data in result {
                if let listStorage = data.value(forKey: key.rawValue) as? [String] {
                    return listStorage.contains(value)
                }
            }
        } catch let error as NSError  {
            print("Unresolved error: \(error), \(error.userInfo)")
        }
        return false
    }
    
    func access(_ identifier: IdentifierEntity) -> [NSManagedObject]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: identifier.rawValue)
        do {
            let results = try context.fetch(request) as? [NSManagedObject]
            return results
        } catch let error as NSError {
            print("Unresolved error: \(error), \(error.userInfo)")
            return []
        }
    }
}
