//
//  RecipeImage.swift
//  Recipes
//
//  Created by Andrei Mirzac on 17/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import UIKit
import Kingfisher

class RecipeImageCell: UITableViewCell {
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    
    func setUp(imageURL: String, title: String) {
        recipeImage.kf.setImage(with: URL(string: imageURL))
        recipeTitle.text = title
    }
}
