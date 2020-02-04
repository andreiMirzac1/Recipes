//
//  Complexity.swift
//  Recipes
//
//  Created by Andrei Mirzac on 17/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import Foundation

enum Complexity: String {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    case all = "All"
    
    static let allValues = [easy, medium, hard, all]
}

extension Complexity {
    init(recipe: Recipe) {
        
        let steps = recipe.steps.count
        let time  = recipe.timers.reduce(0, +)
        let ingredients = recipe.ingredients.count
        
        let complexityPoints = steps + ingredients
        let pointsPerTime = Double(complexityPoints)/Double(time)
    
        switch pointsPerTime {
        case 0..<0.2:
            self = .hard
        case 0.2..<0.7:
            self = .medium
        case 0.7...:
            self = .easy
        default:
            self = .all
        }
    }
}
