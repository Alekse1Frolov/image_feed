//
//  PhotoMapper.swift
//  image_feed
//
//  Created by Aleksei Frolov on 16.07.2024.
//

import Foundation

struct PhotoMapper {
    private static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
    
    static func map(from photoResult: PhotoResult) -> Photo? {
        guard
            let thumbImageURL = URL(string: photoResult.urls.thumb),
            let largeImageURL = URL(string: photoResult.urls.full),
            let fullImageURL = URL(string: photoResult.urls.full)
        else { return nil }
        
        let createdAt = dateFormatter.date(from: photoResult.createdAt)
        return Photo(id: photoResult.id,
                     size: CGSize(width: photoResult.width, height: photoResult.height),
                     createdAt: createdAt,
                     welcomeDescription: photoResult.description,
                     thumbImageURL: thumbImageURL,
                     largeImageURL: largeImageURL,
                     fullImageURL: fullImageURL,
                     isLiked: photoResult.likedByUser)
    }
}
