import UIKit

enum UserDefaultKeys {
    
    static let isFirstLaunch = "isFirstLaunch"
    static let posts = "posts"
}

class LocalDataManager: DataManagerProtocol {
    
    static let shared = LocalDataManager()
    
    private let userDefaults = UserDefaults.standard
    
    //MARK: - UserDefaults
    
    func getAllPosts() -> [PostModel] {
    
        //Получение всех PostModel из UserDefaults
        if let postsData = userDefaults.object(forKey: UserDefaultKeys.posts) as? Data,
            let posts = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(postsData) as? [PostModel] {
            return posts
        } else {
            return []
        }
    }
    
    func setAllPosts(for posts: [PostModel]) {
        
        //Замена старых PostModel в UserDefaults на новые
        let postsData = try? NSKeyedArchiver.archivedData(withRootObject: posts, requiringSecureCoding: false)
        userDefaults.set(postsData, forKey: UserDefaultKeys.posts)
    }
    
    //MARK: - Save
    
    func syncSavePost(post: PostModel) {
        
        var posts = getAllPosts()
        posts.append(post)
        setAllPosts(for: posts)
    }
    
    func asyncSavePost(post: PostModel, complition: @escaping () -> Void) {
        
        let queue = DispatchQueue.global()
        queue.async {
            
            var posts = self.getAllPosts()
            posts.append(post)
            self.setAllPosts(for: posts)
            complition()
        }
    }
    
    //MARK: - Search
    
    func syncSearchPost(for searchString: String) -> [PostModel] {
        
        let posts = getAllPosts()
        let searchedPosts = posts.filter {
            if let text = $0.text { return text.contains(searchString) }
            return false
        }
        return searchedPosts
    }
    
    func asyncSearchPost(for searchString: String, complition: @escaping (([PostModel]) -> Void)) {
        
        let queue = DispatchQueue.global()
        queue.async {
            
            let posts = self.getAllPosts()
            let searchedPosts = posts.filter {
                if let text = $0.text { return text.contains(searchString) }
                return false
            }
            complition(searchedPosts)
        }
    }
    
    //MARK: - Delete
    
    func syncDeletePost(with postID: String) {
        
        var posts = getAllPosts()
        posts.removeAll { $0.id == postID }
        setAllPosts(for: posts)
    }
    
    func asyncDeletePost(with postID: String, complition: @escaping () -> Void) {
        
        let queue = DispatchQueue.global()
        queue.async {
            
            var posts = self.getAllPosts()
            posts.removeAll { $0.id == postID }
            self.setAllPosts(for: posts)
            complition()
        }
    }
    
    //MARK: - Get
    
    func syncGetPosts() -> [PostModel] {
        
        return getAllPosts()
    }
    
    func asyncGetPosts(complition: @escaping (([PostModel]) -> Void)) {
        
        let queue = DispatchQueue.global()
        queue.async {
            let posts = self.getAllPosts()
            complition(posts)
        }
    }
}
