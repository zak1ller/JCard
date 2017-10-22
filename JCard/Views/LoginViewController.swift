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
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        setLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    
    @IBOutlet private weak var backButton: UIButton!
    @IBAction private func pressBackButton(sender: UIButton) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet private weak var fieldBackground: UIView!
    @IBOutlet private weak var idField: UITextField!
    @IBOutlet private weak var pwField: UITextField!
    
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
        
        let fieldBackgroundConst = {
            () in
            self.fieldBackground.translatesAutoresizingMaskIntoConstraints = false
            self.fieldBackground.backgroundColor = UIColor.white
            SokDesigner().cornerRadius(obj: self.fieldBackground, value: 16)
            
            let top = NSLayoutConstraint(item: self.fieldBackground, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 90)
            let leading = NSLayoutConstraint(item: self.fieldBackground, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 30)
            let trailing = NSLayoutConstraint(item: self.fieldBackground, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -30)
            let height = NSLayoutConstraint(item: self.fieldBackground, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
            NSLayoutConstraint.activate([top,leading,trailing,height])
        }
        fieldBackgroundConst()
        
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
            self.idField.font = UIFont.systemFont(ofSize: fieldFontSize, weight: .medium)
            self.idField.borderStyle = .none
            self.idField.placeholder = "Username"
            self.idField.tintColor = UIColor.black
            self.idField.textAlignment = .center
            self.idField.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
            SokDesigner().cornerRadius(obj: self.idField, value: 12)
            
            let height = NSLayoutConstraint(item: self.idField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size*1.25)
            let leading = NSLayoutConstraint(item: self.idField, attribute: .leading, relatedBy: .equal, toItem: self.fieldBackground, attribute: .leading, multiplier: 1, constant: 20)
            let trailing = NSLayoutConstraint(item: self.idField, attribute: .trailing, relatedBy: .equal, toItem: self.fieldBackground, attribute: .trailing, multiplier: 1, constant: -20)
            let top = NSLayoutConstraint(item: self.idField, attribute: .top, relatedBy: .equal, toItem: self.fieldBackground, attribute: .top, multiplier: 1, constant: 20)
            NSLayoutConstraint.activate([height,leading,trailing,top])
        }
        idFieldConst()
        
        let pwFieldConst = {
            () in
            self.pwField.translatesAutoresizingMaskIntoConstraints = false
            self.pwField.font = UIFont.systemFont(ofSize: fieldFontSize, weight: .medium)
            self.pwField.borderStyle = .none
            self.pwField.placeholder = "Password"
            self.pwField.isSecureTextEntry = true
            self.pwField.tintColor = UIColor.black
            self.pwField.textAlignment = .center
            self.pwField.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
            SokDesigner().cornerRadius(obj: self.pwField, value: 12)
            
            let height = NSLayoutConstraint(item: self.pwField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size*1.25)
            let leading = NSLayoutConstraint(item: self.pwField, attribute: .leading, relatedBy: .equal, toItem: self.fieldBackground, attribute: .leading, multiplier: 1, constant: 20)
            let trailing = NSLayoutConstraint(item: self.pwField, attribute: .trailing, relatedBy: .equal, toItem: self.fieldBackground, attribute: .trailing, multiplier: 1, constant: -20)
            let top = NSLayoutConstraint(item: self.pwField, attribute: .top, relatedBy: .equal, toItem: self.fieldBackground, attribute: .top, multiplier: 1, constant: 20+(GlobalInformation().tf_height_size*1.25)+20)
            NSLayoutConstraint.activate([height,leading,trailing,top])
        }
        pwFieldConst()
    }
}
