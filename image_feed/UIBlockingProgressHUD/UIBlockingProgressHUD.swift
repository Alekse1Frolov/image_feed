//
//  UIBlockingProgressHUD.swift
//  image_feed
//
//  Created by Aleksei Frolov on 09.04.2024.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        guard let window = window else { return }
        window.isUserInteractionEnabled = false
        
        let overlay = UIView(frame: window.bounds)
                overlay.backgroundColor = UIColor(white: 0, alpha: 0.5)
                overlay.accessibilityIdentifier = "ProgressHUD"
                overlay.isUserInteractionEnabled = false
        
        window.addSubview(overlay)
        ProgressHUD.show()
    }
    
    static func dismiss() {
        guard let window = window else { return }
        window.isUserInteractionEnabled = true
        
        window.subviews.filter { $0.accessibilityIdentifier == "ProgressHUD" }.forEach { $0.removeFromSuperview() }
        
        ProgressHUD.dismiss()
    }
}
