//
//  ViewController.swift
//  Todoey
//
//  Created by Harshit Jindal on 10/06/19.
//  Copyright © 2019 Harshit Jindal. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = item.status ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemArray[indexPath.row]
        item.status = !(item.status)
        saveData()
        tableView.deselectRow(at: indexPath, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            tableView.reloadData()
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Todoey Item", message: "Please enter the item", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "What do you want to do?"
            textField = alertTextField
        }
        
        let addAction = UIAlertAction(title: "Done", style: .default) { (addAction) in
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            //            self.defaults.set(self.itemArray, forKey: "ToDoList")
            self.saveData()
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func saveData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
    
    func loadData() {
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error Fetching from Persistent Container\(error.localizedDescription)")
        }
    }
}

