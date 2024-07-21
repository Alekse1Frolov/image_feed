//
//  WebViewViewControllerSpy.swift
//  image_feedTests
//
//  Created by Aleksei Frolov on 21.07.2024.
//

import image_feed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: image_feed.WebViewPresenterProtocol?
    
    var loadRequestCalled: Bool = false
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
}
