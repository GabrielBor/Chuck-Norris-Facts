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
    var mockDataTask: MockURLSessionDataTask!
    
    var searchCategoryFactsSuccess: ((_ result: ChuckNorrisResultModel) -> Void)?

    override func setUp() {
        super.setUp()
        mockDataTask = MockURLSessionDataTask()
        disposedBag = DisposeBag()
        repository = ChuckNorrisRespository()
        mockURLSession = MockURLSession()
        api = ChuckNorrisAPI()
        service = ChuckNorrisServices(with: mockURLSession, api: api)
        viewModel = ChuckNorrisSearchFactsViewModel(service, repository: repository)
        viewModel.coordinatorDelegate = self
    }
    
    override func tearDown() {
        super.tearDown()
        service = nil
        viewModel = nil
        mockURLSession = nil
        api = nil
        repository = nil
        disposedBag = nil
        mockDataTask = nil
        mockDataTask = nil
        searchCategoryFactsSuccess = nil
    }
    
    func testRandomSuggestions() {
        let list = try! FactoryTest.makeList([String].self, fromJSON: "suggetions_facts_success")
        repository.insert(.suggetionsKey, list: list)
        let randomList = viewModel.randomSuggestions(repository.getAll(.suggetionsKey), randomElementsIn: 8)
        XCTAssertTrue(list.count != randomList.count)
        XCTAssertEqual(randomList.count, 8)
        repository.delete(.suggetionsKey)
    }
    
    func testTetchListSuggestionFactsSuccess() {
        
        let expectationSuggestions = expectation(description: "Fetch list suggetions sucess")
        mockURLSession.dataTask = mockDataTask

        let sendMockData = try! FactoryTest.makeData(fromJSON: "suggetions_facts_success")
        mockURLSession.success(with: sendMockData)
        
        viewModel.fetchListSuggestionFacts()
        
        DispatchQueue.main.async {
            self.viewModel.listSuggestionBehaviorRelay.subscribe { (list) in
                XCTAssertTrue(list.element!.isEmpty == false)
                expectationSuggestions.fulfill()
            }.disposed(by: self.disposedBag)
        }
        
        wait(for: [expectationSuggestions], timeout: 0.1)
    }
    
    func testTetchListSuggestionFactsFailure() {
        
        let expectationError = expectation(description: "Fetch list suggetions failure")
        mockURLSession.dataTask = mockDataTask
        
        let error = ChuckNorrisError(nil, error: nil)
        mockURLSession.failure(with: error)
        
        DispatchQueue.main.async {
            self.viewModel.errorPublishSubject.subscribe { (error) in
                XCTAssertNotNil(error.element)
                expectationError.fulfill()
            }.disposed(by: self.disposedBag)
        }
        
        viewModel.fetchListSuggestionFacts()
        
        wait(for: [expectationError], timeout: 0.1)
    }
    
    func testFetchSearchCategoryFactsSuccess() {
        
        let expectationFacts = expectation(description: "Fetch list facts sucess")
        mockURLSession.dataTask = mockDataTask
        
        let sendMockData = try! FactoryTest.makeData(fromJSON: "result_facts_list")
        mockURLSession.success(with: sendMockData)
        
        let expectedModel = try! FactoryTest.makeModel(ChuckNorrisResultModel.self, fromJSON: "result_facts_list")
        
        viewModel.fetchSearchCategoryFacts(from: "animal")
        
        searchCategoryFactsSuccess = { result in
            XCTAssertEqual(expectedModel.total, result.total)
            XCTAssertEqual(expectedModel.result, result.result)
            expectationFacts.fulfill()
        }
        
        wait(for: [expectationFacts], timeout: 0.1)
    }
}

// MARK: - ChuckNorrisSearchFactsCoordinatorDelgate

extension SearchFactsViewModelTest: ChuckNorrisSearchFactsCoordinatorDelgate {
    
    func backToHomeFacts(_ viewModel: ChuckNorrisSearchFactsViewModel, result: ChuckNorrisResultModel) {
        searchCategoryFactsSuccess?(result)
    }
}
