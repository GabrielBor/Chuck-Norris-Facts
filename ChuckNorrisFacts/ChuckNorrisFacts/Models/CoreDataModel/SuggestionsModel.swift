//
//  SuggestionsModel.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 28/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import CoreData

@objc(Suggetions)

class SuggestionsModel: NSManagedObject {
     @NSManaged var suggestions: [String]
}
