//
//  ToDoItem.swift
//  CallStack
//
//  Created by Michael Bellissimo on 12/19/16.
//  Copyright © 2016 Michael Bellissimo. All rights reserved.
//

import UIKit

class ToDoItem: NSObject {
    var relationship : String
    var value: String
    var index: Int
    var instance : Int
    
    
    
    init(relationship : String , value: String, index : Int, instance : Int) {
        self.relationship = relationship
        self.value = value
        self.index = index
        self.instance = instance
        
    }
    func text() -> String{
        return relationship + ": " + value
    }
    
    
}
