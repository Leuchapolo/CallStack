//
//  ToDoItem.swift
//  CallStack
//
//  Created by Michael Bellissimo on 12/19/16.
//  Copyright © 2016 Michael Bellissimo. All rights reserved.
//

import UIKit

class ToDoItem: NSObject {
    
    var value: String
    var index: Int
    var instance : Int
    
    
    
    init( value: String, index : Int, instance : Int) {
        
        self.value = value
        self.index = index
        self.instance = instance
        
    }
    
    
    
}
