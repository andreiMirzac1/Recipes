//
//  URLCacheExtension.swift
//  Recipes
//
//  Created by Andrei Mirzac on 14/05/2020.
//  Copyright © 2020 Andrei Mirzac. All rights reserved.
//

import Foundation

extension URLCache {
    static func configureSharedURLCache(memoryCapacityInMb: Int, diskCapacityInMb: Int) {
        let memoryCapacityInBytes =  memoryCapacityInMb * 1024 * 1024
        let diskCapacityInBytes =  diskCapacityInMb * 1024 * 1024

        let urlCache = URLCache(memoryCapacity: memoryCapacityInBytes, diskCapacity: diskCapacityInBytes, diskPath: nil)
        URLCache.shared = urlCache
    }
}
