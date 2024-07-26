//
//  AlertPresenter.swift
//  image_feed
//
//  Created by Aleksei Frolov on 16.06.2024.
//

import UIKit

final class AlertPresenter {
    
    weak var delegate: UIViewController?
    
    init(delegate: UIViewController?) {
        self.delegate = delegate
    }
    
    func showAlertWithNetworkError(title: String?, message: String?, buttonText: String?) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: buttonText,
                                   style: .default)
        
        alert.addAction(action)
        delegate?.present(alert, animated: true)
    }
    
    func showTwoOptionsAlert(title: String?, message: String?, confirmButtonText: String?, cancelButtonText: String?, confirmAction: @escaping () -> Void) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(title: confirmButtonText, style: .destructive) { _ in
            confirmAction()
        }
        
        let cancelAction = UIAlertAction(title: cancelButtonText, style: .cancel, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        alert.view.accessibilityIdentifier = "TwoOptionsAlert"
        delegate?.present(alert, animated: true)
    }
}
