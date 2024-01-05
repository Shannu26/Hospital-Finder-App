//
//  TableViewController.swift
//  Hospital
//
//  Created by Shannu on 13/01/20.
//  Copyright © 2020 Shannu. All rights reserved.
//

import UIKit
import Firebase

class TableViewController: UITableViewController {
    
    var messageArray = ["Hello"]
    var hospitalName : String = ""
    var lat : Double!
    var lon : Double!
    
    var firebaseString : String = ""
    var myIndex = 0
    //let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
//        Auth.auth().currentUser?.uid
        
//        if let name = defaults.value(forKey: (Auth.auth().currentUser?.email)!) as? String{
//            hospitalName = name
//            print(hospitalName)
//        }
        
        retrieveMessages()
        
        
        
        configureTableView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messageArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        cell.textLabel?.text = messageArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        firebaseString = messageArray[myIndex]
        getDirections(string: firebaseString)
        performSegue(withIdentifier: "GetDirections", sender: self)
    }
    
    func configureTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40.0
    }
    
    func retrieveMessages() {
        let messageDB = Database.database().reference().child("Messages").child(Auth.auth().currentUser!.uid)
        
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            self.messageArray.append(snapshotValue["MessageBody"]!)
            print(self.messageArray[self.messageArray.endIndex - 1])
            self.configureTableView()
            self.tableView.reloadData()
        }
    }
    

    // MARK: - LogOut Button Method
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }
        catch{
            print("Error")
        }
        
    }
    func getDirections(string : String) {
        let locationsArray = string.components(separatedBy: " ")
        lat = Double(locationsArray[1])
        lon = Double(locationsArray[3])
        print("\(lat), \(lon)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GetDirections" {
            let destinationVC = segue.destination as! MapViewController
            destinationVC.destLat = lat
            destinationVC.destLon = lon
        }
    }
    
    
    

}
