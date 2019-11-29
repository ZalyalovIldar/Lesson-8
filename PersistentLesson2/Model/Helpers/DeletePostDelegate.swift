//
//  CellDelegate.swift
//  Threads
//
//  Created by Amir on 10.11.2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import UIKit

protocol DeletePostDelegate: AnyObject {
    
    func delete(post model: Post)
}
