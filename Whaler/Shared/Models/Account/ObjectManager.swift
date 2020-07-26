//
//  ObjectManager.swift
//  Whaler
//
//  Created by Zachary Rhodes on 7/25/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import UIKit

enum ObjectManager {
  static func save(_ object: ManagedObject) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: type(of: object).entityName)
    fetchRequest.predicate = NSPredicate(format: "id == %@", object.id)

    do {
      guard let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject] else { return }
      if results.count != 0 {
        let managedObject = results[0]
        object.setProperties(in: managedObject)
      } else {
        let entity = NSEntityDescription.entity(forEntityName: type(of: object).entityName, in: managedContext)!
        let managedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        object.setProperties(in: managedObject)
      }
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }
  
  static func retrieveAll<T: ManagedObject>(ofType type: T.Type) -> [T] {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: T.entityName)
    
    do {
      return try managedContext.fetch(fetchRequest).map(T.init)
    } catch let error as NSError {
      print("Could not retrieve objects. \(error), \(error.userInfo)")
      return []
    }
  }
  
  static func deleteAll<T: ManagedObject>(ofType type: T.Type) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    do {
      try managedContext.execute(deleteRequest)
      try managedContext.save()
    } catch let error as NSError {
      print ("Could not delete objects. \(error), \(error.userInfo)")
    }
  }
}
