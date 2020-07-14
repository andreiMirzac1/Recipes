//
//  Networking.swift
//  Recipes
//
//  Created by Andrei Mirzac on 13/05/2020.
//  Copyright © 2020 Andrei Mirzac. All rights reserved.
//

import Foundation

protocol Networking {
    func load<A: Codable>(resource: Resource<A>, isRefresh: Bool, completion: @escaping (Result<A, NetworkError>) -> ())
}


