//
//  UrlsResult.swift
//  image_feed
//
//  Created by Aleksei Frolov on 30.06.2024.
//

import Foundation

struct UrlsResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
