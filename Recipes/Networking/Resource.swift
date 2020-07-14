//
//  Resource.swift
//  Recipes
//
//  Created by Andrei Mirzac on 14/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

struct Resource<A> {

    var url: String
    var method: HttpMethod
    var parse: (Data) -> A?
    
    init(url: String, parse: @escaping (Data) -> A?, method: HttpMethod = .get) {
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


