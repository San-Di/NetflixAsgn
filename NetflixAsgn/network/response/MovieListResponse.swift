//
//  MovieListResponse.swift
//  NetflixAsgn
//
//  Created by Sandi on 10/3/19.
//  Copyright © 2019 Sandi. All rights reserved.
//

import Foundation

struct NowPlayingDuration: Codable {
    let maximum: String
    let minimum: String
}

struct MovieListResponse : Codable {
    let page : Int
    let total_results : Int
    let total_pages : Int
    let results : [MovieInfoResponse]
    let dates: NowPlayingDuration?
}

