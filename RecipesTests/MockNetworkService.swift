//
//  MockProvider.swift
//  RecipesTests
//
//  Created by Andrei Mirzac on 17/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import Foundation
@testable import Recipes

/// Mock Service class that will load json file provided instead of url
class MockNetworkService: CachedNetworkService {
    override func load<A>(_ resource: Resource<A>, callBack: @escaping (Result<A>) -> ()) {
        
        let bundle = Bundle(for: MockNetworkService.self)
        guard let data = MockProvider.response(forJson: resource.url, bundle: bundle) else {
            return
        }
        guard let result = resource.parse(data) else {
            return callBack(Result.error(.failedToParse))
        }
        
        callBack(Result.success(result))
    }
}

class MockProvider {
    
    static func response(forJson json: String, bundle: Bundle) -> Data? {
        
        guard let path = bundle.path(forResource: json, ofType: "json") else {
            return nil
        }
        return FileManager.default.contents(atPath: path)
    }
}



