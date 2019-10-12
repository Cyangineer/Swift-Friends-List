//
//  CollectionViewHandler.swift
//  Friends List
//
//  Created by Nigell Dennis on 9/30/19.
//  Copyright © 2019 Nigell Dennis. All rights reserved.
//
import UIKit

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tabIndexSelected = indexPath.row
        if indexPath.row == 0 {
            FriendSystem.system.currentUserRef.child("new").child("requests").removeValue()
        }
        titleLabel.text = categoryArray[tabIndexSelected].title
        tableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabItem", for: indexPath) as! CollectionItemViewCell
        cell.icon.image = categoryArray[indexPath.row].icon
        titleLabel.text = categoryArray[tabIndexSelected].title
        if categoryArray[indexPath.row].indicatorOn {
            cell.notificationDot.isHidden = false
        }
        
        if indexPath.row == tabIndexSelected {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width/4, height: 50)
    }
}
