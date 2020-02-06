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

class RecipesViewModel {

  private var allRecipes: [Recipe] = []

  //output
  let disposeBag = DisposeBag()
  let recipes: PublishSubject<[Recipe]> = PublishSubject()

  // input
  let searchText: PublishSubject<String?> = PublishSubject()

  let filterByComplexity: BehaviorRelay<Complexity> = BehaviorRelay(value: .none)
  let filterByTime: BehaviorRelay<Time> = BehaviorRelay(value: .none)

  init(networkService: NetworkService, resource: Resource<[Recipe]>) {
    networkService.load(resource).observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] allRecipes in
      self?.recipes.onNext(allRecipes)
      self?.allRecipes = allRecipes
    }).disposed(by: disposeBag)

    searchText.debounce(RxTimeInterval.seconds(Int(1.0)), scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .compactMap { $0 }
      .filter { !$0.isEmpty }
      .subscribe(onNext: { query in
        print(query)
      }).disposed(by: disposeBag)

    filterByComplexity.subscribe(onNext: { [weak self] newComplexity in
      guard let self = self else {
        return
      }
      self.filterAndUpdateRecipes(complexity: newComplexity, time: self.filterByTime.value)
    }).disposed(by: disposeBag)

    filterByTime.subscribe(onNext: { [weak self] newTime in
      guard let self = self else {
        return
      }
      self.filterAndUpdateRecipes(complexity: self.filterByComplexity.value, time: newTime)
    }).disposed(by: disposeBag)
  }
}

//MARK: - Filtering
extension RecipesViewModel {
  //  func filterBy(_ searchText: String) {
  //    filteredRecipes = allRecipes.filter({ recipe in
  //      let lowerCasedSearchText = searchText.lowercased()
  //
  //      if recipe.name.lowercased().contains(lowerCasedSearchText) ||
  //        !recipe.ingredients.filter({$0.name.lowercased().contains(lowerCasedSearchText)}).isEmpty ||
  //        !recipe.steps.filter({$0.lowercased().contains(lowerCasedSearchText)}).isEmpty {
  //        return true
  //      }
  //      return false
  //    })
  //  }


  private func filterAndUpdateRecipes(complexity: Complexity, time: Time) {

      let filteredRecipes = self.filterRecipes(complexity: complexity, time: time)
      self.recipes.onNext(filteredRecipes)
  }

  private func filterRecipes(complexity: Complexity, time: Time) -> [Recipe] {
    return allRecipes.filter({ recipe in
      let complexityType = complexity != Complexity.none ? Complexity(recipe: recipe) : Complexity.none
      let timeType = time != Time.none ? Time(recipe: recipe) : Time.none
      return complexityType == complexity && timeType == time
    })
  }

}

