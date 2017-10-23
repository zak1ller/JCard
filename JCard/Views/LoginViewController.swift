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
        
    }
    @IBOutlet private weak var signUpButton: UIButton!
    @IBAction private func pressSignUp(sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")
        present(vc!, animated: true, completion: nil)
    }
    @IBOutlet private weak var findPassword: UIButton!
    @IBAction private func pressFindPassword(sender: UIButton) {
        
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
            self.idField.translatesAutoresizingMaskIntoConstraints = false
            self.idField.font = UIFont.systemFont(ofSize: fieldFontSize)
            self.idField.borderStyle = .none
            self.idField.placeholder = "Username"
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
            self.pwField.translatesAutoresizingMaskIntoConstraints = false
            self.pwField.font = UIFont.systemFont(ofSize: fieldFontSize)
            self.pwField.borderStyle = .none
            self.pwField.placeholder = "Password"
            self.pwField.isSecureTextEntry = true
            self.pwField.tintColor = UIColor.black
            self.pwField.textAlignment = .center
            self.pwField.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
            SokDesigner().cornerRadius(obj: self.pwField, value: 8)
            
            let height = NSLayoutConstraint(item: self.pwField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size*1.25)
            let leading = NSLayoutConstraint(item: self.pwField, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 20)
            let trailing = NSLayoutConstraint(item: self.pwField, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -20)
            let top = NSLayoutConstraint(item: self.pwField, attribute: .top, relatedBy: .equal, toItem: self.idField, attribute: .top, multiplier: 1, constant: GlobalInformation().tf_font_size*1.25+30)
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
            self.loginButton.backgroundColor = GlobalInformation().color_lightBlue
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
            self.signUpButton.backgroundColor = GlobalInformation().color_lightBlue
            self.signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize, weight: .black)
            SokDesigner().cornerRadius(obj: self.signUpButton, value: 4)
            
            let height = NSLayoutConstraint(item: self.signUpButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size*1.25)
            let top = NSLayoutConstraint(item: self.signUpButton, attribute: .top, relatedBy: .equal, toItem: self.pwField, attribute: .top, multiplier: 1, constant: GlobalInformation().tf_height_size*1.25+20)
            let trailing = NSLayoutConstraint(item: self.signUpButton, attribute: .trailing, relatedBy: .equal, toItem: self.pwField, attribute: .trailing, multiplier: 1, constant: 0)
            let leading = NSLayoutConstraint(item: self.signUpButton, attribute: .leading, relatedBy: .equal, toItem: self.pwField, attribute: .leading, multiplier: 1, constant: UIScreen.main.bounds.width/2.15)
            NSLayoutConstraint.activate([height,top,trailing,leading])
        }
        signUpButtonConst()
        
        let findPasswordConst = {
            () in
            self.findPassword.translatesAutoresizingMaskIntoConstraints = false
            self.findPassword.setTitle(NSLocalizedString("FindPassword", comment: ""), for: .normal)
            
            let height = NSLayoutConstraint(item: self.findPassword, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size*1.1)
            let leading = NSLayoutConstraint(item: self.findPassword, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 20)
            let trailing = NSLayoutConstraint(item: self.findPassword, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -20)
            let top = NSLayoutConstraint(item: self.findPassword, attribute: .top, relatedBy: .equal, toItem: self.signUpButton, attribute: .top, multiplier: 1, constant: GlobalInformation().tf_height_size+20)
            NSLayoutConstraint.activate([height,leading,trailing,top])
        }
        findPasswordConst()
    }
}
