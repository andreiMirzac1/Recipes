//
//  RecipesViewModel.swift
//  Recipes
//
//  Created by Andrei Mirzac on 14/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol RecipesViewModelDelegate: class {
    func didUpdateContent()
}

class RecipesViewModel {
    
    private var networkService: NetworkService
    private var resource: Resource<[Recipe]>

    let recipes: Observable<[Recipe]>

    var filteredRecipes = [Recipe]()
    var filter = Filter(time: .none, complexity: .none)
    
    weak var delegate: RecipesViewModelDelegate?
    
    init(networkService: NetworkService, resource: Resource<[Recipe]>) {
        self.networkService = networkService
        self.resource = resource
        recipes = networkService.load(resource)
    }
}

//MARK: - Filtering
extension RecipesViewModel {
    
    var isFilterReset: Bool {
        return filter.isReset
    }
    
    func filterBy(_ searchText: String) {
//        filteredRecipes = allRecipes.filter({ recipe in
//            let lowerCasedSearchText = searchText.lowercased()
//
//            if recipe.name.lowercased().contains(lowerCasedSearchText) ||
//                !recipe.ingredients.filter({$0.name.lowercased().contains(lowerCasedSearchText)}).isEmpty ||
//                !recipe.steps.filter({$0.lowercased().contains(lowerCasedSearchText)}).isEmpty {
//                return true
//            }
//            return false
//        })
    }

    func filterBy(_ complexity: Complexity) {
        filter.complexity = complexity
        applyFilter()
    }

    func filterBy(_ time: Time) {
        filter.time = time
        applyFilter()
    }
    
    private func applyFilter() {
//        if filter.isReset {
//            filteredRecipes = []
//        } else {
//            filteredRecipes = allRecipes.filter({ recipe in
//                let complexityType = filter.complexity != .all ? Complexity(recipe: recipe) : Complexity.all
//                let timeType = filter.time != .all ? Time(recipe: recipe) : Time.all
//                return complexityType == filter.complexity && filter.time == timeType
//            })
//        }
        delegate?.didUpdateContent()
    }
}

