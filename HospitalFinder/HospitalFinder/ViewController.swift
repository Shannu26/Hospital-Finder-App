//
//  ViewController.swift
//  HospitalFinder
//
//  Created by Shannu on 12/01/20.
//  Copyright © 2020 Shannu. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class ViewController: UIViewController , CLLocationManagerDelegate {

    @IBOutlet weak var phoneNumber: UITextField!
    
    var hospital = "Shannu"
    var count = 0
    var myLatitude : Double = 0
    var myLongitude : Double = 0
    var minDistance : Double = 0
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.\
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: phoneNumber.frame.height - 1, width: phoneNumber.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.systemBlue.cgColor
        phoneNumber.borderStyle = UITextField.BorderStyle.none
        phoneNumber.layer.addSublayer(bottomLine)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
//        let messageDB = Database.database().reference().child("Count")
//        let msgDict = ["Count" : 0]
//        messageDB.childByAutoId().setValue(msgDict) { (error, reference) in
//            if error != nil {
//                print("Error")
//            }
//        }
        let countDB = Database.database().reference().child("Count")
        
        countDB.observeSingleEvent(of: .childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,Int>
            self.count = snapshotValue["Count"]!
            print(self.count)
        }
        print(count)
    }
    
    // MARK: - Delegate methods
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            myLatitude = location.coordinate.latitude
            myLongitude = location.coordinate.longitude
            print(location.coordinate.longitude)
            print(location.coordinate.latitude)
        }
    }
    
    // MARK: - Button methods
    
    @IBAction func emergencyButtonPressed(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        findNearestHospital()

    }
    
    
    func findNearestHospital() {
        //var min = 0
        let hospitalDB = Database.database().reference().child("Hospitals")
        //var isNotFree = true
        var i = 0
        hospitalDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,Any>
            let latitude = snapshotValue["Latitude"] as! Double
            let longitude = snapshotValue["Longitude"] as! Double
            var distance = (sin(latitude) * sin(self.myLatitude)) + cos(self.myLatitude) * cos(latitude) * cos((longitude - self.myLongitude))
            distance = acos(distance) * 180 / Double.pi
            //let distance = sqrt(pow((latitude - self.myLatitude), 2) + pow((longitude - self.myLongitude), 2))
            if i == 0 {
                self.minDistance = distance
                self.hospital = snapshotValue["Hospital"] as! String
            }
            else {
                if self.minDistance > distance {
                    self.minDistance = distance
                    self.hospital = snapshotValue["Hospital"] as! String
                }
            }
            print(self.minDistance)
            if i < self.count - 1{
                print("Hi in if" , self.hospital)
                i += 1
                print(i)
            }
            else {
                print("Hi in else" , self.hospital)
                self.sendMessage()
            }
            
        }
        print(hospital)
        
    }
    
    func sendMessage() {
        print(hospital)
        let messageDB = Database.database().reference().child("Messages").child(hospital)
        let msgDict = ["MessageBody" : "Latitude: \(myLatitude) ,Longitude: \(myLongitude) ,PhoneNumber: \(phoneNumber.text)"]
        
        messageDB.childByAutoId().setValue(msgDict) { (error, reference) in
            if error != nil {
                print("Error")
            }
        }
    }
    
    
}

