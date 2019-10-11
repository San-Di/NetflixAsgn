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
    static let ROUTE_MOVIES_TOP_RATED = "\(API.BASE_URL)/movie/top_rated?api_key=\(API.KEY)"
    static let ROUTE_MOVIE_DETAILS = "\(API.BASE_URL)/movie"
    static let ROUTE_SEACRH_MOVIES = "\(API.BASE_URL)/search/movie"
    
    static let ROUTE_ADD_WATCH_LIST = "\(API.BASE_URL)/account"
    
    static let ROUTE_ADD_RATE_LIST = "\(API.BASE_URL)/movie"
    
    /* Auth */
    static let ROUTE_REQUEST_TOKEN = "\(API.BASE_URL)/authentication/token/new?api_key=\(API.KEY)"
    static let ROUTE_SESSION_WITH_LOGIN = "\(API.BASE_URL)/authentication/token/validate_with_login?api_key=\(API.KEY)"
    static let ROUTE_CREATE_SESSION = "\(API.BASE_URL)/authentication/session/new?api_key=\(API.KEY)"
    
    /* Account */
    static let ROUTE_ACC_DETAIL = "\(API.BASE_URL)/account?api_key=\(API.KEY)"
    
    static let ROUTE_RATED_MOVIES = "\(API.BASE_URL)/account"
}
