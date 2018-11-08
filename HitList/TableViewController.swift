//
//  TableViewController.swift
//  HitList
//
//  Created by Ryan Phan on 11/8/18.
//  Copyright © 2018 Ryan Phan. All rights reserved.
//

import UIKit
import CoreData
class TableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    let context = AppDelegate.viewContext
    let container = AppDelegate.persistenceContainer
    var fetchedResultController:NSFetchedResultsController<Person>?
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveFromDB()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultController?.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let sections = fetchedResultController?.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    func retrieveFromDB () {
        let request:NSFetchRequest<Person> = Person.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchedResultController = NSFetchedResultsController<Person>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try? fetchedResultController?.performFetch()
        tableView.reloadData()
        fetchedResultController?.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        if let person = fetchedResultController?.object(at: indexPath) {
            cell.textLabel?.text = person.name
        }
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
  

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if let person = fetchedResultController?.object(at: indexPath) {
                context.delete(person)
                appDelegate?.saveContext()
            }
            
        }

        retrieveFromDB()
    }
    



    
    @IBAction func add(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: UIAlertController.Style.alert)
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default) { [unowned self] (action: UIAlertAction)  in
            let textField = alert.textFields?.first
            print(textField?.text)
            if let textField = textField, let name = textField.text{
                self.saveName(name)
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField(configurationHandler: nil)
        present(alert, animated: true, completion: nil)
    }
    func saveName(_ name: String) {
        let person = Person(context: context, name: name)
        do {
            try context.save()
        }catch {
            print("Saving error")
        }
        printDB()
        retrieveFromDB()
    }
    func printDB() {
        context.perform {
            let request: NSFetchRequest<Person> = Person.fetchRequest()
            if let result = try? self.context.fetch(request) {
                print("Person count:\(result.count)")
                
                for person in result {
                    print("Name: \(person.name)")
                }
            }
        }
    }

}
