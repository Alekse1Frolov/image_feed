//
//  ProfileLogoutService.swift
//  image_feed
//
//  Created by Aleksei Frolov on 13.07.2024.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private init() { }
    
    func logout() {
        cleanCookies()
        cleanProfileData()
        switchToAuthScreen()
    }
    
    private func cleanCookies() {
        print("Cleaning cookies...")
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func cleanProfileData() {
        print("Cleaning profile data...")
        ProfileService.shared.cleanProfile()
        ProfileImageService.shared.cleanProfileImage()
        ImageListService.shared.cleanPhotos()
        OAuth2TokenStorage.shared.token = nil
        print("Removing token")
    }
    
    private func switchToAuthScreen() {
        print("Switching to Auth Screen...")
        guard let window = UIApplication.shared.windows.first else { return }
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
    }
}
