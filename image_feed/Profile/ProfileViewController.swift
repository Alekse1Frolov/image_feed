//
//  ProfileViewController.swift
//  image_feed
//
//  Created by Aleksei Frolov on 25.2.24..
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private var avatarImageView: UIImageView!
    private var nameLabel: UILabel!
    private var loginLabel: UILabel!
    private var descriptionLabel: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        showAvatar()
        showNameLabel()
        showLoginLabel()
        showDescriptionLabel()
        showLogoutButton()
    }
    
    private func showAvatar() {
        let image = UIImage(named: "avatar")
        let imageView = UIImageView(image: image)
        
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView = imageView
    }
    
    private func showNameLabel() {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        label.textColor = UIColor(named: "YP_white_color")
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        label.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8).isActive = true
        nameLabel = label
    }
    
    private func showLoginLabel() {
        let label = UILabel()
        label.text = "@ekaterina_now"
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = UIColor(named: "YP_gray_color")
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        label.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        loginLabel = label
    }
    
    private func showDescriptionLabel() {
        let label = UILabel()
        label.text = "Hello, world!"
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = UIColor(named: "YP_white_color")
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        label.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel = label
    }
    
    private func showLogoutButton() {
        let button = UIButton.systemButton(
            with: UIImage(named: "Exit") ?? UIImage(),
            target: self,
            action: #selector(Self.didTapLogoutButton)
        )
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        button.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    @objc
    private func didTapLogoutButton() {
        nameLabel?.removeFromSuperview()
        nameLabel = nil
        loginLabel?.removeFromSuperview()
        loginLabel = nil
        descriptionLabel?.removeFromSuperview()
        descriptionLabel = nil
        avatarImageView.image = UIImage(systemName: "person.crop.circle.fill")
    }
}

