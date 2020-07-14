//
//  NetworkService.swift
//  Recipes
//
//  Created by Andrei Mirzac on 14/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.

import Foundation

class NetworkService: Networking {

   private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    private func handleCache(isRefresh: Bool) {
        if isRefresh {
            URLCache.shared.removeAllCachedResponses()
        }
    }

    func load<A: Codable>(resource: Resource<A>, isRefresh: Bool = false, completion: @escaping (Result<A, NetworkError>) -> ()) {

        handleCache(isRefresh: isRefresh)

        guard let url = URL(string: resource.url) else {
            completion(.failure(.invalidUrl))
            return
        }

        var request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
        request.httpMethod = resource.method.rawValue

        session.dataTask(with: request, completionHandler: { data, response, error in

            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
                    DispatchQueue.main.async{ completion(.failure(.invalidStatusCode)) }
                    return
            }

            guard let data = data else {
                DispatchQueue.main.async{ completion(.failure(.dataNotFound)) }
                return
            }

            guard let value = resource.parse(data) else {
                DispatchQueue.main.async{ completion(.failure(.failureToDecodeData)) }
                return
            }
            DispatchQueue.main.async{ completion(.success(value)) }
        }).resume()
    }
}
