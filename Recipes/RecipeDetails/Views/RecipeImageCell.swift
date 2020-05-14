//
//  RecipeImage.swift
//  Recipes
//
//  Created by Andrei Mirzac on 17/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import UIKit

class RecipeImageCell: UITableViewCell {
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    
    func setUp(imageURL: String, title: String) {
        loadImage(with: imageURL)
        recipeTitle.text = title
    }
    
    func loadImage(with urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        ImageDownloadManager.shared.downloadImage(with: url) {(image, url , error)  in
            DispatchQueue.main.async {  [weak self] in
                self?.recipeImage.image = image
            }
        }
    }
}
