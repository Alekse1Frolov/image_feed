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
        ProgressHUD.show()
    }
    
    static func dismiss() {
        guard let window = window else { return }
        window.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
