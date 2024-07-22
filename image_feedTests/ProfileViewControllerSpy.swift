//
//  ProfileViewControllerSpy.swift
//  image_feedTests
//
//  Created by Aleksei Frolov on 22.07.2024.
//

import image_feed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    var isAvatarSet = false
    var isConfigure = false
    var isAvatarImageUpdated = false

    func updateProfileInfo(name: String, loginName: String, bio: String) {
        isConfigure = true
    }
    
    func updateAvatarImage(with urlString: String) {
        isAvatarSet = true
        isAvatarImageUpdated = true
    }
}
