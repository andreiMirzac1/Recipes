//
//  File.swift
//  RecipesTests
//
//  Created by Andrei Mirzac on 13/05/2020.
//  Copyright © 2020 Andrei Mirzac. All rights reserved.
//

import Foundation

struct MockNetworkData {
    let url: String
    let statusCode: Int
    let data: Data?
}

class MockNetworkServiceHelper {
    static func makeUrlSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }

    static func makeResponse(statusCode: Int, url: String) -> HTTPURLResponse {
        guard let response = HTTPURLResponse(url: URL(string: url)!, statusCode: statusCode, httpVersion: nil, headerFields: nil) else {
            fatalError()
        }
        return response
    }
    
    static func configure(with mockData: MockNetworkData) {
        let response = MockNetworkServiceHelper.makeResponse(statusCode: mockData.statusCode, url: mockData.url)
        MockURLProtocol.requestHandler = { request in
            return (response, mockData.data)
        }
    }
}
