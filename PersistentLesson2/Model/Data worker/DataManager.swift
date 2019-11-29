//
//  DataManager.swift
//  Threads
//
//  Created by Amir on 08.11.2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import Foundation


protocol DataManager {
    
    func syncSavePost(post: Post)
    func asyncSavePost(post: Post, completion: @escaping ([Post]) -> Void)
    
    func syncSearchPost(for searchString: String) -> [Post]
    func asyncSearchPost(for searchString: String, completion: @escaping (([Post]) -> Void))
    
    func syncDeletePost(with postID: String)
    func asyncDeletePost(with post: Post, completion: @escaping ([Post]) -> Void)
    
    func syncGetPosts() -> [Post]
    func asyncGetPosts(completion: @escaping (([Post]) -> Void))
    
    func asyncGetUser(completion: @escaping (User) -> Void)
}
