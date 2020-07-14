//
//  ImageDownloadManager.swift
//  Recipes
//
//  Created by Andrei Mirzac on 08/09/2019.
//  Copyright © 2019 Andrei Mirzac. All rights reserved.
//

import Foundation
import UIKit

typealias ImageDownloadHandler = (_ image: UIImage?, _ url: URL, _ error: Error?) -> Void

final class ImageDownloadManager {
    
    lazy var imageDownloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "imageloading.queue"
        queue.qualityOfService = .userInitiated
        return queue
    }()

    static let shared = ImageDownloadManager()
    private init () {}
    
    func cancelAll() {
        imageDownloadQueue.cancelAllOperations()
    }
}

extension ImageDownloadManager {
    
    func downloadImage(with url: URL, handler: @escaping ImageDownloadHandler) {
        let newOperation = createOperation(with: url, handler: handler)
        imageDownloadQueue.addOperation(newOperation)
    }
    
    private func createOperation(with url: URL, handler: @escaping ImageDownloadHandler) -> ImageLoadingOperation {
        let operation = ImageLoadingOperation(url: url)
        operation.imageDownloadHandler = { (image, url, error) in
            handler(image, url, error)
        }
        return operation
    }
}




