//
//  TasksViewController.swift
//  uikit-to-do-list
//
//  Created by Pedro Franco on 10/02/24.
//

import UIKit
import Firebase
import FirebaseAuth

class TasksViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    
    var tasks: [Task] = []
    
    var createTaskViewController = CreateTaskViewController()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        tableView.backgroundColor = .white
        tableView.dataSource = self
                
        tableView.register(
            UINib(
                nibName: K.cellNibName,
                bundle: nil
            ), forCellReuseIdentifier: K.cellIdentifier
        )
        
        createTaskViewController.reloadTableViewDelegate = self
        
        loadTasks()
    }
    
    private func loadTasks() {
            db.collection(K.collectionName)
                .order(by: K.taskDate)
                .addSnapshotListener { (querySnapshot, error) in
                    
                    self.tasks = []
                    
                    if let err = error {
                        print(";;;; There was an issue retrieving data from firestore, \(err.localizedDescription).")
                    } else {
                        if let snapshotDocuments = querySnapshot?.documents {
                            for doc in snapshotDocuments {
                                let data = doc.data()
                                
                                if let currentUserEmail = data[K.sender] as? String,
                                   let taskName = data[K.taskName] as? String,
                                   let taskDesc = data[K.taskDesc] as? String,
                                   let date = data[K.taskDate] as? String {
                                    
                                    let newTask = Task(sender: currentUserEmail, name: taskName, description: taskDesc, date: date)
                                    
                                    self.tasks.append(newTask)
                                    
                                    DispatchQueue.main.async {
                                        let indexPath = IndexPath(row: self.tasks.count - 1, section: 0)
                                        
                                        if indexPath.count > 8 {
                                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                        }
                                    }
                                    
                                    self.tableView.reloadData()
                                    
                                    print("Carreguei com os dados do banco")
                                }
                            }
                        }
                }
        }
    }
}

extension TasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as? TaskTableViewCell

        let row = indexPath.row
        let message = tasks[row]

        guard let safeCell = cell else { return UITableViewCell() }

        safeCell.dateLabel.text = formatText(from: message.date)
        safeCell.taskNameLabel.text = message.name
        safeCell.taskDescriptionLabel.text = message.description

        let totalSections = tableView.numberOfSections
        let lastSectionIndex = totalSections - 1
        let totalRowsInLastSection = tableView.numberOfRows(inSection: lastSectionIndex)

        if totalRowsInLastSection == 1 {
            safeCell.taskBackgroundView.layer.cornerRadius = 10.0
        } else {
            if indexPath.row == 0 {
                safeCell.taskBackgroundView.layer.cornerRadius = 10.0
                safeCell.taskBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else if indexPath.row == totalRowsInLastSection - 1 {
                safeCell.taskBackgroundView.layer.cornerRadius = 10.0
                safeCell.taskBackgroundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            } else {
                safeCell.taskBackgroundView.layer.cornerRadius = 0.0
            }
        }

        return safeCell
    }

    
    func formatText(from dateText: String) -> String {
        let index = dateText.index(dateText.startIndex, offsetBy: 5)
        let dateFormatted = String(dateText.prefix(upTo: index))
        return dateFormatted
    }
}

extension TasksViewController: ReloadTableViewDelegate {
    func didUpdateTableView() {
        loadTasks()
        tableView.reloadData()
    }
}
