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
    //Search Text
    searchController.searchBar.rx.text.bind(to: viewModel.searchText).disposed(by: disposeBag)

    viewModel.filterByComplexity.subscribe(onNext: { complexity in
      self.complexityButton.setTitle("Complexity \(complexity ?? "None")", for: .normal)
    }).disposed(by: disposeBag)

    viewModel.filterByTime.subscribe(onNext: { time in
      self.timeButton.setTitle("Time \(time ?? "None")", for: .normal)
    }).disposed(by: disposeBag)
  }

  func registerCells() {
    let nib = UINib(nibName: RecipeListViewCell.reuseIdentifier , bundle: nil)
    collectionView.register(nib, forCellWithReuseIdentifier: RecipeListViewCell.reuseIdentifier)
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
      actionTitles = viewModel.complexityTitles
    case .time:
      actionTitles = viewModel.timeTitles
    }

    let actionClosure: (UIAlertAction) -> () = { action in
      switch buttonType {
      case .complexity:
        self.viewModel.filterByComplexity.accept(action.title)
      case .time:
        self.viewModel.filterByTime.accept(action.title)
      }
    }

    let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    actionSheet.addAction(cancel)

    for title in actionTitles {
      let action = UIAlertAction(title: title, style: .default, handler: actionClosure)
      actionSheet.addAction(action)
    }
   present(actionSheet, animated: true)
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

extension RecipesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.recipes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeListViewCell.reuseIdentifier, for: indexPath) as? RecipeListViewCell else {
            fatalError("Failed to deque cell of type \(String(describing: RecipeListViewCell.self))")
        }
        cell.setUp(recipe: viewModel.recipes[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = viewModel.recipes[indexPath.row]
        let recipeDetailViewModel = RecipeDetailViewModel(recipe: recipe)
        let viewController = RecipeDetailViewController(viewModel: recipeDetailViewModel)
        navigationController?.pushViewController(viewController, animated: true)
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
