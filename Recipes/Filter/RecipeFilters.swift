//
//  RecipeFilters.swift
//  Recipes
//
//  Created by Andrei Mirzac on 14/05/2020.
//  Copyright © 2020 Andrei Mirzac. All rights reserved.
//

import Foundation

struct RecipeFilters {
    var time: Time?
    var difficulty: Difficulty?

    init(time: Time? = nil, difficulty: Difficulty? = nil) {
        self.time = time
        self.difficulty = difficulty
    }
}
