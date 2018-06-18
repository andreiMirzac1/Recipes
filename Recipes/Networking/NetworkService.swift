//
//  NetworkService.swift
//  Recipes
//
//  Created by Andrei Mirzac on 14/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import Foundation

class NetworkService {
    
    /// Loads a resource. Completition handler returns an instance of type Result on main queue.
    public func load<A>(_ resource: Resource<A>, completion: @escaping (Result<A>) -> ()) {
         
        URLSession.shared.dataTask(with: URL(string: resource.url)!, completionHandler: { data, response, _ in
            
            var result: Result<A>
            
            guard let httpResponse = response as? HTTPURLResponse , httpResponse.statusCode == 200 else {
                result = Result.error(.invalidStatusCode)
                DispatchQueue.main.async{ completion(result) }
                
                return
            }
            
            guard let data = data else {
                result = Result.error(.dataNotFound)
                DispatchQueue.main.async{ completion(result) }
                return
            }
            result = Result(resource.parse(data), or: .failedToParse)
            completion(result)
        }) .resume()
    }
    
}

