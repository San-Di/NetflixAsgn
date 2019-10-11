//
//  UserAccountDetailResponse.swift
//  NetflixAsgn
//
//  Created by Sandi on 10/9/19.
//  Copyright © 2019 Sandi. All rights reserved.
//

import Foundation

struct GrAvatarResponse: Codable {
    let gravatar: HashResponse
}

struct HashResponse: Codable {
    let hash: String
}
struct UserAccDetailResponse: Codable {
//{
//    "avatar": {
//    "gravatar": {
//    "hash": "cbf499e5669eac08289e1e10d567f7ad"
//    }
//    },
//    "id": 8691657,
//    "iso_639_1": "en",
//    "iso_3166_1": "US",
//    "name": "",
//    "include_adult": false,
//    "username": "nogitsune"
//    }
    let avatar: GrAvatarResponse
    let id: Int
    let iso_639_1: String
    let iso_3166_1: String
    let name: String
    let include_adult: Bool
    let username: String
}
