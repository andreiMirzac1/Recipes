//
//  RecipeListViewCell.swift
//  Recipes
//
//  Created by Andrei Mirzac on 15/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import Foundation
import UIKit

class RecipeListViewCell: UICollectionViewCell {
    @IBOutlet var image: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var ingredients: UILabel!
    @IBOutlet var time: UILabel!
    
    func setUp(recipe: Recipe) {

        loadImage(with: recipe.imageURL)
        title.text = recipe.name
        
        let attrIngredients =  NSMutableAttributedString(string: "Ingredients: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12.0)])
        let ingredientsString = NSMutableAttributedString(string: recipe.ingredients.map({ $0.name }).joined(separator: ", "))
        attrIngredients.append(ingredientsString)
        ingredients.attributedText = attrIngredients
        
        time.text = String(recipe.timers.reduce(0, { $0 + $1 })) + " mins"
    }

    func loadImage(with urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        ImageDownloadManager.shared.downloadImage(with: url) { (image, url , error)  in
            DispatchQueue.main.async {  [weak self] in
                self?.image.image = image
            }
        }
    }
}


