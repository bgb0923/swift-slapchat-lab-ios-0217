//
//  TableViewController.swift
//  SlapChat
//
//  Created by Ian Rahman on 7/16/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    let sharedInstance = DataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sharedInstance.fetch()
        if self.sharedInstance.messages.isEmpty { self.generateTestData() }
        print(sharedInstance.messages.count)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sharedInstance.fetch()
        self.tableView.reloadData()
    }
    
    func generateTestData() {
        for num in 1...25 {
            let context = sharedInstance.persistentContainer.viewContext
            let message = Message(context: context)
            message.content = "This is message # \(num)"
            message.createdAt = Date() as NSDate?
            sharedInstance.saveContext()
        }
        sharedInstance.saveContext()
    }
    
    
    @IBAction func addMessage(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Create New Message", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter new message"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            if let text = alert.textFields?[0].text {
                let context = self.sharedInstance.persistentContainer.viewContext
                let message = Message(context: context)
                message.content = text
                message.createdAt = Date() as NSDate?
                self.sharedInstance.saveContext()
                self.sharedInstance.fetch()
                self.tableView.reloadData()
            }
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sharedInstance.messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
        cell.textLabel?.text = self.sharedInstance.messages[indexPath.row].content
        return cell
    }
}
