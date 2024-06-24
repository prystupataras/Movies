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

    private var movies: [Movie] = []

    func fetchMovies() {
        NetworkService.shared.getMovies(onSuccess: { (movies) in
            self.movies = movies
            self.delegate?.moviesDidChange(self)
        }) { (errorMessage) in
            print(errorMessage)
        }
    }
    
    func fetchMovie(for index: Int) {
        NetworkService.shared.getMovie(by: self.movies[index].id, onSuccess: { (movie) in
            self.movies[index] = movie[0]
            self.delegate?.movieUpdated(index)
        }) { (errorMessage) in
            print(errorMessage)
        }
    }

    func numberOfMovies() -> Int {
        print("numberOfMovies \(movies.count)")
        return movies.count
    }

    func movie(at index: Int) -> Movie {
        return movies[index]
    }
    
    func updateIfNeed(_ movie: Movie) {
        if movie.titleText == "n/a" || movie.yearText == "n/a" {
//            fetchMovie(for: <#T##Int#>)
        }
    }
}
