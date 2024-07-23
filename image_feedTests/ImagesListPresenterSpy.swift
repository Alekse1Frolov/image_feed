//
//  ImagesListPresenterSpy.swift
//  image_feedTests
//
//  Created by Aleksei Frolov on 23.07.2024.
//

import Foundation
@testable import image_feed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    var viewDidLoadCalled = false
    var updateTableViewCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didSelectRowAt(indexPath: IndexPath) {}
    func willDisplayCell(at indexPath: IndexPath) {}
    func didTapLikeButton(at indexPath: IndexPath) {}
    
    func updateTableViewAnimated() {
        updateTableViewCalled = true
    }
}
