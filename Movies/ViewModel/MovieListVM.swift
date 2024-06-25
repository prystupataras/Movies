//
//  MovieListVM.swift
//  Movies
//
//  Created by Prystupa Taras on 24.06.2024.
//

import UIKit

protocol MovieListViewModelDelegate: AnyObject {
    func movieUpdated(_ row: Int)
}

class MovieListVM {
    weak var delegate: MovieListViewModelDelegate?

    private let networkManager = NetworkManager.shared
    
    private var movies: [Movie]      = []
    private var genres: [MovieGenre] = []
    
    private var currentPage = 1
    private var isFetchingMoreMovies = false
    
    func fetchMovie(for id: Int, completion: @escaping (Movie?, Error?) -> Void) {
        self.networkManager.fetchMovie(id: id) { newMovie, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            completion(newMovie, nil)
        }
        
    }
    
    func fetchMoviesBySort(sortDomain: String, completion: @escaping ([Movie], Error?) -> Void) {
        guard !isFetchingMoreMovies else { return }
        isFetchingMoreMovies = true
        
        networkManager.fetchMoviesBySort(sortDomain: sortDomain, page: currentPage) { [weak self] newMovies, error in
            guard let self = self else { return }
            
            if let error = error {
                completion([], error)
                self.isFetchingMoreMovies = false
                return
            }

            self.movies.append(contentsOf: newMovies)
            self.updateIfNeed()
            self.currentPage += 1
            completion(self.movies, nil)
            self.isFetchingMoreMovies = false
        }
    }
    
    func cleanMovies() {
        currentPage = 1
        isFetchingMoreMovies = false
        movies.removeAll()
    }
    
    func numberOfRowsInSection() -> Int {
        return movies.count
    }
    
    func movie(at index: Int) -> Movie {
        return movies[index]
    }
    
    func isFetching() -> Bool {
        return isFetchingMoreMovies
    }
    
    func updateIfNeed() {
        let shouldUpdate = self.movies.filter { $0.genres == nil }
        
        for movie in shouldUpdate {
            networkManager.fetchMovie(id: movie.id) { movie, error in
                guard let movie = movie else { return }
                let index = self.movies.firstIndex(where: { $0.id == movie.id })!
                self.movies[index] = movie
                self.delegate?.movieUpdated(index)
            }
        }
    }
}
