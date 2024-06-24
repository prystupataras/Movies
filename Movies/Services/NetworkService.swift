//
//  NetworkService.swift
//  Movies
//
//  Created by Prystupa Taras on 24.06.2024.
//

import Foundation
import Alamofire

typealias SuccessCallback = (_ result   : Array<Movie> ) -> Void
typealias ErrorCallback   = (_ message  : String ) -> Void

class NetworkService {
    static let shared =  NetworkService()
    
    private var onSuccess: SuccessCallback?
    private var onError: ErrorCallback?
    
    private var testCounter: Int = 1
    
    let session = URLSession(configuration: .default)
    
    func getMovies(onSuccess: @escaping (Array<Movie>) -> Void, onError: @escaping ErrorCallback) {
        self.onSuccess = onSuccess
        self.onError = onError
        
        getMovies(.URL_BASE + .URL_TRAND + .API_DAY + .API_KEY)
    }
    
    func getMovie(by id: Int, onSuccess:  @escaping (Array<Movie>) -> Void, onError:  @escaping ErrorCallback) {
        self.onSuccess = onSuccess
        self.onError = onError
        
        getMovie(.URL_BASE + .API_MOVIE + "/\(id)" + .API_KEY)
    }
    
    private func getMovies(_ path: String?) {
        
        guard let url = URL(string: path ?? "") else { self.onError?("Can`t reatch url path"); return }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            DispatchQueue.global(qos: .background).async{
//            DispatchQueue.main.async {
                if let error = error {
                    self.onError?(error.localizedDescription)
                    return
                }
                
                guard let data = data, let response = response as? HTTPURLResponse else {
                    self.onError?("Invalid data or response")
                    return
                }
                
                do {
                    if response.statusCode == 200 {
                    
                        
                        let response = try Utils.jsonDecoder.decode(MovieResponse.self, from: data)
                        self.onSuccess?(response.results)

                    } else {
                        let err = try JSONDecoder().decode(APIError.self, from: data)
                        self.onError?(err.message)
                    }
                }
                catch {
                    self.onError?(error.localizedDescription)
                    print(error)
                }
            }
            
        }
        task.resume()
    }
    
    private func getMovie(_ path: String?) {
        
        guard let url = URL(string: path ?? "") else { self.onError?("Can`t reatch url path"); return }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            DispatchQueue.global(qos: .userInitiated).async {
                if let error = error {
                    self.onError?(error.localizedDescription)
                    return
                }
                
                guard let data = data, let response = response as? HTTPURLResponse else {
                    self.onError?("Invalid data or response")
                    return
                }
                
                do {
                    if response.statusCode == 200 {
                    
                        
                        let movie = try Utils.jsonDecoder.decode(Movie.self, from: data)
                        self.onSuccess?([movie])

                    } else {
                        let err = try JSONDecoder().decode(APIError.self, from: data)
                        self.onError?(err.message)
                    }
                }
                catch {
                    self.onError?(error.localizedDescription)
                    print(error)
                }
            }
            
        }
        task.resume()
    }
}
