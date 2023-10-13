//
//  CategoryDaoRepo.swift
//  iOSTodoTask
//
//  Created by Murat on 13.10.2023.
//

import Foundation
import RxSwift


class CategoryDaoRepo{
    
    var categoriesList = BehaviorSubject<[CategoryModel]>(value: [CategoryModel]())

    let db : FMDatabase?
    
    init() {
        
        let target = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        let dbURL = URL(fileURLWithPath: target).appendingPathComponent("todo.sqlite")
        
        db = FMDatabase(path: dbURL.path)
    }
    
    
    func getCategories(){

        db?.open()
        
        var categories = [CategoryModel]()
        
        do{
            var result = try db!.executeQuery("SELECT * FROM Category", values: nil)
            
            while result.next(){
                
                let category = CategoryModel(id: Int(result.string(forColumn: "id"))!, categoryName: result.string(forColumn: "categoryName")!)
                
                categories.append(category)
            }
            
            categoriesList.onNext(categories)
            
        }catch{
            print(error.localizedDescription)
        }
        db?.close()
    }
    
    func addCategory(name:String,completion:@escaping (Error?)->Void){
        db?.open()
        
        do{
            try db!.executeUpdate("INSERT INTO Category (categoryName) VALUES (?)", values: [name])
            completion(nil)
        }catch{
            completion(error)
        }
        db?.close()
    }
    
    func deleteCategory(id:Int){
        
        db?.open()
        
        do{
            try db!.executeUpdate("DELETE FROM Category WHERE id = ?", values: [id])
        }catch{
            print("DEBUG ERROR WHEN DELETE")
        }
        
        db?.close()
    }
    
    func searchCategory(text:String){
        
        var categories = [CategoryModel]()
        
        db?.open()
        
        do{
            let result = try db!.executeQuery("SELECT * FROM Category WHERE categoryName like '%\(text)%'", values: nil)
            
            while result.next() {
                
                let category = CategoryModel(id: Int(result.string(forColumn: "id")), categoryName: result.string(forColumn: "categoryName"))
                
                categories.append(category)
            }
        }catch{
            print("DEBUG ERROR WHEN SEARCH CATEGORY")
        }
       
        categoriesList.onNext(categories)
    }
    
}
