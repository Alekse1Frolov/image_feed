//
//  ImageListPresenter.swift
//  image_feed
//
//  Created by Aleksei Frolov on 22.07.2024.
//

import UIKit

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    func viewDidLoad()
    func didSelectRowAt(indexPath: IndexPath)
    func willDisplayCell(at indexPath: IndexPath)
    func didTapLikeButton(at indexPath: IndexPath)
}

final class ImageListPresenter: ImagesListPresenterProtocol {
    
    weak var view: ImagesListViewControllerProtocol?
    private let imagesListService: ImagesListServiceProtocol
    private var isLiking: Bool = false
    
    var photos: [Photo] {
        return imagesListService.photos
    }
    
    init(imagesListService: ImagesListServiceProtocol = ImageListService.shared) {
        self.imagesListService = imagesListService
    }
    
    func viewDidLoad() {
        print("ImageListPresenter viewDidLoad called")
        imagesListService.fetchPhotosNextPage()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleImagesListServiceDidChange),
            name: ImageListService.didChangeNotification,
            object: nil
        )
    }
    
    @objc private func handleImagesListServiceDidChange(_ notification: Notification) {
        print("ImageListPresenter: handleImagesListServiceDidChange called")
        view?.updateTableViewAnimated()
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        print("ImageListPresenter: didSelectRowAt called for indexPath: \(indexPath)")
        guard indexPath.row < photos.count else { return }
        let photo = photos[indexPath.row]
        view?.navigateToImageController(with: photo.largeImageURL.absoluteString)
    }
    
    func willDisplayCell(at indexPath: IndexPath) {
        print("willDisplayCell called for indexPath: \(indexPath)")
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func didTapLikeButton(at indexPath: IndexPath) {
        print("didTapLikeButton called for indexPath: \(indexPath)")
        guard !isLiking else { return }
        isLiking = true
        
        UIBlockingProgressHUD.show()
        
        let photo = photos[indexPath.row]
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            self.isLiking = false
            
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success(let updatedPhoto):
                print("Like status changed successfully for photo: \(updatedPhoto)")
                self.view?.updateLikeButton(at: indexPath, isLiked: updatedPhoto.isLiked)
            case .failure(let error):
                print("Failed to change like status: \(error)")
            }
        }
    }
}
