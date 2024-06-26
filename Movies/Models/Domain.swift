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
    
    static let movie    = "/movie"
    static let search   = "/search" + Domain.movie
}

enum SortDomain: Int, CaseIterable {
    case popular = 0
    case topRated
    case nowPlaying
    case upcoming
    
    var description: String {
        switch self {
            case .popular:    return "/movie/popular"
            case .topRated:   return "/movie/top_rated"
            case .nowPlaying: return "/movie/now_playing"
            case .upcoming:   return "/movie/upcoming"
        }
    }
}
