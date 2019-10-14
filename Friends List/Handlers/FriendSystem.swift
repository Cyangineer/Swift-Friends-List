//
//  FirebaseHandler.swift
//  Friends List
//
//  Created by Nigell Dennis on 6/12/19.
//  Copyright © 2019 Nigell Dennis. All rights reserved.
//

import FirebaseDatabase
import FirebaseAuth

class FriendSystem {
    
    static let system = FriendSystem()
    
    var currentUser: User? {
        return Auth.auth().currentUser
    }
    
    var currentUserRef: DatabaseReference {
        if let uid = currentUser?.uid {
            return Database.database().reference().child("users").child(uid)
        }else{
            return Database.database().reference()
        }
    }
    
    var usersRef: DatabaseReference {
        return Database.database().reference().child("users")
    }
    
    func getUser(_ userID: String, completion: @escaping (UserModel) -> Void) {
        Database.database().reference().child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            let username = snapshot.childSnapshot(forPath: "username").value as? String ?? "--"
            let email = snapshot.childSnapshot(forPath: "email").value as? String ?? "--"
            let uid = snapshot.key
            let timeStamp = snapshot.childSnapshot(forPath: "timeStamp").value as? String ?? ""
            let profilePic = snapshot.childSnapshot(forPath: "picUrl").value as? String ?? ""
            completion(UserModel(uid: uid, username: username, email: email, profilePicUrl: profilePic, timeStamp: timeStamp))
        })
    }
    
    var usersList = [UserModel]()
    
    func getUsers(_ update: @escaping () -> Void) {
        Database.database().reference().child("users").queryOrdered(byChild: "username").observeSingleEvent(of: .value) { (snapshot) in
            self.usersList.removeAll()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let uid = child.key
                if let myUid = Auth.auth().currentUser?.uid {
                    if uid != myUid {
                        self.getUser(uid, completion: { (user) in
                            self.usersList.append(user)
                            update()
                        })
                    }
                }
            }
            
            if snapshot.childrenCount == 0 {
                update()
            }
        }
    }
    
    var friendsList = [UserModel]()
    var didGetFriendData = false
    var friendAddedIndex = 0
    var friendRemovedIndex = 0
    
    func getFriends(_ update: @escaping () -> Void){
        currentUserRef.child("friends").queryOrdered(byChild: "username").observeSingleEvent(of: .value) { (snapshot) in
            self.friendsList.removeAll()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let uid = child.key
                self.getUser(uid, completion: { (user) in
                    if let index = self.friendsList.firstIndex(where: {$0.username > user.username}) {
                        self.didGetFriendData = true
                        self.friendAddedIndex = index
                        self.friendsList.insert(user, at: index)
                        update()
                    }else{
                        self.friendsList.append(user)
                        self.didGetFriendData = false
                        update()
                    }
                })
            }
        }
    }
    
    func friendAdded(_ update: @escaping () -> Void) {
        currentUserRef.child("friends").queryOrdered(byChild: "username").observe(.childAdded) { (snapshot) in
            let uid = snapshot.key
            self.getUser(uid, completion: { (user) in
                if let index = self.friendsList.firstIndex(where: {$0.username > user.username}) {
                    self.didGetFriendData = true
                    self.friendAddedIndex = index
                    self.friendsList.insert(user, at: index)
                    update()
                }else{
                    self.friendsList.append(user)
                    self.didGetFriendData = false
                    update()
                }
            })
        }
    }
    
    func friendRemoved(_ update: @escaping () -> Void) {
        currentUserRef.child("friends").observe(.childRemoved) { (snapshot) in
            let uid = snapshot.key
            self.getUser(uid, completion: { (user) in
                if let index = self.friendsList.firstIndex(where: {$0.uid == user.uid}) {
                    self.friendRemovedIndex = index
                    self.friendsList.remove(at: index)
                    update()
                }
            })
        }
    }
    
    var orderedRequestsList = [UserModel]()
    var didGetRequestData = false
    var requestAddedIndex = 0
    var requestRemovedIndex = 0
    
    func getRequests(_ update: @escaping () -> Void){
        currentUserRef.child("requests").queryOrdered(byChild: "timeStamp").observeSingleEvent(of: .value) { (snapshot) in
            self.orderedRequestsList.removeAll()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let uid = child.key
                let timestamp = child.childSnapshot(forPath: "timeStamp").value as! String
                self.getUser(uid, completion: { (request) in
                    request.timeStamp = timestamp
                    if let index = self.orderedRequestsList.firstIndex(where: {$0.timeStamp < request.timeStamp}) {
                        self.orderedRequestsList.insert(request, at: index)
                        self.requestAddedIndex = index
                        self.didGetRequestData = true
                        update()
                    }else{
                        self.orderedRequestsList.append(request)
                        self.didGetRequestData = false
                        update()
                    }
                })
            }
        }
    }
    
    func requestAdded(_ update: @escaping () -> Void) {
        currentUserRef.child("requests").queryOrdered(byChild: "timeStamp").observe(.childAdded) { (snapshot) in
            let uid = snapshot.key
            let timestamp = snapshot.childSnapshot(forPath: "timeStamp").value as! String
            self.getUser(uid, completion: { (request) in
                request.timeStamp = timestamp
                if let index = self.orderedRequestsList.firstIndex(where: {$0.timeStamp < request.timeStamp}) {
                    self.didGetRequestData = true
                    self.requestAddedIndex = index
                    self.orderedRequestsList.insert(request, at: index)
                    update()
                }else{
                    self.orderedRequestsList.append(request)
                    self.didGetRequestData = false
                    update()
                }
            })
        }
    }
    
    func requestRemoved(_ update: @escaping () -> Void) {
        currentUserRef.child("requests").queryOrdered(byChild: "timeStamp").observe(.childRemoved) { (snapshot) in
            let uid = snapshot.key
            self.getUser(uid, completion: { (request) in
                if let index = self.orderedRequestsList.firstIndex(where: {$0.uid == request.uid}) {
                    self.requestRemovedIndex = index
                    self.orderedRequestsList.remove(at: index)
                    update()
                }
            })
        }
    }
    
    var orderedPendingList = [UserModel]()
    var didGetPendingData = false
    var pendingAddedIndex = 0
    var pendingRemovedIndex = 0
    
    func getPending(_ update: @escaping () -> Void){
        currentUserRef.child("pending").queryOrdered(byChild: "timeStamp").observeSingleEvent(of: .value) { (snapshot) in
            self.orderedPendingList.removeAll()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let uid = child.key
                let timestamp = child.childSnapshot(forPath: "timeStamp").value as! String
                self.getUser(uid, completion: { (pending) in
                    pending.timeStamp = timestamp
                    if let index = self.orderedPendingList.firstIndex(where: {$0.timeStamp < pending.timeStamp}) {
                        self.didGetPendingData = true
                        self.pendingAddedIndex = index
                        self.orderedPendingList.insert(pending, at: index)
                        update()
                    }else{
                        self.orderedPendingList.append(pending)
                        self.didGetPendingData = false
                        update()
                    }
                })
            }
        }
    }
    
    func pendingAdded(_ update: @escaping () -> Void) {
        currentUserRef.child("pending").queryOrdered(byChild: "timeStamp").observe(.childAdded) { (snapshot) in
            let uid = snapshot.key
            let timestamp = snapshot.childSnapshot(forPath: "timeStamp").value as! String
            self.getUser(uid, completion: { (pending) in
                pending.timeStamp = timestamp
                if let index = self.orderedPendingList.firstIndex(where: {$0.timeStamp < pending.timeStamp}) {
                    self.didGetPendingData = true
                    self.pendingAddedIndex = index
                    self.orderedPendingList.insert(pending, at: index)
                    update()
                }else{
                    self.orderedPendingList.append(pending)
                    self.didGetPendingData = false
                    update()
                }
            })
        }
    }
    
    func pendingRemoved(_ update: @escaping () -> Void) {
        currentUserRef.child("pending").queryOrdered(byChild: "timeStamp").observe(.childRemoved) { (snapshot) in
            let uid = snapshot.key
            self.getUser(uid, completion: { (pending) in
                if let index = self.orderedPendingList.firstIndex(where: {$0.uid == pending.uid}) {
                    self.pendingRemovedIndex = index
                    self.orderedPendingList.remove(at: index)
                    update()
                }
            })
        }
    }
    
    func sendRequest(_ userID: String) {
        guard let currentUserID = currentUser?.uid else {return}
        let timeStamp = Date().description
        let newPending = ["timeStamp": timeStamp] as [String : Any]
        let newRequest = ["timeStamp": timeStamp] as [String : Any]
        usersRef.child(userID).child("requests").child(currentUserID).updateChildValues(newRequest)
        usersRef.child(userID).child("new").child("requests").child(currentUserID).setValue(true)
        
        currentUserRef.child("pending").child(userID).updateChildValues(newPending)
    }
    
    func acceptRequest(_ userID: String){
        guard let currentUserID = currentUser?.uid else {return}
        getUser(currentUserID) { (user) in
            let newFriend = ["username": user.username] as [String : Any]
            self.currentUserRef.child("requests").child(userID).removeValue()
            self.currentUserRef.child("friends").child(userID).updateChildValues(newFriend)
            
            self.usersRef.child(userID).child("friends").child(currentUserID).updateChildValues(newFriend)
            self.usersRef.child(userID).child("pending").child(currentUserID).removeValue()
        }
    }
    
    func declineRequest(_ userID: String){
        currentUserRef.child("requests").child(userID).removeValue()
        usersRef.child(userID).child("pending").child(currentUser!.uid).removeValue()
    }
    
    func cancelRequest(_ userID: String){
        guard let currentUserID = currentUser?.uid else {return}
        currentUserRef.child("pending").child(userID).removeValue()
        usersRef.child(userID).child("requests").child(currentUserID).removeValue()
    }
    
    func removeFriend(_ userID: String){
        guard let currentUserID = currentUser?.uid else {return}
        currentUserRef.child("friends").child(userID).removeValue()
        usersRef.child(userID).child("friends").child(currentUserID).removeValue()
    }
    
    func removeAllObservers(){
        friendsList.removeAll()
        orderedRequestsList.removeAll()
        orderedPendingList.removeAll()
        currentUserRef.child("friends").removeAllObservers()
        currentUserRef.child("pending").removeAllObservers()
        currentUserRef.child("requests").removeAllObservers()
        didGetFriendData = false
        didGetRequestData = false
        didGetPendingData = false
    }
}
