//
//  OAuth2Service.swift
//  image_feed
//
//  Created by Aleksei Frolov on 03.04.2024.
//

import UIKit

final class OAuth2Service {
    
    struct OAuthTokenResponseBody: Codable {
        let accessToken: String
        let tokenType: String
    }
    
    enum OAuthError: Error {
        case invalidURL
    }
    
    static let shared = OAuth2Service()
    private let tokenStorage = OAuth2TokenStorage.shared
    
    private init() {}
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        
        guard let baseURL = URL(string: "https://unsplash.com") else {
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
    
    func fetchOAuthToken(with code: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(OAuthError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            if 200..<300 ~= httpResponse.statusCode {
                if let data = data {
                    self.tokenStorage.token = String(data: data, encoding: .utf8)
                    completion(.success(data))
                } else {
                    completion(.failure(NetworkError.noData))
                }
            } else {
                completion(.failure(NetworkError.httpStatusCode(httpResponse.statusCode)))
            }
        }
        task.resume()
    }
}
