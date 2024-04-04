//
//  AuthViewController.swift
//  image_feed
//
//  Created by Aleksei Frolov on 12.03.2024.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

final class AuthViewController: UIViewController {
    
    private let showWebViewIdentifier = "ShowWebView"
    
    private let oauth2Service = OAuth2Service.shared
    
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP_black_color")
    }
}

extension AuthViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewIdentifier {
            if let viewController = segue.destination as? WebViewViewController {
                viewController.delegate = self
            } else {
                print("Failed to prepare for \(showWebViewIdentifier)")
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        
        oauth2Service.fetchOAuthToken(with: code) { result in
            switch result {
            case .success:
                self.delegate?.didAuthenticate(self)
            case .failure(let error):
                print("Error fetching OAuth token:", error.localizedDescription)
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
