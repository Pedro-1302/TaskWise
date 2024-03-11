//
//  RegisterViewController.swift
//  uikit-to-do-list
//
//  Created by Pedro Franco on 10/02/24.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var taskManager = TaskManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.stylizeTextField(placeholder: "Enter your email address")
        
        passwordTextField.stylizeTextField(placeholder: "Enter your password")
        
        taskManager.authenticationDelegate = self
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            return ErrorHandler.showErrorBox(in: self, title: "Please fill in all the required fields.")
        }
        
        taskManager.checkAuthRegister(emailNotVerified: email, passwordNotVerified: password)
    }
}

extension RegisterViewController: AuthenticationDelegate {
    func didReturnWithError(with error: Error) {
        ErrorHandler.showErrorBox(in: self, title: error.localizedDescription)
    }
    
    func didPerformSegue(identifier: String) {
        self.performSegue(withIdentifier: identifier, sender: self)
    }
}
