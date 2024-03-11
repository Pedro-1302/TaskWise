//
//  UserTabBarController.swift
//  uikit-to-do-list
//
//  Created by Pedro Franco on 11/02/24.
//
import UIKit
import FirebaseAuth

class UserTabBarController: UITabBarController {
    private var customButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        self.navigationItem.hidesBackButton = true
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonTapped))
        
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtonTapped() {
        self.performSegue(withIdentifier: "CreateNewTask", sender: self)
    }
    
    @objc func logoutButtonTapped() {
        do {
            try Auth.auth().signOut()
            self.navigationController?.popViewController(animated: true)
            //tabBarController?.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out : %@", signOutError)
        }
    }
}

extension UserTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController is TasksViewController {
            navigationItem.title = "Tasks"
            
            let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonTapped))

            navigationItem.rightBarButtonItem = addButton
        }
        
        if viewController is ProfileViewController {
            navigationItem.title = "Profile"
            
            
            let logOutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonTapped))
            
            navigationItem.rightBarButtonItem = logOutButton
        }
    }
}

