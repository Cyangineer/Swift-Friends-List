//
//  ProfileHandler.swift
//  Friends List
//
//  Created by Nigell Dennis on 9/30/19.
//  Copyright © 2019 Nigell Dennis. All rights reserved.
//

import UIKit

extension MainViewController {
    func presentProfile(user: UserModel){
        
        profileView = Bundle.main.loadNibNamed("Profile", owner: self, options: nil)?.first as! ProfileView
        profileViewBackground = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissProfileView))
        
        profileViewBackground.addGestureRecognizer(tap)
        profileViewBackground.backgroundColor = .black
        profileViewBackground.alpha = 0.0
        profileView.usernameLabel.text = user.username
        profileView.emailLabel.text = user.email
        profileView.alpha = 0.0
        profileView.center.y = self.view.center.y + 50
        profileView.center.x = self.view.center.x
        
        switch tabIndexSelected {
        case 0:
            profileView.acceptButton.setTitle("Accept Request", for: .normal)
            profileView.declineButton.setTitle("Decline Request", for: .normal)
        case 1:
            profileView.declineButton.setTitle("Cancel Request", for: .normal)
            profileView.acceptButton.isHidden = true
        case 2:
            profileView.declineButton.setTitle("Remove Friend", for: .normal)
            profileView.acceptButton.isHidden = true
        default:
            break
        }
        
        profileView.acceptButton.addTarget(self, action: #selector(acceptAction), for: .touchUpInside)
        profileView.declineButton.addTarget(self, action: #selector(declineAction), for: .touchUpInside)
        self.view.addSubview(profileViewBackground)
        self.view.addSubview(profileView)
        UIView.animate(withDuration: 0.3) {
            self.profileViewBackground.alpha = 0.5
            self.profileView.center.y = self.view.center.y
            self.profileView.alpha = 1.0
        }
    }
    
    @objc func dismissProfileView(){
        UIView.animate(withDuration: 0.3, animations: {
            self.profileViewBackground.alpha = 0.0
            self.profileView.center.y = self.view.center.y + 50
            self.profileView.alpha = 0.0
        }) { (_) in
            self.profileView.removeFromSuperview()
        }
    }
    
    @objc func acceptAction(){
        friendSystem.acceptRequest(friendSystem.orderedRequestsList[userIndexSelected].uid)
        dismissProfileView()
    }
    
    @objc func declineAction(){
        switch tabIndexSelected {
        case 0:
            friendSystem.declineRequest(friendSystem.orderedRequestsList[userIndexSelected].uid)
        case 1:
            friendSystem.cancelRequest(friendSystem.orderedPendingList[userIndexSelected].uid)
        case 2:
            friendSystem.removeFriend(friendSystem.friendsList[userIndexSelected].uid)
        default:
            break
        }
        dismissProfileView()
    }
}
