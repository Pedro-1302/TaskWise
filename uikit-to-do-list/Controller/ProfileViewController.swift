//
//  ProfileViewController.swift
//  uikit-to-do-list
//
//  Created by Pedro Franco on 11/02/24.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    @IBOutlet weak var myImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let uid = Auth.auth().currentUser?.uid,
                  let savedImagePath = UserDefaults.standard.string(forKey: "userProfileImage_\(uid)") {
                   let savedImage = UIImage(contentsOfFile: savedImagePath)
                   myImageView.image = savedImage
               }
        
        myImageView.layer.cornerRadius = 10
    }
    
    @IBAction func chooseImageAction(_ sender: Any) {
        showImagePickerOptions()
    }
    
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
                // TODO
            }
        }
        
        let libraryAction = UIAlertAction(title: "Library", style: .default) { [weak self] (action) in
            guard let self = self else {
                return
            }
            
            let libraryImagePicker = self.imagePicker(sourceType: .photoLibrary)
            libraryImagePicker.delegate = self
            
            self.present (libraryImagePicker, animated: true) {
                // TODO
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(cameraAction)
        alertVC.addAction(libraryAction)
        alertVC.addAction(cancelAction)
        
        self.present(alertVC, animated: true, completion: nil)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
                    self.myImageView.image = image

                    // Salvar o caminho da imagem no UserDefaults com base no UID do usuário
                    if let uid = Auth.auth().currentUser?.uid,
                       let imageData = image.jpegData(compressionQuality: 1.0) {
                        let uniqueFilename = UUID().uuidString
                        let imagePath = getDocumentsDirectory().appendingPathComponent("\(uniqueFilename).jpg")
                        UserDefaults.standard.set(imagePath.path, forKey: "userProfileImage_\(uid)")
                        try? imageData.write(to: imagePath)
                    }
                }

                self.dismiss(animated: true, completion: nil)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
