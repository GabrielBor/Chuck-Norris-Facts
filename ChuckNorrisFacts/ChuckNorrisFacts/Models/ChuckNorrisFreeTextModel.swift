//
//  ChuckNorrisFreeTextModel.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 15/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import Foundation

struct ChuckNorrisFreeTextModel: Codable {
    let total: Int
    let result: [ChuckNorrisRandomModel]
}
