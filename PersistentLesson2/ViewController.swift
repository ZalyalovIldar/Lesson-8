//
//  ViewController.swift
//  PersistentLesson2
//
//  Created by Ильдар Залялов on 27.11.2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var dataStoreManager = DataStoreManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let user = dataStoreManager.obtainMainUser()
        
        nameLabel.text = user.name! + " " + (user.company?.name ?? "")
        ageLabel.text = String(user.age)
        
        nameLabel.sizeToFit()
        ageLabel.sizeToFit()
        
        textField.delegate = self
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc
    func textFieldDidChange() {

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let name = textField.text else { return }
        
        dataStoreManager.updateMainUser(with: name)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func removeDidPressed(_ sender: Any) {
        dataStoreManager.removeMainUser()
    }
}

