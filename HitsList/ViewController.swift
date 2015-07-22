//
//  ViewController.swift
//  HitsList
//
//  Created by vichhai on 5/25/15.
//  Copyright (c) 2015 kan vichhai. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController , UITableViewDataSource{
    
    @IBOutlet weak var myHitListTableView: UITableView!
    
//    var names = [String]()
    var people = [NSManagedObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Top Hit List"
        myHitListTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 1
        let appDelegte = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegte.managedObjectContext!
        
        // 2
        let fetchRequest = NSFetchRequest(entityName: "Person") // fetch to enitity Person
        
        //3
        var err : NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &err) as? [NSManagedObject]
        
        if let result = fetchedResults {
            people = result
            println(people)
        } else {
            println("Count not fetch \(err), \(err!.userInfo)")
        }
    }
    
    // =-----> Tableview datasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        let person = people [indexPath.row]
        
        cell.textLabel!.text = person.valueForKey("name") as? String // get name from core data
        
        return cell
    }
    
    @IBAction func addNameAction(sender: AnyObject) {
        
        var alert = UIAlertController(title: "New name",
            message: "Add a new name",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default) { (action: UIAlertAction!) -> Void in
                
                let textField = alert.textFields![0] as! UITextField
                self.saveName(textField.text)
                self.myHitListTableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
        
    }
    
    // save data into core data
    func saveName(name : String) {
        // 1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        // 2
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedContext)
        let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext) // create manageobject and insert into managedContext
        
        // 3
        person.setValue(name, forKey: "name")
        
        // 4
        var error : NSError?
        if !managedContext.save(&error){
            println("Could not save \(error)")
        }
        
        // 5
        people.append(person)
    }
    
    
    
    
    

}

