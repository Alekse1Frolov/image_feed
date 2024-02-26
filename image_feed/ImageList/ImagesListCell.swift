//
//  ImageListCell.swift
//  image_feed
//
//  Created by Aleksei Frolov on 24.2.24..
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var cellImage: UIImageView!
    
    @IBOutlet var likeButton: UIButton!
    
    @IBOutlet var dateLabel: UILabel!
    
}
