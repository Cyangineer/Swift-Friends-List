//
//  ObserverHandler.swift
//  Friends List
//
//  Created by Nigell Dennis on 9/30/19.
//  Copyright © 2019 Nigell Dennis. All rights reserved.
//
import UIKit
import FirebaseDatabase

extension MainViewController {
    
    func addObservers(){
        
        friendSystem.friendAdded {
            if self.tabIndexSelected == 2 {
                if self.friendSystem.didGetFriendData {
                    let indexPath = IndexPath(row: self.friendSystem.friendAddedIndex, section: 0)
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                    self.tableView.endUpdates()
                }else{
                    self.tableView.reloadData()
                }
            }
        }
        
        friendSystem.friendRemoved {
            if self.tabIndexSelected == 2 {
                let indexPath = IndexPath(row: self.friendSystem.friendRemovedIndex, section: 0)
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.endUpdates()
            }
        }
        
        friendSystem.requestAdded {
            if self.tabIndexSelected == 0 {
                if self.friendSystem.didGetRequestData {
                    let indexPath = IndexPath(row: self.friendSystem.requestAddedIndex, section: 0)
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                    self.tableView.endUpdates()
                }else{
                    self.tableView.reloadData()
                }
            }
        }
        
        friendSystem.requestRemoved {
            if self.tabIndexSelected == 0 {
                let indexPath = IndexPath(row: self.friendSystem.requestRemovedIndex, section: 0)
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.endUpdates()
            }
        }
        
        friendSystem.pendingAdded {
            if self.tabIndexSelected == 1 {
                if self.friendSystem.didGetPendingData {
                    let indexPath = IndexPath(row: self.friendSystem.pendingAddedIndex, section: 0)
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                    self.tableView.endUpdates()
                }else{
                    self.tableView.reloadData()
                }
            }
        }
        
        friendSystem.pendingRemoved {
            if self.tabIndexSelected == 1 {
                let indexPath = IndexPath(row: self.friendSystem.pendingRemovedIndex, section: 0)
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.endUpdates()
            }
        }
        
        friendSystem.currentUserRef.child("new").child("requests").observe(.value) { (snapshot) in
            var requestCount = 0
            for _ in snapshot.children.allObjects as! [DataSnapshot] {
                requestCount += 1
            }
            if requestCount != 0 {
                self.categoryArray[0].indicatorOn = true
            }else{
                self.categoryArray[0].indicatorOn = false
            }
            self.collectionView.reloadData()
        }
    }
}
