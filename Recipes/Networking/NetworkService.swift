//
//  NetworkService.swift
//  Recipes
//
//  Created by Andrei Mirzac on 14/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.

import Foundation

class NetworkService {

    let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func load<A>(_ resource: Resource<A>, completion: @escaping (Result<A, NetworkServiceError>) -> ()) {
        session.dataTask(with: URL(string: resource.url)!, completionHandler: { data, response, error in

            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
                    DispatchQueue.main.async{ completion(.failure(.invalidStatusCode)) }
                    return
            }

            guard let data = data, let value = resource.parse(data) else {
                DispatchQueue.main.async{ completion(.failure(.failedToParse)) }
                return
            }

            DispatchQueue.main.async{ completion(.success(value)) }

        }).resume()
    }
}

