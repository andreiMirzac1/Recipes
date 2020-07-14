//
//  DependecyContainer.swift
//  Recipes
//
//  Created by Andrei Mirzac on 14/05/2020.
//  Copyright © 2020 Andrei Mirzac. All rights reserved.
//

import Foundation

class DependencyContainer {
    private lazy var networkService: Networking = NetworkService()
    
    func makeRecipesViewController() -> RecipesViewController {
        return RecipesViewController(factory: self)
    }
}

extension DependencyContainer: RecipesViewControllerFactory {
    func makeRecipesViewModel() -> RecipesViewModel {
        let service = RecipesService(networking: NetworkService())
        return RecipesViewModel(recipesService: service)
    }
    
    func makeFilterDifficultyTitles() -> [String] {
        var titles = Difficulty.allValues.map({ $0.rawValue })
        titles.append("All")
        return titles
    }
    
    func makeFilterPreparationTimeTitles() -> [String] {
        var titles = PreparationTime.allValues.map({ $0.rawValue })
        titles.append("All")
        return titles
    }

    func makeRecipeDetailViewController(recipe: Recipe) -> RecipeDetailViewController {
        let viewModel = RecipeDetailViewModel(recipe: recipe)
        return RecipeDetailViewController(viewModel: viewModel)
    }
}


