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
    
    init(_ response: URLResponse?, error: Error?) {
        self = .unknown(error, nil)
        if let httpResponse = response as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case URLError.unknown.rawValue:
                self = .unknown(error, URLError.unknown.rawValue)
            case URLError.badURL.rawValue:
                self = .badURL(error, URLError.badURL.rawValue)
            case URLError.timedOut.rawValue:
                self = .timedOut(error, URLError.timedOut.rawValue)
            case URLError.notConnectedToInternet.rawValue:
                self = .notConnectedToInternet(error, URLError.notConnectedToInternet.rawValue)
            default:
                self = .unknown(error, httpResponse.statusCode)
            }
        }
    }
}

extension NetworkError: ChuckNorrisGenericError, Equatable {
    
    public var message: String {
        switch self {
        case .unknown(_, let code):
            return code != nil ? HTTPURLResponse.localizedString(forStatusCode: code!) : ChuckNorrisGenericMessages.unknown.rawValue
        case .badURL(_, let code):
            return HTTPURLResponse.localizedString(forStatusCode: code)
        case .notConnectedToInternet(_, let code):
            return HTTPURLResponse.localizedString(forStatusCode: code)
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
