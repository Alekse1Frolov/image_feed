//
//  OAuthTokenResponseBody.swift
//  image_feed
//
//  Created by Aleksei Frolov on 06.04.2024.
//

import Foundation

struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
    }
}
