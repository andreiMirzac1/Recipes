//
//  File.swift
//  Recipes
//
//  Created by Andrei Mirzac on 17/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: RecipeDetailViewModel
    
    
    init(viewModel: RecipeDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "RecipeDetailView", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
    }
    
    func registerCells() {
        for contentItem in viewModel.content {
            tableView.register(UINib(nibName: contentItem.cellIdentifier, bundle: nil), forCellReuseIdentifier: contentItem.cellIdentifier)
        }
    }
    
}

extension RecipeDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.content.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.content[section] {
        case .ingredients: return viewModel.totalIngredients
        case .steps: return viewModel.totalSteps
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contentItem = viewModel.content[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: contentItem.cellIdentifier, for: indexPath)
        
        switch contentItem {
        case .image(let imageUrl, title: let title):
            if let cell = cell as? RecipeImageCell {
                cell.setUp(imageURL: imageUrl, title: title)
            }
        case .ingredients(let ingredients):
            if let cell = cell as? RecipeIngredientCell {
                cell.setup(ingredients[indexPath.row])
            }
        case .steps(let steps):
            if let cell = cell as? RecipeStepCell {
                let step = steps[indexPath.row]
                cell.setup(step: step, stepNumber: indexPath.row + 1)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch viewModel.content[section] {
        case .ingredients: return "\(viewModel.totalIngredients) Ingredients "
        case .steps: return "\(viewModel.totalSteps) Steps "
        case .image: return nil
        }
    }
    
}
