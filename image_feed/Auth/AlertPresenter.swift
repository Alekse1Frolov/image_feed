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
}
