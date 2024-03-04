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
    
    var taskManager = TaskManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stylizeTextField(emailTextField, placeholder: "Enter your email address")
        
        stylizeTextField(passwordTextField, placeholder: "Enter your password")
        
        taskManager.authenticationDelegate = self
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        taskManager.checkAuthLogin(emailNotVerified: emailTextField.text, passwordNotVerified: passwordTextField.text)
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
        print(error.localizedDescription)

    }
    
    func didPerformSegue(identifier: String) {
        print("Deu")
        self.performSegue(withIdentifier: identifier, sender: self)
    }
}
