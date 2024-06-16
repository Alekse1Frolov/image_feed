//
//  OAuth2Service.swift
//  image_feed
//
//  Created by Aleksei Frolov on 03.04.2024.
//

import UIKit

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private let tokenStorage = OAuth2TokenStorage.shared
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private init() {}
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        
        guard let baseURL = Constants.baseURL else {
            print("Error creating base URL")
            return nil
        }
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        components.path = "/oauth/token"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = components.url else {
            print("Error creating URL from components")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return request
    }
    
    func fetchOAuthToken(with code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        
        if let task {
            if lastCode == code {
                completion(.failure(OAuthError.invalidRequest))
                return
            } else {
                task.cancel()
            }
        }
        
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(OAuthError.invalidURL))
            return
        }
        
        print("Fetching OAuth token with request: \(request)")
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>)  in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let token = data.accessToken
                    self?.tokenStorage.token = token
                    completion(.success(token))
                case .failure(let error):
                    print("Error fetching OAuth token: \(error)")
                    completion(.failure(error))
                }
                self?.task = nil
                self?.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
}
