//
//  ChuckNorrisParse.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 14/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import Foundation

class ChuckNorrisParse {
    
    /// Basic parser to easily deal with object parse
    /// - Parameters:
    ///   - object: T - The Object type
    ///   - data: Data - The data that will be parsed to object
    static func JSONDecodable<T: Codable>(to object: T.Type, from data: Data) -> T? {
        do {
            let parseObject = try JSONDecoder().decode(T.self, from: data)
            return parseObject
        } catch {
            print("\n JSONDecoder Error -> \(T.self): \(error)\n")
            return nil
        }
    }
    
    /// Basic parser to easily deal with [object] parse
    /// - Parameters:
    ///   - object: [T].Type
    ///   - data: Data
    static func JSONDecodable<T: Codable>(to object: [T].Type, from data: Data) -> [T]? {
        do {
            let parseObject = try JSONDecoder().decode([T].self, from: data)
            return parseObject
        } catch {
            print("\n JSONDecoder Error -> \(T.self): \(error)\n")
            return nil
        }
    }
}
