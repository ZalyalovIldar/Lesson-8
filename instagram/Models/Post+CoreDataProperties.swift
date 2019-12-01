import Foundation
import CoreData

extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var id: UUID
    @NSManaged public var userImageData: Data?
    @NSManaged public var nickname: String?
    @NSManaged public var photoData: Data?
    @NSManaged public var text: String?
    @NSManaged public var date: String?
}
