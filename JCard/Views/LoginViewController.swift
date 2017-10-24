//
//  LoginViewController.swift
//  JCard
//
//  Created by 민수 on 2017. 10. 22..
//  Copyright © 2017년 김민수. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class LoginViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        setLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        if let useData = UserDefaults.standard.string(forKey: "username") {
            print(useData)
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet private weak var backButton: UIButton!
    @IBAction private func pressBackButton(sender: UIButton) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet private weak var idField: UITextField!
    @IBOutlet private weak var pwField: UITextField!
    
    @IBOutlet private weak var loginButton: UIButton!
    @IBAction private func pressLoginButton(sender: UIButton) {
        let usid = idField.text!
        let pwd = pwField.text!
        if idField.text!.lengthOfBytes(using: .utf8) < 4 || pwField.text!.lengthOfBytes(using: .utf8) < 4 {
            let alert = MinsuLibrarys().alert_confirm(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("DoNotMatchIDPW", comment: ""))
            present(alert, animated: true, completion: nil)
        } else {
            BackUpViewBrain().isConnectToNetwork(handler: {
                res in
                if res == false {
                    let alert = MinsuLibrarys().alert_confirm(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("NetworkFailed", comment: ""))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    BackUpViewBrain().login(username: usid, password: pwd, complete: {
                        res in
                        DispatchQueue.main.async(execute: {
                            if res == "False" {
                                let alert = MinsuLibrarys().alert_confirm(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("DoNotMatchIDPW", comment: ""))
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                UserDefaults.standard.set(usid, forKey: "username")
                                UserDefaults.standard.set(pwd, forKey: "password")
                                let alert = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("SignedIn", comment: ""), preferredStyle: .alert)
                                alert.view.tintColor = UIColor.black
                                alert.addAction(UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .cancel, handler: {
                                    (_) in
                                    self.viewWillAppear(true)
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                        })
                    })
                }
            })
        }
    }
    @IBOutlet private weak var signUpButton: UIButton!
    @IBAction private func pressSignUp(sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")
        present(vc!, animated: true, completion: nil)
    }
    
    private func setLayout() {
        let backConst = {
            () in
            self.backButton.translatesAutoresizingMaskIntoConstraints = false
            self.backButton.tintColor = UIColor.black
            self.backButton.setTitle("", for: .normal)
            self.backButton.setImage(UIImage(named: "left.png"), for: .normal)
            
            let width = NSLayoutConstraint(item: self.backButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size)
            let height = NSLayoutConstraint(item: self.backButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size)
            let top = NSLayoutConstraint(item: self.backButton, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: GlobalInformation().top_menu_top_size)
            let leading = NSLayoutConstraint(item: self.backButton, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: GlobalInformation().top_menu_space)
            NSLayoutConstraint.activate([width,height,top,leading])
        }
        backConst()
        
        var fieldFontSize: CGFloat {
            if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 560 {
                return 12
            } else {
                return 15
            }
        }
        let idFieldConst = {
            () in
            self.idField.keyboardType = .asciiCapable
            self.idField.translatesAutoresizingMaskIntoConstraints = false
            self.idField.font = UIFont.systemFont(ofSize: fieldFontSize)
            self.idField.borderStyle = .none
            self.idField.placeholder = NSLocalizedString("Username", comment: "")
            self.idField.tintColor = UIColor.black
            self.idField.textAlignment = .center
            self.idField.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
            SokDesigner().cornerRadius(obj: self.idField, value: 8)
            
            let height = NSLayoutConstraint(item: self.idField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size*1.25)
            let leading = NSLayoutConstraint(item: self.idField, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 20)
            let trailing = NSLayoutConstraint(item: self.idField, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -20)
            let top = NSLayoutConstraint(item: self.idField, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 80)
            NSLayoutConstraint.activate([height,leading,trailing,top])
        }
        idFieldConst()
        
        let pwFieldConst = {
            () in
            self.pwField.keyboardType = .numberPad
            self.pwField.translatesAutoresizingMaskIntoConstraints = false
            self.pwField.font = UIFont.systemFont(ofSize: fieldFontSize)
            self.pwField.borderStyle = .none
            self.pwField.placeholder = NSLocalizedString("Password", comment: "")
            self.pwField.isSecureTextEntry = true
            self.pwField.tintColor = UIColor.black
            self.pwField.textAlignment = .center
            self.pwField.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
            SokDesigner().cornerRadius(obj: self.pwField, value: 8)
            
            let height = NSLayoutConstraint(item: self.pwField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size*1.25)
            let leading = NSLayoutConstraint(item: self.pwField, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 20)
            let trailing = NSLayoutConstraint(item: self.pwField, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -20)
            let top = NSLayoutConstraint(item: self.pwField, attribute: .top, relatedBy: .equal, toItem: self.idField, attribute: .top, multiplier: 1, constant: GlobalInformation().tf_height_size*1.25+20)
            NSLayoutConstraint.activate([height,leading,trailing,top])
        }
        pwFieldConst()
        
        var buttonFontSize: CGFloat {
            if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 560 {
                return 13.5
            } else {
                return 17
            }
        }
        let loginButtonConst = {
            () in
            self.loginButton.translatesAutoresizingMaskIntoConstraints = false
            self.loginButton.setTitle(NSLocalizedString("SignIn", comment: ""), for: .normal)
            self.loginButton.backgroundColor = UIColor.darkGray
            self.loginButton.setTitleColor(UIColor.white, for: .normal)
            self.loginButton.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize, weight: .black)
            SokDesigner().cornerRadius(obj: self.loginButton, value: 4)
            
            let height = NSLayoutConstraint(item: self.loginButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size*1.25)
            let top = NSLayoutConstraint(item: self.loginButton, attribute: .top, relatedBy: .equal, toItem: self.pwField, attribute: .top, multiplier: 1, constant: GlobalInformation().tf_height_size*1.25+20)
            let leading = NSLayoutConstraint(item: self.loginButton, attribute: .leading, relatedBy: .equal, toItem: self.pwField, attribute: .leading, multiplier: 1, constant: 0)
            let trailing = NSLayoutConstraint(item: self.loginButton, attribute: .trailing, relatedBy: .equal, toItem: self.pwField, attribute: .trailing, multiplier: 1, constant: -(UIScreen.main.bounds.width/2.15))
            NSLayoutConstraint.activate([height,top,leading,trailing])
        }
        loginButtonConst()
        
        let signUpButtonConst = {
            () in
            self.signUpButton.translatesAutoresizingMaskIntoConstraints = false
            self.signUpButton.setTitle(NSLocalizedString("SignUp", comment: ""), for: .normal)
            self.signUpButton.setTitleColor(UIColor.white, for: .normal)
            self.signUpButton.backgroundColor = UIColor.darkGray
            self.signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize, weight: .black)
            SokDesigner().cornerRadius(obj: self.signUpButton, value: 4)
            
            let height = NSLayoutConstraint(item: self.signUpButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size*1.25)
            let top = NSLayoutConstraint(item: self.signUpButton, attribute: .top, relatedBy: .equal, toItem: self.pwField, attribute: .top, multiplier: 1, constant: GlobalInformation().tf_height_size*1.25+20)
            let trailing = NSLayoutConstraint(item: self.signUpButton, attribute: .trailing, relatedBy: .equal, toItem: self.pwField, attribute: .trailing, multiplier: 1, constant: 0)
            let leading = NSLayoutConstraint(item: self.signUpButton, attribute: .leading, relatedBy: .equal, toItem: self.pwField, attribute: .leading, multiplier: 1, constant: UIScreen.main.bounds.width/2.15)
            NSLayoutConstraint.activate([height,top,trailing,leading])
        }
        signUpButtonConst()
    }
}
