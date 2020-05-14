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

struct Resource<A> {

    public var url: String
    public var method: HttpMethod
    public var parse: (Data) -> A?
    
    public init(url: String, parse: @escaping (Data) -> A?, method: HttpMethod = .get) {
        self.url = url
        self.method = method
        self.parse = parse
    }
}

extension Resource where A: Codable {
    init(url: String, method: HttpMethod = .get) {
        self.url = url
        self.method = method
        self.parse = { data in
            let decodedObject: A? = try? JSONDecoder().decode(A.self, from: data)
            return decodedObject
        }
    }
}


