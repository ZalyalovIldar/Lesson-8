import Foundation

protocol DataManagerProtocol {
    
    func syncSavePost(post: PostModel)
    func asyncSavePost(post: PostModel, complition: @escaping () -> Void)
    
    func syncSearchPost(for searchString: String) -> [PostModel]
    func asyncSearchPost(for searchString: String, complition: @escaping (([PostModel]) -> Void))
    
    func syncDeletePost(with postID: String)
    func asyncDeletePost(with postID: String, complition: @escaping () -> Void)
    
    func syncGetPosts() -> [PostModel]
    func asyncGetPosts(complition: @escaping (([PostModel]) -> Void))
}
