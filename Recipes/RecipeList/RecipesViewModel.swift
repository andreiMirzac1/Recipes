//
//  RecipesViewModel.swift
//  Recipes
//
//  Created by Andrei Mirzac on 14/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import Foundation

class RecipesViewModel {

    var shouldUpdateContent: (NetworkError?) -> Void = { _ in }
    var didSelectDifficultyFilter: (Difficulty?) -> Void = { _ in }
    var didSelectTimeFilter: (Time?) -> Void = { _ in }

    let difficultyTitles: [String] = {
        var titles = Difficulty.allValues.map({ $0.rawValue })
        titles.append("All")
        return titles
    }()

    let timeTitles: [String] = {
        var titles = Time.allValues.map({ $0.rawValue })
        titles.append("All")
        return titles
    }()

    var navigationBarTitle: String {
        return "Recipes"
    }

    //output
    var filter: RecipeFilter?

    private let networkService: Networking
    private let resource: Resource<[Recipe]>
    private var allRecipes: [Recipe] = []
    var recipes: [Recipe] = []

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
        allRecipes = recipes
        filter = RecipeFilter(recipes: allRecipes)
        self.recipes = allRecipes
        shouldUpdateContent(nil)
    }
}

//MARK: - Filtering
extension RecipesViewModel {

    func filterByDifficulty(rawValue: String) {
        guard let filter = filter else {
            return
        }

        let difficulty = Difficulty(rawValue: rawValue)
        recipes = filter.filterBy(difficulty: difficulty)
        shouldUpdateContent(nil)
        didSelectDifficultyFilter(difficulty)
    }

    func filterByTime(rawValue: String) {
        guard let filter = filter else {
            return
        }

        let time = Time(rawValue: rawValue)
        recipes = filter.filterBy(time: time)
        shouldUpdateContent(nil)
        didSelectTimeFilter(time)
    }
}

