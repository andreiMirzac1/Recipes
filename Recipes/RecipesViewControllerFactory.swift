//
//  File.swift
//  Recipes
//
//  Created by Andrei Mirzac on 14/05/2020.
//  Copyright © 2020 Andrei Mirzac. All rights reserved.
//

import Foundation

protocol RecipesViewControllerFactory {
    func makeRecipesViewModel() -> RecipesViewModel
    func makeFilterDifficultyTitles() -> [String]
    func makeFilterPreparationTimeTitles() -> [String] 
}
