//
//  MainProfileViewController.swift
//  Friends List
//
//  Created by Nigell Dennis on 10/7/19.
//  Copyright © 2019 Nigell Dennis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MainProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = Auth.auth().currentUser?.displayName
        emailLabel.text = Auth.auth().currentUser?.email
    }

    @IBAction func logout(_ sender: Any) {
        UserSystem.system.logoutAccount()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let rootVC = appDelegate.window!.rootViewController
        if rootVC?.restorationIdentifier == "mainViewController" {
            if let initialVc = storyboard?.instantiateInitialViewController() {
                self.present(initialVc, animated: true, completion: nil)
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
