//
//  FactoryTest.swift
//  ChuckNorrisFactsTests
//
//  Created by Gabriel Borges on 02/05/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import Foundation

class FactoryTest {
    
    static func makeData(fromJSON json: String) throws -> Data {
        let bundle = Bundle(for: self)
        let filePath = bundle.url(forResource: json, withExtension: "json")
        
        let data = try Data(contentsOf: filePath!)
        return data
    }
    
    static func makeModel<T: Codable>(_: T.Type, fromJSON json: String) throws -> T {
        let bundle = Bundle(for: self)
        let filePath = bundle.url(
            forResource: json,
            withExtension: "json"
        )
        
        let content = try Data(contentsOf: filePath!)
        return try JSONDecoder().decode(
            T.self,
            from: content
        )
    }
    
    static func makeList<T: Codable>(_: [T].Type, fromJSON json: String) throws -> [T] {
        let bundle = Bundle(for: self)
        let filePath = bundle.url(
            forResource: json,
            withExtension: "json"
        )
        
        let content = try Data(contentsOf: filePath!)
        return try JSONDecoder().decode(
            [T].self,
            from: content
        )
    }
}
