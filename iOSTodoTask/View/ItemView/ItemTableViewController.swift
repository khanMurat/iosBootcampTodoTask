//
//  ItemTableViewController.swift
//  iOSTodoTask
//
//  Created by Murat on 13.10.2023.
//

import UIKit

class ItemTableViewController: UITableViewController {

    var categoryID:Int?
    
    var viewModel : ItemViewModel!
    
    var itemList = [ItemModel]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ItemViewModel(categoryID: categoryID!)
        
        observeList()

    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return itemList.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
        
        cell.itemNameLabel.text = itemList[indexPath.row].itemName ?? ""
        
        return cell
    }
    
    func observeList(){
        
        _ = viewModel.itemList.subscribe(onNext: { list in
            
            self.itemList = list
            self.tableView.reloadData()
        })
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
               textField.placeholder = "Enter Item Name"
           }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
               let firstTextField = alertController.textFields![0] as UITextField

            guard let text = firstTextField.text else{return}
            
            self.viewModel.addItemToItems(name: text,categoryID: self.categoryID!) { error in
                
                if error != nil{
                    print("Error")
                }
                self.viewModel.getItems(categoryID: self.categoryID!)
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
            self.viewModel.deleteItem(id: itemList[indexPath.row].id!)
            self.viewModel.getItems(categoryID: categoryID!)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
