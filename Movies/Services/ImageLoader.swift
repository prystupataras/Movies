//
//  ImageLoader.swift
//  Movies
//
//  Created by Prystupa Taras on 24.06.2024.
//

import UIKit

class ImageDownloader {
    static let shared =  ImageDownloader()

    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Check for errors
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Check for response status
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                completion(nil)
                return
            }
            
            // Check if data is valid
            guard let data = data, let image = UIImage(data: data) else {
                print("Invalid image data")
                completion(nil)
                return
            }
            
            // Image downloaded successfully
            completion(image)
        }.resume()
    }
}
