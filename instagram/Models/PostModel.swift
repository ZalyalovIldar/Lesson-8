import Foundation
import UIKit

class PostModel: NSObject, NSCoding {
    
    var id = UUID().uuidString
    var userImage: UIImage?
    var nickName: String?
    var photo: UIImage?
    var text: String?
    var date: String?
    
    private enum stringKeys {
        
        static let id = "id"
        static let userImage = "userImage"
        static let nickName = "nickname"
        static let photo = "photo"
        static let text = "text"
        static let date = "date"
    }
    
    override init() {
        
    }
    
    //MARK: - NSCoding
    
    func encode(with coder: NSCoder) {
        
        coder.encode(id, forKey: stringKeys.id)
        coder.encode(userImage, forKey: stringKeys.userImage)
        coder.encode(nickName, forKey: stringKeys.nickName)
        coder.encode(photo, forKey: stringKeys.photo)
        coder.encode(text, forKey: stringKeys.text)
        coder.encode(date, forKey: stringKeys.date)
    }
    
    required init?(coder: NSCoder) {
        
        if let id = coder.decodeObject(forKey: stringKeys.id) as? String {
            self.id = id
        }
        if let userImage = coder.decodeObject(forKey: stringKeys.userImage) as? UIImage {
            self.userImage = userImage
        }
        if let nickname = coder.decodeObject(forKey: stringKeys.nickName) as? String {
            self.nickName = nickname
        }
        if let photo = coder.decodeObject(forKey: stringKeys.photo) as? UIImage {
            self.photo = photo
        }
        if let text = coder.decodeObject(forKey: stringKeys.text) as? String {
            self.text = text
        }
        if let date = coder.decodeObject(forKey: stringKeys.date) as? String {
            self.date = date
        }
    }
}

