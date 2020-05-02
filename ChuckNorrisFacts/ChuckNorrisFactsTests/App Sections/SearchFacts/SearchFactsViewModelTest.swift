//
//  SearchFactsViewModelTest.swift
//  ChuckNorrisFactsTests
//
//  Created by Gabriel Borges on 02/05/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import XCTest
@testable import ChuckNorrisFacts

class SearchFactsViewModelTest: XCTestCase {
    
    // MARK: Property Test
    
    var viewModel: ChuckNorrisSearchFactsViewModel!
    var service: ChuckNorrisServices!
    var mockURLSession: MockURLSession!
    var api: ChuckNorrisAPI!
   
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        api = ChuckNorrisAPI()
        service = ChuckNorrisServices(with: mockURLSession, api: api)
        viewModel = ChuckNorrisSearchFactsViewModel(service)
    }

    override func tearDown() {
        super.tearDown()
        service = nil
        viewModel = nil
    }

    func testFetchLisSuggestionsFactsSuccess() {
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
