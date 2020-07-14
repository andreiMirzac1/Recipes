//
//  RecipeService.swift
//  Recipes
//
//  Created by Andrei Mirzac on 14/07/2020.
//  Copyright © 2020 Andrei Mirzac. All rights reserved.
//

import Foundation

class RecipesService {
    let networking: Networking

    init(networking: Networking = NetworkService()) {
        self.networking = networking
    }

    func loadRecipes() {

    }
}
