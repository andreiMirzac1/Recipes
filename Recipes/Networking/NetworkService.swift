//
//  NetworkService.swift
//  Recipes
//
//  Created by Andrei Mirzac on 14/06/2018.
//  Copyright © 2018 Andrei Mirzac. All rights reserved.

import Foundation
import RxSwift

class NetworkService {

  enum NetworkServiceError: Error {
      case dataNotFound
      case failedToParse
      case invalidStatusCode
  }
  
  private let cache: Cache?

  init(cache: Cache? = nil) {
    self.cache = cache
  }

  public func load<A: Codable>(_ resource: Resource<A>) -> Observable<A> {

    return Observable<A>.create { observer in
      let url = URL(string: resource.url)!
      let task = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error)  in
        do {
          guard let data = data else {
            return observer.onError(NetworkServiceError.dataNotFound)
          }
          let model = try JSONDecoder().decode(A.self , from: data)
          self?.cache?.save(data, for: resource)
          return observer.onNext(model)
        } catch let error {
          return observer.onError(error)
        }
      })

      task.resume()
      return Disposables.create {
        task.cancel()
      }
    }
  }

}

