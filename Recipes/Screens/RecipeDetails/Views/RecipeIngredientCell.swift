//
//  RecipeIngredientsCell.swift
//  Recipes
//
//  Created by Andrei Mirzac on 17/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import Foundation
import UIKit

class RecipeIngredientCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var quantity: UILabel!
    
    func setup(_ ingredient: Ingredient) {
        self.name.text = ingredient.name.localizedCapitalized
        self.quantity.text = ingredient.quantity
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let heightConstraint = contentView.heightAnchor.constraint(equalToConstant: 44)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true
    }
}
