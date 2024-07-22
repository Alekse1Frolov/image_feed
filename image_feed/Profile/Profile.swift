//
//  Profile.swift
//  image_feed
//
//  Created by Aleksei Frolov on 22.07.2024.
//

import Foundation

public struct Profile {
    let name: String
    let username: String
    let loginName: String
    let bio: String
    
    init(profileResult: ProfileResult) {
        self.name = profileResult.firstName + " " + (profileResult.lastName ?? "")
        self.username = profileResult.username
        self.loginName = "@\(profileResult.username)"
        self.bio = profileResult.bio ?? ""
    }
}
