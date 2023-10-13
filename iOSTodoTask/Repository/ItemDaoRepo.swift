//
//  ItemDaoRepo.swift
//  iOSTodoTask
//
//  Created by Murat on 13.10.2023.
//

import Foundation
import RxSwift


class ItemDaoRepo{
    
    var itemList = BehaviorSubject<[ItemModel]>(value: [ItemModel]())

    let db : FMDatabase?
    
    init() {
        
        let target = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        let dbURL = URL(fileURLWithPath: target).appendingPathComponent("todo.sqlite")
        
        db = FMDatabase(path: dbURL.path)
    }
    
    
    func getItems(categoryID:Int){

        db?.open()
        
        var items = [ItemModel]()
        
        do{
            let result = try db!.executeQuery("SELECT * FROM Item WHERE categoryID = ?", values: [categoryID])
            
            while result.next(){
                
                let item = ItemModel(id: Int(result.string(forColumn: "id"))!, itemName: result.string(forColumn: "itemName")!,categoryID: Int(result.string(forColumn: "categoryID")))
                
                items.append(item)
            }
            
            itemList.onNext(items)
            
        }catch{
            print(error.localizedDescription)
        }
        db?.close()
    }
    
    func addItem(name:String,categoryID:Int,completion:@escaping (Error?)->Void){
        db?.open()
        
        do{
            try db!.executeUpdate("INSERT INTO Item (itemName,categoryID) VALUES (?,?)", values: [name,categoryID])
            completion(nil)
        }catch{
            completion(error)
        }
        db?.close()
    }
    
    func deleteItem(id:Int){
        
        db?.open()
        
        do{
            try db!.executeUpdate("DELETE FROM Item WHERE id = ?", values: [id])
        }catch{
            print("DEBUG ERROR WHEN DELETE")
        }
        
        db?.close()
    }
    
}

