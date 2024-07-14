//
//  SingleImageViewController.swift
//  image_feed
//
//  Created by Aleksei Frolov on 25.2.24..
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    var imageURL: URL? {
        didSet {
            guard isViewLoaded else { return }
            loadImage()
        }
    }
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(_ sender: UIButton) {
        print("Share button tapped")
        guard let image else { print("No image to share"); return }
        
        print("Preparing to share image: \(image)")
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        share.completionWithItemsHandler = { activity, success, items, error in
                    if let error = error {
                        print("Error sharing: \(error)")
                    } else if success {
                        print("Image shared successfully")
                    } else {
                        print("Sharing canceled")
                    }
                }
        present(share, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        scrollView.delegate = self
        loadImage()
    }
    
    private func loadImage() {
        guard let imageURL = imageURL else { return }
        print("Showing loader")
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: imageURL) { [weak self] result in
            print("Hiding loader")
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.image = imageResult.image
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showError()
            }
        }
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage?) {
        guard let image else { return }
        
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func showError() {
        let alert = UIAlertController(title: "Error",
                                      message: "Something went wrong. Try again?",
                                      preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "Repeat", style: .default) { _ in
            self.loadImage()
        }
        
        let cancelAction = UIAlertAction(title: "No",
                                        style: .cancel,
                                        handler: nil)
        
        alert.addAction(retryAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
