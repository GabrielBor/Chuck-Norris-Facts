//
//  HomeFactsViewModel.swift
//  ChuckNorris
//
//  Created by Gabriel Borges on 12/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import UIKit

class HomeFactsViewModel {
    
    // MARK: - Properties
    
    var factsList: [ChuckNorrisRandomModel] = []
    
    // MARK: - Initialize
    
    init(_ factsList: [ChuckNorrisRandomModel]) {
        self.factsList = factsList
    }
    
    func sizeFont(for fact: String) -> CGFloat {
        return fact.count > 80 ? 24.0 : 16.0
    }
}
