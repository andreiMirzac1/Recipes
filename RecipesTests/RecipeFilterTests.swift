//
//  RecipeFilter.swift
//  RecipesTests
//
//  Created by Andrei Mirzac on 14/05/2020.
//  Copyright © 2020 Andrei Mirzac. All rights reserved.
//

import XCTest
@testable import Recipes

class RecipeFilterTests: XCTestCase {

    let recipes: [Recipe] = StubLoader.load(fileName: "allRecipes")!
    let easyRecipe: Recipe = StubLoader.load(fileName: "recipe_complexity_easy")!
    let mediumRecipe: Recipe = StubLoader.load(fileName: "recipe_complexity_medium")!
    let hardRecipe: Recipe = StubLoader.load(fileName: "recipe_complexity_hard")!

    let quickRecipe: Recipe = StubLoader.load(fileName: "recipe_time_0_10min")!
    let mediumTimeRecipe: Recipe = StubLoader.load(fileName: "recipe_time_10_20min")!
    let slowRecipe: Recipe = StubLoader.load(fileName: "recipe_time_more_then_20min")!

    func testFilterDifficulty() {
        let filter = FilterManager(filters: RecipeFilters())
        XCTAssertNil(filter.filters.difficulty)

        filter.set(difficulty: .easy)
        XCTAssert(filter.filters.difficulty == .easy)
    }

    func testFilterSetPreparationTime() {
        let filter = FilterManager(filters: RecipeFilters())
        XCTAssertNil(filter.filters.preparationTime)

        filter.set(preparationTime: .medium)
        XCTAssert(filter.filters.preparationTime == .medium)
    }

    func testFilterResultByComplexityEasy() {
        let filter = FilterManager(filters: RecipeFilters(difficulty: .easy))
        filter.set(recipes: [easyRecipe, hardRecipe, mediumRecipe])
        XCTAssert(filter.filterRecipes().count == 1)
        XCTAssert(filter.filterRecipes().first == easyRecipe)
    }

    func testFilterResultByComplexityMedium() {
        let filter = FilterManager(filters: RecipeFilters(difficulty: .medium))
        filter.set(recipes: [easyRecipe, mediumRecipe, mediumRecipe])
        XCTAssert(filter.filterRecipes().count == 2)
        XCTAssert(filter.filterRecipes().first == mediumRecipe)
    }

    func testFilterResultByComplexityHard() {
        let filter = FilterManager(filters: RecipeFilters(difficulty: .hard))
        filter.set(recipes: [easyRecipe, hardRecipe, hardRecipe])
        XCTAssert(filter.filterRecipes().count == 2)
        XCTAssert(filter.filterRecipes().first == hardRecipe)
    }

    func testFilterResultByTimeLessThenTenMinutes() {
        let filter = FilterManager(filters: RecipeFilters(preparationTime: .quick))
        filter.set(recipes: [quickRecipe, mediumTimeRecipe, mediumTimeRecipe])
        XCTAssert(filter.filterRecipes().count == 1)
        XCTAssert(filter.filterRecipes().first == quickRecipe)
    }

    func testFilterResultByTimeBetweenTenAndTwentyMinutes() {
        let filter = FilterManager(filters: RecipeFilters(preparationTime: .medium))
        filter.set(recipes: [quickRecipe, mediumTimeRecipe, mediumTimeRecipe])
        XCTAssert(filter.filterRecipes().count == 2)
        XCTAssert(filter.filterRecipes().first == mediumTimeRecipe)
    }

    func testFilterResultByTimeMoreThenTwentyMinutes() {
        let filter = FilterManager(filters: RecipeFilters(preparationTime: .slow))
        filter.set(recipes: [quickRecipe, slowRecipe, mediumTimeRecipe])
        XCTAssert(filter.filterRecipes().count == 1)
        XCTAssert(filter.filterRecipes().first == slowRecipe)
    }
}
