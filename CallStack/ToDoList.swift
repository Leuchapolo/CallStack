//
//  ToDoList.swift
//  CallStack
//
//  Created by Michael Bellissimo on 12/20/16.
//  Copyright © 2016 Michael Bellissimo. All rights reserved.
//

import UIKit
import Firebase

class ToDoList: NSObject {
    
    var list = [ToDoItem]()
    
    
    
    func count() -> Int {
        return list.count
    }
    
    
    
    func prepend(newItem : ToDoItem?) -> Bool{
        
        list.append(newItem!)
        
        
        return true
    }
    
    func sort(){
        self.list.sort(by: sortedFunction)
    }
    
    private func sortedFunction (item1 : ToDoItem, item2 : ToDoItem) -> Bool {
        return item1.index < item2.index
    }
    
    func pop(){
        list.removeLast()
    }
    
    func get(index : Int) -> ToDoItem{
        return list[index]
    }
    
    
    
    func printList(){
        for item in list{
            print(item.text())
        }
    }
    
}
