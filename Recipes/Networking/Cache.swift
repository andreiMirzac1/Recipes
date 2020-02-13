//
//  Cache.swift
//  Recipes
//
//  Created by Andrei Mirzac on 15/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import Foundation

protocol Caching {
    
    var storage: FileStorage { get set }
    
    func load<A>(_ resource: Resource<A>) -> A?
    func save<A>(_ data: Data, for resource: Resource<A>)
}

final class Cache: Caching {
    
    struct CacheData: Codable {
        let savedDate: Date
        let data: Data
    }
    
    var storage: FileStorage
    var time: Int
    
    init(storage: FileStorage, time: Int) {
        self.storage = storage
        self.time = time
    }
    
    func load<A>(_ resource: Resource<A>) -> A? {
        
        guard let data = storage[resource.cacheKey] else {
            return nil
        }
        
        guard let cacheData = try? JSONDecoder().decode(CacheData.self, from: data) else {
            return nil
        }
        
        if Date().hours(from: cacheData.savedDate) >= time {
            storage[resource.cacheKey] = nil
            return nil
        }
    
        return resource.parse(cacheData.data)
    }
    
    func save<A>(_ data: Data, for resource: Resource<A>) {
        let cacheData = CacheData(savedDate: Date(), data: data)
        let data  = try? JSONEncoder().encode(cacheData)
        storage[resource.cacheKey] = data
    }
}

extension Date {
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
}



