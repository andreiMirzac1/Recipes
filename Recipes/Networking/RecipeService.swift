//
//  RecipeService.swift
//  Recipes
//
//  Created by Andrei Mirzac on 14/07/2020.
//  Copyright © 2020 Andrei Mirzac. All rights reserved.
//

import Foundation

class RecipesService {
    private let networking: Networking

    init(networking: Networking = NetworkService()) {
        self.networking = networking
    }

    func loadRecipes(isRefresh: Bool = false, completion: @escaping (Result<[Recipe], NetworkError>) -> ()) {
        let url = "https://mobile.asosservices.com/sampleapifortest/recipes.json"
        let resource = Resource<[Recipe]>(url: url)
        networking.load(resource: resource, isRefresh: isRefresh, completion: completion)
    }
}
