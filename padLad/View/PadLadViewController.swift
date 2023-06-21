//
//  ViewController.swift
//  padLad
//
//  Created by Tracy Adams on 6/14/23.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework

class PadLadViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var padItems: Results<Item>?
    
   let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
   //CoreData context
   //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.

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
        //let newNavBarAppearance = UINavigationBarAppearance()
         //newNavBarAppearance.configureWithTransparentBackground()
       
        // Navigation bar's background color
        //newNavBarAppearance.backgroundColor = UIColor(red: 94/255, green: 187/255, blue: 230/255, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let colorHex = selectedCategory?.color {
            
            title = selectedCategory!.name
            
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
            if let navBarColor = UIColor(hexString: colorHex) {
                navBar.barTintColor = UIColor(hexString: colorHex)
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor,  returnFlat: true)]
                searchBar.barTintColor = UIColor(hexString: colorHex)
            }
            
           
        }
    }
    
    //MARK: - Tableview Datasource Methods.
    
    //number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //number of items
        return padItems?.count ?? 1
    }
    
    //which tableView cell will show?
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = padItems?[indexPath.row]{
           
            cell.textLabel?.text  = item.title
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(padItems!.count)){
                
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            //Ternary Operator:
            //checkmark logic
            cell.accessoryType = item.done == true ? .checkmark : .none
            
            
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = padItems?[indexPath.row] {
            do {
                try realm.write {
                   item.done = !item.done
                   //realm.delete(item)
                    
                }
            }catch {
                print("error saving done status, \(error)")
            }
        }
        tableView.reloadData()
        
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
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error saving items, \(error)")
                }
            }
        
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
    
    //MARK: Model Manipulation Methods
    //CREATE
    //    func saveItems(){
    //        do{
    //            try context.save()
    //            print("saved items")
    //        }catch{
    //            print("Error saving context \(error)")
    //        }
    //
    //        self.tableView.reloadData()
    //    }
    
    //READ
    //This method has a default value
    func loadItems() {
        

        padItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        //CoreData:
        //        //overrides the predicate
        //        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        //
        //        request.predicate = predicate
        //
        //        do{
        //            itemArray = try context.fetch(request)
        //            print("loaded")
        //        } catch {
        //            print("error fetching data from context \(error)")
        //        }
        
        tableView.reloadData()
        
        
    }
    
    //MARK: -- Delete Data from Swipe
    //Items updateModel version
    override func updateModel(at indexPath: IndexPath) {
        //if the category is present and exists..
                if let itemsDeletion = self.padItems?[indexPath.row]{
                    do {
                        try self.realm.write {
                            self.realm.delete(itemsDeletion)
                        }
                    }catch{
                        print("Error deleting category, \(error)")
                    }

                }
    }
    
}

//MARK: SearchBar
extension PadLadViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        padItems = padItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
       
        //CoreData:
        //query database
        //        let request: NSFetchRequest<Item> = Item.fetchRequest()
        //
        //        let predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
        //
        //        request.predicate = predicate
        //
        //        let sortDescriptr = NSSortDescriptor(key: "title", ascending: true)
        //        request.sortDescriptors = [sortDescriptr]
        //
        //        loadItems(with: request)
        
        
    }
    
    //to clear up the history in search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
           
        }
    }
    
}
