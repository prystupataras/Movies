//
//  Movie.swift
//  Movies
//
//  Created by Prystupa Taras on 24.06.2024.
//

import Foundation

struct MovieResponse: Decodable {
    let results: [Movie]
}


struct Movie: Decodable {
    
    let id: Int
    let originalTitle: String?
    let title: String?
    let backdropPath: String?
    let posterPath: String?
    let overview: String
    let voteAverage: Double
    let voteCount: Int
    let runtime: Int?
    let releaseDate: String?
    
    let genres: [MovieGenre]?
    
    static private let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    var backdropURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath ?? "")")!
    }
    
    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
    }
    
    var titleText: String {
        guard let title = self.title else {
            return "n/a"
        }
        return title
    }
    
    var yearText: String {
        guard let releaseDate = self.releaseDate, let date = Utils.dateFormatter.date(from: releaseDate) else {
            return "n/a"
        }
        return Movie.yearFormatter.string(from: date)
    }
}

struct MovieGenre: Decodable {
    let name: String
}
