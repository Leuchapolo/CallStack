//
//  ViewController.swift
//  CallStack
//
//  Created by Michael Bellissimo on 12/19/16.
//  Copyright © 2016 Michael Bellissimo. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    
    var ref : FIRDatabaseReference!
    
    @IBOutlet weak var terminalInputField: UITextField!
    
    @IBOutlet weak var enterButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    enum Color{
        case blue
        case red
        case green
    }
    var colorScheme = Color.red
    var currentThing = "Take a bath"
    
    var toDoItems = ToDoList()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        self.terminalInputField.delegate = self
        
        toDoItems = ToDoList()
        loadList(thingName: "Take a bath", instanceNumber: 0, ref: ref)
        
        
        
        tableView.dataSource = self
        
        
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.tableLongPressed(_:)))
        self.tableView.addGestureRecognizer(longpress)
        tableView.separatorStyle = .none
        tableView.rowHeight = 50.0
        
        
        
        
        
        

    }
    
    @IBAction func enterButtonPressed(_ sender: Any) {
        terminalInputField.resignFirstResponder()
        processText()
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        
        processText()
        return true
    }
    
    func addChild(parent : String,  value : String ){
        print(value +  " \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
        self.ref.child("Everything/"  + parent + "/" + value).setValue( ["instance" :  0, "index" : toDoItems.count()])
        
    }
    
    func loadList(thingName : String, instanceNumber : Int, ref : FIRDatabaseReference){
        print("THis should workkkkkkk \n \n \n \n \n")
        let refHandle = ref.child("Everything/" + thingName).observe(FIRDataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : [String : AnyObject]] ?? [:]
            self.toDoItems.list.removeAll(keepingCapacity: true)
            
            for (val, info) in postDict {
                
                    self.toDoItems.prepend(newItem: ToDoItem( value: val , index: info["index"] as! Int, instance: info["instance"] as! Int))
                
                //make temp list and then sort it and then prepend onto the list
                
                
                
            }
            self.toDoItems.sort()
            
            self.tableView.reloadData()
        })
        
    }
    
    
    func blueColorForIndex(index: Int) -> UIColor {
        let itemCount = toDoItems.count() - 1
        var val = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        if (itemCount == 1 && index == 1){
            val = 0.3
        }
        return UIColor(red: val * 0.5, green: val  , blue: 0.84, alpha: 1.0)
    }
    
    
    func redColorForIndex(index: Int) -> UIColor {
        let itemCount = toDoItems.count() - 1
        var val = (CGFloat(index) / CGFloat(itemCount)) * 0.3
        if (itemCount == 1 && index == 1){
            val = 0.3
        }
        return UIColor(red: 0.9, green: val * 1.1 + 0.3 , blue: val + 0.4, alpha: 1.0)
    }
    func greenColorForIndex(index: Int) -> UIColor {
        let itemCount = toDoItems.count() - 1
        var val = (CGFloat(index) / CGFloat(itemCount)) * 0.4
        if (itemCount == 1 && index == 1){
            val = 0.3
        }
        return UIColor(red: val / 1.3 + 0.3, green: 0.8 , blue: val + 0.3  , alpha: 1.0)
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
                    //Make it so that it just changes a variable newIndex that tells Firebase where to change it to and save it after you move it and this is executed at uigesturerecogstate.ended
                    
                    
                    
                    tableView.moveRow(at: Path.initialIndexPath!, to: indexPath!)
                    reorderInFireBase()
                    Path.initialIndexPath = indexPath
                    
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
    
    func reorderInFireBase(){
        var i = 0
        var indexDict = [String : Int]()
        var newKey = ""
        for  item in toDoItems.list{
            //add a dictionary entry with the key being the path to the order and then use update child values to do it all
            newKey = "Everything/Take a bath/" + item.value + "/index"
            indexDict[newKey] = i
            i+=1
        }
        ref.updateChildValues(indexDict)
        tableView.reloadData()
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
    
    
    
    func pop(){
        
        self.ref.child("Everything/"  + currentThing + "/" + toDoItems.pop().value ).setValue(nil)
        
    }
    
    
    func processText(){
        let text = terminalInputField.text
        terminalInputField.text = ""
        var arr = text?.components(separatedBy:  "\"")
        var index = 0
        var stringArgs = [String]()
        for item in arr!{
            if(item != " " && item != "" && index != 0){
                
                stringArgs.insert(item, at: 0)
            }
            index += 1
        }
        
        
        if(text == "pop"){
            pop()
        }
        if(text == "debug print"){
            toDoItems.printList()
            print(toDoItems.count())
        }
        
        if(text == "red" ){
            colorScheme = Color.red
            enterButton.titleLabel?.textColor = UIColor(colorLiteralRed: 0.9, green: 0.3, blue: 0.4, alpha: 1)
            tableView.reloadData()
        }
        
        if(text == "blue" ){
            colorScheme = Color.blue
            enterButton.titleLabel?.textColor = UIColor(colorLiteralRed: 0.1, green: 0.2, blue: 0.8, alpha: 1)
            tableView.reloadData()
        }
        if(text == "green" ){
            colorScheme = Color.green
            enterButton.titleLabel?.textColor = UIColor(colorLiteralRed: 0.1, green: 0.8, blue: 0.2, alpha: 1)
            tableView.reloadData()
        }
        if((text?.characters.count)! < 3){
            return
        }
        if(text?.substring(to: (text?.index((text?.startIndex)!, offsetBy: 3))!) == "add" ){
            
            
            var newChild = ""
            for item in stringArgs {
                newChild = item
                
                addChild(parent: currentThing, value: newChild)
            }
        }
        
        
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
        cell.textLabel?.text = item.value
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.textAlignment = .center
        cell.layer.cornerRadius = 8.0
        
        cell.layer.borderWidth = 4
        cell.layer.borderColor = UIColor.white.cgColor
        return cell
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        if(colorScheme == Color.red){
            cell.backgroundColor = redColorForIndex(index: indexPath.row)
        } else if (colorScheme == Color.blue){
            cell.backgroundColor = blueColorForIndex(index: indexPath.row)
        } else {
            cell.backgroundColor = greenColorForIndex(index: indexPath.row)
        }
        
        
    }

}

