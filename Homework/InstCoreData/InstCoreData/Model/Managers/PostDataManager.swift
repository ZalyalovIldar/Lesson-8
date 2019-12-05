//
//  DataManager.swift
//  6HomeworkInstagram
//
//  Created by Роман Шуркин on 16/11/2019.
//  Copyright © 2019 Роман Шуркин. All rights reserved.
//

import Foundation
import UIKit

protocol DataProtocol {
    func syncSave(post: Post)
    func asyncSave(post: Post, completion: @escaping () -> Void)
    func syncGet(id: UUID) -> Post?
    func asyncGet(id: UUID, completion: @escaping (Post) -> Void)
    func syncGetAllOfUser(user: User) -> [Post]
    func asyncGetAllOfUser(user: User, completion: @escaping ([Post]) -> Void)
    func syncGetAll() -> [Post]
    func asyncGetAll(completion: @escaping ([Post]) -> Void)
    func syncRemove(id: UUID)
    func asyncRemove(id: UUID, completion: @escaping ([Post]) -> Void)
    func syncSearch(id: UUID)
    func asyncSearch(textOfSearch: String, completion: @escaping ([Post]) -> Void)
}

enum UserDefaultKeys {
    static let posts = "posts"
    static let user = "user"
}

/// Data Manager of User
class PostDataManager: DataProtocol {
    

    static var shared = PostDataManager()

    var coreDM = CoreDataManager()
    
    var allPosts: [Post]

    private init() {
        allPosts = coreDM.getAllPosts()
    }
    
    func syncSave(post: Post) {
        allPosts.append(post)
    }
    
    func asyncSave(post: Post, completion: @escaping () -> Void) {
        
        let operationQueue = OperationQueue()

        DispatchQueue.global(qos: .userInteractive).async {

            let operation = BlockOperation { [weak self] in

                self?.allPosts.append(post)

                DispatchQueue.main.async { completion() }
            }

            operationQueue.addOperation(operation)
        }
    }
    
    func syncGet(id: UUID) -> Post? {
        return allPosts.filter {
            $0.id == id
        }.first
    }
    
    func asyncGet(id: UUID, completion: @escaping (Post) -> Void) {
        return
    }
    
    func syncGetAllOfUser(user: User) -> [Post] {

        return reverse(array: allPosts.filter { $0.user!.id == user.id })
    }
    
    func asyncGetAllOfUser(user: User, completion: @escaping ([Post]) -> Void) {
        
        let operationQueue = OperationQueue()

        DispatchQueue.global(qos: .userInteractive).async {

            let operation = BlockOperation { [weak self] in


                DispatchQueue.main.async { [weak self] in

                    if let posts = self?.reverse(array: (self?.allPosts.filter { $0.user!.id == user.id })!) {
                        completion(posts)
                    }
                }
            }

            operationQueue.addOperation(operation)
        }
    }
    
    func syncGetAll() -> [Post] {
        return allPosts
    }
    
    func asyncGetAll(completion: @escaping ([Post]) -> Void) {
        
        let operationQueue = OperationQueue()

        DispatchQueue.global(qos: .userInteractive).async {

            let operation = BlockOperation { [weak self] in


                DispatchQueue.main.async { [weak self] in

                    if let posts = self?.allPosts {
                        completion(posts)
                    }
                }
            }

            operationQueue.addOperation(operation)
        }
    }
    
    func syncRemove(id: UUID) {
        
        allPosts.removeAll {
            $0.id! == id
        }
    }
    
    func asyncRemove(id: UUID, completion: @escaping ([Post]) -> Void) {
        
        let operationQueue = OperationQueue()

        DispatchQueue.global(qos: .userInteractive).async {

            let operation = BlockOperation { [weak self] in

                self?.allPosts.removeAll {
                    $0.id! == id
                }
                
                self?.coreDM.removePost(id: id)
                DispatchQueue.main.async { [weak self] in

                    if let posts = self?.allPosts {
                        completion(posts)
                    }
                }
            }

            operationQueue.addOperation(operation)
        }
    }
    
    func syncSearch(id: UUID) {
        return
    }
    
    func asyncSearch(textOfSearch: String, completion: @escaping ([Post]) -> Void) {
        
        let operationQueue = OperationQueue()
        
        DispatchQueue.global(qos: .userInteractive).async {
            let operation = BlockOperation { [weak self] in
                
                if let filterPosts = self?.allPosts.filter({ $0.text!.lowercased().contains(textOfSearch.lowercased()) }) {
                    DispatchQueue.main.async {
                        completion(filterPosts)
                    }
                }
            }
            operationQueue.addOperation(operation)
        }
    }
    
    func getUIImage(name: String) -> UIImage {
     return UIImage(named: name) ?? UIImage()
    }
    
    func reverse(array: [Post]) -> [Post] {
        
        var reverseArray = array
        
        for index in 0...reverseArray.count {
            if index < reverseArray.count / 2 {
                let t = reverseArray[index]
                reverseArray[index] = reverseArray[reverseArray.count - index - 1]
                reverseArray[reverseArray.count - index - 1] = t
            }
            else {
                break
            }
        }
        return reverseArray
    }

}
