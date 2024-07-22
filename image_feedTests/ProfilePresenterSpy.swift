//
//  ProfilePresenterSpy.swift
//  image_feedTests
//
//  Created by Aleksei Frolov on 22.07.2024.
//

import image_feed
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    var view: ProfileViewControllerProtocol?
    var updatedAvatarCalled = false
    var viewDidLoadCalled = false
    var confirmLogoutCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
        view?.updateProfileInfo(name: "Test Name", loginName: "@testlogin", bio: "Test bio")
        updateAvatar()
    }
    
    func updateAvatar() {
        updatedAvatarCalled = true
        view?.updateAvatarImage(with: "https://test.url/image.png")
    }
    
    func confirmLogout() {
        confirmLogoutCalled = true
    }
}
