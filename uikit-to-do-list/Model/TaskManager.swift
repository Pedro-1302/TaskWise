//
//  TaskManager.swift
//  uikit-to-do-list
//
//  Created by Pedro Franco on 03/03/24.
//

import FirebaseAuth

protocol AuthenticationDelegate {
    func didReturnWithError(with error: Error)
    func didPerformSegue(identifier: String)
}

struct TaskManager {
    var authenticationDelegate: AuthenticationDelegate?

    func checkAuthRegister(emailNotVerified: String?, passwordNotVerified: String?) {
        if let email = emailNotVerified, let password = passwordNotVerified {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let err = error {
                    self.authenticationDelegate?.didReturnWithError(with: err)
                } else {
                    self.authenticationDelegate?.didPerformSegue(identifier: K.registerSegue)
                }
            }
        }
    }
    
    func checkAuthLogin(emailNotVerified: String?, passwordNotVerified:String?) {
        if let email = emailNotVerified, let password = passwordNotVerified {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let err = error {
                    self.authenticationDelegate?.didReturnWithError(with: err)
                } else {
                    self.authenticationDelegate?.didPerformSegue(identifier: K.loginSegue)
                }
            }
        }
    }
}
