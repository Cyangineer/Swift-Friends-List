//
//  TableViewHandler.swift
//  Friends List
//
//  Created by Nigell Dennis on 6/13/19.
//  Copyright © 2019 Nigell Dennis. All rights reserved.
//
import UIKit

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tabIndexSelected {
        case 0:
            if friendSystem.orderedRequestsList.count == 0 {
                tableView.setEmptyView(title: "", message: "No New Requests")
            }else{
                tableView.restore()
            }
            return friendSystem.orderedRequestsList.count
        case 1:
            if friendSystem.orderedPendingList.count == 0 {
                tableView.setEmptyView(title: "", message: "No Pending Requests")
            }else{
                tableView.restore()
            }
            return friendSystem.orderedPendingList.count
        case 2:
            if friendSystem.friendsList.count == 0 {
                tableView.setEmptyView(title: "No Friends Listed", message: "Search For Friends To Add")
            }else{
                tableView.restore()
            }
            return friendSystem.friendsList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserViewCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        
        switch tabIndexSelected {
        case 0:
            cell.usernameLabel.text = friendSystem.orderedRequestsList[indexPath.row].username
            cell.emailLabel.text = friendSystem.orderedRequestsList[indexPath.row].email
            if let dateFromString = dateFormatter.date(from: friendSystem.orderedRequestsList[indexPath.row].timeStamp) {
                cell.timeStampLabel.text = timeAgoSince(dateFromString)
            }
            cell.timeStampLabel.isHidden = false
        break
            
        case 1:
            cell.usernameLabel.text = friendSystem.orderedPendingList[indexPath.row].username
            cell.emailLabel.text = friendSystem.orderedPendingList[indexPath.row].email
            if let dateFromString = dateFormatter.date(from: friendSystem.orderedPendingList[indexPath.row].timeStamp) {
                cell.timeStampLabel.text = timeAgoSince(dateFromString)
            }
            cell.timeStampLabel.isHidden = false
        break
            
        case 2:
            cell.usernameLabel.text = friendSystem.friendsList[indexPath.row].username
            cell.emailLabel.text = friendSystem.friendsList[indexPath.row].email
            cell.timeStampLabel.isHidden = true
        break
        
        default: break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var friend: UserModel
        
        userIndexSelected = indexPath.row
        
        switch tabIndexSelected {
        case 0:
            friend = friendSystem.orderedRequestsList[indexPath.row]
        case 1:
            friend = friendSystem.orderedPendingList[indexPath.row]
        case 2:
            friend = friendSystem.friendsList[indexPath.row]
        default:
            return
        }
        
        presentProfile(user: friend)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl.isRefreshing {
            tableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
}

extension UITableView {
    func setEmptyView(title: String, message: String) {
        
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        emptyView.backgroundColor = UIColor(named: "secondary")
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = UIColor(named: "Label Color")
        titleLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 18)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 17)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        let view = UIView()
        view.backgroundColor = UIColor(named: "secondary")
        self.backgroundView = view
        self.separatorStyle = .singleLine
    }
}
