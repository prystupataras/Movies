//
//  ImageLoader.swift
//  Movies
//
//  Created by Prystupa Taras on 24.06.2024.
//

import UIKit

class ImageDownloader {
    static let shared =  ImageDownloader()
    
    let image = UIImage(named: "no.picture")
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Check for errors
            if let error = error {
                completion(self.image)
                return
            }
            
            // Check for response status
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(self.image)
                return
            }
            
            // Check if data is valid
            guard let data = data, let image = UIImage(data: data) else {
                completion(self.image)
                return
            }
            
            // Image downloaded successfully
            completion(image)
        }.resume()
    }
}
