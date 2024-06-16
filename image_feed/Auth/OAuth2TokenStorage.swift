//
//  OAuth2TokenStorage.swift
//  image_feed
//
//  Created by Aleksei Frolov on 03.04.2024.
//

import UIKit

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    private let userDefaults = UserDefaults.standard
    private let tokenKey = "OAuth2Token"
    
    var token: String? {
        get {
            return userDefaults.string(forKey: tokenKey)
        }
        set {
            print("Saving token: \(newValue ?? "nil")")
            userDefaults.set(newValue, forKey: tokenKey)
        }
    }
}
