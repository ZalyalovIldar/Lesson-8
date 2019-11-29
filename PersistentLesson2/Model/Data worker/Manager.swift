//
//  Manager.swift
//  Threads
//
//  Created by Amir on 08.11.2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import UIKit
import CoreData

class Manager: DataManager {
    
    //MARK: - Singleton
    static let shared = Manager()
    
    //MARK: - Properties
    private var posts: [Post] = []
    private var user: User!
    
    //MARK: - Initialization
    
    init() {
        
        posts = obtainPosts()
        user = obtainUser()
    }
    
    //MARK: - Save
    func syncSavePost(post: Post) {
        
        let postModel = Post(context: viewContext)
        
        postModel.image = post.image
        postModel.imageDescription = post.imageDescription
        postModel.likes = post.likes
        postModel.postId = UUID().uuidString
        
        posts.append(postModel)
        
        try? viewContext.save()
    }
    
    func asyncSavePost(post: Post, completion: @escaping ([Post]) -> Void) {
        
        let operationQueue = OperationQueue()
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let operation = BlockOperation { [weak self] in
                
                let postModel = Post(context: self!.viewContext)
                
                postModel.image = post.image
                postModel.imageDescription = post.imageDescription
                postModel.time = post.time
                postModel.likes = post.likes
                postModel.postId = UUID().uuidString
                
                self?.posts.append(postModel)
                
                DispatchQueue.main.async {
                    guard let postsArray = self?.obtainPosts() else { return }
                    
                    completion(postsArray)
                }
            }
            operationQueue.addOperation(operation)
        }
    }
    
    //MARK: - Search
    func syncSearchPost(for searchString: String) -> [Post] {
        
        let searchedPosts = posts.filter { (post) -> Bool in
            
            if let postText = post.imageDescription {
                return postText.contains(searchString)
            }
            return false
        }
        return searchedPosts
    }
    
    func asyncSearchPost(for searchString: String, completion: @escaping (([Post]) -> Void)) {
        
        let operationQueue = OperationQueue()
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let operation = BlockOperation { [weak self] in
                
                let filteredPosts = self?.obtainPosts().filter({ post -> Bool in
                    return (post.imageDescription?.lowercased().contains(searchString.lowercased()))!
                })
                
                guard let filteredPostsUnwrapped = filteredPosts else { return }
                completion(filteredPostsUnwrapped)
            }
            operationQueue.addOperation(operation)
        }
    }
    
    //MARK: - Delete
    func syncDeletePost(with postID: String) {
        
        posts.removeAll(where: { $0.postId == postID })
        
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "postId == %@", postID)
        
        if let posts = try? viewContext.fetch(fetchRequest) {
            
            guard let post = posts.first else { return }
            
            viewContext.delete(post)
            try? viewContext.save()
        }        
    }
    
    func asyncDeletePost(with post: Post, completion: @escaping ([Post]) -> Void) {
        
        let operationQueue = OperationQueue()
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let operation = BlockOperation { [weak self] in
                
                self?.removePost(with: post.postId!)
                
                DispatchQueue.main.async { [weak self] in
                    
                    guard let postsArray = self?.obtainPosts() else { return }
                    
                    completion(postsArray)
                }
            }
            operationQueue.addOperation(operation)
        }
    }
    
    //MARK: - Get
    func syncGetPosts() -> [Post] {
        return self.posts
    }
    
    func asyncGetPosts(completion: @escaping (([Post]) -> Void)) {
        
        let operationQueue = OperationQueue()
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let operation = BlockOperation { [weak self] in
                
                guard let postsArray = self?.obtainPosts() else { return }
                
                completion(postsArray)
            }
            operationQueue.addOperation(operation)
        }
    }
    
    func asyncGetUser(completion: @escaping (User) -> Void) {
        
        let operationQueue = OperationQueue()
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let operation = BlockOperation { [weak self] in
                
                guard let user = self?.obtainUser() else { return }
                
                completion(user)
            }
            operationQueue.addOperation(operation)
        }
    }
    
    //MARK: - CoreData Stack
    lazy var viewContext: NSManagedObjectContext = persistentContainer.viewContext
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PersistentLesson2")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - CRUD
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
    
    func obtainUser() -> User {
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        if let users = try? viewContext.fetch(fetchRequest), !users.isEmpty {
            
            return users.first!
        }
        else {
            
            let user = User(context: viewContext)
            
            user.name = "Amir"
            user.nickName = "omeeer78"
            user.profileImage = "profileImage"
            
            do {
                try viewContext.save()
            } catch let error {
                print("Error: \(error)")
            }
            
            return user
        }
    }
    
    func obtainPosts() -> [Post] {
        
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Post.time), ascending: true)
        
        fetchRequest.sortDescriptors = [sort]
        
        if let postsArray = try? viewContext.fetch(fetchRequest), !postsArray.isEmpty {
            
            return postsArray
            
        } else {
            var postsArray = [Post]()
            
            for index in 1...9 {
                
                let post = Post(context: viewContext)
                
                post.image = "postPhoto\(index + 1)"
                post.imageDescription = "Description \(index)"
                post.time = "\(index) часов назад"
                post.likes = "\(Int.random(in: 10...100))"
                post.postId = UUID().uuidString
                
                postsArray.append(post)
            }
            return postsArray
        }
    }
    
    func removePost(with id: String) {
        
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        let predicate = NSPredicate(format: "postId == %@", id)
        
        fetchRequest.predicate = predicate
        
        do {
            
            let array = try viewContext.fetch(fetchRequest)
            let postToDelete = array.first!
            
            viewContext.delete(postToDelete)
            
            try viewContext.save()
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
}
