//
//  UIViewControllerExtensions.swift
//  Recipes
//
//  Created by Andrei Mirzac on 13/05/2020.
//  Copyright © 2020 Andrei Mirzac. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}
