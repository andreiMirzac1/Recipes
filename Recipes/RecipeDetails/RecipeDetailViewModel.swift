//
//  RecipeDetailViewModel.swift
//  Recipes
//
//  Created by Andrei Mirzac on 17/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import Foundation
import UIKit

class RecipeDetailViewModel {
    
    var recipe: Recipe
    var content: [SectionContent] = []
    
    var totalIngredients: Int {
        return recipe.ingredients.count
    }
    
    var totalSteps: Int {
        return recipe.steps.count
    }
    
    init(recipe: Recipe) {
        self.recipe = recipe
        content = [SectionContent.image(recipe.imageURL, title: recipe.name),
                   SectionContent.ingredients(recipe.ingredients),
                   SectionContent.steps(recipe.steps)]
    }
}

enum SectionContent {
    case image(String, title: String)
    case ingredients([Ingredient])
    case steps([String])
}

extension SectionContent {
    var cellIdentifier: String {
        return String(describing: cellType)
    }
    
    var cellType: UITableViewCell.Type {
        switch  self {
        case .image:
            return RecipeImageCell.self
        case .ingredients:
            return RecipeIngredientCell.self
        case .steps:
            return RecipeStepCell.self
        }
    }
}
