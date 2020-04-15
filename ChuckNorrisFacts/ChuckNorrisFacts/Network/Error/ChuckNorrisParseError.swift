//
//  ChuckNorrisParseError.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 15/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import Foundation

enum ChuckNorrisParseError: Error {
    case parse(AnyObject?)
}

extension ChuckNorrisParseError: ChuckNorrisGenericError, Equatable {
    var code: Int {
        switch self {
        case .parse(_):
            return -1
        }
    }
    
    var message: String {
        switch self {
        case .parse(_):
            return ChuckNorrisGenericMessages.parse.rawValue
        }
    }
}
