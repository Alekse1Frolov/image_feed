//
//  ProfileViewController.swift
//  image_feed
//
//  Created by Aleksei Frolov on 25.2.24..
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let avatarImageView: UIImageView = {
        let image = UIImage(named: "avatar")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        label.textColor = UIColor(named: "YP_white_color")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_now"
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = UIColor(named: "YP_gray_color")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
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
        addSubViews()
        applyConstraints()
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
    
    @objc
    private func didTapLogoutButton() {
        nameLabel.text = ""
        loginLabel.text = ""
        descriptionLabel.text = ""
        avatarImageView.image = UIImage(systemName: "person.crop.circle.fill")
    }
}

