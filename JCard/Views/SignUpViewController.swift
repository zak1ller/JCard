//
//  SignUpViewController.swift
//  JCard
//
//  Created by 민수 on 2017. 10. 23..
//  Copyright © 2017년 김민수. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class SignUpViewController: UIViewController {
    override func viewDidLoad() {
        setLayout()
        usernameField.tag = 1
        passwordField.tag = 2
        passwordField2.tag = 3
    }
    
    @IBOutlet private weak var backButton: UIButton!
    @IBAction private func pressBackButton(sender: UIButton) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var passwordField2: UITextField!
    @IBAction private func fieldBegin(sender: UITextField) {
        if usernameField.text!.lengthOfBytes(using: .utf8) < 4 {
            self.saveButton.isEnabled = false
            self.saveButton.alpha = 0.25
        } else if passwordField.text!.lengthOfBytes(using: .utf8) < 4 {
            self.saveButton.isEnabled = false
            self.saveButton.alpha = 0.25
        } else if passwordField2.text!.lengthOfBytes(using: .utf8) < 4 {
            self.saveButton.isEnabled = false
            self.saveButton.alpha = 0.25
        } else {
            self.saveButton.isEnabled = true
            self.saveButton.alpha = 1
        }
    }
    
    @IBOutlet private weak var saveButton: UIButton!
    @IBAction private func pressSaveButton(sender: UIButton) {
        let usname = usernameField.text!
        let pwd = passwordField2.text!
        if usernameField.text!.lengthOfBytes(using: .utf8) > 30 {
            let alert = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("MaxID", comment: ""), preferredStyle: .alert)
            self.present(alert, animated: true, completion: {
                sleep(1)
                self.dismiss(animated: true, completion: {
                    self.usernameField.becomeFirstResponder()
                })
            })
        } else if passwordField.text!.lengthOfBytes(using: .utf8) > 50 {
            let alert = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("MaxPW", comment: ""), preferredStyle: .alert)
            self.present(alert, animated: true, completion: {
                sleep(1)
                self.dismiss(animated: true, completion: {
                    self.passwordField.becomeFirstResponder()
                })
            })
        } else if passwordField.text !=  passwordField2.text {
            let alert = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("DoNotMatchPW", comment: ""), preferredStyle: .alert)
            self.present(alert, animated: true, completion: {
                sleep(1)
                self.dismiss(animated: true, completion: nil)
            })
        } else {
            BackUpViewBrain().isConnectToNetwork(handler: {
                result in
                if result == false {
                    let alert = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("NetworkFailed", comment: ""), preferredStyle: .alert)
                    self.present(alert, animated: true, completion: {
                        sleep(1)
                        self.dismiss(animated: true, completion: nil)
                    })
                } else {
                    BackUpViewBrain().CheckAlreadyAccount(username: usname, complete: {
                        res in
                        if res == "IsAlready" {
                            DispatchQueue.main.async(execute: {
                                let alert = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("IsAlreadyAccount", comment: ""), preferredStyle: .alert)
                                alert.view.tintColor = UIColor.black
                                alert.addAction(UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .cancel, handler: {
                                    (_) in
                                    self.usernameField.becomeFirstResponder()
                                }))
                                self.present(alert, animated: true, completion: nil)
                            })
                        } else {
                                BackUpViewBrain().CreateAccount(username: usname, pw: pwd, complete: {
                                    res in
                                    DispatchQueue.main.async(execute: {
                                        if res == "Failed Creating" {
                                            let alert = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("FailedCreatingAccount", comment: ""), preferredStyle: .alert)
                                            alert.view.tintColor = UIColor.black
                                            alert.addAction(UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .cancel, handler: nil))
                                            self.present(alert, animated: true, completion: nil)
                                        } else if res == "Success Creating" {
                                            let alert = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("SuccessCreatingAccount", comment: ""), preferredStyle: .alert)
                                            alert.view.tintColor = UIColor.black
                                            alert.addAction(UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .cancel, handler: {
                                                (_) in
                                                self.dismiss(animated: true, completion: nil)
                                            }))
                                            self.present(alert, animated: true, completion: {
                                                UserDefaults.standard.set(usname, forKey: "username")
                                                UserDefaults.standard.set(pwd, forKey: "password")
                                            })
                                        }
                                    })
                            })
                        }
                    })
                }
            })
        }
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
        let usernameFieldConst = {
            () in
            self.usernameField.translatesAutoresizingMaskIntoConstraints = false
            self.usernameField.placeholder = NSLocalizedString("EnterID", comment: "")
            self.usernameField.textAlignment = .center
            self.usernameField.borderStyle = .none
            self.usernameField.keyboardType = .asciiCapable
            self.usernameField.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
            self.usernameField.font = UIFont.systemFont(ofSize: fieldFontSize)
            self.usernameField.tintColor = UIColor.black
            SokDesigner().cornerRadius(obj: self.usernameField, value: 8)
            
            let height = NSLayoutConstraint(item: self.usernameField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size*1.25)
            let leading = NSLayoutConstraint(item: self.usernameField, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 20)
            let trailing = NSLayoutConstraint(item: self.usernameField, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -20)
            let top = NSLayoutConstraint(item: self.usernameField, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 80)
            NSLayoutConstraint.activate([leading,trailing,top,height])
        }
        usernameFieldConst()
        
        let passwordConst = {
            () in
            self.passwordField.translatesAutoresizingMaskIntoConstraints = false
            self.passwordField.placeholder = NSLocalizedString("EnterPW", comment: "")
            self.passwordField.textAlignment = .center
            self.passwordField.borderStyle = .none
            self.passwordField.keyboardType = .numberPad
            self.passwordField.tintColor = UIColor.black
            self.passwordField.isSecureTextEntry = true
            self.passwordField.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
            self.passwordField.font = UIFont.systemFont(ofSize: fieldFontSize)
            SokDesigner().cornerRadius(obj: self.passwordField, value: 8)
            
            let height = NSLayoutConstraint(item: self.passwordField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size*1.25)
            let leading = NSLayoutConstraint(item: self.passwordField, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 20)
            let trailing = NSLayoutConstraint(item: self.passwordField, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -20)
            let top = NSLayoutConstraint(item: self.passwordField, attribute: .top, relatedBy: .equal, toItem: self.usernameField, attribute: .top, multiplier: 1, constant: GlobalInformation().tf_height_size*1.25+20)
            NSLayoutConstraint.activate([leading,trailing,top,height])
        }
        passwordConst()
        
        let passwordConst2 = {
            () in
            self.passwordField2.translatesAutoresizingMaskIntoConstraints = false
            self.passwordField2.placeholder = NSLocalizedString("MoreCheckPassword", comment: "")
            self.passwordField2.textAlignment = .center
            self.passwordField2.borderStyle = .none
            self.passwordField2.tintColor = UIColor.black
            self.passwordField2.keyboardType = .numberPad
            self.passwordField2.isSecureTextEntry = true
            self.passwordField2.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
            self.passwordField2.font = UIFont.systemFont(ofSize: fieldFontSize)
            SokDesigner().cornerRadius(obj: self.passwordField2, value: 8)
            
            let height = NSLayoutConstraint(item: self.passwordField2, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size*1.25)
            let leading = NSLayoutConstraint(item: self.passwordField2, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 20)
            let trailing = NSLayoutConstraint(item: self.passwordField2, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -20)
            let top = NSLayoutConstraint(item: self.passwordField2, attribute: .top, relatedBy: .equal, toItem: self.passwordField, attribute: .top, multiplier: 1, constant: GlobalInformation().tf_height_size*1.25+20)
            NSLayoutConstraint.activate([leading,trailing,top,height])
        }
        passwordConst2()
        
        let saveButtonConst = {
            () in
            self.saveButton.translatesAutoresizingMaskIntoConstraints = false
            self.saveButton.setTitle(NSLocalizedString("SignUp", comment: ""), for: .normal)
            self.saveButton.setTitleColor(UIColor.white, for: .normal)
            self.saveButton.backgroundColor = UIColor.red
            self.saveButton.isEnabled = false
            self.saveButton.alpha = 0.25
            
            var fontSize: CGFloat {
                if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 560 {
                    return 13.5
                } else {
                    return 17
                }
            }
            self.saveButton.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .black)
            SokDesigner().cornerRadius(obj: self.saveButton, value: 4)
            
            let height = NSLayoutConstraint(item: self.saveButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size*1.5)
            let top = NSLayoutConstraint(item: self.saveButton, attribute: .top, relatedBy: .equal, toItem: self.passwordField2, attribute: .top, multiplier: 1, constant: GlobalInformation().tf_height_size*1.25+30)
            let leading = NSLayoutConstraint(item: self.saveButton, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 20)
            let trailing = NSLayoutConstraint(item: self.saveButton, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -20)
            NSLayoutConstraint.activate([top,height,leading,trailing])
        }
        saveButtonConst()
    }
}
