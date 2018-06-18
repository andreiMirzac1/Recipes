//
//  RecipesViewModel.swift
//  Recipes
//
//  Created by Andrei Mirzac on 14/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import Foundation

protocol RecipesViewModelDelegate: class {
    func didUpdateContent()
}

class RecipesViewModel {
    
    private var networkService: CachedNetworkService
    private var resource: Resource<[Recipe]>
    
    var allRecipes = [Recipe]()
    var filteredRecipes = [Recipe]()
    var filter = Filter(time: Time.all, complexity: Complexity.all)
    
    weak var delegate: RecipesViewModelDelegate?
    
    init(networkService: CachedNetworkService, resource: Resource<[Recipe]>) {
        self.networkService = networkService
        self.resource = resource
    }
    
    func loadRecipes() {
        networkService.load(resource, callBack: { result in
            
            switch result {
            case .success(let recipes):
                self.allRecipes = recipes
                
            case .error(let error):
                print(error.localizedDescription)
            }
            self.delegate?.didUpdateContent()
        })
    }
}

//MARK: - Filtering
extension RecipesViewModel {
    
    var isFilterReset: Bool {
        return filter.isReset
    }
    
    func filterBy(_ searchText: String) {
        filteredRecipes = allRecipes.filter({ recipe in
            let lowerCasedSearchText = searchText.lowercased()
            
            if recipe.name.lowercased().contains(lowerCasedSearchText) ||
                !recipe.ingredients.filter({$0.name.lowercased().contains(lowerCasedSearchText)}).isEmpty ||
                !recipe.steps.filter({$0.lowercased().contains(lowerCasedSearchText)}).isEmpty {
                return true
            }
            return false
        })
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
        if filter.isReset {
            filteredRecipes = []
        } else {
            filteredRecipes = allRecipes.filter({ recipe in
                let complexityType = filter.complexity != .all ? Complexity(recipe: recipe) : Complexity.all
                let timeType = filter.time != .all ? Time(recipe: recipe) : Time.all
                return complexityType == filter.complexity && filter.time == timeType
            })
        }
        delegate?.didUpdateContent()
    }
}

