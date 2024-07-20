//
//  ImageListCell.swift
//  image_feed
//
//  Created by Aleksei Frolov on 24.2.24..
//

import UIKit
import Kingfisher

protocol ImageListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImageListCellDelegate?
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    
    @IBAction private func likeButtonTapped(_ sender: UIButton) {
        print("Like button tapped for cell: \(self)")
        delegate?.imageListCellDidTapLike(self)
    }
    
    @IBOutlet var dateLabel: UILabel!
    
    override func prepareForReuse() {
        print("Preparing for reuse: \(self)")
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
    
    func setIsLiked(_ isLiked: Bool) {
        print("Setting isLiked to \(isLiked) for cell: \(self)")
        let picture = isLiked ? UIImage(named: "likeButtonActive") : UIImage(named: "likeButtonInactive")
        self.likeButton.setImage(picture, for: .normal)
    }
}
