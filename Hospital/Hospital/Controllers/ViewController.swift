//
//  ViewController.swift
//  Hospital
//
//  Created by Shannu on 12/01/20.
//  Copyright © 2020 Shannu. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: emailAddress.frame.height - 1, width: emailAddress.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.systemBlue.cgColor
        
        emailAddress.borderStyle = UITextField.BorderStyle.none
        emailAddress.layer.addSublayer(bottomLine)
        
        let bottomLine1 = CALayer()
        bottomLine1.frame = CGRect(x: 0.0, y: password.frame.height - 1, width: password.frame.width, height: 1.0)
        bottomLine1.backgroundColor = UIColor.systemBlue.cgColor
        
        password.borderStyle = UITextField.BorderStyle.none
        password.layer.addSublayer(bottomLine1)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        view.addGestureRecognizer(tapGesture)
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        emailAddress.delegate = self
        password.delegate = self
    }
    
    @objc func tapped() {
        view.endEditing(true)
    }
    
    // MARK: - LogIn button pressed method
    @IBAction func logInPressed(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: emailAddress.text!, password: password.text!) { (user, error) in
            if error != nil {
                print("Error")
            }
            else {
                self.performSegue(withIdentifier: "goToMain", sender: self)
            }
        }
    }
}

