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
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

