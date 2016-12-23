//
//  ViewController.swift
//  CallStack
//
//  Created by Michael Bellissimo on 12/19/16.
//  Copyright © 2016 Michael Bellissimo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var tableView: UITableView!

    
    var toDoItems = ToDoList()
    var coreStack = DataController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        toDoItems = coreStack.loadState()
        
//        toDoItems.prepend(newItem: ToDoItem(text: "feed the cat"))
//        toDoItems.prepend(newItem: ToDoItem(text: "buy eggs"))
//        toDoItems.prepend(newItem: ToDoItem(text: "watch WWDC videos"))
//        toDoItems.prepend(newItem: ToDoItem(text: "ahdsfkj"))
//        toDoItems.prepend(newItem: ToDoItem(text: "plants lots of them"))
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        if toDoItems.count() > 0 {
            return
        }
        
//
        toDoItems.printList()
    }
    
    @IBAction func pop(_ sender: Any) {
        toDoItems.pop()
        tableView.reloadData()
    }
    
    func appMovedToBackground(){
        coreStack.saveState(items: toDoItems)
    }
    
    
    
    
    @IBAction func addScreenButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add New Name", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            self.toDoItems.prepend(newItem: ToDoItem(text: firstTextField.text!))
            self.tableView.reloadData()
            
        })
        
        
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "What would you like to add?"
        }
        
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
   

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count()
    }
    
    internal func tableView(_ tableView: UITableView,
                           cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) 
        let item = toDoItems.get(index: indexPath.row)
        cell.textLabel?.text = item.text
        return cell
    }
    

}

