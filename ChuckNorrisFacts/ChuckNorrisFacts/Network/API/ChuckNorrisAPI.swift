//
//  ChuckNorrisAPI.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 13/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import Foundation

class ChuckNorrisAPI {
    
    // MARK: - Property

    var baseURLComponents: URLComponents {
        var urlComponent = URLComponents()
        urlComponent.scheme = ChuckNorrisComponent.https.rawValue
        urlComponent.host = ChuckNorrisComponent.host.rawValue
        return urlComponent
    }
    
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
    
    enum Services {
        case random
        case category(value: String)
        case listCategory
        case searchCategory(value: String)
    }
    
    enum Path: String {
        case random = "random"
        case listCategory = "categories"
        case searchCategory = "search"
    }
    
    func urlService(_ services: Services) -> URL? {
        var urlComponent = baseURLComponents
        switch services {
        case .random:
            urlComponent.path = Path.random.rawValue
            return urlComponent.url
        case .category(let value):
            urlComponent.path = Path.random.rawValue
            urlComponent.queryItems = [URLQueryItem(name: "category", value: value)]
            return urlComponent.url
        case .listCategory:
            urlComponent.path = Path.listCategory.rawValue
            return urlComponent.url
        case .searchCategory(let value):
            urlComponent.path = Path.searchCategory.rawValue
            urlComponent.queryItems = [URLQueryItem(name: "query", value: value)]
            return urlComponent.url
        }
    }
}
