//
//  SearchViewController.swift
//  Friends List
//
//  Created by Nigell Dennis on 6/25/19.
//  Copyright © 2019 Nigell Dennis. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var profileView = ProfileView()
    var profileViewBackground = UIView()
    let friendSystem = FriendSystem.system
    var filteredUsers = [UserModel]()
    var selectedIndex = 0
    var selectedUser: UserModel?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.searchTextField.font = UIFont(name: "Arial Rounded MT Bold", size: 16)
        searchBar.setImage(UIImage(), for: .search, state: .normal)
        tableView.register(UINib(nibName: "UserView", bundle: nil), forCellReuseIdentifier: "userCell")
        friendSystem.getUsers {
            self.tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredUsers = friendSystem.usersList.filter({ (user) -> Bool in
            if searchText.lowercased().count >= 3 {
                if user.username.lowercased().contains(searchText.lowercased()) {
                    return true
                } else {
                    return false
                }
            }else{
                return false
            }
        })
        
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredUsers.count == 0 {
            tableView.setEmptyView(title: "", message: "No Results")
        }else{
            tableView.restore()
        }
        return filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserViewCell
        cell.usernameLabel.text = filteredUsers[indexPath.row].username
        cell.emailLabel.text = filteredUsers[indexPath.row].email
        cell.timeStampLabel.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        presentProfile(user: filteredUsers[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
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
        
        for searchedUser in friendSystem.usersList {
            if user.uid == searchedUser.uid {
                profileView.acceptButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
                profileView.acceptButton.isHidden = false
                profileView.acceptButton.setTitle("Add", for: .normal)
                profileView.declineButton.isHidden = true
            }
        }
        
        for friend in friendSystem.friendsList {
            if user.uid == friend.uid {
                profileView.declineButton.addTarget(self, action: #selector(removeAction), for: .touchUpInside)
                profileView.declineButton.setTitle("Remove", for: .normal)
                profileView.acceptButton.isHidden = true
                profileView.declineButton.isHidden = false
            }
        }
        
        for request in friendSystem.orderedRequestsList {
            if user.uid == request.uid {
                profileView.acceptButton.addTarget(self, action: #selector(acceptAction), for: .touchUpInside)
                profileView.declineButton.addTarget(self, action: #selector(declineAction), for: .touchUpInside)
                profileView.acceptButton.setTitle("Accept", for: .normal)
                profileView.declineButton.setTitle("Decline", for: .normal)
                profileView.acceptButton.isHidden = false
                profileView.declineButton.isHidden = false
            }
        }
        
        for pending in friendSystem.orderedPendingList {
            if user.uid == pending.uid {
                profileView.declineButton.setTitle("Cancel Request", for: .normal)
                profileView.declineButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
                profileView.acceptButton.isHidden = true
                profileView.declineButton.isHidden = false
            }
        }
        
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
    
    @objc func addAction(){
        friendSystem.sendRequest(filteredUsers[selectedIndex].uid)
        dismissProfileView()
    }
    
    @objc func acceptAction(){
        friendSystem.acceptRequest(filteredUsers[selectedIndex].uid)
        dismissProfileView()
    }
    
    @objc func declineAction(){
        friendSystem.declineRequest(filteredUsers[selectedIndex].uid)
        dismissProfileView()
    }
    
    @objc func cancelAction(){
        friendSystem.cancelRequest(filteredUsers[selectedIndex].uid)
        dismissProfileView()
    }
    
    @objc func removeAction(){
        friendSystem.removeFriend(filteredUsers[selectedIndex].uid)
        dismissProfileView()
    }
}
