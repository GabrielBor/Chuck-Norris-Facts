//
//  HomeFactsViewModelTest.swift
//  ChuckNorrisFactsTests
//
//  Created by Gabriel Borges on 04/05/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import XCTest
import RxSwift
import RxRelay

@testable import ChuckNorrisFacts

class HomeFactsViewModelTest: XCTestCase {
    
    // MARK: Properties
    
    var viewModel: HomeFactsViewModel!
    var isGoingToSearchFacts = false
    var disposedBag: DisposeBag!

    override func setUp() {
        super.setUp()
        disposedBag = DisposeBag()
        viewModel = HomeFactsViewModel()
        viewModel.coordinatorDelegate = self
    }

    override func tearDown() {
        super.tearDown()
        viewModel = nil
        disposedBag = nil
        isGoingToSearchFacts = false
    }
    
    // MARK: - Test methods
    
    func testUpdateFactList() {
        
        let expectationResultList = expectation(description: "Verify if result list is passing result list")
        
        let result = try! FactoryTest.makeModel(ChuckNorrisResultModel.self, fromJSON: "result_facts_list")
        
        self.viewModel.factsPublishSubject.subscribe { (event) in
            XCTAssertEqual(result.result, event.element)
            expectationResultList.fulfill()
        }.disposed(by: self.disposedBag)
        
        viewModel.updateFactsList(with: result.result)
        
        wait(for: [expectationResultList], timeout: 0.1)
    }
    
    func testClearListFacts() {
        let result = try! FactoryTest.makeModel(ChuckNorrisResultModel.self, fromJSON: "result_facts_list")
        viewModel.factsList = result.result
        viewModel.clearFactsList()
        XCTAssertTrue(viewModel.factsList.isEmpty)
    }
    
    func testMinSizeFont() {
        let minSize = viewModel.sizeFont(for: " The Honey Badger (most fearless animal in the Guinness Book of World Records) checks under its bed&#65279; every night for Chuck Norris.")
        XCTAssertEqual(HomeFactsViewModel.SizeFont.minFontSize.rawValue, minSize)
    }
    
    func testMaxSizeFont() {
        let maxSize = viewModel.sizeFont(for: "Chuck Norris believes that Shanimal rocks.")
        XCTAssertEqual(HomeFactsViewModel.SizeFont.maxFontSize.rawValue, maxSize)
    }
    
    func testUncategorized() {
        let uncategorizedText = viewModel.setUncategorizedIfNeeded(nil)
        XCTAssertEqual(uncategorizedText, "UNCATEGORIZED")
    }
    
    func testTextCategory() {
        let category = viewModel.setUncategorizedIfNeeded("Category")
        XCTAssertEqual(category, "Category")
    }
    
    // MARK: Test Coordinator method
    
    func testGoingToSearchFacts() {
        viewModel.goToSearchFacts()
        XCTAssertTrue(isGoingToSearchFacts, "Going to Search Facts Ok!")
    }
}


// MARK: - HomeFactsCoordinatorDelegate

extension HomeFactsViewModelTest: HomeFactsCoordinatorDelegate {
    
    func goToSearchFacts(_ viewModel: HomeFactsViewModel) {
        isGoingToSearchFacts = true
    }
}
