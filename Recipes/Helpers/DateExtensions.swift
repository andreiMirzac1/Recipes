//
//  DateExtensions.swift
//  Recipes
//
//  Created by Andrei Mirzac on 15/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import Foundation


extension Date {
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
}
