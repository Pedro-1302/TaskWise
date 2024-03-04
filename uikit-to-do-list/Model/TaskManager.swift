//
//  TaskManager.swift
//  uikit-to-do-list
//
//  Created by Pedro Franco on 03/03/24.
//

import FirebaseAuth
import FirebaseFirestore

protocol AuthenticationDelegate {
    func didReturnWithError(with error: Error)
    func didPerformSegue(identifier: String)
}

class TaskManager {
    static let shared = TaskManager()
    
    var authenticationDelegate: AuthenticationDelegate?
    
    var tasks: [Task] = []
    
    let db = Firestore.firestore()
    
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
    
    func loadTasks(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        db.collection(K.collectionName)
            .order(by: K.taskDate)
            .addSnapshotListener { (querySnapshot, error) in
                self.tasks = []
                
                if let err = error {
                    print("There was an issue retrieving data from firestore, \(err.localizedDescription).")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            
                            if let id = data[K.id] as? String,
                               let currentUserEmail = data[K.sender] as? String,
                               let taskName = data[K.taskName] as? String,
                               let taskDesc = data[K.taskDesc] as? String,
                               let date = data[K.taskDate] as? String {
                                
                                let newTask = Task(id: id, sender: currentUserEmail, name: taskName, description: taskDesc, date: date)
                                
                                if currentUserEmail == Auth.auth().currentUser?.email {
                                    self.tasks.append(newTask)
                                }
                                
                                completion()
                                
                                print("Tasks loaded from Firestore successfully.")
                            }
                        }
                    }
                }
            }
    }
    
    func deleteTask(taskId: String) {
        guard let currentUserEmail = Auth.auth().currentUser?.email else { return }
        
        db.collection(K.collectionName)
            .whereField(K.sender, isEqualTo: currentUserEmail)
            .whereField(K.id, isEqualTo: taskId)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error deleting task from Firestore: \(error.localizedDescription)")
                } else {
                    for document in querySnapshot!.documents {
                        document.reference.delete()
                    }
                    
                    print("Task deleted from Firestore successfully.")
                }
            }
    }
    
    func createTask(taskId: String?, taskSender: String, taskName: String, taskDesc: String, taskDate: String, completion: @escaping () -> Void) {
                
        if let taskId = taskId {
            db.collection(K.collectionName)
                .document(taskId)
                .updateData([
                    K.id: taskId,
                    K.sender: taskSender,
                    K.taskName: taskName,
                    K.taskDesc: taskDesc,
                    K.taskDate: taskDate
                ]) { error in
                    if let error = error {
                        print("An error ocurred: \(error.localizedDescription).")
                    } else {
                        
                        completion()
                        
                        print("Task updated sucessfully.")
                    }
                }
        } else {
            let newTaskId = UUID().uuidString
            
            db.collection(K.collectionName)
                .document(newTaskId)
                .setData([
                    K.id: newTaskId,
                    K.sender: taskSender,
                    K.taskName: taskName,
                    K.taskDesc: taskDesc,
                    K.taskDate: taskDate
                ]) { error in
                    if let error = error {
                        print("An error ocurred: \(error.localizedDescription).")
                    } else {
                        
                        completion()
                        
                        print("Task created sucessfully.")
                    }
                }
        }
    }
}

