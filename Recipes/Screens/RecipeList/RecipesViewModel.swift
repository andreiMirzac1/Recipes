//
//  RecipesViewModel.swift
//  Recipes
//
//  Created by Andrei Mirzac on 14/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import Foundation

class RecipesViewModel {

    var navigationBarTitle: String {
        return "Recipes"
    }

    var shouldUpdateContent: (NetworkError?) -> Void = { _ in }
    var didSelectDifficultyFilter: (Difficulty?) -> Void = { _ in }
    var didSelectTimeFilter: (PreparationTime?) -> Void = { _ in }

    private var filter = FilterManager(filters: RecipeFilters())

    private let networkService: Networking
    private let resource: Resource<[Recipe]>
    private(set) var recipes: [Recipe] = []

    init(networkService: Networking, resource: Resource<[Recipe]>) {
        self.networkService = networkService
        self.resource = resource
    }

    func loadRecipes(isRefresh: Bool = false) {
        networkService.load(valueType: [Recipe].self, urlString: resource.url, isRefresh: isRefresh) { [weak self] result in
            switch result {
            case .failure(let error):
                 self?.shouldUpdateContent(error)
            case .success(let recipes):
                self?.updateRecipes(recipes: recipes)
            }
        }
    }

    private func updateRecipes(recipes: [Recipe]) {
        filter.set(recipes: recipes)
        self.recipes = filter.filterRecipes()
        shouldUpdateContent(nil)
    }
}

//MARK: - Filtering
extension RecipesViewModel {

    func filterByDifficulty(rawValue: String) {
        let difficulty = Difficulty(rawValue: rawValue)
        filter.set(difficulty: difficulty)
        recipes = filter.filterRecipes()

        didSelectDifficultyFilter(difficulty)
        shouldUpdateContent(nil)
    }

    func filterByTime(rawValue: String) {
        let preparationTime = PreparationTime(rawValue: rawValue)
        filter.set(preparationTime: preparationTime)
        recipes = filter.filterRecipes()

        didSelectTimeFilter(preparationTime)
        shouldUpdateContent(nil)
    }
}

