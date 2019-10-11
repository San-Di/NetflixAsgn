//
//  RequestTokenResponse.swift
//  NetflixAsgn
//
//  Created by Sandi on 10/9/19.
//  Copyright © 2019 Sandi. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let success: Bool
    let expires_at: String
    let request_token: String
    
}

struct SessionResponse: Codable {
    let success: Bool
    let session_id: String
}
