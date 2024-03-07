//
//  ProfileViewController.swift
//  uikit-to-do-list
//
//  Created by Pedro Franco on 11/02/24.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
//    @IBOutlet weak var myImageView: UIImageView!
//    
//    
//    @IBAction func chooseImageAction(_ sender: Any) {
//        showImagePickerOptions()
//    }
    
    func imagePicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        return imagePicker
    }
    
    func showImagePickerOptions() {
        let alertVC = UIAlertController(title: "Pick a Photo", message: "Choose a picture from Librar or", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] (action) in
            guard let self = self else {
                return
            }
            
            let cameraImagePicker = self.imagePicker (sourceType: .camera)
            cameraImagePicker.delegate = self
            
            self.present (cameraImagePicker, animated: true) {
                //TODO
            }
        }
        
        let libraryAction = UIAlertAction(title: "Library", style: .default) { [weak self] (action) in
            guard let self = self else {
                return
            }
            
            let libraryImagePicker = self.imagePicker(sourceType: .photoLibrary)
            libraryImagePicker.delegate = self
            
            self.present (libraryImagePicker, animated: true) {
                //TODO
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(cameraAction)
        alertVC.addAction(libraryAction)
        alertVC.addAction(cancelAction)
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
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

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        // self.myImageView.image = image
        self.dismiss(animated: true, completion: nil)
    }
}
