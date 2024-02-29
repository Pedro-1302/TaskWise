//
//  CreateTaskViewController.swift
//  uikit-to-do-list
//
//  Created by Pedro Franco on 10/02/24.
//

import UIKit
import Firebase

protocol ReloadTableViewDelegate {
    func didUpdateTableView()
}

class CreateTaskViewController: UIViewController {
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    private let datePicker: UIDatePicker = UIDatePicker()
    private var dateFormatter = DateFormatter()
    private var selectedIndexPath: IndexPath?
    
    var reloadTableViewDelegate: ReloadTableViewDelegate?
                
    let db = Firestore.firestore()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskNameTextField.stylizeTextField(placeholder: "Enter task name")
        
        taskDescriptionTextField.stylizeTextField(placeholder: "Enter task description")
        
        dateTextField.stylizeTextField(placeholder: "Select finish date")
        
        dateTextField.delegate = self
        
        configureDatePicker()
        
        print("\(Auth.auth().currentUser?.email)")
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        if taskNameTextField.text == "" { return }
        if taskDescriptionTextField.text == "" { return }
        if dateTextField.text == "" { return }
        
        let id = UUID().uuidString
        
        if let taskName = taskNameTextField.text,
           let taskDesc = taskDescriptionTextField.text,
           let date = dateTextField.text,
           let taskSender = Auth.auth().currentUser?.email {

            db.collection(K.collectionName).addDocument (
                data: [
                    K.id: id,
                    K.sender: taskSender,
                    K.taskName: taskName,
                    K.taskDesc: taskDesc,
                    K.taskDate: date
                ]) { (error) in
                    if let err = error {
                        print("There was an issue saving data to firestore, \(err.localizedDescription).")
                    } else {
                        DispatchQueue.main.async {
                            self.taskNameTextField.text = ""
                            self.taskDescriptionTextField.text = ""
                            self.dateTextField.text = ""
                            self.dismiss(animated: true)
                            self.reloadTableViewDelegate?.didUpdateTableView()
                        }
                                                
                        print("Sucessfully saved data.")
                    }
                }
        }
    }
    
}

extension CreateTaskViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dateTextField {
            datePicker.date = dateFormatter.date(from: textField.text ?? "") ?? Date()
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == dateTextField {
            datePicker.date = dateFormatter.date(from: textField.text ?? "") ?? Date()
        }
        
        return true
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
    
    // Configure the TextField do receive DatePicker format
    func configureDatePicker() {
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = accessoryView()
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    // Create Done Button
    func accessoryView() -> UIView {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        let barItemSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(selectDate))
        
        toolbar.setItems([barItemSpace, doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        toolbar.sizeToFit()
        
        return toolbar
    }
    
    // Add date to textField
    @objc func selectDate() {
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        dateTextField.resignFirstResponder()
    }
    
    // Update the value in textField after user stop rolling the datepicker wheel
    @objc func datePickerValueChanged() {
        dateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
}
