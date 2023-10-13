//
//  CategoryTableViewController.swift
//  iOSTodoTask
//
//  Created by Murat on 13.10.2023.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    
    var viewModel = CategoryViewModel()
    
    var categoryList = [CategoryModel](){
        didSet{
            self.tableView.reloadData()
        }
    }
    
    var indexPath : IndexPath?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeList()
        
        searchBar.delegate = self
        
        tableView.keyboardDismissMode = .interactive
    
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categoryList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
        
        cell.categoryLabel.text = categoryList[indexPath.row].categoryName

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.indexPath = indexPath
        
        performSegue(withIdentifier: "toItemVC", sender: nil)
        
    }
    func observeList(){
        
        _ = viewModel.categoryList.subscribe(onNext: { list in
            
            self.categoryList = list
            self.tableView.reloadData()
        })
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
               textField.placeholder = "Enter Category Name"
           }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
               let firstTextField = alertController.textFields![0] as UITextField

            guard let text = firstTextField.text else{return}
            
            self.viewModel.addCategoryToCategories(name: text) { error in
                
                if error != nil{
                    print("ERROR")
                }
                
                self.viewModel.getCategories()
            }
            
           })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
               (action : UIAlertAction!) -> Void in })
       
           alertController.addAction(saveAction)
           alertController.addAction(cancelAction)
           
        self.present(alertController, animated: true,completion: nil)
        
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.viewModel.categoryRepository.deleteCategory(id: categoryList[indexPath.row].id!)
            self.viewModel.getCategories()
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toItemVC"{
                
            let vc = segue.destination as! ItemTableViewController
            
            guard let index = self.indexPath else {return}
            
            vc.categoryID = categoryList[index.row].id
        }
    }
}

extension CategoryTableViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        viewModel.searchCategory(text: searchText.lowercased())
        
    }
}
