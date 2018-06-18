//
//  FileStorage.swift
//  Recipes
//
//  Created by Andrei Mirzac on 15/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import Foundation

struct FileStorage {
    
    var baseURL: URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    
    subscript(key: String) -> Data? {
        get {
            let url = baseURL.appendingPathComponent(key)
            return try? Data(contentsOf: url)
        }
        set {
            let url = baseURL.appendingPathComponent(key)
            
            guard let newValue = newValue else {
                try? FileManager.default.removeItem(at: url)
                return
            }
            
            try? newValue.write(to: url)
        }
    }
}
