//
//  ItemViewModel.swift
//  iOSTodoTask
//
//  Created by Murat on 13.10.2023.
//

import Foundation
import RxSwift


class ItemViewModel{
    
    var itemRepository = ItemDaoRepo()
    
    var itemList = BehaviorSubject<[ItemModel]>(value: [ItemModel]())
    
    init(categoryID:Int) {
        copyDB()
        itemList = itemRepository.itemList
        getItems(categoryID: categoryID)
    }
    
    
    func addItemToItems(name:String,categoryID:Int,completion:@escaping (Error?)->Void){
        
        itemRepository.addItem(name: name,categoryID: categoryID,completion: completion)
    }
    
    func getItems(categoryID:Int){
        itemRepository.getItems(categoryID: categoryID)
    }
    
    func deleteItem(id:Int){
        itemRepository.deleteItem(id: id)
    }
    
    
    func copyDB(){
            let bundlePath = Bundle.main.path(forResource: "todo", ofType: ".sqlite")
            let target = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let copyPlace = URL(fileURLWithPath: target).appendingPathComponent("todo.sqlite")
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: copyPlace.path){
                print("Database already exists")
            }else{
                do{
                    try fileManager.copyItem(atPath: bundlePath!, toPath: copyPlace.path)
                }catch{
                    print("@DEBUG Error FILE MANAGER")
                }
        }
    }
}

