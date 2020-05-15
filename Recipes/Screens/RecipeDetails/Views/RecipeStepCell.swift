//
//  RecipeStepsCell.swift
//  Recipes
//
//  Created by Andrei Mirzac on 17/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import Foundation
import UIKit

class RecipeStepCell: UITableViewCell {
    
    @IBOutlet weak var step: UILabel!
    @IBOutlet weak var stepNumber: UILabel!
    
    func setup(step: String, stepNumber: Int) {
        self.step.text = step
        self.stepNumber.text = String(stepNumber) + "#"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let heightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true
    }
    
}
