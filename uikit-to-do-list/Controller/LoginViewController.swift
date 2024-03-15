//
//  LoginViewController.swift
//  uikit-to-do-list
//
//  Created by Pedro Franco on 10/02/24.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var buttonClicked = 0
    private var taskManager = TaskManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stylizeTextField(emailTextField, placeholder: "Enter your email address")
        
        stylizeTextField(passwordTextField, placeholder: "Enter your password")
        
        taskManager.authenticationDelegate = self
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            return ErrorHandler.showErrorBox(in: self, title: "Please fill in all the required fields.")
        }
        buttonClicked += 1
        
        if (buttonClicked > 1) {
            return
        } else {
            taskManager.checkAuthLogin(emailNotVerified: email, passwordNotVerified: password)
        }
    }
    
    func stylizeTextField(_ textField: UITextField, placeholder: String) {
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
    }
}

extension LoginViewController: AuthenticationDelegate {
    func didReturnWithError(with error: Error) {
        ErrorHandler.showErrorBox(in: self, title: error.localizedDescription)
    }
    
    func didPerformSegue(identifier: String) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: identifier, sender: self)
            self.buttonClicked = 0
        }
    }
}
