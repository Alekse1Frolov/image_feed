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
        app.launchArguments = ["testMode"]
        app.launch()
    }
    
    override func tearDownWithError() throws {
        
    }
    
    private func hideWebViewKeyboard() {
        guard app.keyboards.element(boundBy: 0).exists else {
            return
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            app.keyboards.buttons["Hide keyboard"].tap()
        } else {
            app.toolbars.buttons["Done"].tap()
        }
    }
    
    private func waitForProgressHUDToDisappear() {
        let hud = app.otherElements["ProgressHUD"]
        XCTAssertFalse(hud.exists)
        
        let exists = NSPredicate(format: "exists == false")
        expectation(for: exists, evaluatedWith: hud, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 10))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("adv.a.frolov@gmail.com")
        hideWebViewKeyboard()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssert(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("115230115230")
        hideWebViewKeyboard()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssert(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.descendants(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["Like button"].tap()
        waitForProgressHUDToDisappear()
        
        cellToLike.buttons["Like button"].tap()
        waitForProgressHUDToDisappear()
        
        cellToLike.tap()
        
        let image = app.scrollViews.images.element(boundBy: 0)
        
        image.pinch(withScale: 2, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let backButton = app.buttons["Back button"]
        backButton.tap()
        
        let likedCell = tablesQuery.descendants(matching: .cell).element(boundBy: 1)
        XCTAssertTrue(likedCell.waitForExistence(timeout: 5))
    }
    
    func testProfile() throws {
        let tab = app.tabBars.buttons.element(boundBy: 1)
        XCTAssertTrue(tab.waitForExistence(timeout: 5))
        tab.tap()
        
        sleep(1)
        
        XCTAssertTrue(app.staticTexts["Aleksei Frolov"].exists)
        XCTAssertTrue(app.staticTexts["@lac05ta"].exists)
        
        app.buttons["Logout"].tap()
        app.alerts["TwoOptionsAlert"].scrollViews.otherElements.buttons["Да"].tap()
        
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 5))
    }
}
