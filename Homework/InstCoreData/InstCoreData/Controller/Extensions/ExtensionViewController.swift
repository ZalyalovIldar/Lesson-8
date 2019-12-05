//
//  ExtensionViewController.swift
//  6HomeworkInstagram
//
//  Created by Роман Шуркин on 18.11.2019.
//  Copyright © 2019 Роман Шуркин. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    /// Create UIImage by name
    /// - Parameter name: name of Image
    func getUIImage(name: String) -> UIImage {
        return UIImage(named: name) ?? UIImage()
    }
}
