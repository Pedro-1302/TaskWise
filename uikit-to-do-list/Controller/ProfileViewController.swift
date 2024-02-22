//
//  ProfileViewController.swift
//  uikit-to-do-list
//
//  Created by Pedro Franco on 11/02/24.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            tabBarController?.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out : %@", signOutError)
        }
    }
}
