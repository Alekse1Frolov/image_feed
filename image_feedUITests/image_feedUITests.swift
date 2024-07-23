//
//  image_feedUITests.swift
//  image_feedUITests
//
//  Created by Aleksei Frolov on 23.07.2024.
//

import XCTest

final class image_feedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDownWithError() throws {
        
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 10))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("your login")
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssert(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("your email")
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssert(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        XCTAssertTrue(cellToLike.waitForExistence(timeout: 5))
        sleep(5)
        cellToLike.buttons["Like button"].tap()
        sleep(10)
        cellToLike.buttons["Like button"].tap()
        
        sleep(2)
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 5))
        
        image.pinch(withScale: 2, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let backButton = app.buttons["Back button"]
        XCTAssertTrue(backButton.waitForExistence(timeout: 5))
        backButton.tap()
        
        sleep(2)
            
        cell.swipeUp()
        
        let likedCell = tablesQuery.descendants(matching: .cell).element(boundBy: 1)
        XCTAssertTrue(likedCell.waitForExistence(timeout: 5))
    }
    
    func testProfile() throws {
        let tab = app.tabBars.buttons.element(boundBy: 1)
        XCTAssertTrue(tab.waitForExistence(timeout: 5))
        tab.tap()
        
        sleep(1)
        
        XCTAssertTrue(app.staticTexts["your name"].exists)
        XCTAssertTrue(app.staticTexts["@your nickname"].exists)
        
        app.buttons["Logout"].tap()
        app.alerts["TwoOptionsAlert"].scrollViews.otherElements.buttons["Да"].tap()
        
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 5))
    }
}
