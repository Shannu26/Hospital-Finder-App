//
//  SignUpViewController.swift
//  Hospital
//
//  Created by Shannu on 13/01/20.
//  Copyright © 2020 Shannu. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class SignUpViewController: UIViewController , CLLocationManagerDelegate {

    @IBOutlet weak var hospitalName: UITextField!
    @IBOutlet weak var hospitalNumber: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var latitude : Double!
    var longitude : Double!
    let locationManager = CLLocationManager()
    var count = 2
    var p = 0
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let bottomLine1 = CALayer()
        bottomLine1.frame = CGRect(x: 0.0, y: hospitalName.frame.height - 1, width: hospitalName.frame.width, height: 1.0)
        bottomLine1.backgroundColor = UIColor.systemBlue.cgColor
        
        hospitalName.borderStyle = UITextField.BorderStyle.none
        hospitalName.layer.addSublayer(bottomLine1)
        
        let bottomLine2 = CALayer()
        bottomLine2.frame = CGRect(x: 0.0, y: hospitalNumber.frame.height - 1, width: hospitalNumber.frame.width, height: 1.0)
        bottomLine2.backgroundColor = UIColor.systemBlue.cgColor
        
        hospitalNumber.borderStyle = UITextField.BorderStyle.none
        hospitalNumber.layer.addSublayer(bottomLine2)
        
        let bottomLine3 = CALayer()
        bottomLine3.frame = CGRect(x: 0.0, y: emailAddress.frame.height - 1, width: emailAddress.frame.width, height: 1.0)
        bottomLine3.backgroundColor = UIColor.systemBlue.cgColor
        
        emailAddress.borderStyle = UITextField.BorderStyle.none
        emailAddress.layer.addSublayer(bottomLine3)
        
        let bottomLine4 = CALayer()
        bottomLine4.frame = CGRect(x: 0.0, y: userName.frame.height - 1, width: userName.frame.width, height: 1.0)
        bottomLine4.backgroundColor = UIColor.systemBlue.cgColor
        
        userName.borderStyle = UITextField.BorderStyle.none
        userName.layer.addSublayer(bottomLine4)
        
        let bottomLine5 = CALayer()
        bottomLine5.frame = CGRect(x: 0.0, y: password.frame.height - 1, width: password.frame.width, height: 1.0)
        bottomLine5.backgroundColor = UIColor.systemBlue.cgColor
        
        password.borderStyle = UITextField.BorderStyle.none
        password.layer.addSublayer(bottomLine5)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        view.addGestureRecognizer(tapGesture)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        // Do any additional setup after loading the view.
        let countDB = Database.database().reference().child("Count")
        
        countDB.observeSingleEvent(of: .childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,Int>
            self.count = snapshotValue["Count"]!
            print(self.count)
        }
        print(count)
    }
    
    @objc func tapped() {
        view.endEditing(true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if  p == 0 && location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            p = 1
            addDataToFirebase()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        
        if hospitalName.text == "" || hospitalNumber.text == "" || emailAddress.text == "" || userName.text == "" || password.text == "" {
            return
        }
        else {
            Auth.auth().createUser(withEmail: emailAddress.text!, password: password.text!) { (user, error) in
                if error != nil {
                    print("Error")
                }
                else{
                    self.locationManager.startUpdatingLocation()
                    self.locationManager.requestWhenInUseAuthorization()
                    self.performSegue(withIdentifier: "goToWelcome", sender: self)
                }
            }
        }
        self.defaults.set(hospitalName.text, forKey: emailAddress.text!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToWelcome" {
            let destinationVC = segue.destination as! WelcomeViewController
            destinationVC.userName = userName.text
        }
    }
    
    func addDataToFirebase() {
        var messageDB = Database.database().reference()
        messageDB.child("Count").child("-LyiDafRkSTxpaCrkijE").updateChildValues(["Count" : count + 1])
        messageDB = messageDB.child("Hospitals")
        let msgDict = ["Hospital" : Auth.auth().currentUser?.uid , "Latitude" : latitude! , "Longitude" : longitude!] as [String : Any]
        
        messageDB.childByAutoId().setValue(msgDict) { (error, reference) in
            if error != nil {
                print("Error")
            }
        }
    }
    
}
