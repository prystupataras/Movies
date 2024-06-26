//
//  Domain.swift
//  Movies
//
//  Created by Prystupa Taras on 25.06.2024.
//

import Foundation

struct Domain {
    static let key      = "aedc7cd82c856cb67721fb6d91de5bc3"
    static let baseUrl  = "https://api.themoviedb.org/3"
    
    static let movie = "/movie"
//    static let discover = "/discover" + Domain.movie
//    static let discover = Domain.movie + "/popular"
    
//    static let new     = "primary_release_data.desc"
//    static let popular = "vote_count.desc"
//    static let rating  = "vote_average.desc"
    
    
    static let popular    = Domain.movie + "/popular"
    static let topRated   = Domain.movie + "/top_rated"
    static let nowPlaying = Domain.movie + "/now_playing"
    static let upcoming   = Domain.movie + "/upcoming"
}
