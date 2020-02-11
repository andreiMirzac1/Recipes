//
//  ViewController.swift
//  Recipes
//
//  Created by Andrei Mirzac on 13/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RecipesViewController: UIViewController {

  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var complexityButton: UIButton!
  @IBOutlet var timeButton: UIButton!
  
  let disposeBag = DisposeBag()

  let sectionInsets = UIEdgeInsets(top: 20.0, left: 5.0, bottom: 20.0, right: 5.0)
  let columns: CGFloat = 2
  let spaceBetweenRows: CGFloat = 20
  let spaceBetweenColumns: CGFloat = 0
  let interitemSpacing: CGFloat = 10

  /// SearchController
  let searchController = UISearchController(searchResultsController: nil)

  //Filter button tags
  enum FilterButton: Int {
    case complexity = 1
    case time
  }

  lazy var viewModel: RecipesViewModel =  {
    let url = "https://mobile.asosservices.com/sampleapifortest/recipes.json"
    let resource = Resource<[Recipe]>(url: url)
    return RecipesViewModel(networkService: NetworkService(), resource: resource)
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    registerCells()
    setupSearchController()
    bindToViewModel()
  }

  func bindToViewModel() {
    collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    viewModel.recipes
      .subscribeOn(MainScheduler.instance)
      .bind(to: collectionView.rx.items(cellIdentifier: RecipeListViewCell.reuseIdentifier, cellType: RecipeListViewCell.self)) { (row, recipe, cell) in
        cell.setUp(recipe: recipe)
    }.disposed(by: disposeBag)

    //Search Text
    searchController.searchBar.rx.text.bind(to: viewModel.searchText).disposed(by: disposeBag)

    viewModel.filterByComplexity.subscribe(onNext: { complexity in
      var title = "Complexity: None"
      if let complexity = complexity {
        title = "Complexity: \(complexity.rawValue)"
      }

      self.complexityButton.setTitle(title, for: .normal)
    }).disposed(by: disposeBag)

    viewModel.filterByTime.subscribe(onNext: { time in
       var title = "Time: None"
       if let time = time {
         title = "Time: \(time.rawValue)"
       }
       self.timeButton.setTitle(title, for: .normal)
     }).disposed(by: disposeBag)
  }

  func registerCells() {
    let nib = UINib(nibName: RecipeListViewCell.reuseIdentifier, bundle: nil)
    collectionView.register(nib, forCellWithReuseIdentifier: RecipeListViewCell.reuseIdentifier)
  }
}

// MARK: - SearchController Helpers
extension RecipesViewController {

  func searchBarIsEmpty() -> Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }

  func isFiltering() -> Bool {
    return searchController.isActive && !searchBarIsEmpty()
  }
}

extension RecipesViewController {

  @IBAction func filterBy(sender: UIButton) {
    guard let buttonType = FilterButton(rawValue: sender.tag) else {
      return
    }

    var actionTitles = [String]()
    switch buttonType {
    case .complexity:
      actionTitles = Complexity.allValues.map({ $0.rawValue })
    case .time:
      actionTitles = Time.allValues.map({ $0.rawValue })
    }

    let actionClosure: (UIAlertAction) -> () = { action in
      guard let title = action.title else {
        return
      }

      switch buttonType {
      case .complexity:
        guard let complexity = Complexity(rawValue: title) else {
          return
        }
        self.viewModel.filterByComplexity.accept(complexity)
      case .time:
        guard let time = Time(rawValue: title) else {
          return
        }
        self.viewModel.filterByTime.accept(time)
      }
    }

    let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    actionSheet.addAction(cancel)

    for title in actionTitles {
      let action = UIAlertAction(title: title, style: .default, handler: actionClosure)
      actionSheet.addAction(action)
    }
    self.present(actionSheet, animated: true)
  }
}

extension RecipesViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    //Width
    let screenWidth = UIScreen.main.bounds.width
    let paddingSpace = sectionInsets.left * (columns)
    let availableWidth = screenWidth - paddingSpace - interitemSpacing
    let width = availableWidth / columns

    // Height
    let height = width + (width * 0.50)

    return CGSize(width: width, height: height)
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return spaceBetweenColumns
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return spaceBetweenRows
  }
}

extension RecipesViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    guard let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeListViewCell.reuseIdentifier, for: indexPath) as? RecipeListViewCell else {
      return UICollectionViewCell()
    }

    if isFiltering() {
      //   cell.setUp(recipe: viewModel.filteredRecipes[indexPath.row])
    } else {
      //  cell.setUp(recipe: viewModel.allRecipes.[indexPath.row])
    }

    return cell
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
//    if isFiltering() {
//      //return viewModel.filteredRecipes.count
//
//    } else {
//      //   return viewModel.allRecipes.count
//    }
  }
}


extension RecipesViewController: UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        var selectedRecipe: Recipe
    //        if isFiltering() {
    //            selectedRecipe = viewModel.filteredRecipes[indexPath.row]
    //        } else {
    //            selectedRecipe = viewModel.allRecipes[indexPath.row]
    //        }
    //
    //        let recipeDetailViewModel = RecipeDetailViewModel(recipe: selectedRecipe)
    //        let viewController = RecipeDetailViewController(viewModel: recipeDetailViewModel)
    //        self.navigationController?.pushViewController(viewController, animated: true)
  }
}

extension RecipesViewController {

  func setupSearchController() {
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search recipe by name, ingredients, steps"
    navigationItem.searchController = searchController
    definesPresentationContext = true
  }
}
