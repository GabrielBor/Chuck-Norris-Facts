//
//  SearchFactsViewModelTest.swift
//  ChuckNorrisFactsTests
//
//  Created by Gabriel Borges on 02/05/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import XCTest
import RxSwift
import RxRelay

@testable import ChuckNorrisFacts

class SearchFactsViewModelTest: XCTestCase {
    
    // MARK: Property Test
    
    var viewModel: ChuckNorrisSearchFactsViewModel!
    var service: ChuckNorrisServices!
    var mockURLSession: MockURLSession!
    var api: ChuckNorrisAPI!
    var repository: ChuckNorrisRespository!
    var disposedBag: DisposeBag!

    override func setUp() {
        super.setUp()
        disposedBag = DisposeBag()
        repository = ChuckNorrisRespository()
        mockURLSession = MockURLSession()
        api = ChuckNorrisAPI()
        service = ChuckNorrisServices(with: mockURLSession, api: api)
        viewModel = ChuckNorrisSearchFactsViewModel(service, repository: repository)
    }
    
    override func tearDown() {
        super.tearDown()
        service = nil
        viewModel = nil
    }
    
    func testRandomSuggestions() {
        let list = try! FactoryTest.makeList([String].self, fromJSON: "suggetions_facts_success")
        repository.insert(.suggetionsKey, list: list)
        let randomList = viewModel.randomSuggestions(repository.getAll(.suggetionsKey), randomElementsIn: 8)
        XCTAssertTrue(list.count != randomList.count)
        XCTAssertEqual(randomList.count, 8)
        repository.delete(.suggetionsKey)
    }
    
    func testFetchListSuggestionFacts() {
        
        let dataTask = MockURLSessionDataTask()
        mockURLSession.dataTask = dataTask

        let sendMockData = try! FactoryTest.makeData(fromJSON: "suggetions_facts_success")
        mockURLSession.success(with: sendMockData)
        
        viewModel.fetchListSuggestionFacts()
        let expectationSuggestions = expectation(description:"friendCells contains a normal cell")
        
        DispatchQueue.main.async {
            self.viewModel.listSuggestionBehaviorRelay.subscribe { (list) in
                XCTAssertTrue(list.element!.isEmpty == false)
                expectationSuggestions.fulfill()
            }.disposed(by: self.disposedBag)
        }
        
        wait(for: [expectationSuggestions], timeout: 0.1)
    }
}
