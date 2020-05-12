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

    var shouldUpdateContent: () -> Void = { }
    var didSelectComplexityFilter: (Complexity?) -> Void = { _ in }
    var didSelectTimeFilter: (Time?) -> Void = { _ in }

    let complexityTitles: [String] = {
        var titles = Complexity.allValues.map({ $0.rawValue })
        titles.append("All")
        return titles
    }()

    let timeTitles: [String] = {
        var titles = Time.allValues.map({ $0.rawValue })
        titles.append("All")
        return titles
    }()

    //output
    let disposeBag = DisposeBag()
    var filter: RecipeFilter?

    // input
    let searchText: PublishSubject<String?> = PublishSubject()
    private let networkService: NetworkService
    private let resource: Resource<[Recipe]>
    private var allRecipes: [Recipe] = []
    var recipes: [Recipe] = []
    // input output

    init(networkService: NetworkService, resource: Resource<[Recipe]>) {
        self.networkService = networkService
        self.resource = resource

        searchText.debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [weak self] query in
                guard let self = self else {
                    return
                }
                // self.recipes.accept(self.filterBy(query))
            }).disposed(by: disposeBag)
    }

    func loadRecipes() {
        networkService.load(resource) { [weak self] result in
            switch result {
            case .failure(let error):
                //TODO: Handle errors
                break
            case .success(let recipes):
                self?.allRecipes = recipes
                self?.filter = RecipeFilter(recipes: recipes)
                self?.recipes = recipes
            }
            self?.shouldUpdateContent()
        }
    }
}

//MARK: - Filtering
extension RecipesViewModel {

    func filterByComplexity(rawValue: String) {
        guard let filter = filter else {
            return
        }

        let complexity = Complexity(rawValue: rawValue)
        recipes = filter.filterBy(complexity: complexity)
        shouldUpdateContent()
    }

    func filterByTime(rawValue: String) {
        guard let filter = filter else {
            return
        }

        let time = Time(rawValue: rawValue)
        recipes = filter.filterBy(time: time)
        shouldUpdateContent()
    }

    private func filterBy(_ searchText: String) -> [Recipe] {
        return allRecipes.filter({ $0.containsOccurence(of: searchText) })
    }
}

