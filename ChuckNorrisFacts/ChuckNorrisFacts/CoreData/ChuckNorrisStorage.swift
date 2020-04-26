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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func save(to list: [String], identifierEntity: IdentifierCoreData, key: IdentifierCoreData) {
        let entity = NSEntityDescription.entity(forEntityName: identifierEntity.rawValue, in: context)
        guard let entitySuggestion = entity else { return }
        
        let contextValue = NSManagedObject(entity: entitySuggestion, insertInto: context)
        contextValue.setValue(list, forKey: key.rawValue)
        do {
            try context.save()
        } catch let error as NSError  {
             print("Unresolved error: \(error), \(error.userInfo)")
        }
    }
    
    func access(_ identifier: IdentifierCoreData) -> [NSManagedObject]? {
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
