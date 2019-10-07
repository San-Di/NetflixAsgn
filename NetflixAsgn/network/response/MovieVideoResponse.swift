//
//  MovieVideoResponse.swift
//  NetflixAsgn
//
//  Created by Sandi on 10/5/19.
//  Copyright © 2019 Sandi. All rights reserved.
//

import Foundation

struct VideoListResponse: Codable {
    let id: Int
    let results: [MovieVideoResponse]
}
struct MovieVideoResponse : Codable {
    
    let id : String?
    let iso_639_1 : String?
    let iso_3166_1 : String?
    let key : String?
    let name : String?
    let site : Int?
    let type : String?
    
    enum CodingKeys:String,CodingKey {
      
        case id
        case iso_639_1
        case iso_3166_1
        case key
        case name
        case site
        case type
    }

}
