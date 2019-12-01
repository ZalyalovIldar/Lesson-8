import Foundation
import UIKit

class Generator {
    
    private static let userImage = UIImage(named: "userImage")
    private static let userNickname = "NikitaL"
    
    static func getData() -> [PostModel] {
        
        var posts: [PostModel] = []
        
        for i in 1...6 {
            
            let post = PostModel()
            post.nickName = userNickname
            post.userImage = userImage
            post.text = "Post #\(i)"
            post.date = "\(i) september"
            post.photo = UIImage(named: "photo\(i)")
            posts.append(post)
        }
        
        return posts
    }
}
