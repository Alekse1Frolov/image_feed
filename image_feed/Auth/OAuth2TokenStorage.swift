//
//  OAuth2TokenStorage.swift
//  image_feed
//
//  Created by Aleksei Frolov on 03.04.2024.
//

import UIKit
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    private let tokenKey = "OAuth2Token"
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            if let token = newValue {
                KeychainWrapper.standard.set(token, forKey: tokenKey)
                print("Saving token: \(token)")
            } else {
                KeychainWrapper.standard.removeObject(forKey: tokenKey)
                print("Removing token")
            }
        }
    }
}
