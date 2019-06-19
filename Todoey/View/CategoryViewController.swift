//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Harshit Jindal on 19/06/19.
//  Copyright © 2019 Harshit Jindal. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Todoey Item", message: "Please Enter Category Name", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Category Name"
            textField = alertTextField
        }
        
        let addAction = UIAlertAction(title: "Done", style: .default) { (addAction) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            self.saveData()
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    // MARK: - Table view data source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        categoryCell.textLabel?.text = categoryArray[indexPath.row].name
        categoryCell.accessoryType = .disclosureIndicator
        return categoryCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Table view data update methods
    
    
    
    // MARK: - Table view delegate methods
    
    func saveData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error Fetching from Persistent Container: \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
}

extension CategoryViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            let request:NSFetchRequest<Category> = Category.fetchRequest()
            request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            loadData(with: request)
        }
    }
}
