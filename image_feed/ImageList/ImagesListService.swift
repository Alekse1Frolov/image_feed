//
//  ImagesListService.swift
//  image_feed
//
//  Created by Aleksei Frolov on 30.06.2024.
//

import UIKit

final class ImageListService {
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var isFetching = false
    private let session = URLSession.shared
    private var tokenStorage = OAuth2TokenStorage()
    
    static let shared = ImageListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    func makeFetchPhotoRequest(pageNumber: Int) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/photos?page=\(pageNumber)") else {
            print("[ImageListService - makeFetchPhotoRequest] - error creating URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        guard let token = tokenStorage.token else {
            print("[ImageListService - makeFetchPhotoRequest] - No token found")
            return nil
        }
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func fetchPhotosNextPage() {
        guard !isFetching else { return }
        
        isFetching = true
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = makeFetchPhotoRequest(pageNumber: nextPage) else {
            print("[ImageListService - fetchPhotosNextPage] - error creating request")
            return
        }
        
        print("[fetchPhotosNextPage]: Fetching photos for page \(nextPage)")
        
        let task = session.objectTask(for: request) { [weak self] (result: (Result<[PhotoResult], Error>)) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isFetching = false
                
                switch result {
                case .success(let photoResults):
                    self.lastLoadedPage = nextPage
                    let newPhotos = photoResults.map { Photo(from: $0) }
                    self.photos.append(contentsOf: newPhotos)
                    NotificationCenter.default.post(name: ImageListService.didChangeNotification, object: nil)
                    print("[fetchPhotosNextPage]: Photos fetched successfully")
                    
                case .failure(let error):
                    print("[ImageListService - fetchPhotosNextPage] - error: \(error)")
                }
            }
        }
        task.resume()
    }
    
    private func makeLikesRequest(with url: String, httpMethod: String) -> URLRequest? {
        guard let url = URL(string: url) else {
            print("[ImageListService - makeLikesRequest] - error creating URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        
        guard let token = tokenStorage.token else {
            print("[ImageListService - makeLikesRequest] - No token found")
            return nil
        }
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = httpMethod
        
        return request
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Photo, Error>) -> Void) {
        guard let request = makeLikesRequest(with: "https://api.unsplash.com/photos/\(photoId)/like", httpMethod: isLike ? "DELETE" : "POST") else {
            print("[ImageListService - changeLike] - error creating request")
            return
        }
        
        let task = URLSession.shared.data(for: request) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        let photo = self.photos[index]
                        let newPhoto = Photo(id: photo.id,
                                             size: photo.size,
                                             createdAt: photo.createdAt,
                                             welcomeDescription: photo.welcomeDescription,
                                             thumbImageURL: photo.thumbImageURL,
                                             largeImageURL: photo.largeImageURL,
                                             fullImageURL: photo.fullImageURL,
                                             isLiked: !photo.isLiked)
                        self.photos[index] = newPhoto
                        print("Photo updated: \(newPhoto)")
                        completion(.success((newPhoto)))
                    } else {
                        print("Photo not found in array")
                        completion(.failure(NetworkError.indexError))
                    }
                }
            case .failure(let error):
                print("Error in like request: \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func cleanPhotos() {
        photos = []
        lastLoadedPage = nil
        isFetching = false
    }
}
