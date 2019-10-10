//
//  SignUpViewController.swift
//  Friends List
//
//  Created by Nigell Dennis on 6/10/19.
//  Copyright © 2019 Nigell Dennis. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    let userSystem = UserSystem.system
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func signUp(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text, let username = usernameTextField.text else { return }
        activityIndicatorView.startAnimating()
        scrollView.isHidden = true
        dismissKeyboard()
        UserSystem.system.createAccount(email, password: password, username: username) { (success) in
            if success {
                self.usernameTextField.text = ""
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.activityIndicatorView.stopAnimating()
                self.scrollView.isHidden = false
                let mainVc = self.storyboard?.instantiateViewController(withIdentifier: "mainViewController") as! MainViewController
                self.present(mainVc, animated: true, completion: nil)
            } else {
                self.activityIndicatorView.stopAnimating()
                self.scrollView.isHidden = false
                self.presentAlert()
            }
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func presentAlert(){
        let alert = UIAlertController(title: "Warning ⚠️", message: userSystem.errorMessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func keyboard(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = UIEdgeInsets.zero
        }else{
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
