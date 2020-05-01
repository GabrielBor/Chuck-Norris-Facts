//
//  BaseRepository.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 01/05/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import Foundation

protocol BaseRepository {
    func getAll(_ key: IdentifierRepositoryKey) -> [String]
    func contains(_ key: IdentifierRepositoryKey, value: String) -> Bool
    func insert(_ key: IdentifierRepositoryKey, value: String)
    func insert(_ key: IdentifierRepositoryKey, list: [String]?)
    func delete(_ key: IdentifierRepositoryKey)
}

extension BaseRepository {
    func insert(_ key: IdentifierRepositoryKey, list: [String]?) { }
    func delete(_ key: IdentifierRepositoryKey) { }
}
