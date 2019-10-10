//
//  UserSystem.swift
//  Friends List
//
//  Created by Nigell Dennis on 6/9/19.
//  Copyright © 2019 Nigell Dennis. All rights reserved.
//

import Firebase
import FirebaseAuth

class UserSystem {
    
    static let system = UserSystem()
    var errorMessage = ""
    
    func createAccount(_ email: String, password: String, username: String, completion: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (authResult, error) in
            if (error == nil) {
                // Success
                if let authResult = authResult?.user {
                    let values = ["username": username, "email": email]
                    Database.database().reference().child("users").child(authResult.uid).updateChildValues(values)
                }
                
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = username
                changeRequest?.commitChanges(completion: { (error) in
                    completion(true)
                })
            } else {
                // Failure
                if let error = error {
                    self.errorMessage = error.localizedDescription
                }
                completion(false)
            }
        })
    }
    
    func loginAccount(_ email: String, password: String, completion: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if (error == nil) {
                // Success
                completion(true)
            } else {
                // Failure
                if let error = error {
                    self.errorMessage = error.localizedDescription
                }
                completion(false)
            }
            
        })
    }
    
    func logoutAccount() {
        FriendSystem.system.removeAllObservers()
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            self.errorMessage = signOutError.localizedDescription
        }
    }
}
