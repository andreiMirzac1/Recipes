//
//  Time.swift
//  Recipes
//
//  Created by Andrei Mirzac on 17/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import Foundation

enum Time: String {
    case quick = "0-10min"
    case medium = "10-20min"
    case slow = "20+min"
    case all = "All"
    
    static let allValues = [quick, medium, slow, all]
}

extension Time {
    init(recipe: Recipe) {
        
        switch recipe.timers.reduce(0, +) {
        case 0..<10:
            self = .quick
        case 10..<20:
            self = .medium
        case 20...Int.max:
            self = .slow
        default:
            self = .all
        }
    }
}
