//
//  WelcomeViewController.swift
//  Hospital
//
//  Created by Shannu on 13/01/20.
//  Copyright © 2020 Shannu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    var userName : String?
    @IBOutlet weak var userText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userText.text = userName
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
