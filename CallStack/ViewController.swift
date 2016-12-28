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
        

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.tableLongPressed(_:)))
        self.tableView.addGestureRecognizer(longpress)
        tableView.separatorStyle = .none
        tableView.rowHeight = 50.0
        
        
        
        
        

    }
    
    func colorForIndex(index: Int) -> UIColor {
        let itemCount = toDoItems.count() - 1
        var val = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        if (itemCount == 1 && index == 1){
            val = 0.3
        }
        return UIColor(red: val / 2, green: val, blue: 0.84, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        cell.backgroundColor = colorForIndex(index: indexPath.row)
    }
    
    func tableLongPressed(_ gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: locationInView)
        
        struct My {
            static var cellSnapshot : UIView? = nil
            static var cellIsAnimating : Bool = false
            static var cellNeedToShow : Bool = false
        }
        struct Path {
            static var initialIndexPath : IndexPath? = nil
        }
        
        switch state {
        case UIGestureRecognizerState.began:
            if indexPath != nil {
                Path.initialIndexPath = indexPath
                let cell = tableView.cellForRow(at: indexPath!) as UITableViewCell!
                My.cellSnapshot  = snapshotOfCell(cell!)
                
                var center = cell?.center
                My.cellSnapshot!.center = center!
                My.cellSnapshot!.alpha = 0.0
                tableView.addSubview(My.cellSnapshot!)
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    center?.y = locationInView.y
                    My.cellIsAnimating = true
                    My.cellSnapshot!.center = center!
                    My.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    My.cellSnapshot!.alpha = 0.98
                    cell?.alpha = 0.0
                }, completion: { (finished) -> Void in
                    if finished {
                        My.cellIsAnimating = false
                        if My.cellNeedToShow {
                            My.cellNeedToShow = false
                            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                                cell?.alpha = 1
                            })
                        } else {
                            cell?.isHidden = true
                        }
                    }
                })
            }
            
        case UIGestureRecognizerState.changed:
            if My.cellSnapshot != nil {
                var center = My.cellSnapshot!.center
                center.y = locationInView.y
                My.cellSnapshot!.center = center
                
                if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                    
                    //to fix adding to end then you need to append to the list instead of insert so do if statement
                    toDoItems.list.insert(toDoItems.list.remove(at: toDoItems.count() - 1 - Path.initialIndexPath!.row), at: toDoItems.count() -  indexPath!.row)
                    print((Path.initialIndexPath!.row as NSNumber).stringValue + (" : Initial index"))
                    print((indexPath!.row as NSNumber).stringValue + (" : New index"))
                    print(((toDoItems.count() - 1 - Path.initialIndexPath!.row) as NSNumber).stringValue + (" : Old index in Array"))
                    print(((toDoItems.count() - 1 - indexPath!.row) as NSNumber).stringValue + (" : New index in Array"))
                    
                    
                    
                    toDoItems.printList()
                    
                    tableView.moveRow(at: Path.initialIndexPath!, to: indexPath!)
                    Path.initialIndexPath = indexPath
                    tableView.reloadData()
                }
                
            }
        
            
        default:
            if Path.initialIndexPath != nil {
                let cell = tableView.cellForRow(at: Path.initialIndexPath!) as UITableViewCell!
                if My.cellIsAnimating {
                    My.cellNeedToShow = true
                } else {
                    cell?.isHidden = false
                    cell?.alpha = 0.0
                }
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    My.cellSnapshot!.center = (cell?.center)!
                    My.cellSnapshot!.transform = CGAffineTransform.identity
                    My.cellSnapshot!.alpha = 0.0
                    cell?.alpha = 1.0
                    
                }, completion: { (finished) -> Void in
                    if finished {
                        Path.initialIndexPath = nil
                        My.cellSnapshot!.removeFromSuperview()
                        My.cellSnapshot = nil
                    }
                })
            }
        }

    }
    
    func snapshotOfCell(_ inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
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
//REMOVE THIS THIS IS FOR DEBUGGING!!!!!!!!!!!!!!!!!!!
        tableView.reloadData()
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            self.toDoItems.list.append(ToDoItem(text: firstTextField.text!))
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
        let item = toDoItems.get(index: toDoItems.count() - 1 - indexPath.row)
        cell.textLabel?.text = item.text
        cell.textLabel?.textColor = UIColor.white
        cell.layer.borderColor = UIColor.black.cgColor
        return cell
    }
    

}

