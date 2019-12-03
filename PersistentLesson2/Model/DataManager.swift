//
//  DataManager.swift
//  BlocksSwift
//
//  Created by Евгений on 25.10.2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import Foundation
import CoreData

class DataManager: DataManagerProtocol {
    
    //Singleton of Data Manager
    public static let dataManagerSingleton = DataManager()
    
    //Keys for UserDefaults
    fileprivate enum UserDefaultsKeys {
        //Main posts array key in UserDefaults
        static let postsArrayKey = "postsArray"
    }
    
    //Array of posts
    private var posts: [PostStructure] = []
    
    //JSON Decoder for UserDefaults
    private let decoder = JSONDecoder()
    
    //JSON Encoder for UserDefaults
    private let encoder = JSONEncoder()
    
    //Constant for using UserDefaults
    private let userDefaults = UserDefaults.standard;
    
    //ViewContext for using CoreData
    private lazy var viewContext = persistentContainer.viewContext
    
    //DataManager initiallizer for getting posts
    init() {
        posts = getPosts()
    }
    
    //PersistentContainer for using CoreData
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PersistentLesson2")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Saving methods
    
    /// Saves a post synchronously
    /// - Parameter post: Post, which need to save
    func syncSave(_ post: PostStructure) -> [PostStructure] {
        
        let newPost = Post(context: viewContext)
        
        newPost.image = post.image
        newPost.text = post.text
        newPost.date = post.date
        newPost.id = UUID().uuidString
        
        posts.append(post)
        try? viewContext.save()
        return posts
    }
    
    
    /// Saves a post not synchronously
    /// - Parameter post: Post, which need to save
    /// - Parameter completion: Completion block
    func asyncSave(_ post: PostStructure, completion: @escaping ([PostStructure]) -> Void) {
        
        let operationQueue = OperationQueue()
        
        DispatchQueue.global().async {
            
            let appendingOperation = BlockOperation { [weak self] in
                
                let newPost = Post(context: self!.viewContext)
                newPost.image = post.image
                newPost.text = post.text
                newPost.date = post.date
                newPost.id = post.id
                
                self?.posts.append(post)
                try? self!.viewContext.save()
            }
            
            DispatchQueue.main.async { [weak self] in
                
                if let posts = self?.posts {
                    completion(posts)
                }
            }
            
            operationQueue.addOperation(appendingOperation)
        }
    }
    
    // MARK: - Getting methods
    
    
    /// Synchronously get posts array
    func syncGet() -> [PostStructure] {
        return posts
    }
    
    
    /// Not synchronously get posts array
    /// - Parameter completion: Completion block
    func asyncGet(completion: @escaping ([PostStructure]) -> Void) {
        
        let operationQueue = OperationQueue()
        
        DispatchQueue.global().async {
            
            let gettingOperation = BlockOperation { [weak self] in
                
                if let posts = self?.posts {
                    
                    completion(posts)
                }
            }
            
            operationQueue.addOperation(gettingOperation)
        }
    }
    
    // MARK: - Deleting methods
    
    /// Synchronously delete post
    /// - Parameter post: Post, which need to delete
    func syncDelete(_ post: PostStructure) -> [PostStructure] {
        
        posts.removeAll(where: {$0.id == post.id})
        
        let fetchRequest = NSFetchRequest<Post>()
        fetchRequest.predicate = NSPredicate(format: "id = '\(post.id)")
        
        if let posts = try? self.viewContext.fetch(fetchRequest), !posts.isEmpty {
            
            let post = posts.first
            viewContext.delete(post!)
            try? viewContext.save()
        }
        return posts
    }
    
    /// Not synchronously delete post
    /// - Parameter post: Post, which need to delete
    /// - Parameter completion: Completion block
    func asyncDelete(_ post: PostStructure, completion: @escaping ([PostStructure]) -> Void) {
        
        let operationQueue = OperationQueue()
        
        DispatchQueue.global().async {
            
            let deletingOperation = BlockOperation { [weak self] in
                
                self?.posts.removeAll(where: {$0.id == post.id})
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
                fetchRequest.predicate = NSPredicate(format: "id = '\(post.id)'")
                
                if let posts = try? self?.viewContext.fetch(fetchRequest), !posts.isEmpty {
                    
                    let post = posts.first
                    self?.viewContext.delete(post! as! NSManagedObject)
                    try? self?.viewContext.save()
                }
                
                DispatchQueue.main.async {
                    
                    if let posts = self?.posts {
                        completion(posts)
                    }
                }
            }
            
            operationQueue.addOperation(deletingOperation)
        }
    }
    
    // MARK: - Searching methods
    
    /// Synchronously search the post in posts array
    /// - Parameter searchQuery: Text, which need to search in post
    func syncSearch(_ searchQuery: String) -> [PostStructure] {
        
        let foundPosts = self.posts.filter( { $0.text.contains(searchQuery) } )
        return foundPosts
    }
    
    
    /// Not synchronously search the post in posts array
    /// - Parameter searchQuery: Text, which need to search in post
    /// - Parameter completion: Completion block
    func asyncSearch(_ searchQuery: String, completion: @escaping ([PostStructure]) -> Void) {
        
        let operationQueue = OperationQueue()
        
        DispatchQueue.global().async {
            
            let searchingOperation = BlockOperation { [weak self] in
                
                let foundPosts = self?.posts.filter( { $0.text.contains(searchQuery) } )
                
                DispatchQueue.main.async {
                    completion(foundPosts ?? [])
                }
            }
            
            operationQueue.addOperation(searchingOperation)
        }
    }
    
    //MARK: - Core Data
    
    /// Common core data saveContext function
    func saveContext () {
        
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    /// Getting posts from core data or create a new array of posts if there is no posts in core data
    func getPosts() -> [PostStructure] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
        if let posts = try? viewContext.fetch(fetchRequest) as? [Post], !posts.isEmpty {
            
            var newPostsArray: [PostStructure] = []
            
            for post in posts {
                let newPost = PostStructure(image: post.image!, text: post.text!, date: post.date!, id: post.id!)
                newPostsArray.append(newPost)
            }
            
            return newPostsArray
            
        } else {
            
            let images = ["picture1", "picture2", "picture3", "picture4", "picture5"]
            let texts = ["Hello. Yoda my name is. Yrsssss.", "Just do it!", "Национальное управление по аэронавтике и исследованию космического пространства — ведомство, относящееся к федеральному правительству США и подчиняющееся непосредственно Президенту США.", "Курлык", "YOU are the world-famous Mario!?!"]
            let dates = ["1 ноября 2019", "25 января 1964", "25 июля 1958", "1 января 2020", "13 сентября 1985"]
            var newPostsArray = [PostStructure]()
            
            for i in 1...5 {
                
                let post = Post(context: viewContext)
                
                post.image = images[i-1]
                post.date = dates[i-1]
                post.text = texts[i-1]
                post.id = UUID().uuidString
                
                let newPost = PostStructure(image: images[i-1], text: texts[i-1], date: dates[i-1], id: post.id!)
                newPostsArray.append(newPost)
            }
            
            return newPostsArray
        }
    }
}
