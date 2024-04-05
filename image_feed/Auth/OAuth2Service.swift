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
    
    func fetchOAuthToken(with code: String, completion: @escaping (Result<String, Error>) -> Void) {

        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(OAuthError.invalidURL))
            return
        }

        let task = URLSession.shared.data(for: request) { result  in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let tokenResponse = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    let token = tokenResponse.accessToken
                    completion(.success(token))
                } catch {
                    completion(.failure(OAuthError.decodingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
