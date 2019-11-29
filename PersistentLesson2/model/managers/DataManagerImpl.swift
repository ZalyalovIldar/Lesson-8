//
//  DataManagerImpl.swift
//  PersistanceLesson1
//
//  Created by Enoxus on 20/11/2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import Foundation
import CoreData

class DataManagerImpl: DataManager {
    
    /// singleton instance
    public static let shared = DataManagerImpl()
    
    /// main database
    private var database: [PostDTO]
    
    // core data persistent container
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PersistentLesson2")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    /// view context
    private lazy var viewContext = persistentContainer.viewContext
    
    /// cached database initialization
    private init() {
        database = []
    }
    
    private func ensureDatabaseIsPresent() {
        if database.isEmpty {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Post.className)
            
            if let databaseData = try? viewContext.fetch(fetchRequest) as? [Post], !databaseData.isEmpty {
                
                for post in databaseData {
                    database.append(PostDTO(owner: post.owner, pic: post.pic, text: post.text, id: post.id))
                }
            }
            // populates database if it's empty. If there would be adding post functionality, this would be removed
            else {
                let randomTexts = ["sample text", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", "another sick text"]
                
                let user = User(context: viewContext)
                user.name = "sample text"
                user.desc = "desc"
                user.avi = "avi"
                
                for i in 1 ..< 10 {
                    let post = Post(context: viewContext)
                    post.owner = user
                    post.pic = "pic\(i)"
                    post.text = randomTexts.randomElement()!
                    post.id = UUID().uuidString
                    
                    user.addToPosts(post)
                    
                    database.append(PostDTO(owner: post.owner, pic: post.pic, text: post.text, id: post.id))
                }
                
                try? viewContext.save()
            }
        }
    }
    
    /// method that deletes passed post in the main thread synchronously
    /// - Parameter post: post that should be deleted
    func syncDelete(_ post: PostDTO) {
        
        ensureDatabaseIsPresent()
        
        database.removeAll(where: { $0.id == post.id })
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Post.className)
        fetchRequest.predicate = NSPredicate(format: "id = '\(post.id)'")
        
        if let posts = try? viewContext.fetch(fetchRequest) as? [Post] {
            
            guard let post = posts.first else { return }
            
            viewContext.delete(post)
            try? viewContext.save()
        }
    }
    
    /// method that deletes passed post asynchronously
    /// - Parameter post: post that should be deleted
    /// - Parameter completion: completion block that is being called after deleting the post, provides the updated list of posts
    func asyncDelete(_ post: PostDTO, completion: @escaping ([PostDTO]) -> Void) {
        
        ensureDatabaseIsPresent()
        
        let operationQueue = OperationQueue()
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let operation = BlockOperation { [weak self] in
                
                self?.database.removeAll(where: { $0.id == post.id })
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Post.className)
                fetchRequest.predicate = NSPredicate(format: "id = '\(post.id)'")
                
                if let posts = try? self?.viewContext.fetch(fetchRequest) as? [Post] {
                    
                    guard let post = posts.first else { return }
                    
                    self?.viewContext.delete(post)
                    try? self?.viewContext.save()
                }
                
                DispatchQueue.main.async { [weak self] in
                    
                    if let db = self?.database {
                        completion(db)
                    }
                }
            }
            
            operationQueue.addOperation(operation)
        }
    }
    
    /// method that returns particular post syncronously
    /// - Parameter index: index of the post in database
    func syncGet(by index: Int) -> PostDTO {
        
        ensureDatabaseIsPresent()
        
        return database[index]
    }
    
    /// method that returns particular post asyncronously
    /// - Parameter index: index of the post in database
    /// - Parameter completion: completion block that is being called after retrieving the post, provides this post as an input parameter
    func asyncGet(by index: Int, completion: @escaping (PostDTO) -> Void) {
        
        ensureDatabaseIsPresent()
        
        let operationQueue = OperationQueue()
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let operation = BlockOperation { [weak self] in
                
                if let post = self?.database[index] {
                    
                    DispatchQueue.main.async {
                        completion(post)
                    }
                }
            }
            
            operationQueue.addOperation(operation)
        }
    }
    
    /// method that synchronously returns whole database
    func syncGetAll() -> [PostDTO] {
        
        ensureDatabaseIsPresent()
        
        return database
    }
    
    /// method that asynchronously returns whole database
    /// - Parameter completion: completion block that is being called after retrieving the database, provides its posts as an input parameter
    func asyncGetAll(completion: @escaping ([PostDTO]) -> Void) {
        
        ensureDatabaseIsPresent()
        
        let operationQueue = OperationQueue()
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let operation = BlockOperation { [weak self] in
                
                if let database = self?.database {
                    
                    DispatchQueue.main.async {
                        completion(database)
                    }
                }
            }
            
            operationQueue.addOperation(operation)
        }
    }
    
    /// method that asyncronously filters the database and returns posts that meet the criteria
    /// - Parameter query: string that should be contained in post's text
    /// - Parameter completion: completion block that is being called after filtering the database, provides filtered list as an input parameter
    func asyncSearch(by query: String, completion: @escaping ([PostDTO]) -> Void) {
        
        ensureDatabaseIsPresent()
        
        let operationQueue = OperationQueue()
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let operation = BlockOperation { [weak self] in
                
                if let searchResults = self?.database.filter({ $0.text.lowercased().contains(query.lowercased()) }) {
                    
                    DispatchQueue.main.async {
                        completion(searchResults)
                    }
                }
                else {
                    
                    DispatchQueue.main.async {
                        completion([])
                    }
                }
            }
            
            operationQueue.addOperation(operation)
        }
    }
    
    /// method that syncronously appends given post to database
    /// - Parameter post: the post to append
    func syncSave(_ post: PostDTO) {
        
        ensureDatabaseIsPresent()
    
        let postModel = Post(context: viewContext)
        postModel.id = UUID().uuidString
        postModel.owner = post.owner
        postModel.text = post.text
        postModel.pic = post.pic
        
        database.append(post)
        try? viewContext.save()
    }
    
    /// method that asyncronously appends given post to database
    /// - Parameter post: the post to append
    /// - Parameter completion: completion block that is being called after appending the post to database, provides updated list as an input parameter
    func asyncSave(_ post: PostDTO, completion: @escaping ([PostDTO]) -> Void) {
        
        ensureDatabaseIsPresent()
        
        let operationQueue = OperationQueue()
        DispatchQueue.global(qos: .userInteractive).async {
            
            let operation = BlockOperation { [weak self] in
                self?.database.append(post)
                
                let postModel = Post(context: self!.viewContext)
                postModel.id = UUID().uuidString
                postModel.owner = post.owner
                postModel.text = post.text
                postModel.pic = post.pic
                
                try? self?.viewContext.save()
            }
            
            DispatchQueue.main.async { [weak self] in
                
                if let db = self?.database {
                    completion(db)
                }
            }
            
            operationQueue.addOperation(operation)
        }
    }
}

