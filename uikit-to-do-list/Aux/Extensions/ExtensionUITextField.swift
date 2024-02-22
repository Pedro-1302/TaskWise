//
//  ExtensionUITextField.swift
//  uikit-to-do-list
//
//  Created by Pedro Franco on 10/02/24.
//

import UIKit

extension UITextField {
    func stylizeTextField(placeholder: String) {
        self.attributedPlaceholder = NSAttributedString(
               string: placeholder,
               attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
           )

        self.layer.borderColor = UIColor.black.cgColor
           self.layer.borderWidth = 1.0
           self.layer.cornerRadius = 5.0
       }
}
