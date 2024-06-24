//
//  MovieListVM.swift
//  Movies
//
//  Created by Prystupa Taras on 24.06.2024.
//

import UIKit

protocol MovieListViewModelDelegate: AnyObject {
    func moviesDidChange(_ viewModel: MovieListVM)
}

class MovieListVM {
    weak var delegate: MovieListViewModelDelegate?

    private var movies: [Movie] = []

    func fetchMovies() {
        // Simulate data fetching from a service or repository (using Dependency Injection)
        movies = [
            Movie(title: "The Shawshank Redemption", year: "1994", imageName: "movie1", genres: ["Drama", "Crime"], rating: 4.8),
            Movie(title: "The Godfather", year: "1972", imageName: "movie2", genres: ["Crime", "Drama"], rating: 4.9),
            Movie(title: "The Dark Knight", year: "2008", imageName: "movie3", genres: ["Action", "Thriller"], rating: 4.6)
        ]
        delegate?.moviesDidChange(self)
    }

    func numberOfMovies() -> Int {
        return movies.count
    }

    func movie(at index: Int) -> Movie {
        return movies[index]
    }
}
