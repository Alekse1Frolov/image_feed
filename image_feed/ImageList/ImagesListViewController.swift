//
//  ImagesListViewController.swift
//  image_feed
//
//  Created by Aleksei Frolov on 13.2.24..
//

import UIKit
import Kingfisher

public protocol ImagesListViewControllerProtocol: AnyObject {
    func updateTableViewAnimated()
    func navigateToImageController(with url: String)
    func updateLikeButton(at indexPath: IndexPath, isLiked: Bool)
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private var presenter: ImagesListPresenterProtocol?
    
    @IBOutlet private var tableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad called")
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        
        presenter?.viewDidLoad()
    }
    
    func updateTableViewAnimated() {
        print("updateTableViewAnimated called")
        tableView.reloadData()
    }
    
    func navigateToImageController(with url: String) {
        print("navigateToImageController called with URL: \(url)")
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: url)
    }
    
    func updateLikeButton(at indexPath: IndexPath, isLiked: Bool) {
        print("updateLikeButton called at indexPath: \(indexPath) with isLiked: \(isLiked)")
        guard let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell else { return }
        cell.setIsLiked(isLiked)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            if let indexPath = sender as? IndexPath {
                viewController.imageURL = presenter?.photos[indexPath.row].largeImageURL
            } else if let url = sender as? String {
                viewController.imageURL = URL(string: url)
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func configure(_ presenter: ImagesListPresenterProtocol) {
        print("ImagesListViewController: configure called")
        self.presenter = presenter
        presenter.view = self
    }
}

extension ImagesListViewController {
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) -> Void {
        guard let photo = presenter?.photos[indexPath.row] else { return }
        
        print("configCell called for indexPath: \(indexPath) with photo: \(photo)")
        
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
        let count = presenter?.photos.count ?? 0
        print("numberOfRowsInSection called with count: \(count)")
        return count
        
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
        print("ImagesListViewController: didSelectRowAt called with indexPath: \(indexPath)")
        presenter?.didSelectRowAt(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = presenter?.photos[indexPath.row] else { return 0 }
        let imageWidth = photo.size.width
        let imageHeight = photo.size.height
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageHeight * scale + imageInsets.top + imageInsets.bottom
        
        print("ImagesListViewController: heightForRowAt called with height: \(cellHeight)")
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.willDisplayCell(at: indexPath)
    }
}

extension ImagesListViewController: ImageListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        print("imageListCellDidTapLike called for indexPath: \(indexPath)")
        presenter?.didTapLikeButton(at: indexPath)
    }
}
