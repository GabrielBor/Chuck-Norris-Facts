//
//  ChuckNorrisRepository.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 01/05/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import Foundation

class ChuckNorrisRespository: BaseRepository {
    
    // MARK: Priperties
   
    private var userDefaults = UserDefaults.standard
    private var activeLastSearches = [String]()
    
    // MARK: - Methods
    
    func getAll(_ key: IdentifierRepositoryKey) -> [String] {
        guard let value = userDefaults.array(forKey: key.rawValue) as? [String] else { return [] }
        return value
    }
    
    func insert(_ key: IdentifierRepositoryKey, value: String) {
        guard var list = userDefaults.array(forKey: key.rawValue) as? [String] else {
            activeLastSearches.append(value)
            userDefaults.set(activeLastSearches, forKey: key.rawValue)
            return
        }
        list.append(value)
        userDefaults.set(list, forKey: key.rawValue)
    }
    
    func insert(_ key: IdentifierRepositoryKey, list: [String]?) {
        userDefaults.set(list, forKey: key.rawValue)
    }
    
    func contains(_ key: IdentifierRepositoryKey, value: String) -> Bool {
        guard let list = userDefaults.array(forKey: key.rawValue) as? [String] else { return false }
        return list.contains(value)
    }
    
    func delete(_ key: IdentifierRepositoryKey) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
}
