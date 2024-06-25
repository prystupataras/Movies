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
    let title: String?
    let backdropPath: String?
    let posterPath: String?
    let overview: String
    let voteAverage: Double
    let releaseDate: String?
    let video: Bool?
    
    let genres: [MovieGenre]?
    let originCountry: [String]?
    
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
    
    var hasTrailer: Bool {
        guard let hasVideo = self.video else {
            return false
        }
        
        return hasVideo
    }
}

struct MovieGenre: Decodable {
    let name: String
}
