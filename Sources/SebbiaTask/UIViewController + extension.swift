//
//  UIViewController + extension.swift
//  SebbiaTask
//
//  Created by Александр Иванцов on 24.06.2025.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(with data: AlertData) {
        let alertController = UIAlertController(
            title: data.title,
            message: data.message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: data.actionTitle, style: .default) { _ in
            data.actionHandler?()
        }
        alertController.addAction(action)
        
        present(alertController, animated: true)
    }
    
}
