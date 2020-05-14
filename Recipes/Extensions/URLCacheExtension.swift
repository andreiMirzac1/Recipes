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
        let urlCache = URLCache(memoryCapacity: memoryCapacityInMb * 1024 * 1024, diskCapacity: diskCapacityInMb * 1024 * 1024, diskPath: nil)
        URLCache.shared = urlCache
    }
}
