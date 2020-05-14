//
//  StubLoader.swift
//  RecipesTests
//
//  Created by Andrei Mirzac on 13/05/2020.
//  Copyright © 2020 Andrei Mirzac. All rights reserved.
//

import Foundation

class StubLoader {
    static func loadData(from fileName: String) -> Data? {
        let bundle = Bundle(for: StubLoader.self)
        guard let path = bundle.path(forResource: fileName, ofType: "json") else {
            return nil
        }
        return FileManager.default.contents(atPath: path)
    }
    
    static func load<T: Decodable>(fileName: String) -> T? {
        do {
            guard let data = loadData(from: fileName) else {
                return nil
            }
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            return nil
        }
    }
}
