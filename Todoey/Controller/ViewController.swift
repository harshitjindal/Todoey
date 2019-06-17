//
//  ViewController.swift
//  Todoey
//
//  Created by Harshit Jindal on 10/06/19.
//  Copyright © 2019 Harshit Jindal. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    var itemArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        print(dataFilePath)
        
        let newItem1 = Item()
        newItem1.title = "Find Piggy"
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "Wash Tuffy"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Save the World"
        itemArray.append(newItem3)
        
        let newItem4 = Item()
        newItem4.title = "Kill Demogorgons"
        itemArray.append(newItem4)
        
        loadData()
        
//        if let items = defaults.array(forKey: "ToDoList") as? [String] {
//            itemArray = items
//        }
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
            let newItem = Item()
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
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadData() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

