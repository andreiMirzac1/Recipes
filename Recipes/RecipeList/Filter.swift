//
//  Filter.swift
//  Recipes
//
//  Created by Andrei Mirzac on 12/05/2020.
//  Copyright © 2020 Andrei Mirzac. All rights reserved.
//

import Foundation

protocol Filter {
}

class RecipeFilter {
    private var time: Time?
    private var complexity: Complexity?
    private let recipes: [Recipe]

    init(recipes: [Recipe]) {
        self.recipes = recipes
    }

    func filterBy(time: Time?) -> [Recipe] {
        return filterBy(complexityStr: complexity?.rawValue, timeStr: time?.rawValue)
    }

    func filterBy(complexity: Complexity?) -> [Recipe] {
        return filterBy(complexityStr: complexity?.rawValue, timeStr: time?.rawValue)
    }

    private func filterBy(complexityStr: String?, timeStr: String?) -> [Recipe] {
        return recipes.filter({ recipe in
            var complexityMatch = true
            var timeMatch = true

            if let complexityStr = complexityStr, let selectedComplexity = Complexity(rawValue: complexityStr) {
                complexityMatch = selectedComplexity == Complexity(recipe: recipe)
            }

            if let timeStr = timeStr, let recipeTime = Time(rawValue: timeStr) {
                timeMatch = recipeTime == Time(recipe: recipe)
            }

            return complexityMatch && timeMatch
        })
    }
}
