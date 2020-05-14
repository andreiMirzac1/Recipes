//
//  Recipe.swift
//  Recipes
//
//  Created by Andrei Mirzac on 13/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import Foundation

struct Recipe: Codable, Equatable {
    var name: String
    var ingredients: [Ingredient]
    var steps: [String]
    var timers: [Int]
    var imageURL: String
    var originalURL: String?
}
