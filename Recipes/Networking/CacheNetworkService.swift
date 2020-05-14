//
//  CacheNetworkService.swift
//  Recipes
//
//  Created by Andrei Mirzac on 13/05/2020.
//  Copyright © 2020 Andrei Mirzac. All rights reserved.
//

import Foundation

class CachingNetworkService: Networking {

    let networkService: NetworkService
    let cache: Cache

    init(networkService: NetworkService, cache: Cache) {
        self.networkService = networkService
        self.cache = cache
    }

    func load<A: Decodable>(valueType: A.Type, urlString: String, completion: @escaping (Result<A, NetworkError>) -> ()) {
        if let cacheValue: A = cache.value(forKey: urlString) {
            completion(.success(cacheValue))
        } else {
            networkService.load(valueType: valueType, urlString: urlString, completion: completion)
        }
    }
}
