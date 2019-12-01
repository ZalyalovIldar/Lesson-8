import Foundation
import UIKit
import CoreData

@objc(Post)
public class Post: NSManagedObject {
    
    func convertToPostModel() -> PostModel {
        
        let postModel = PostModel()
        postModel.id = self.id
        postModel.nickName = self.nickname
        postModel.date = self.date
        postModel.text = self.text
        postModel.userImage = UIImage(data: self.userImageData!)
        postModel.photo = UIImage(data: self.photoData!)
        
        return postModel
    }
}

