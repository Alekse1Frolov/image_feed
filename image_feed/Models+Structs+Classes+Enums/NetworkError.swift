//
//  NetworkError.swift
//  image_feed
//
//  Created by Aleksei Frolov on 06.04.2024.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case invalidResponse
    case noData
}
