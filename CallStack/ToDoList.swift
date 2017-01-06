//
//  ToDoList.swift
//  CallStack
//
//  Created by Michael Bellissimo on 12/20/16.
//  Copyright © 2016 Michael Bellissimo. All rights reserved.
//

import UIKit

class ToDoList: NSObject {
    
    var list = [ToDoItem]()
    
    
    func count() -> Int {
        return list.count
    }
    
    func prepend(newItem : ToDoItem?) -> Bool{
        
        if(list.count == 0){
            list.append(newItem!)
            
            return true
        }
        
        list.insert(newItem!, at: 0)
        
        return true
    }
    
    func pop(){
        list.removeLast()
    }
    
    func get(index : Int) -> ToDoItem{
        return list[index]
    }
    
    func printList(){
        for item in list{
            print(item.text)
        }
    }
    
}
