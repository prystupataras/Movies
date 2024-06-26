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
        let url = Domain.baseUrl + Domain.movie + "/\(id)"
        let parameters: [String: Any] = [
            "api_key": Domain.key,
        ]
        
        concurrentQueue.async {
            AF.request(url, method: .get, parameters: parameters)
                .responseDecodable(of: Movie.self, decoder: Utils.jsonDecoder) { response in
                    switch response.result {
                    case .success(let movie):
                        completion(movie, nil)
                    case .failure(let error):
                        completion(nil, error)
                    }
                }
        }
    }
    
    func fetchMoviesBySort(sortDomain: String, page: Int, completion: @escaping ([Movie], Error?) -> Void) {
        
        let url = Domain.baseUrl + sortDomain
        
        let parameters: [String: Any] = [
            "api_key": Domain.key,
            "page": page
        ]
        
        concurrentQueue.async {
            AF.request(url, method: .get, parameters: parameters)
                .responseDecodable(of: MovieResponse.self, decoder: Utils.jsonDecoder) { response in
                    switch response.result {
                    case .success(let movieResponse):
                        completion(movieResponse.results, nil)
                    case .failure(let error):
                        completion([], error)
                    }
                }
        }
    }
}
