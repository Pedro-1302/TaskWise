//
//  ErrorHandler.swift
//  uikit-to-do-list
//
//  Created by Pedro Franco on 07/03/24.
//

import UIKit

class ErrorHandler {
    
    static func showErrorBox(in viewController: UIViewController, title: String, message: String? = nil) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        ac.popoverPresentationController?.barButtonItem = viewController.navigationItem.rightBarButtonItem
        
        viewController.present(ac, animated: true)
    }

}
