//
//  Resource.swift
//  Recipes
//
//  Created by Andrei Mirzac on 14/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import Foundation

public enum HttpMethod {
    case get
    case post
}

struct Resource<A: Codable> {
    
    public var url: String
    public var method: HttpMethod
    
    public init(url: String, method: HttpMethod = .get) {
        self.url = url
        self.method = method
    }
}
