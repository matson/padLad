//
//  CategoryViewController.swift
//  padLad
//
//  Created by Tracy Adams on 6/19/23.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {
    
    //make a new realm instance:
    let realm = try! Realm()
    
    //category array
    var categories: Results<Category>?
    
    //CoreData:
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
        
    }
    
    //MARK: -- TableView Datasource Methods
    
    //number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //number of items
        return categories?.count ?? 1
    }
    
    //which tableView cell will show?
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        //comes from superclass. 
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text  = category.name
            guard let categoryColor = UIColor(hexString: category.color) else {fatalError()}
            
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }

        //change colors of cell
        //cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].color ?? "1D9BF6" )
        
        
        return cell
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        //alerts
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default){(action) in
            
            //what will happen once the user clicks the add item button
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
            
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: -- TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //need segue
        performSegue(withIdentifier: "goToItems", sender: self)
        
        
    
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PadLadViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
            
        }
    }
    
    //MARK: -- Data Manipulation Methods
    
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories(){
        //let request : NSFetchRequest<Category> = Category.fetchRequest()
       
         categories = realm.objects(Category.self)
        
        //CoreData:
        //        do{
        //            categories = try context.fetch(request)
        //            print("loaded")
        //        } catch {
        //            print("error fetching data from context \(error)")
        //        }
        
        tableView.reloadData()
        
    }
    
    //MARK: -- Delete Data from Swipe
    //Category updateModel version 
    override func updateModel(at indexPath: IndexPath) {
        //if the category is present and exists..
                if let categoryDeletion = self.categories?[indexPath.row]{
                    do {
                        try self.realm.write {
                            self.realm.delete(categoryDeletion)
                        }
                    }catch{
                        print("Error deleting category, \(error)")
                    }

                }
    }
    
    
    
    
    
}


