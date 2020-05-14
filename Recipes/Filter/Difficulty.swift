//
//  Difficulty.swift
//  Recipes
//
//  Created by Andrei Mirzac on 17/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import Foundation

enum Difficulty: String {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    static let allValues = [easy, medium, hard]
}

extension Difficulty {
    init?(recipe: Recipe) {
        let steps = recipe.steps.count
        let ingredients = recipe.ingredients.count
        let difficultyPoints = steps + ingredients
    
        switch difficultyPoints {
        case 0..<10:
            self = .easy
        case 10..<20:
            self = .medium
        case 20...:
            self = .hard
        default:
           return nil
        }
    }
}
