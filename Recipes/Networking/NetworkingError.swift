//
//  NetworkingError.swift
//  Recipes
//
//  Created by Andrei Mirzac on 13/05/2020.
//  Copyright © 2020 Andrei Mirzac. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case dataNotFound
    case failureToDecodeData
    case invalidStatusCode
    case invalidUrl

    var localizedDescription: String {
        return "There is a problem loading data. Please try again"
    }
}
