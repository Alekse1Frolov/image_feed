//
//  ProfileImageService.swift
//  image_feed
//
//  Created by Aleksei Frolov on 05.06.2024.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastUserName: String?
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    
    private init() {}
    
    struct UserResult: Codable {
        struct ProfileUmage: Codable {
            let small: String
        }
        let profile_image: ProfileUmage
    }
    
    private(set) var avatarURL: String?
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if let task = task {
            if lastUserName == username {
                completion(.failure(NetworkError.invalidResponse))
                return
            } else {
                task.cancel()
            }
        }
        
        lastUserName = username
        
        guard let request = makeProfileImageRequest(username: username) else {
            completion(.failure(NetworkError.invalidResponse))
            return
        }
        
        let task = urlSession.data(for: request) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    do {
                        let userResult = try decoder.decode(UserResult.self, from: data)
                        let imageURL = userResult.profile_image.small
                        self.avatarURL = imageURL
                        completion(.success(imageURL))
                        NotificationCenter.default.post(
                            name: ProfileImageService.didChangeNotification,
                            object: self,
                            userInfo: ["URL": imageURL]
                        )
                    } catch {
                        print("Decoding error: \(error)")
                        completion(.failure(OAuthError.decodingError))
                    }
                case .failure(let error):
                    print("Network error: \(error)")
                    completion(.failure(error))
                }
                self.task = nil
                self.lastUserName = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    func makeProfileImageRequest(username: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else {
            print("Error creating URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = OAuth2TokenStorage.shared.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}
