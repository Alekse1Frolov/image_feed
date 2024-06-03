//
//  ProfileService.swift
//  image_feed
//
//  Created by Aleksei Frolov on 03.06.2024.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastToken: String?
    private(set) var profile: Profile?
    
    private init() {}
    
    struct ProfileResult: Codable {
        let username: String
        let firstName: String
        let lastName: String?
        let bio: String?
    }
    
    struct Profile {
        let name: String
        let username: String
        let loginName: String
        let bio: String
        
        init(profileResult: ProfileResult) {
            self.name = profileResult.firstName + " " + (profileResult.lastName ?? "")
            self.username = profileResult.username
            self.loginName = "@\(profileResult.username)"
            self.bio = profileResult.bio ?? ""
        }
    }
    
    func makeProfileRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/me") else {
            print("Error creating URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if let task = task {
            if lastToken == token {
                completion(.failure(NetworkError.invalidResponse))
                return
            } else {
                task.cancel()
            }
        }
        
        lastToken = token
        
        guard let request = makeProfileRequest(token: token) else {
            completion(.failure(NetworkError.invalidResponse))
            return
        }
        
        print("Fetching profile with token: \(token)")
        
        let task = urlSession.data(for: request) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Server response: \(jsonString)")
                    }
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        let profileResult = try decoder.decode(ProfileResult.self, from: data)
                        let profile = Profile(profileResult: profileResult)
                        self?.profile = profile
                        print("Profile fetched successfully: \(profile)")
                        completion(.success(profile))
                    } catch {
                        print("Decoding error: \(error)")
                        completion(.failure(OAuthError.decodingError))
                    }
                case .failure(let error):
                    print("Network error: \(error)")
                    completion(.failure(error))
                }
                self?.task = nil
                self?.lastToken = nil
            }
        }
        self.task = task
        task.resume()
    }
}