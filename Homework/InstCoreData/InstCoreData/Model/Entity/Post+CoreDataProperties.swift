//
//  Post+CoreDataProperties.swift
//  InstCoreData
//
//  Created by Роман Шуркин on 05.12.2019.
//  Copyright © 2019 Роман Шуркин. All rights reserved.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var image: String?
    @NSManaged public var text: String?
    @NSManaged public var date: Date?
    @NSManaged public var user: User?

}
