//
//  RecipesViewModel.swift
//  Recipes
//
//  Created by Andrei Mirzac on 14/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import Foundation


class RecipesViewModel {
    
    init(networkService: NetworkService = RecipeNetworkService()) {
        
    }
    
    func loadRecipes() {
        let resource = Resource<[Recipe]>(url: "https://mobile.asosservices.com/sampleapifortest/recipes.json")
        RecipeNetworkService().load(resource, completion: { result in
            
            switch result {
            case .success(let recipes):
                print(recipes)
            case .error(let error):
                print(error.localizedDescription)
                //TODO: Display an error popup
            }
        })
    }
}
