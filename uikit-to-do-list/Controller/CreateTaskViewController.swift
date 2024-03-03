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
    @IBOutlet weak var modalNavItem: UINavigationItem!
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    private var selectedIndexPath: IndexPath?
    
    var reloadTableViewDelegate: ReloadTableViewDelegate?
    
    let db = Firestore.firestore()
    
    var taskToEdit: Task?
    private var taskId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskNameTextField.stylizeTextField(placeholder: "Enter task name")
        taskDescriptionTextField.stylizeTextField(placeholder: "Enter task description")
        dateTextField.stylizeTextField(placeholder: "Select finish date")
        
        dateTextField.delegate = self
        
        configureDatePicker()
        
        self.modalNavItem.title = "Create Task"
        
        if let taskToUpdate = taskToEdit {
            taskId = taskToUpdate.id
            
            taskNameTextField.text = taskToUpdate.name
            taskDescriptionTextField.text = taskToUpdate.description
            dateTextField.text = taskToUpdate.date
            self.modalNavItem.title = "Update Task"
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        let taskSender = Auth.auth().currentUser?.email ?? ""
        let updatedTaskName = taskNameTextField.text ?? ""
        let updatedTaskDesc = taskDescriptionTextField.text ?? ""
        let updatedTaskDate = dateTextField.text ?? ""
        
        if let taskId = taskId {
            db.collection(K.collectionName)
                .document(taskId)
                .updateData([
                    K.id: taskId,
                    K.sender: taskSender,
                    K.taskName: updatedTaskName,
                    K.taskDesc: updatedTaskDesc,
                    K.taskDate: updatedTaskDate
                ]) { error in
                    if let error = error {
                        print("Error updating task: \(error.localizedDescription)")
                    } else {
                        print("Task updated successfully.")
                        self.dismissScreen()
                    }
                }
        } else {
            let newTaskId = UUID().uuidString
            
            db.collection(K.collectionName)
                .document(newTaskId)
                .setData([
                    K.id: newTaskId,
                    K.sender: taskSender,
                    K.taskName: updatedTaskName,
                    K.taskDesc: updatedTaskDesc,
                    K.taskDate: updatedTaskDate
                ]) { error in
                    if let error = error {
                        print("Error adding new task: \(error.localizedDescription)")
                    } else {
                        print("New task added successfully.")
                        self.dismissScreen()
                    }
                }
        }
    }
    
    func dismissScreen() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
            self.reloadTableViewDelegate?.didUpdateTableView()
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
        guard !dateTextField.isFirstResponder else {
            return
        }

        dateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
}
