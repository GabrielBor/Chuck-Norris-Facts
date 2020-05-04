//
//  ChuckNorrisGenericError.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 14/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import Foundation

public enum ChuckNorrisGenericMessages: String {
    case parse = "Could not parse the object"
    case generic, unknown = "Something went wrong, try again later."
    case notConnectedToInternet = "No internet connection :(. Please check your wifi or mobile device data."
}

public protocol ChuckNorrisGenericError: LocalizedError {
    var code: Int { get }
    var message: String { get }
}

public extension ChuckNorrisGenericError where Self: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.code == rhs.code
    }
}
