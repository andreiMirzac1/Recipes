//
//  Filter.swift
//  Recipes
//
//  Created by Andrei Mirzac on 12/05/2020.
//  Copyright © 2020 Andrei Mirzac. All rights reserved.
//

import Foundation

class FilterManager {
    private var recipes: [Recipe] = []
    private var filters: RecipeFilters

    init(filters: RecipeFilters) {
        self.filters = filters
    }

    func set(difficulty: Difficulty?) {
        filters.difficulty = difficulty
    }

    func set(preparationTime: PreparationTime?) {
        filters.preparationTime = preparationTime
    }

    func set(recipes: [Recipe]) {
        self.recipes = recipes
    }

    func filterRecipes() -> [Recipe] {
        return recipes.filter({ recipe in
            var isDifficultyMatch = true
            var isTimeMatch = true

            if let difficulty = filters.difficulty {
                isDifficultyMatch = difficulty == Difficulty(recipe: recipe)
            }

            if let time = filters.preparationTime {
                isTimeMatch = time == PreparationTime(recipe: recipe)
            }

            return isDifficultyMatch && isTimeMatch
        })
    }
}

