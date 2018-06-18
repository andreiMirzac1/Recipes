//
//  Filter.swift
//  Recipes
//
//  Created by Andrei Mirzac on 16/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import Foundation


struct Filter {
    var time: Time
    var complexity: Complexity
    
    var isReset: Bool {
        return complexity == .all && time == .all
    }
}











