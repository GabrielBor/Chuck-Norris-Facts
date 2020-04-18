//
//  NetworkError.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 14/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    case unknown(_ error: Error?, _ statusCode: Int?)
    case badURL(_ error: Error?, _ statusCode: Int)
    case timedOut(_ error: Error?, _ statusCode: Int)
    case notConnectedToInternet(_ error: Error?, _ statusCode: Int)
    
    init(error: URLError?) {
        self = .unknown(error, nil)
        if let urlError = error {
            switch urlError.code {
            case URLError.unknown:
                self = .unknown(error, URLError.unknown.rawValue)
            case URLError.badURL:
                self = .badURL(error, URLError.badURL.rawValue)
            case URLError.timedOut:
                self = .timedOut(error, URLError.timedOut.rawValue)
            case URLError.notConnectedToInternet:
                self = .notConnectedToInternet(error, URLError.notConnectedToInternet.rawValue)
            default:
                self = .unknown(error, urlError.code.rawValue)
            }
        }
    }
}

extension NetworkError: ChuckNorrisGenericError, Equatable {
    
    public var message: String {
        switch self {
        case .unknown(let error, _):
            return error?.localizedDescription ?? ChuckNorrisGenericMessages.unknown.rawValue
        case .badURL(let error, _):
             return error?.localizedDescription ?? ChuckNorrisGenericMessages.generic.rawValue
        case .notConnectedToInternet(let error, _):
            return error?.localizedDescription ?? ChuckNorrisGenericMessages.generic.rawValue
        default:
            return ChuckNorrisGenericMessages.generic.rawValue
        }
    }
    
    public var code: Int {
        switch self {
        case .unknown(_, let code):
            return code != nil ? code! : URLError.unknown.rawValue
        case .badURL(_, let code):
            return code
        case .timedOut(_, let code):
             return code
        case .notConnectedToInternet(_, let code):
             return code
        }
    }
}
