//
//  MockHelper.swift
//  RecipesTests
//
//  Created by Andrei Mirzac on 13/05/2020.
//  Copyright © 2020 Andrei Mirzac. All rights reserved.
//

import Foundation

class  NetworkingServiceHelper {
    static func getResponse(statusCode: Int, url: String) -> HTTPURLResponse {
        return HTTPURLResponse(url: URL(string: url)!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }

    static func loadData(fileName: String) -> Data? {

        let bundle = Bundle(for: NetworkingServiceHelper.self)
        guard let path = bundle.path(forResource: fileName, ofType: "json") else {
            return nil
        }
        return FileManager.default.contents(atPath: path)
    }
}
