//
//  Filter.swift
//  Recipes
//
//  Created by Andrei Mirzac on 12/05/2020.
//  Copyright © 2020 Andrei Mirzac. All rights reserved.
//

import Foundation

class RecipeFilter {
    private var time: Time?
    private var difficulty: Difficulty?
    private let recipes: [Recipe]

    init(recipes: [Recipe]) {
        self.recipes = recipes
    }

    func filterBy(time: Time?) -> [Recipe] {
        return filterBy(difficulty: difficulty?.rawValue, timeStr: time?.rawValue)
    }

    func filterBy(difficulty: Difficulty?) -> [Recipe] {
        return filterBy(difficulty: difficulty?.rawValue, timeStr: time?.rawValue)
    }

    private func filterBy(difficulty: String?, timeStr: String?) -> [Recipe] {
        return recipes.filter({ recipe in
            var difficultyMatch = true
            var timeMatch = true

            if let difficulty = difficulty, let selDifficulty = Difficulty(rawValue: difficulty) {
                difficultyMatch = selDifficulty == Difficulty(recipe: recipe)
            }

            if let timeStr = timeStr, let recipeTime = Time(rawValue: timeStr) {
                timeMatch = recipeTime == Time(recipe: recipe)
            }

            return difficultyMatch && timeMatch
        })
    }
}
