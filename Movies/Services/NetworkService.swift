//
//  NetworkService.swift
//  Movies
//
//  Created by Prystupa Taras on 24.06.2024.
//

import Foundation
import Alamofire

class NetworkManager {
    static  let shared = NetworkManager()
    
    private let concurrentQueue = DispatchQueue(label: "com.example.concurrentFetchingQueue", attributes: .concurrent)
    
    func fetchMovie(id: Int, completion: @escaping (Movie?, Error?) -> Void) {
        let urlPath = Domain.baseUrl + Domain.movie + "/\(id)"
        
        fetchData(with: urlPath, completion: { (movie: Movie?, error: Error?) -> Void in
            if let movie = movie {
                completion(movie, nil)
            } else {
                completion(nil, error)
            }
        })
    }
    
    func fetchMoviesBySort(sortDomain: String, page: Int, completion: @escaping ([Movie], Error?) -> Void) {
        
        let urlPath = Domain.baseUrl + sortDomain
        
        fetchData(with: urlPath, parameters: ["page" : page], completion: { (movies: MovieResponse?, error: Error?) -> Void in
            if let movies = movies {
                completion(movies.results, nil)
            } else {
                completion([], error)
            }
        })
    }
    
    func searchMovie(query: String, completion: @escaping ([Movie], Error?) -> Void) {
        let urlPath = Domain.baseUrl + Domain.search

        fetchData(with: urlPath, parameters: ["query" : query], completion: { (movies: MovieResponse?, error: Error?) -> Void in
            if let movies = movies {
                completion(movies.results, nil)
            } else {
                completion([], error)
            }
        })
    }
}


private extension NetworkManager {
    func fetchData<T: Decodable>(with urlString: String, parameters: [String: Any] = [:], completion: @escaping (T?, Error?) -> Void) {
        let params = ["api_key": Domain.key].merging(parameters) { (current, new) in new }
        
        concurrentQueue.async {
            AF.request(urlString, method: .get, parameters: params)
                .responseDecodable(of: T.self, decoder: Utils.jsonDecoder) { response in
                    switch response.result {
                    case .success(let data):
                        completion(data, nil)
                    case .failure(let error):
                        completion(nil, error)
                    }
                }
        }
    }
}
