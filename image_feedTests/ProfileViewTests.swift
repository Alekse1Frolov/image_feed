//
//  ProfileViewTests.swift
//  image_feedTests
//
//  Created by Aleksei Frolov on 22.07.2024.
//

@testable import image_feed
import XCTest

final class ProfileViewControllerTests: XCTestCase {

    func testViewControllerCallViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        //when
        _ = viewController.view

        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }

    func testViewControllerCallUpdateAvatar() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        //when
        let urlString = "https://test.url/image.png"
        viewController.updateAvatarImage(with: urlString)

        //then
        XCTAssertNotNil(viewController._avatarImageView.image)
    }

    func testViewControllerCallUpdateProfileInfo() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        //when
        viewController.updateProfileInfo(name: "Test Name", loginName: "@testlogin", bio: "Test bio")

        //then
        XCTAssertEqual(viewController._nameLabel.text, "Test Name")
        XCTAssertEqual(viewController._loginLabel.text, "@testlogin")
        XCTAssertEqual(viewController._descriptionLabel.text, "Test bio")
    }

    func testViewControllerCallLogout() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        //when
        viewController._didTapLogoutButton()

        //then
        XCTAssertTrue(presenter.confirmLogoutCalled)
    }
}

extension ProfileViewController {
    var _avatarImageView: UIImageView {
        return avatarImageView
    }
    
    var _nameLabel: UILabel {
        return nameLabel
    }
    
    var _loginLabel: UILabel {
        return loginLabel
    }
    
    var _descriptionLabel: UILabel {
        return descriptionLabel
    }
    
    @objc func _didTapLogoutButton() {
        didTapLogoutButton()
    }
}
