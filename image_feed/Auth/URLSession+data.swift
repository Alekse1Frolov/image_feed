//
//  URLSession+data.swift
//  image_feed
//
//  Created by Aleksei Frolov on 03.04.2024.
//

import UIKit

extension URLSession {
    func data(for request: URLRequest,
              completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
        
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let error {
                print("[dataTask]: NetworkError - request error \(error.localizedDescription)")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("[dataTask]: NetworkError - invalid response")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.invalidResponse))
                return
            }
            
            if 200..<300 ~= httpResponse.statusCode {
                if let data {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    print("[dataTask]: NetworkError - no data")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.noData))
                }
            } else {
                print("[dataTask]: NetworkError - HTTP status code \(httpResponse.statusCode)")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(httpResponse.statusCode)))
            }
        })
        return task
    }
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        
        let task = data(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let decodeObject = try decoder.decode(T.self, from: data)
                        completion(.success(decodeObject))
                } catch {
                        print("[objectTask]: NetworkError - decoding error")
                        completion(.failure(NetworkError.decodingError(error)))
                }
            case .failure(let error):
                    print("[objectTask]: NetworkError - request error")
                    completion(.failure(error))
            }
        }
        return task
    }
}
