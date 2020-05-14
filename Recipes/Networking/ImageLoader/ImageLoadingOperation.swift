//
//  ImageLoadingOperation.swift
//  Recipes
//
//  Created by Andrei Mirzac on 08/09/2019.
//  Copyright © 2019 Andrei Mirzac. All rights reserved.
//

import UIKit

class ImageLoadingOperation: AsynchronousOperation {
    
    private var imageUrl: URL
    
    var imageDownloadHandler: ImageDownloadHandler?
    
    required init(url: URL) {
        self.imageUrl = url
    }
    
    override func main() {
        super.main()
        guard !isCancelled else {
            state = .finished
            return
        }
        state = .executing
        downloadImage()
    }
    
    private func downloadImage() {

        let newSession = URLSession.shared
        let request = URLRequest(url: imageUrl, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        let downloadTask = newSession.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let image = UIImage(data: data)
                self.imageDownloadHandler?(image, self.imageUrl, error)
            }
            self.state = .finished
        }
        downloadTask.resume()
    }
}
