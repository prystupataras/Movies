//
//  MovieListVM.swift
//  Movies
//
//  Created by Prystupa Taras on 24.06.2024.
//

import UIKit

protocol MovieListViewModelDelegate: AnyObject {
    func moviesDidChange(_ viewModel: MovieListVM)
    func movieUpdated(_ row: Int)
}

class MovieListVM {
    weak var delegate: MovieListViewModelDelegate?

    private let networkManager = NetworkManager.shared
    
    private var movies: [Movie]      = []
    private var search: [Movie]      = []
    private var genres: [MovieGenre] = []
    
    private var currentPage = 1
    private var isFetchingMoreMovies = false
    private var isSearchingMovies = false
    
    func fetchMovie(for id: Int, completion: @escaping (Movie?, Error?) -> Void) {
        self.networkManager.fetchMovie(id: id) { newMovie, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            completion(newMovie, nil)
        }
        
    }
    
    func fetchMoviesBySort(sortDomain: String, completion: @escaping (Error?) -> Void) {
        guard !isFetchingMoreMovies else { return }
        isFetchingMoreMovies = true
        
        networkManager.fetchMoviesBySort(sortDomain: sortDomain, page: currentPage) { [weak self] newMovies, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(error)
                self.isFetchingMoreMovies = false
                return
            }

            self.movies.append(contentsOf: newMovies)
            self.updateIfNeed()
            self.delegate?.moviesDidChange(self)
            self.currentPage += 1
            completion(nil)
            self.isFetchingMoreMovies = false
        }
    }
    
    func searchMovie(query: String, completion: @escaping (Error?) -> Void) {
        search.removeAll()
        delegate?.moviesDidChange(self)
        
        networkManager.searchMovie(query: query) { [weak self] newMovies, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(error)
                return
            }

            self.search.removeAll()
            self.search.append(contentsOf: newMovies)
            self.updateIfNeed()
            self.delegate?.moviesDidChange(self)
            completion(nil)
        }
    }
    
    func cleanMovies() {
        currentPage = 1
        isFetchingMoreMovies = false
        movies.removeAll()
    }
    
    func numberOfRowsInSection() -> Int {
        return isSearchingMovies ? search.count : movies.count
    }
    
    func movie(at index: Int) -> Movie {
        return isSearchingMovies ? search[index] : movies[index]
    }
    
    func isFetching() -> Bool {
        return isFetchingMoreMovies
    }
    
    func setSerching(flag: Bool) {
        isSearchingMovies = flag
        
        if !flag { search.removeAll() }
        
        delegate?.moviesDidChange(self)
    }
}


private extension MovieListVM {
    func updateIfNeed() {
        var shouldUpdate = self.movies.filter { $0.genres == nil }
        
        for movie in shouldUpdate {
            networkManager.fetchMovie(id: movie.id) { movie, error in
                guard let movie = movie else { return }
                let index = self.movies.firstIndex(where: { $0.id == movie.id })!
                self.movies[index] = movie
                self.delegate?.movieUpdated(index)
            }
        }
        
        if !isSearchingMovies  { return }
        shouldUpdate = self.search.filter { $0.genres == nil }
        
        for movie in shouldUpdate {
            networkManager.fetchMovie(id: movie.id) { movie, error in
                guard let movie = movie else { return }
                guard let index = self.search.firstIndex(where: { $0.id == movie.id }) else { return }
                self.search[index] = movie
                self.delegate?.movieUpdated(index)
            }
        }
    }
}
