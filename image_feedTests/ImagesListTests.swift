//
//  ImagesListTests.swift
//  image_feedTests
//
//  Created by Aleksei Frolov on 23.07.2024.
//

@testable import image_feed
import XCTest

final class ImagesListTests: XCTestCase {
    
    final class ImagesListTests: XCTestCase {
        func testViewDidLoadCallsPresenterViewDidLoad() {
            // given
            let presenter = ImagesListPresenterSpy()
            let viewController = ImagesListViewController()
            viewController.configure(presenter)
            presenter.view = viewController
            
            // when
            viewController.viewDidLoad()
            
            // then
            XCTAssertTrue(presenter.viewDidLoadCalled)
        }
        
        func testUpdateTableViewAnimatedCallsPresenterMethod() {
            // given
            let presenter = ImagesListPresenterSpy()
            let viewController = ImagesListViewController()
            viewController.configure(presenter)
            presenter.view = viewController
            
            // when
            viewController.updateTableViewAnimated()
            
            // then
            XCTAssertTrue(presenter.updateTableViewCalled)
        }
    }
}
