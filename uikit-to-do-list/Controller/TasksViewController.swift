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
    
    let createTaskViewController = CreateTaskViewController()
    
    var overlayView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        createTaskViewController.reloadTableViewDelegate = self
        loadTasks()
    }
    
    private func setupTableView() {
        self.navigationItem.hidesBackButton = true
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }
    
    private func loadTasks() {
        TaskManager.shared.loadTasks {
            let indexPath = IndexPath(row: TaskManager.shared.tasks.count - 1, section: 0)
            
            if indexPath.count > 8 {
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
            
            self.tableView.reloadData()
            self.toggleOverlayView()
        }
    }
    
    private func deleteTask(at indexPath: IndexPath) {
        let row = indexPath.row
        let deletedTask = TaskManager.shared.tasks[row]
        
        TaskManager.shared.deleteTask(taskId: deletedTask.id)
        TaskManager.shared.tasks.remove(at: row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        self.toggleOverlayView()
    }
    
    private func toggleOverlayView() {
        if TaskManager.shared.tasks.isEmpty {
            showOverlayView()
        } else {
            hideOverlayView()
        }
    }

    private func showOverlayView() {
        if overlayView == nil {
            let messageLabel = UILabel()
            messageLabel.textAlignment = .center
            messageLabel.textColor = .gray
            messageLabel.preferredMaxLayoutWidth = 400
            messageLabel.font = UIFont.systemFont(ofSize: 22.0)

            let attributedText = NSMutableAttributedString(string: "Click on '+' to add a new Task.")
            let range = (attributedText.string as NSString).range(of: "+")
            attributedText.addAttribute(.foregroundColor, value: UIColor.accent, range: range)

            messageLabel.attributedText = attributedText

            overlayView = UIView(frame: tableView.bounds)
            overlayView?.addSubview(messageLabel)

            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                messageLabel.centerXAnchor.constraint(equalTo: overlayView!.centerXAnchor),
                messageLabel.centerYAnchor.constraint(equalTo: overlayView!.centerYAnchor)
            ])
        }

        tableView.backgroundView = overlayView
        tableView.separatorStyle = .none
    }


    private func hideOverlayView() {
        tableView.backgroundView = nil
        tableView.separatorStyle = .singleLine
    }

    private func formatText(from dateText: String) -> String {
        let index = dateText.index(dateText.startIndex, offsetBy: 5)
        let dateFormatted = String(dateText.prefix(upTo: index))
        return dateFormatted
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UpdateNewTask" {
            let destinationVC = segue.destination as! CreateTaskViewController
            
            if let selectedTask = sender as? Task {
                destinationVC.taskToEdit = selectedTask
            }
            
            destinationVC.title = "Edit Task"
        }
    }
}

extension TasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteTask(at: indexPath)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTask = TaskManager.shared.tasks[indexPath.row]
        
        self.performSegue(withIdentifier: "UpdateNewTask", sender: selectedTask)
    }
        
}

extension TasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tasksCount = TaskManager.shared.tasks.count
   
        return tasksCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as? TaskTableViewCell
        
        let row = indexPath.row
        let message = TaskManager.shared.tasks[row]
        
        guard let safeCell = cell else { return UITableViewCell() }
        
        safeCell.dateLabel.text = formatText(from: message.date)
        safeCell.taskNameLabel.text = message.name
        safeCell.taskDescriptionLabel.text = message.description
        
        setCornerRadius(for: safeCell, at: indexPath)
        
        return safeCell
    }
    
    private func setCornerRadius(for cell: TaskTableViewCell, at indexPath: IndexPath) {
        let totalRowsInLastSection = tableView.numberOfRows(inSection: tableView.numberOfSections - 1)
        
        if totalRowsInLastSection == 1 {
            cell.taskBackgroundView.layer.cornerRadius = 10.0
            cell.taskBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            let isFirstRow = indexPath.row == 0
            let isLastRow = indexPath.row == totalRowsInLastSection - 1
            
            if isFirstRow || isLastRow {
                cell.taskBackgroundView.layer.cornerRadius = 10.0
                cell.taskBackgroundView.layer.maskedCorners = isFirstRow ? [.layerMinXMinYCorner, .layerMaxXMinYCorner] : [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            } else {
                cell.taskBackgroundView.layer.cornerRadius = 0.0
            }
        }
    }
}

extension TasksViewController: ReloadTableViewDelegate {
    func didUpdateTableView() {
        loadTasks()
    }
}
