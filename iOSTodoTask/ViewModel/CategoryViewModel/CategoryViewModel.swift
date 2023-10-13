//
//  CategoryViewModel.swift
//  iOSTodoTask
//
//  Created by Murat on 13.10.2023.
//

import Foundation
import RxSwift


class CategoryViewModel{
    
    var categoryRepository = CategoryDaoRepo()
    
    var categoryList = BehaviorSubject<[CategoryModel]>(value: [CategoryModel]())
    
    init() {
        copyDB()
        categoryList = categoryRepository.categoriesList
        getCategories()
    }
    
    
    func addCategoryToCategories(name:String,completion:@escaping (Error?)->Void){
        
        categoryRepository.addCategory(name: name, completion: completion)
    }
    
    func getCategories(){
        categoryRepository.getCategories()
    }
    
    func deleteCategory(id:Int){
        categoryRepository.deleteCategory(id: id)
    }
    
    func searchCategory(text:String){
        categoryRepository.searchCategory(text: text)
        categoryList = categoryRepository.categoriesList
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
