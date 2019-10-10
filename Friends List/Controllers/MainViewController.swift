//
//  MainViewController.swift
//  Friends List
//
//  Created by Nigell Dennis on 6/10/19.
//  Copyright © 2019 Nigell Dennis. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MainViewController: UIViewController {
    
    @IBOutlet weak var searchView: UIViewX!
    @IBOutlet weak var mainProfileView: UIView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var cardView: UIViewX!
    @IBOutlet weak var cardViewTab: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cardViewContraint: NSLayoutConstraint!
    
    let friendSystem = FriendSystem.system
    
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var tabIndexSelected = 2
    var userIndexSelected = 0
    let refreshControl = UIRefreshControl()
    
    var profileView = ProfileView()
    var profileViewBackground = UIView()
    
    // animation vars
    var currentState: State = .closed
    var runningAnimators = [UIViewPropertyAnimator]()
    var animationProgress = [CGFloat]()
    let popupOffset: CGFloat = 210
    lazy var panRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewPanned(recognizer:)))
        return recognizer
    }()
    private lazy var tapRecognizer: InstantPanGestureRecognizer = {
        let recognizer = InstantPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewPanned(recognizer:)))
        return recognizer
    }()
    
    var categoryArray: [CategoryModel] = [CategoryModel(title: "Requests", icon: #imageLiteral(resourceName: "ic_add"), indicatorOn: false), CategoryModel(title: "Pending", icon: #imageLiteral(resourceName: "ic_access_time"), indicatorOn: false), CategoryModel(title: "Friends", icon: #imageLiteral(resourceName: "ic_person_2x"), indicatorOn: false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "UserView", bundle: nil), forCellReuseIdentifier: "userCell")
        tableView.addSubview(refreshControl)
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        profileButton.addGestureRecognizer(tapRecognizer)
        setupCardView()
        addObservers()
    }
    
    func setupCardView(){
        let path = UIBezierPath(roundedRect: self.view.bounds, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 15.0, height: 15.0))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        cardView.layer.mask = maskLayer
        cardViewTab.addGestureRecognizer(panRecognizer)
    }
    
    @objc func goToSearch(){
        if #available(iOS 13.0, *) {
            let searchVc = mainStoryboard.instantiateViewController(identifier: "searchViewController") as! SearchViewController
            self.present(searchVc, animated: false, completion: nil)
        } else {
            // Fallback on earlier versions
            let searchVc = mainStoryboard.instantiateViewController(withIdentifier: "searchViewController") as! SearchViewController
            self.present(searchVc, animated: false, completion: nil)
        }
    }
}
