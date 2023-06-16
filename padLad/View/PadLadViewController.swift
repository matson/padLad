//
//  ViewController.swift
//  padLad
//
//  Created by Tracy Adams on 6/14/23.
//

import UIKit
import CoreData

class PadLadViewController: UITableViewController{
    
    //all TableView things are handled using this specific class/protocol
    
   var itemArray = [Item]()
    
   //CoreData context
   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        loadItems()
        

//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//        let newItem2 = Item()
//        newItem2.title = "Buy Eggos"
//        itemArray.append(newItem2)
        
        //DEFAULTS: setting the defaults to the array
//        if let items  = defaults.array(forKey: "PadLadArray") as? [Item] {
//            itemArray = items
//
//        }
        
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
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text  = item.title
        
        //Ternary Operator:
        //checkmark logic
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            //        let cell = itemArray[indexPath.row]
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
       
        //forced tableview to call datasource methods again
        //tableView.reloadData()
        
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
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            
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
    
    
    //CREATE
    func saveItems(){
        do{
            try context.save()
        }catch{
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    //READ
    func loadItems(){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
            itemArray = try context.fetch(request)
        } catch {
            print("error fetching data from context \(error)")
        }
        
    }
}

