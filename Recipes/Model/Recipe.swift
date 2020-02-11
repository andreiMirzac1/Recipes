//
//  Recipe.swift
//  Recipes
//
//  Created by Andrei Mirzac on 13/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import Foundation

struct Recipe: Codable {    
  var name: String
  var ingredients: [Ingredient]
  var steps: [String]
  var timers: [Int]
  var imageURL: String
  var originalURL: String?
}

extension Recipe {
  func containsOccurence(of string: String) -> Bool {
    let query = string.lowercased()

    if name.lowercased().contains(query) ||
      !ingredients.filter({ $0.name.lowercased().contains(query) }).isEmpty ||
      !steps.filter({ $0.lowercased().contains(query) }).isEmpty {
      return true
    }
    return false
  }
}
