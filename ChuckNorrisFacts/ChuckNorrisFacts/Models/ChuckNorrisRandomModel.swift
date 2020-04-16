//
//  ChuckNorrisRandomModel.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 15/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import Foundation

struct ChuckNorrisRandomModel: Codable {
    let categories: [String]
    let createdAt: String
    let iconURL: String
    let id: String
    let updatedAt: String
    let url: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case categories
        case createdAt = "created_at"
        case iconURL = "icon_url"
        case id
        case updatedAt = "updated_at"
        case url
        case description = "value"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        categories = try values.decode([String].self, forKey: .categories)
        createdAt = try values.decode(String.self, forKey: .createdAt)
        iconURL = try values.decode(String.self, forKey: .iconURL)
        id = try values.decode(String.self, forKey: .id)
        updatedAt = try values.decode(String.self, forKey: .updatedAt)
        url = try values.decode(String.self, forKey: .url)
        description = try values.decode(String.self, forKey: .description)
    }
}
