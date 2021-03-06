//
//  CardService.swift
//  yugioh
//
//  Created by Aaron on 26/10/2016.
//  Copyright © 2016 sightcorner. All rights reserved.
//

import Foundation

import UIKit
import CoreData



class CardService {
    
    
    private let appDelegate: AppDelegate!
    private let managedContex: NSManagedObjectContext!
    private let entity: NSEntityDescription
    private let entityName: String = "CardPO"
    private let fetchRequest: NSFetchRequest<NSManagedObject>!
    
    init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContex = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContex)!
        fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createAt", ascending: false)]
    }
    
    
    func list() -> [String] {
        var result = [String]()
        do {
            let r = try managedContex.fetch(fetchRequest)
            
            
            for i in 0 ..< r.count {
                result.append(r[i].value(forKey: "id") as! String)
            }
        } catch {
            print("error: list")
        }
        
        return result
        
    }
    
    
    
    func delete(id: String) {
        do {
            let result = try managedContex.fetch(fetchRequest)
            for i in 0 ..< result.count {
                if id == (result[i].value(forKey: "id") as! String) {
                    managedContex.delete(result[i])
                }
            }
            
            try managedContex.save()
            
        } catch {
            print("error: delete")
        }
    }
    
    func isExist(id: String) -> Bool {
        var flag = false
        do {
            let result = try managedContex.fetch(fetchRequest)
            for i in 0 ..< result.count {
                if id == (result[i].value(forKey: "id") as! String) {
                    flag = true
                }
            }
        } catch {
            print("error: isExist")
        }
        
        return flag
        
    }
    
    
    func save(id: String) {
        
        if isExist(id: id) {
            return
        }
        
        let card = CardPO(entity: entity, insertInto: managedContex)
        card.id = id
        card.createAt = Date()
        
        do {
            try managedContex.save()
        } catch {
            print("error: save")
        }
    }
    
    
}
