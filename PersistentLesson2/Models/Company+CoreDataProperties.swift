//
//  Company+CoreDataProperties.swift
//  PersistentLesson2
//
//  Created by Ильдар Залялов on 27.11.2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//
//

import Foundation
import CoreData


extension Company {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Company> {
        return NSFetchRequest<Company>(entityName: "Company")
    }

    @NSManaged public var name: String?
    @NSManaged public var employee: NSSet?

}

// MARK: Generated accessors for employee
extension Company {

    @objc(addEmployeeObject:)
    @NSManaged public func addToEmployee(_ value: User)

    @objc(removeEmployeeObject:)
    @NSManaged public func removeFromEmployee(_ value: User)

    @objc(addEmployee:)
    @NSManaged public func addToEmployee(_ values: NSSet)

    @objc(removeEmployee:)
    @NSManaged public func removeFromEmployee(_ values: NSSet)

}
