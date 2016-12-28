//
//  DataController.swift
//  CallStack
//
//  Created by Michael Bellissimo on 12/21/16.
//  Copyright © 2016 Michael Bellissimo. All rights reserved.
//

import UIKit

import UIKit
import CoreData

class DataController: NSObject {
    var managedObjectContext: NSManagedObjectContext
    
    override init(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        super.init()
    }
    
    private func sortedFunction(obj1 : ToDo, obj2 : ToDo ) -> Bool{
        return obj1.index > obj2.index
    }
    
    func loadState() -> ToDoList{
        let returnList = ToDoList()
        let todosFetch = NSFetchRequest<ToDo>(entityName: "ToDo")
        
        do {
            let fetchedToDos = try managedObjectContext.fetch(todosFetch)
            var currentToDo : ToDoItem
        
            let sortedTodos = fetchedToDos.sorted(by: sortedFunction)
            for item in sortedTodos{
                print(item.index)
                currentToDo = ToDoItem(text: item.text! )
                returnList.prepend(newItem: currentToDo)
            }
            
            for item in fetchedToDos{
                managedObjectContext.delete(item)
            }
            
            
            
        } catch {
            fatalError("Failed to fetch todos: \(error)")
        }
        
        return returnList
    }
    
    func saveState(items : ToDoList){
        let todosFetch = NSFetchRequest<ToDo>(entityName: "ToDo")
        print("SAVING")
        do {
            if(try managedObjectContext.count(for: todosFetch) == 0)
            {
                
                
                var index = 0
                for item in items.list{
                    print(item.text)
                    let entity = NSEntityDescription.entity(forEntityName: "ToDo", in: managedObjectContext)
                    let todo = NSManagedObject(entity: entity!, insertInto: managedObjectContext) as! ToDo
                    todo.setValue(item.text, forKey: "text")
                    todo.setValue(index, forKey: "index")
                    index += 1
                }
                do {
                    try managedObjectContext.save()
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
            }
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        
    }
    

}
