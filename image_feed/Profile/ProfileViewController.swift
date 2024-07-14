//
//  ProfileViewController.swift
//  image_feed
//
//  Created by Aleksei Frolov on 25.2.24..
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private var gradientLayers: [CAGradientLayer] = []
    
    private let avatarImageView: UIImageView = {
        let image = UIImage(systemName: "person.crop.circle.fill")
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = 35
        imageView.tintColor = .gray
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        label.textColor = UIColor(named: "YP_white_color")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = UIColor(named: "YP_gray_color")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = UIColor(named: "YP_white_color")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "Exit") ?? UIImage(),
            target: self,
            action: #selector(didTapLogoutButton)
        )
        button.tintColor = UIColor(named: "YP_red_color")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        applyConstraints()
        updateProfileInfo()
        addGradientLayers()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
                self.removeGradientLayers()
            }
        updateAvatar()
    }
    
    private func addSubViews() {
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(loginLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(logoutButton)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            
            loginLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 24),
            logoutButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func addGradientLayers() {
        addGradientLayer(to: avatarImageView, size: CGSize(width: 70, height: 70), cornerRadius: 35)
        addGradientLayer(to: nameLabel, size: CGSize(width: nameLabel.bounds.width, height: nameLabel.bounds.height), cornerRadius: 0)
        addGradientLayer(to: loginLabel, size: CGSize(width: loginLabel.bounds.width, height: loginLabel.bounds.height), cornerRadius: 0)
        addGradientLayer(to: descriptionLabel, size: CGSize(width: descriptionLabel.bounds.width, height: descriptionLabel.bounds.height), cornerRadius: 0)
    }
    
    private func addGradientLayer(to view: UIView, size: CGSize, cornerRadius: CGFloat) {
        let gradient = CAGradientLayer()
        
        gradient.frame = CGRect(origin: .zero, size: size)
        gradient.locations = [0, 0.1, 0.3]
        gradient.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = cornerRadius
        gradient.masksToBounds = true
        gradientLayers.append(gradient)
        view.layer.addSublayer(gradient)
    }
    
    private func removeGradientLayers() {
        gradientLayers.forEach { $0.removeFromSuperlayer() }
        gradientLayers.removeAll()
    }
    
    private func updateProfileInfo() {
        guard let profile = profileService.profile else { return }
        nameLabel.text = profile.name
        loginLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
        
        profileImageService.fetchProfileImageURL(username: profile.username) { [weak self] result in
            switch result {
            case .success(let imageURL):
                self?.updateAvatarImage(with: imageURL)
            case .failure(let error):
                print("Failed to fetch profile image URL: \(error)")
            }
        }
    }
    
    private func updateAvatarImage(with urlString: String) {
        guard let url = URL(string: urlString) else { return }

        avatarImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "person.crop.circle.fill"))
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        avatarImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "person.crop.circle.fill"))
    }
    
    @objc
    private func didTapLogoutButton() {
        ProfileLogoutService.shared.logout()
    }
}

