//
//  ImagesListViewController.swift
//  image_feed
//
//  Created by Aleksei Frolov on 13.2.24..
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private let imageListService = ImageListService()
    private var photos: [Photo] = []
    private var isLiking: Bool = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleImageListServiceDidChange),
            name: ImageListService.didChangeNotification,
            object: nil)
        imageListService.fetchPhotosNextPage()
    }
    
    @objc private func handleImageListServiceDidChange(_ notivication: Notification) {
        updateTableViewAnimated()
    }
    
    private func updateTableViewAnimated() {
            let oldPhotos = photos.count
            let newPhotos = imageListService.photos.count
            photos = imageListService.photos
            
            tableView.performBatchUpdates {
                let indexPaths = (oldPhotos..<newPhotos).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            
            viewController.imageURL = photos[indexPath.row].largeImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController {
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) -> Void {
        let photo = photos[indexPath.row]
        
        cell.cellImage.kf.setImage(with: photo.thumbImageURL)
        
        if let date = photo.createdAt {
            cell.dateLabel.text = dateFormatter.string(from: date)
        } else {
            cell.dateLabel.text = ""
        }
        
        let likeImage = photo.isLiked ? UIImage(named: "likeButtonActive") : UIImage(named: "likeButtonInactive")
        cell.likeButton.setImage(likeImage, for: .normal)
        cell.delegate = self
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        let imageWidth = photo.size.width
        let imageHeight = photo.size.height
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageHeight * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imageListService.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: ImageListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        
        guard !isLiking else { return }
        isLiking = true
        
        UIBlockingProgressHUD.show()
        imageListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { result in
            
            defer {
                self.isLiking = false
                UIBlockingProgressHUD.dismiss()
            }
            
            switch result {
            case .success:
                self.photos = self.imageListService.photos
                cell.setIsLiked(self.photos[indexPath.row].isLiked)
                
            case .failure(let error):
                print("Failed to change like status: \(error)")
            }
        }
    }
}
