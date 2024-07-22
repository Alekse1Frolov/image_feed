//
//  SplashViewController.swift
//  image_feed
//
//  Created by Aleksei Frolov on 03.04.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private let showAuthenticationScreenSegueIdentifier = "AuthViewController"
    private let oauth2Service = OAuth2Service.shared
    private let storage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    
    private let splashImageView:  UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "splash_screen_logo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        print("SplashViewController: viewDidLoad")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("SplashViewController: viewDidAppear")
        
        if let token = storage.token {
            print("SplashViewController: Token found, fetching profile")
            fetchProfile(token)
        } else {
            print("SplashViewController: No token found, presenting AuthViewController")
            presentAuthViewController()
        }
    }
    
    private func setupUI() -> Void {
        view.backgroundColor = .white
        view.addSubview(splashImageView)
        
        NSLayoutConstraint.activate([
            splashImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        print("SplashViewController: UI setup complete")
    }
    
    private func switchToTabBarController() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first else {
                assertionFailure("Invalid window configuration")
                return
            }
            let tabBarController = UIStoryboard(name: "Main", bundle: .main)
                .instantiateViewController(withIdentifier: "TabBarViewController")
            
            window.rootViewController = tabBarController
            window.makeKeyAndVisible()
            print("SplashViewController: Switched to TabBarController")
            
        }
    }
    
    private func fetchProfile(_ token: String) {
        print("SplashViewController: Fetching profile with token: \(token)")
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
            case .success(let profile):
                print("SplashViewController: Profile fetched successfully - \(profile)")
                self.fetchProfileImage(username: profile.username)
                self.switchToTabBarController()
            case .failure (let error):
                print("Error fetching profile: \(error.localizedDescription)")
                self.presentAuthViewController()
            }
        }
    }
    
    private func fetchProfileImage(username: String) {
        print("SplashViewController: Fetching profile image for username: \(username)")
        profileImageService.fetchProfileImageURL(username: username) { result in
            
            switch result {
            case .success(let url):
                print("Fetch profile image URL: \(url)")
            case .failure(let error):
                print("Failed to fetch profile image URL: \(error)")
            }
        }
    }
    
    private func presentAuthViewController() {
        print("SplashViewController: Presenting AuthViewController")
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
            assertionFailure("Failed to instantiate AuthViewController")
            return
        }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true, completion: nil)
        print("SplashViewController: AuthViewController presented")
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        print("SplashViewController: didAuthenticate delegate called")
        vc.dismiss(animated: true)
        
        guard let token = storage.token else {
            print("SplashViewController: No token found after authentication")
            return
        }
        fetchProfile(token)
    }
}
