//
//  RecipesTests.swift
//  RecipesTests
//
//  Created by Andrei Mirzac on 13/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import XCTest
@testable import Recipes

class RecipesTests: XCTestCase {
    
    var recipesViewModel: RecipesViewModel!
    
    override func setUp() {
        super.setUp()
        
        let url = "recipes"
        let resource = Resource<[Recipe]>(url: url)
        let mockedService = MockNetworkService(networkService: NetworkService())
        recipesViewModel = RecipesViewModel(networkService: mockedService, resource: resource)
        recipesViewModel.loadRecipes()
    }
    
    func testCountAllRecipes() {
        XCTAssert(recipesViewModel.allRecipes.count == 9, "Number of recipes doesn't match")
    }
    
    func testFilterShouldReturnNoResults() {
        
        let searchText = "Random search text that should return no results"
        recipesViewModel.filterBy(searchText)
        XCTAssert(recipesViewModel.filteredRecipes.isEmpty, "Expected empty recipe list")
    }
    
    func testFilterResultsByRecipeName() {
        
        let searchText = "Roasted Asparagus"
        recipesViewModel.filterBy(searchText)
        
        XCTAssert(recipesViewModel.filteredRecipes.count == 1, "Number of recipes doesn't match")
        guard let recipe = recipesViewModel.filteredRecipes.first else {
            XCTFail("Filtered results list is empty")
            return
        }
        
        XCTAssert(recipe.name == searchText, "Wrong recipe name, should be equal with \(searchText)")
    }
    
    func testFilterRecipeByIngredientKeyWord() {
        
        let searchText = "olive oil"
        recipesViewModel.filterBy(searchText)
        
        XCTAssert(recipesViewModel.filteredRecipes.count == 1, "Number of recipes doesn't match")
        guard let recipe = recipesViewModel.filteredRecipes.first else {
            XCTFail("Filtered results list is empty")
            return
        }
        
        XCTAssert(recipe.name == "Roasted Asparagus", "Wrong recipe name should be equal with 'Roasted Asparagus'")
    }
    
    func testFilterResultByStepsKeyWord() {
        
        let searchText = "Add rice"
        
        recipesViewModel.filterBy(searchText)
        
        XCTAssert(recipesViewModel.filteredRecipes.count == 1, "Number of recipes doesn't match")
        guard let recipe = recipesViewModel.filteredRecipes.first else {
            XCTFail("Filtered results list is empty")
            return
        }
        
        XCTAssert(recipe.name == "Curried Lentils and Rice", "Recipe name should be equal with 'Curried Lentils and Rice'")
    }
    
    func testFilterResultByComplexityEasy() {
        recipesViewModel.filterBy(Complexity.easy)
        XCTAssert(recipesViewModel.filteredRecipes.count == 3, "Number of recipes doesn't match")
        XCTAssert(recipesViewModel.filteredRecipes[0].name == "Roasted Asparagus", "Recipe name doesn't match")
    }
    
    func testFilterResultByComplexityMedium() {
        recipesViewModel.filterBy(Complexity.medium)
        XCTAssert(recipesViewModel.filteredRecipes.count == 3, "Number of recipes doesn't match")
        XCTAssert(recipesViewModel.filteredRecipes[0].name == "Curried Lentils and Rice", "Recipe name doesn't match")
    }
    
    func testFilterResultByComplexityHard() {
        recipesViewModel.filterBy(Complexity.hard)
        XCTAssert(recipesViewModel.filteredRecipes.count == 3, "Number of recipes doesn't match")
        XCTAssert(recipesViewModel.filteredRecipes[0].name == "Crock Pot Roast", "Recipe name doesn't match")
    }
    
    func testFilterResultByComplexityAll() {
        recipesViewModel.filterBy(Complexity.none)
        XCTAssert(recipesViewModel.filteredRecipes.count == 0, "Number of recipes doesn't match")
    }
    
    func testFilterResultByTimeLessThenTenMinutes() {
        recipesViewModel.filterBy(Time.quick)
        XCTAssert(recipesViewModel.filteredRecipes.count == 1, "Number of recipes doesn't match")
        XCTAssert(recipesViewModel.filteredRecipes[0].name == "Curried chicken salad", "Recipe name doesn't match")
    }
    
    func testFilterResultByTimeBetweenTenAndTwentyMinutes() {
        recipesViewModel.filterBy(Time.medium)
        XCTAssert(recipesViewModel.filteredRecipes.count == 1, "Number of recipes doesn't match")
        XCTAssert(recipesViewModel.filteredRecipes[0].name == "Roasted Asparagus", "Recipe name doesn't match")
    }
    
    func testFilterResultByTimeMoreThenTwentyMinutes() {
        recipesViewModel.filterBy(Time.slow)
        XCTAssert(recipesViewModel.filteredRecipes.count == 7, "Number of recipes doesn't match")
        XCTAssert(recipesViewModel.filteredRecipes[0].name == "Crock Pot Roast", "Recipe name doesn't match")
    }
    
    func testFilterResultBySlowTimeComplexityHard() {
        recipesViewModel.filterBy(Time.slow)
        recipesViewModel.filterBy(Complexity.hard)
        XCTAssert(recipesViewModel.filteredRecipes.count == 3, "Number of recipes doesn't match")
    }
    
    func testFilterIsResetWhenComplexityAndTimeIsSetToAll() {
        recipesViewModel.filterBy(Time.none)
        recipesViewModel.filterBy(Complexity.none)
        XCTAssert(recipesViewModel.isFilterReset, "Expected filter to be reset")
    }
}


