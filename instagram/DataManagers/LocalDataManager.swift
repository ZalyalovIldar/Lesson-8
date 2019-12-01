import UIKit
import CoreData

class LocalDataManager: DataManagerProtocol {
    
    static let shared = LocalDataManager()
    
    //MARK: - Save
    
    func syncSavePost(post: PostModel) {
        
        let _ = post.convertToPost()
        saveContext()
    }
    
    func asyncSavePost(post: PostModel, complition: @escaping () -> Void) {
        
        let queue = DispatchQueue.global()
        queue.async {
            let _ = post.convertToPost()
            self.saveContext()
            complition()
        }
    }
    
    func savePosts(postModels: [PostModel]) {
        
        for postModel in postModels {
            let _ = postModel.convertToPost()
        }
        try! context.save()
    }
    
    //MARK: - Search
    
    func syncSearchPost(for searchString: String) -> [PostModel] {
        
        let predicate = NSPredicate(format: "text CONTAINS[c] '\(searchString)'", argumentArray: nil)
        let fetchRequest = NSFetchRequest<Post>(entityName: "Post")
        fetchRequest.predicate = predicate
        guard let posts = try? context.fetch(fetchRequest) else {
            print("Error")
            return []
        }
        var postModels: [PostModel] = []
        for post in posts {
            postModels.append(post.convertToPostModel())
        }
        return postModels
    }
    
    func asyncSearchPost(for searchString: String, complition: @escaping (([PostModel]) -> Void)) {
        
        let queue = DispatchQueue.global()
        queue.async {
            let predicate = NSPredicate(format: "text CONTAINS[c] '\(searchString)'", argumentArray: nil)
            let fetchRequest = NSFetchRequest<Post>(entityName: "Post")
            fetchRequest.predicate = predicate
            guard let posts = try? self.context.fetch(fetchRequest) else {
                print("Error")
                complition([])
                return
            }
            var postModels: [PostModel] = []
            for post in posts {
                postModels.append(post.convertToPostModel())
            }
            complition(postModels)
        }
    }
    
    //MARK: - Delete
    
    func syncDeletePost(with postID: String) {
        guard let userToDelete = getPost(by: UUID(uuidString: postID)!) else { return }
        context.delete(userToDelete)
    }
    
    func asyncDeletePost(with postID: String, complition: @escaping () -> Void) {
        
        let queue = DispatchQueue.global()
        queue.async {
            guard let userToDelete = self.getPost(by: UUID(uuidString: postID)!) else { return }
            self.context.delete(userToDelete)
            complition()
        }
    }
    
    //MARK: - Get
    
    func syncGetPosts() -> [PostModel] {
        
        let fetchRequest = NSFetchRequest<Post>(entityName: "Post")
        guard let posts = try? context.fetch(fetchRequest) else { return [] }
        var postModelsToReturn: [PostModel] = []
        for post in posts {
            postModelsToReturn.append(post.convertToPostModel())
        }
        return postModelsToReturn
    }
    
    func asyncGetPosts(complition: @escaping (([PostModel]) -> Void)) {
        
        let queue = DispatchQueue.global()
        queue.async {
            let fetchRequest = NSFetchRequest<Post>(entityName: "Post")
            guard let posts = try? self.context.fetch(fetchRequest) else {
                complition( [] )
                return
            }
            var postModelsToReturn: [PostModel] = []
            for post in posts {
                postModelsToReturn.append(post.convertToPostModel())
            }
            complition(postModelsToReturn)
        }
    }
    
    func getPost(by id: UUID) -> Post? {
        
        let fetchRequest = NSFetchRequest<Post>(entityName: "Post")
        let predicateFormat = "id = '\(id.uuidString)'"
        let predicate = NSPredicate(format: predicateFormat, argumentArray: nil)
        fetchRequest.predicate = predicate
        
        guard let post = try? context.fetch(fetchRequest).first else { return nil }
        return post
    }
    
    //MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "instagram")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context = self.persistentContainer.viewContext

    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
