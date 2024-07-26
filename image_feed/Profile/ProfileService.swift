//
//  ProfileService.swift
//  image_feed
//
//  Created by Aleksei Frolov on 03.06.2024.
//

import Foundation

public protocol ProfileServiceProtocol {
    var profile: Profile? { get }
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void)
    func cleanProfile()
}

final class ProfileService: ProfileServiceProtocol {
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastToken: String?
    private(set) var profile: Profile?
    
    private init() {}
    
    func makeProfileRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/me") else {
            print("[ProfileService - makeProfileRequest] - error creating URL")
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
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let profile = Profile(profileResult: data)
                    self?.profile = profile
                    print("Profile fetched successfully: \(profile)")
                    completion(.success(profile))
                case .failure(let error):
                    print("[ProfileService - fetchProfile - network error]")
                    completion(.failure(error))
                }
                self?.task = nil
                self?.lastToken = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    func cleanProfile() {
        profile = nil
    }
}
