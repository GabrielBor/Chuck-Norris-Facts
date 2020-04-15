//
//  ChuckNorrisAPI.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 13/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import Foundation

class ChuckNorrisAPI {
    
    // MARK: - HTTPMethod

    enum HTTPMethod: String {
        case get = "GET"
    }
    
    // MARK: - URLComponents for baseURL

    enum ChuckNorrisComponent: String {
        case https = "https"
        case host = "api.chucknorris.io"
        case path = "jokes"
    }
    
    // MARK: - Path of Services
    
    enum Path: String {
        case random = "random"
        case category = "random?category="
        case listCategory = "categories"
        case freeText = "search?query="
    }
    
    // MARK: - Property

    var baseURLComponents: URLComponents {
        var urlComponent = URLComponents()
        urlComponent.scheme = ChuckNorrisComponent.https.rawValue
        urlComponent.host = ChuckNorrisComponent.host.rawValue
        return urlComponent
    }
}
