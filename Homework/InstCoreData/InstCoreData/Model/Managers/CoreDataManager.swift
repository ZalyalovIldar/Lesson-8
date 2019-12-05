//
//  CoreDataManager.swift
//  InstCoreData
//
//  Created by Роман Шуркин on 05.12.2019.
//  Copyright © 2019 Роман Шуркин. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    lazy var viewContext: NSManagedObjectContext = persistentContainer.viewContext
    lazy var backgroundContext: NSManagedObjectContext = persistentContainer.newBackgroundContext()
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "InstCoreData")
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
    
    func getUser(name: String) -> User {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        if let users = try? viewContext.fetch(fetchRequest) as? [User], !users.isEmpty {
            return users.first!
        }
        else {
            
            let user = User(context: viewContext)
            
            user.id = UUID()
            user.nickname = name
            user.avatarImage = "ava"
            user.posts = NSSet(array: getAllPosts())
            
            do {
                try viewContext.save()
            } catch let error {
                print("Error: \(error)")
            }
            
            return user
        }
    }
    
    func getAllPosts() -> [Post] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
        
        if let posts = try? viewContext.fetch(fetchRequest) as? [Post], !posts.isEmpty {
            return posts
        }
        else {
            
            var newPosts: [Post] = []
            
            let user = getUser(name: "romash_only")
        
            let post1 = Post(context: viewContext)
            
            post1.id = UUID()
            post1.image = "post1"
            post1.text = "Hello"
            post1.user = user
            post1.date = Date()
            
            let post2 = Post(context: viewContext)
            
            post2.id = UUID()
            post2.image = "post2"
            post2.text = "Hai"
            post2.user = user
            post2.date = Date()
            
            let post3 = Post(context: viewContext)
            
            post3.id = UUID()
            post3.image = "post3"
            post3.text = "Good"
            post3.user = user
            post3.date = Date()
            
            let post4 = Post(context: viewContext)
            
            post4.id = UUID()
            post4.image = "post4"
            post4.text = "Very Bad"
            post4.user = user
            post4.date = Date()
            
            newPosts.append(post1)
            newPosts.append(post2)
            newPosts.append(post3)
            newPosts.append(post4)
            
            do {
                try viewContext.save()
            } catch let error {
                print("Error: \(error)")
            }
            
            return newPosts
        }
    }
    
    func removePost(id: UUID) {
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
               
        if let posts = try? viewContext.fetch(fetchRequest) as? [Post], !posts.isEmpty {
            
            viewContext.delete(posts.filter { $0.id == id }.first!)
            
            try? viewContext.save()
       }
    }
}
