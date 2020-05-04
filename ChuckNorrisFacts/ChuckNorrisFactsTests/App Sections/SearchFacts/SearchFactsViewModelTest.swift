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
    
    // MARK: - Test methods
    
    func testRandomSuggestions() {
        let list = try! FactoryTest.makeList([String].self, fromJSON: "suggetions_facts_success")
        repository.insert(.suggetionsKey, list: list)
        let randomList = viewModel.randomSuggestions(repository.getAll(.suggetionsKey), randomElementsIn: 8)
        XCTAssertTrue(list.count != randomList.count)
        XCTAssertEqual(randomList.count, 8)
        repository.delete(.suggetionsKey)
    }
    
    func testEmptySuggetionsFetchListSuggestionFacts() {
        
        let expectationEmpty = expectation(description: "Verify if a insert empty list for fetchRuleSuggestions and call service")

        let sendMockData = try! FactoryTest.makeData(fromJSON: "suggetions_facts_success")
        mockURLSession.success(with: sendMockData)

        repository.insert(.suggetionsKey, list: [])
        viewModel.fetchRuleSuggestions()

        DispatchQueue.main.async {
            self.viewModel.listSuggestionBehaviorRelay.subscribe { (list) in
                XCTAssertTrue(!list.element!.isEmpty)
                expectationEmpty.fulfill()
            }.disposed(by: self.disposedBag)
        }

        wait(for: [expectationEmpty], timeout: 5)
    }
    
    func testNotEmptySuggestions() {
        
        let expectationList = expectation(description: "Verify if not empty list and load from repository")
        
        let expectedList = try! FactoryTest.makeModel([String].self, fromJSON: "suggetions_facts_success")
        
        repository.insert(.suggetionsKey, list: expectedList)
        viewModel.fetchRuleSuggestions()
        
        DispatchQueue.main.async {
            self.viewModel.listSuggestionBehaviorRelay.subscribe { (list) in
                XCTAssertTrue(!list.element!.isEmpty)
                expectationList.fulfill()
            }.disposed(by: self.disposedBag)
        }
        
        repository.delete(.suggetionsKey)
        wait(for: [expectationList], timeout: 0.1)
    }
    
    func testEmptyResultFacts() {
        
        let expectationList = expectation(description: "Verify if publish receive empty list")
        
        DispatchQueue.main.async {
            self.viewModel.emptySearchResultBehaviorRelay?.subscribe { (list) in
                XCTAssertTrue(list.element!.isEmpty)
                expectationList.fulfill()
            }.disposed(by: self.disposedBag)
        }
        
        let model = ChuckNorrisResultModel(total: 0, result: [])
        viewModel.handlerResultSuccess(with: model)
        
        wait(for: [expectationList], timeout: 0.1)
    }
}

// MARK: - Test saveSearch

extension SearchFactsViewModelTest {
    
    func testInsertSearchInRepository() {
        let search = "animal"
        viewModel.saveLastSearch(search)
        XCTAssertTrue(repository.contains(.lastSearchesKey, value: search))
        repository.delete(.lastSearchesKey)
    }
    
    func testLoadLastSearches() {
        let expectationList = expectation(description: "Verify if not empty list and load from repository")
        
        let search = "dev"
        repository.insert(.lastSearchesKey, list: [search])
        viewModel.saveLastSearch(search)
        
        let expectedList = repository.getAll(.lastSearchesKey)
        
        DispatchQueue.main.async {
            self.viewModel.listLastSearhcesRelay.subscribe { (list) in
                XCTAssertEqual(expectedList, list.element!)
                expectationList.fulfill()
            }.disposed(by: self.disposedBag)
        }
        
        wait(for: [expectationList], timeout: 0.1)
    }
}

// MARK: - Test services

extension SearchFactsViewModelTest {
    
    func testTetchListSuggestionFactsSuccess() {
        
        let expectationSuggestions = expectation(description: "Fetch list suggetions sucess")
        mockURLSession.dataTask = mockDataTask

        let sendMockData = try! FactoryTest.makeData(fromJSON: "suggetions_facts_success")
        mockURLSession.success(with: sendMockData)
        
        viewModel.fetchListSuggestionFacts()
        
        DispatchQueue.main.async {
            self.viewModel.listSuggestionBehaviorRelay.subscribe { (list) in
                XCTAssertTrue(!list.element!.isEmpty)
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
        
        let expectationFacts = expectation(description: "Fetch list facts success")
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
    
    func testFetchSearchCategoryFactsFailure() {
        
        let expectationError = expectation(description: "Fetch list facts failure")
        mockURLSession.dataTask = mockDataTask
        
        let error = ChuckNorrisError(nil, error: nil)
        mockURLSession.failure(with: error)
        
        DispatchQueue.main.async {
            self.viewModel.errorPublishSubject.subscribe { (error) in
                XCTAssertNotNil(error.element)
                expectationError.fulfill()
            }.disposed(by: self.disposedBag)
        }
        
        viewModel.fetchSearchCategoryFacts(from: "animal")
        
        wait(for: [expectationError], timeout: 0.1)
    }
}

// MARK: - ChuckNorrisSearchFactsCoordinatorDelgate

extension SearchFactsViewModelTest: ChuckNorrisSearchFactsCoordinatorDelgate {
    
    func backToHomeFacts(_ viewModel: ChuckNorrisSearchFactsViewModel, result: ChuckNorrisResultModel) {
        searchCategoryFactsSuccess?(result)
    }
}
