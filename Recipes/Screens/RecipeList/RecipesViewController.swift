//
//  ViewController.swift
//  Recipes
//
//  Created by Andrei Mirzac on 13/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import UIKit

class RecipesViewController: UIViewController {

    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var difficultyButton: UIButton!
    @IBOutlet private var timeButton: UIButton!
    private let refreshControl = UIRefreshControl()

    private struct Constants {
        static let sectionInsets = UIEdgeInsets(top: 20.0, left: 5.0, bottom: 20.0, right: 5.0)
        static let columns: CGFloat = 2
        static let spaceBetweenRows: CGFloat = 20
        static let spaceBetweenColumns: CGFloat = 0
        static let interitemSpacing: CGFloat = 10
    }

    private let factory: RecipesViewControllerFactory
    private lazy var viewModel = factory.makeRecipesViewModel()

    init(factory: RecipesViewControllerFactory) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        setUpRefreshControl()
        bindToViewModel()
        styleFilterButtons()
        navigationItem.title = viewModel.navigationBarTitle
        viewModel.loadRecipes()
    }

    private func bindToViewModel() {
        viewModel.shouldUpdateContent = { [weak self] error in
            self?.collectionView.reloadData()
            self?.refreshControl.endRefreshing()

            if let error = error  {
                self?.showAlert(title: "Network Error", message: error.localizedDescription)
            }
        }

        viewModel.didSelectTimeFilter = { [weak self] time in
            self?.timeButton.setTitle("Time: \(time?.rawValue ?? "All")", for: .normal)
        }

        viewModel.didSelectDifficultyFilter = { [weak self] difficulty in
            self?.difficultyButton.setTitle("Difficulty: \(difficulty?.rawValue ?? "All")", for: .normal)
        }
    }

    private func registerCells() {
        let nib = UINib(nibName: RecipeListViewCell.reuseIdentifier , bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: RecipeListViewCell.reuseIdentifier)
    }

    private func setUpRefreshControl() {
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }

    @objc private func pullToRefresh(refreshControl: UIRefreshControl) {
        viewModel.loadRecipes(isRefresh: true)
    }

    private func showAlert(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }

    private func styleFilterButtons() {
        difficultyButton.layer.cornerRadius = 15
        timeButton.layer.cornerRadius = 15
    }
}

//MARK: - AlertController Factory
extension RecipesViewController {

    @IBAction private func filterByPreparationTime(sender: UIButton) {
        let actionClosure: (UIAlertAction) -> () = { action in
            guard let title = action.title else {
                return
            }
            self.viewModel.filterByTime(rawValue: title)
        }
        let actionTitles = factory.makeFilterPreparationTimeTitles()
        let alertController = createAlertController(actionTitles: actionTitles, handler: actionClosure)
        present(alertController, animated: true)
    }

    @IBAction private func filterByDifficulty(sender: UIButton) {
        let actionClosure: (UIAlertAction) -> () = { action in
            guard let title = action.title else {
                return
            }
            self.viewModel.filterByDifficulty(rawValue: title)
        }

        let actionTitles = factory.makeFilterDifficultyTitles()
        let alertController = createAlertController(actionTitles: actionTitles, handler: actionClosure)
        present(alertController, animated: true)
    }

    private func createAlertController(actionTitles: [String], handler: ((UIAlertAction) -> ())?) -> UIAlertController {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancel)

        for title in actionTitles {
            let action = UIAlertAction(title: title, style: .default, handler: handler)
            actionSheet.addAction(action)
        }
        return actionSheet
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension RecipesViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Width
        let screenWidth = UIScreen.main.bounds.width
        let paddingSpace = Constants.sectionInsets.left * (Constants.columns)
        let availableWidth = screenWidth - paddingSpace - Constants.interitemSpacing
        let width = availableWidth / Constants.columns

        let height = width + (width / 2)

        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.spaceBetweenColumns
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.spaceBetweenRows
    }

}

//MARK: - UICollectionViewDataSource UICollectionViewDelegate
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
        let viewController = factory.makeRecipeDetailViewController(recipe: recipe)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

