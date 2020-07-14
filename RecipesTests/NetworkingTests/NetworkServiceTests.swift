//
//  NetworkService.swift
//  Recipes
//
//  Created by Andrei Mirzac on 08/09/2019.
//  Copyright © 2019 Andrei Mirzac. All rights reserved.
//

import XCTest
@testable import Recipes

class NetworkServiceTests: XCTestCase {

    var recipesService: RecipesService!
    var resource = Resource<[Recipe]>(url: "http://example.com", method: .get)
    
    override func setUp() {
        let session = MockNetworkServiceHelper.makeUrlSession()
        let networkService = NetworkService(session: session)
        recipesService = RecipesService(networking: networkService)
    }
    
    func testNetworkServiceReturnsInvalidStatusCodeError() {
        let mockData = MockNetworkData(url: resource.url, statusCode: 400, data: Data())
        MockNetworkServiceHelper.configure(with: mockData)

        let expectation = XCTestExpectation(description: "NetworkService")
        recipesService.loadRecipes() { result in
            switch result {
            case .failure(let error):
                XCTAssert(error == .invalidStatusCode)
            case .success:
                XCTFail("Expected .invalidStatusCode error type")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testNetworkServiceReturnsFailedToParseErrorWhenDataIsInvalid() {

        let mockData = MockNetworkData(url: resource.url, statusCode: 200, data: Data())
        MockNetworkServiceHelper.configure(with: mockData)

        let expectation = XCTestExpectation(description: "NetworkService")
        recipesService.loadRecipes() { result in
            switch result {
            case .failure(let error):
                XCTAssert(error == .failureToDecodeData)
            case .success:
                XCTFail("Expected .failureToDecodeData error type but received a success result")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testNetworkServiceLoadsSuccesfully() {

        let recipesData = StubLoader.loadData(from: "oneRecipe")!
        let mockData = MockNetworkData(url: resource.url, statusCode: 200, data: recipesData)
        MockNetworkServiceHelper.configure(with: mockData)

        let expectation = XCTestExpectation(description: "NetworkService")
        recipesService.loadRecipes() { result in
            switch result {
            case .failure:
                XCTFail("Expected a success result")
            case .success(let result):
                let recipes: [Recipe] = StubLoader.load(fileName: "oneRecipe")!
                XCTAssert(result.count == 1)
                XCTAssert(result.first == recipes.first)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}
