//
//  AppDelegate.swift
//  Whaler
//
//  Created by Zachary Rhodes on 6/21/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import UIKit
import SwiftyBeaver

let clientId = UUID().uuidString

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    UITableView.appearance().backgroundColor = .white
    UITableViewCell.appearance().backgroundColor = .white
    UITableViewHeaderFooterView.appearance().tintColor = .white
    UITableView.appearance().separatorStyle = .none
//    if let directoryLocation = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
//      print("Documents Directory: \(directoryLocation)Application Support")
//    }
//    resetAllRecords(of: "AccountEntity")
//    resetAllRecords(of: "ContactEntity")
    configureSwiftyBeaverLogging()
    WebSocketManager.shared = WebSocketManager()
    return true
  }
  
  private func configureSwiftyBeaverLogging() {
    let format = "$DHH:mm:ss.SSS$d $C$L$c $M"
    
    let file = FileDestination()  //Should only log to file when debugging -- need to add that -- or maybe just remove..
    file.logFileURL = URL(fileURLWithPath: "./WhalerLogs.beaver")
    file.format = format
    SwiftyBeaver.addDestination(file)
    
    let platform = SBPlatformDestination(appID: "JXQ8RN",
                                         appSecret: "vaa2mnVbU2FscXvcv5bmuutxCKc3tjgV",
                                         encryptionKey: "91fezcmxcWusZdnsE2NyaSzsikLweCnv")
    platform.format = format
    SwiftyBeaver.addDestination(platform)
    
    let console = ConsoleDestination()
    console.format = format
    SwiftyBeaver.addDestination(console)
    
    Log.destinations.append(SwiftyBeaver.self)
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    self.saveContext()
  }

  // MARK: - Core Data stack

  // MARK: - Core Data Saving support

  func saveContext () {
      let context = persistentContainer.viewContext
      if context.hasChanges {
          do {
              try context.save()
          } catch {
              // Replace this implementation with code to handle the error appropriately.
              // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
              let nserror = error as NSError
              fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
          }
      }
  }

  func resetAllRecords(of entity: String) {
      let context = persistentContainer.viewContext
      let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
      let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
      do {
          try context.execute(deleteRequest)
          try context.save()
      }
      catch {
          print ("There was an error")
      }
  }
}

var persistentContainer: NSPersistentContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
    */
    let container = NSPersistentContainer(name: "Whaler")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             
            /*
             Typical reasons for an error here include:
             * The parent directory does not exist, cannot be created, or disallows writing.
             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
             * The device is out of space.
             * The store could not be migrated to the current model version.
             Check the error message to determine what the actual problem was.
             */
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    })
    return container
}()
