//
//  NetworkService.swift
//  Recipes
//
//  Created by Andrei Mirzac on 14/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.
//

import Foundation

protocol NetworkService {
    func load<A>(_ resource: Resource<A>, completion: @escaping (Result<A>) -> ())
}

extension NetworkService {
    
    /// Loads a resource. Completition handler returns an instance of type Result on main queue.
    public func load<A>(_ resource: Resource<A>, completion: @escaping (Result<A>) -> ()) {
        
        URLSession.shared.dataTask(with: URL(string: resource.url)!, completionHandler: { data, response, _ in
            
            var result: Result<A>
            
            guard let httpResponse = response as? HTTPURLResponse , httpResponse.statusCode == 200 else {
                result = Result.error(.invalidStatusCode)
                completion(result)
                return
            }
            
            guard let data = data else {
                result = Result.error(.dataNotFound)
                completion(result)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let decodedObject: A = try decoder.decode(A.self, from: data)
                result = Result.success(decodedObject)
                DispatchQueue.main.async { completion(result) }
            } catch {
                result = Result.error(.failedToParse)
                completion(result)
            }
        }) .resume()
    }
    
}

