//
//  Result.swift
//  Recipes
//
//  Created by Andrei Mirzac on 14/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import Foundation

public enum NetworkServiceError: Error {
    case dataNotFound
    case failedToParse
    case invalidStatusCode
}

public enum Result<A> {
    case success(A)
    case error(NetworkServiceError)
}

extension Result {
    
    public var value: A? {
        guard case .success(let v) = self else { return nil }
        return v
    }
}




