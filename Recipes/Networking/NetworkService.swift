//
//  NetworkService.swift
//  Recipes
//
//  Created by Andrei Mirzac on 14/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.

import Foundation

class NetworkService: Networking {

    let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    private func handleCache(isRefresh: Bool) {
        if isRefresh {
            URLCache.shared.removeAllCachedResponses()
        }
    }

    func load<A: Codable>(valueType: A.Type, urlString: String, isRefresh: Bool = false, completion: @escaping (Result<A, NetworkError>) -> ()) {

        handleCache(isRefresh: isRefresh)

        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidUrl))
            return
        }

        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
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

            do {
                let value = try JSONDecoder().decode(A.self, from: data)
                DispatchQueue.main.async{ completion(.success(value)) }
            } catch {
                DispatchQueue.main.async{ completion(.failure(.failureToDecodeData)) }
            }
        }).resume()
    }
}
