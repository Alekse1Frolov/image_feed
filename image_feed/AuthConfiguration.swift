//
//  Constants.swift
//  image_feed
//
//  Created by Aleksei Frolov on 11.03.2024.
//

import UIKit
import WebKit

enum Constants {
    static let accessKey = "HyAv7Tq7aJRGyxa_-p_0yvJTH9rlpFNpLiEUkcBxjZ0"
    static let secretKey = "7pkFVROt4_rE4-M57uvmCBAxFTebpOu-wi64_8_r2TY"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let baseURL = URL(string: "https://unsplash.com")
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 defaultBaseURL: Constants.baseURL!,
                                 authURLString: Constants.unsplashAuthorizeURLString)
    }
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
}

