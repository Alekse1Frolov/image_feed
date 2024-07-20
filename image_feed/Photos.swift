//
//  Photos.swift
//  image_feed
//
//  Created by Aleksei Frolov on 30.06.2024.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: URL
    let largeImageURL: URL
    let fullImageURL: URL
    let isLiked: Bool
}
