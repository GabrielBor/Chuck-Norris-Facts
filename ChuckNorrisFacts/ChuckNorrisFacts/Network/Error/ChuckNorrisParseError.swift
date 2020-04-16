//
//  ChuckNorrisParseError.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 15/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import Foundation

public enum ChuckNorrisParseError: Error {
    case parse(AnyObject?)
}

extension ChuckNorrisParseError: ChuckNorrisGenericError, Equatable {
    public var code: Int {
        switch self {
        case .parse(_):
            return -1
        }
    }
    
    public var message: String {
        switch self {
        case .parse(_):
            return ChuckNorrisGenericMessages.parse.rawValue
        }
    }
}
