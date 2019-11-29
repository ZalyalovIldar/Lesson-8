//
//  Post+CoreDataProperties.swift
//  PersistentLesson2
//
//  Created by Amir on 28.11.2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var image: String?
    @NSManaged public var imageDescription: String?
    @NSManaged public var likes: String?
    @NSManaged public var postId: String?
    @NSManaged public var time: String?
    @NSManaged public var user: User?

}
