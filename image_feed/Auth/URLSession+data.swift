//
//  URLSession+data.swift
//  image_feed
//
//  Created by Aleksei Frolov on 03.04.2024.
//

import UIKit

enum NetworkError: Error {
    case httpStatusCode(Int)
    case invalidResponse
    case noData
}

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
                fulfillCompletionOnTheMainThread(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.invalidResponse))
                return
            }
            
            if 200..<300 ~= httpResponse.statusCode {
                if let data {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.noData))
                }
            } else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(httpResponse.statusCode)))
            }
        })
        return task
    }
}
