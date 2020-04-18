//
//  ChuckNorrisError.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 14/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import Foundation

public enum ChuckNorrisError: Error {
    case parse(ChuckNorrisParseError?)
    case network(NetworkError)
    case client(_ error: Error?, _ statusCode: Int)
    case server(_ error: Error?, _ statusCode: Int)
    case unknown
    
    init(_ response: URLResponse?, error: Error?) {
        self = .unknown
        if let httpResponse = response as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 400...499:
                self = .client(error, httpResponse.statusCode)
            case 500...599:
                self = .server(error, httpResponse.statusCode)
            default:
                self = .unknown
            }
        }
    }
}

extension ChuckNorrisError: ChuckNorrisGenericError, Equatable {
    
    public var message: String {
        switch self {
        case .client(_, let code):
            return HTTPURLResponse.localizedString(forStatusCode: code)
        case .server(_, let code):
            return HTTPURLResponse.localizedString(forStatusCode: code)
        case .unknown:
            return ChuckNorrisGenericMessages.unknown.rawValue
        case .network(let error):
            return error.message
        case .parse(let error):
            return error?.message ?? ""
        }
    }
    
    public var code: Int {
        switch self {
        case .server(_ , let code):
            return code
        case .client(_ , let code):
            return code
        case .unknown:
            return -1
        case .network(let error):
            return error.code
        case .parse(let error):
            return error?.code ?? 0
        }
    }
}

