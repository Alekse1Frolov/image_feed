//
//  ProfilePresenter.swift
//  image_feed
//
//  Created by Aleksei Frolov on 22.07.2024.
//

import UIKit

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func updateAvatar()
    func confirmLogout()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private var profileService: ProfileServiceProtocol
    private var profileImageService: ProfileImageServiceProtocol
    private var logoutService: ProfileLogoutServiceProtocol
    private var alertPresenter: AlertPresenter?
    
    init(view: ProfileViewControllerProtocol,
         logoutService: ProfileLogoutServiceProtocol = ProfileLogoutService.shared,
         profileService: ProfileServiceProtocol = ProfileService.shared,
         profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared) {
        self.view = view
        self.logoutService = logoutService
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.alertPresenter = AlertPresenter(delegate: view as? UIViewController)
    }
    
    func confirmLogout() {
        alertPresenter?.showTwoOptionsAlert(title: "Пока, пока!",
                                            message: "Уверены, что хотите выйти?",
                                            confirmButtonText: "Да",
                                            cancelButtonText: "Нет") { [weak self] in
            self?.logoutService.logout()
        }
    }
    
    func updateAvatar() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else {
            print("ProfilePresenter: avatar URL is nil or invalid")
            return
        }
        print("ProfilePresenter: updating avatar with URL: \(url)")
        view?.updateAvatarImage(with: url.absoluteString)
    }
    
    func viewDidLoad() {
        guard let profile = profileService.profile else {
            print("ProfilePresenter: profile is nil")
            return
        }
        
        print("ProfilePresenter: profile loaded - Name: \(profile.name), LoginName: \(profile.loginName), Bio: \(profile.bio)")
        view?.updateProfileInfo(name: profile.name, loginName: profile.loginName, bio: profile.bio)
        
        addNotification()
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let self = self else { return }
                print("ProfilePresenter: avatar image updated notification received")
                self.updateAvatar()
            })
        updateAvatar()
    }
}
