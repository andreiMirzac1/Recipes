//
//  RecipeListViewCell.swift
//  Recipes
//
//  Created by Andrei Mirzac on 15/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class RecipeListViewCell: UICollectionViewCell {
    @IBOutlet var image: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var ingredients: UILabel!
    @IBOutlet var time: UILabel!
    
    func setUp(recipe: Recipe) {
        let url = URL(string: recipe.imageURL)
        image.kf.setImage(with: url)
        
        title.text = recipe.name
        
        let attrIngredients =  NSMutableAttributedString(string: "Ingredients: ", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12.0)])
        let ingredientsString = NSMutableAttributedString(string: recipe.ingredients.map({ $0.name }).joined(separator: ", "))
        attrIngredients.append(ingredientsString)
        ingredients.attributedText = attrIngredients
        
        time.text = String(recipe.timers.reduce(0, { $0 + $1 })) + " mins"
    }
    
}

extension UICollectionViewCell {
  public static var reuseIdentifier: String {
    return String(describing: self)
  }
}
