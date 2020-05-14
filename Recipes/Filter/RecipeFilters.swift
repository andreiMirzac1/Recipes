//
//  RecipeFilters.swift
//  Recipes
//
//  Created by Andrei Mirzac on 14/05/2020.
//  Copyright © 2020 Andrei Mirzac. All rights reserved.
//

import Foundation

struct RecipeFilters {
    var preparationTime: PreparationTime?
    var difficulty: Difficulty?

    init(preparationTime: PreparationTime? = nil, difficulty: Difficulty? = nil) {
        self.preparationTime = preparationTime
        self.difficulty = difficulty
    }
}
