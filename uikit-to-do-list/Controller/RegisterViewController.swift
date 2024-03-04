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
        taskManager.checkAuthRegister(emailNotVerified: emailTextField.text, passwordNotVerified: passwordTextField.text)
    }
}

extension RegisterViewController: AuthenticationDelegate {
    func didReturnWithError(with error: Error) {
        print(error.localizedDescription)

    }
    
    func didPerformSegue(identifier: String) {
        self.performSegue(withIdentifier: identifier, sender: self)
    }
}



