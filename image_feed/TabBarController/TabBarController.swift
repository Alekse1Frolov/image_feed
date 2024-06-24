//
//  TabBarController.swift
//  image_feed
//
//  Created by Aleksei Frolov on 25.06.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imageListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
        title: "",
        image: UIImage(named: "tab_profile_active"),
        selectedImage: nil
        )
        
        self.viewControllers = [imageListViewController, profileViewController]
    }
}
