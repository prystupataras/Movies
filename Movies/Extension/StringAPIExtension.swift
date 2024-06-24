//
//  StringAPIExtension.swift
//  Movies
//
//  Created by Prystupa Taras on 24.06.2024.
//

import Foundation

extension String {
    static let API_KEY      = "?api_key=aedc7cd82c856cb67721fb6d91de5bc3"
    static let URL_BASE     = "https://api.themoviedb.org/3"
    
    static let URL_TRAND    = "/trending/all"
    
    static let API_DAY      = "/day"
    static let API_WEEK     = "/week"
    static let API_GENRE    = "/genre"
    static let API_MOVIE    = "/movie"
    
    static let API_PAGE     = "&page="
}
