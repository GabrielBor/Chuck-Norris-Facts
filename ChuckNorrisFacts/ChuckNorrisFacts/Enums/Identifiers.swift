//
//  Identifiers.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 25/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import Foundation

enum IdentifierCell: String {
    case pastSearch = "ChuckNorrisPastSearchTableViewCell"
    case suggestionCollectionCell = "ChuckNorrisCategoryCollectionViewCell"
    case suggestionTableViewCell = "SugggetionsTableViewCell"
    case homeFactsTableViewCell = "HomeFactTableViewCell"
}

enum IdentifierCoreData: String {
    case entitySuggestions = "Suggestions"
    case propertySuggestions = "suggestions"
}
