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

  let complexityTitles: [String] = {
    var titles = Complexity.allValues.map({ $0.rawValue })
    titles.append("None")
    return titles
  }()

  let timeTitles: [String] = {
    var titles = Time.allValues.map({ $0.rawValue })
    titles.append("None")
    return titles
  }()

  //output
  let disposeBag = DisposeBag()
  let recipes: PublishSubject<[Recipe]> = PublishSubject()

  // input
  let searchText: PublishSubject<String?> = PublishSubject()

  // input output
  let filterByComplexity: BehaviorRelay<String?> = BehaviorRelay(value: .none)
  let filterByTime: BehaviorRelay<String?> = BehaviorRelay(value: .none)

  init(networkService: NetworkService, resource: Resource<[Recipe]>) {
    networkService.load(resource).observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] allRecipes in
      self?.recipes.onNext(allRecipes)
      self?.allRecipes = allRecipes
    }).disposed(by: disposeBag)

    searchText.debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .compactMap { $0 }
      .filter { !$0.isEmpty }
      .subscribe(onNext: { [weak self] query in
        guard let self = self else {
          return
        }
        self.recipes.onNext(self.filterBy(query))
      }).disposed(by: disposeBag)

    filterByComplexity.subscribe(onNext: { [weak self] newComplexity in
      guard let self = self else {
        return
      }
      let filtered = self.filterBy(complexityStr: newComplexity, timeStr: self.filterByTime.value)
      self.recipes.onNext(filtered)
    }).disposed(by: disposeBag)

    filterByTime.subscribe(onNext: { [weak self] newTime in
      guard let self = self else {
        return
      }
      let filtered = self.filterBy(complexityStr: self.filterByComplexity.value, timeStr: newTime)
      self.recipes.onNext(filtered)
    }).disposed(by: disposeBag)
  }
}

//MARK: - Filtering
extension RecipesViewModel {
  
  private func filterBy(_ searchText: String) -> [Recipe] {
    return allRecipes.filter({ $0.containsOccurence(of: searchText) })
  }
  
  private func filterBy(complexityStr: String?, timeStr: String?) -> [Recipe] {
    return allRecipes.filter({ recipe in
      var complexityMatch = true
      var timeMatch = true
      
      if let complexityStr = complexityStr, let selectedComplexity = Complexity(rawValue: complexityStr) {
        complexityMatch = selectedComplexity == Complexity(recipe: recipe)
      }
      
      if let timeStr = timeStr, let recipeTime = Time(rawValue: timeStr) {
        timeMatch = recipeTime == Time(recipe: recipe)
      }
      
      return complexityMatch && timeMatch
    })
  }
}

