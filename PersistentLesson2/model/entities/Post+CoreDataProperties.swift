//
//  Post+CoreDataProperties.swift
//  PersistentLesson2
//
//  Created by Enoxus on 29/11/2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var pic: String
    @NSManaged public var text: String
    @NSManaged public var id: String
    @NSManaged public var owner: User

}
