//
//  NetworkServiceError.swift
//  Recipes
//
//  Created by Andrei Mirzac on 12/05/2020.
//  Copyright © 2020 Andrei Mirzac. All rights reserved.
//

import Foundation

public enum NetworkServiceError: Error {
    case dataNotFound
    case failedToParse
    case invalidStatusCode
}
