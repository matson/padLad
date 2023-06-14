//
//  ViewController.swift
//  padLad
//
//  Created by Tracy Adams on 6/14/23.
//

import UIKit

class PadLadViewController: UITableViewController{
    
    //all TableView things are handled using this specific class/protocol
    
   var itemArray = ["clean kitchen", "find a man", "kiss a boy"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //NavBar SetUp:
        let newNavBarAppearance = UINavigationBarAppearance()
         newNavBarAppearance.configureWithTransparentBackground()
    
        // Navigation bar's background color
        newNavBarAppearance.backgroundColor = UIColor(red: 73/255, green: 120/255, blue: 210/255, alpha: 1.0)
        
        // Navigation bar's title foreground color
        newNavBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        // Apply the appearance to different styles:
        navigationController?.navigationBar.scrollEdgeAppearance = newNavBarAppearance
        navigationController?.navigationBar.compactAppearance = newNavBarAppearance
        navigationController?.navigationBar.standardAppearance = newNavBarAppearance
        if #available(iOS 15.0, *) {
            navigationController?.navigationBar.compactScrollEdgeAppearance = newNavBarAppearance
        }
        
    }
    
    //MARK: - Tableview Datasource Methods.
    
    //number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //number of items
        return itemArray.count
    }
    
    //which tableView cell will show?
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PadLadCell", for: indexPath)
        cell.textLabel?.text  = itemArray[indexPath.row]
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            //        let cell = itemArray[indexPath.row]
        
        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        //goes back to being white.
        tableView.deselectRow(at: indexPath, animated: true)
        
       
    }
    
    //MARK: Add Button
    
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //alerts
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default){(action) in
            
            //what will happen once the user clicks the add item button
            self.itemArray.append(textField.text!)
            
            //this is needed to show the new data. 
            self.tableView.reloadData()
            
        }
        //show textfield
        alert.addTextField {(alertTextField) in
            alertTextField.placeholder = "Create new item here"
            textField = alertTextField
            
        }
        //show action
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    


}

