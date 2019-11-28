//
//  User+CoreDataProperties.swift
//  PersistentLesson2
//
//  Created by Ильдар Залялов on 27.11.2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var age: Int16
    @NSManaged public var name: String?
    @NSManaged public var isMain: Bool
    @NSManaged public var anyBool: NSNumber?
    @NSManaged public var company: Company?

}
