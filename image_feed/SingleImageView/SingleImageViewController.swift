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
    
    private var alertPresenter: AlertPresenter?
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(_ sender: UIButton) {
        guard let image else {
            print("No image to share")
            return
        }
        
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
        alertPresenter = AlertPresenter(delegate: self)
        loadImage()
    }
    
    private func loadImage() {
        guard let imageURL = imageURL else { return }
        print("Showing loader")
        UIBlockingProgressHUD.show()
        
        imageView.kf.setImage(with: imageURL) { [weak self] result in
            guard let self = self else { return }
            print("Hiding loader")
            UIBlockingProgressHUD.dismiss()
            
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
        alertPresenter?.showTwoOptionsAlert(title: "Ошибка",
                                            message: "Что-то пошло не так. Попробовать снова?",
                                            confirmButtonText: "Повторить",
                                            cancelButtonText: "Нет"
        ) { [weak self] in
            self?.loadImage()
        }
    }
}

// MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
