//
//  Routes.swift
//  NetflixAsgn
//
//  Created by Sandi on 10/3/19.
//  Copyright © 2019 Sandi. All rights reserved.
//

import Foundation

class Routes{
    static let ROUTE_MOVIES_TRENDING = "\(API.BASE_URL)/movie/popular?api_key=\(API.KEY)"
    static let ROUTE_MOVIES_NOW_PLAYING = "\(API.BASE_URL)/movie/now_playing?api_key=\(API.KEY)"
    static let ROUTE_MOVIES_UPCOMING = "\(API.BASE_URL)/movie/upcoming?api_key=\(API.KEY)"
    static let ROUTE_MOVIES_TOP_RATED = "\(API.BASE_URL)/movie/upcoming?api_key=\(API.KEY)"
    static let ROUTE_MOVIE_DETAILS = "\(API.BASE_URL)/movie"
    static let ROUTE_SEACRH_MOVIES = "\(API.BASE_URL)/search/movie"
    
}
