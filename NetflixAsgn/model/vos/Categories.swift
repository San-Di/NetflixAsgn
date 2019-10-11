//
//  Categories.swift
//  NetflixAsgn
//
//  Created by Sandi on 10/4/19.
//  Copyright © 2019 Sandi. All rights reserved.
//

import Foundation

enum Categories: String, CaseIterable {
    case Trending = "Popular"
    case NowPlaying = "Now Playing"
    case Upcoming = "Upcoming Movies"
    case Toprated = "Top Rated"
    
    case All = "All"
}
