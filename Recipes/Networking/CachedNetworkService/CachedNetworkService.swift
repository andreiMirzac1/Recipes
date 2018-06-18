//
//  CachedNetworkingService.swift
//  Recipes
//
//  Created by Andrei Mirzac on 14/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import Foundation

class CachedNetworkService {
    
    let networkService: NetworkService
    let cache: Cache
    
    init(networkService: NetworkService, cache: Cache = Cache(storage: FileStorage(), time: 1)) {
        self.networkService = networkService
        self.cache = cache
    }
    
    func load<A>(_ resource: Resource<A>, callBack: @escaping (Result<A>) -> ()) {
        guard let result = cache.load(resource) else {
            
            let dataResource = Resource<Data>(url: resource.url, parse: { $0 }, method: resource.method)
            networkService.load(dataResource, completion: { result in
                
                switch result {
                case .error(let error):
                    DispatchQueue.main.async{ callBack(Result.error(error)) }
                    
                case .success(let data):
                    self.cache.save(data, for: resource)
                    DispatchQueue.main.async{ callBack(Result(resource.parse(data), or: .failedToParse)) }
                }
            })
            return
        }
    
        DispatchQueue.main.async{ callBack(Result.success(result)) }
    }
}
