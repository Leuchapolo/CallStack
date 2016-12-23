//
//  ToDoItem.swift
//  CallStack
//
//  Created by Michael Bellissimo on 12/19/16.
//  Copyright © 2016 Michael Bellissimo. All rights reserved.
//

import UIKit

class ToDoItem: NSObject {
    var text: String
    var completed: Bool
    
    
    
    init(text: String) {
        self.text = text
        self.completed = false
        
        
    }
    
}
