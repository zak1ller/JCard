//
//  GroupEditViewController.swift
//  JCard
//
//  Created by 민수 on 2017. 10. 20..
//  Copyright © 2017년 김민수. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class GroupEditViewController: UIViewController {
    
    var thisData = try! Realm().objects(group.self)
    override func viewDidLoad() {
        setLayout()
    }
    
    @IBOutlet private weak var backButton: UIButton!
    @IBAction private func pressBackButton(sender: UIButton) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var groupNameField: UITextField!
    @IBAction private func didChangedGroupNameField(sender: UITextField) {
        if sender.text!.lengthOfBytes(using: .utf8) < 1 {
            saveButton.isHidden = true
        } else if sender.text!.lengthOfBytes(using: .utf8) > 50 {
            saveButton.isHidden = true
        } else {
            saveButton.isHidden = false
        }
    }
    
    @IBOutlet private weak var saveButton: UIButton!
    @IBAction private func pressSave(sender: UIButton) {
        try! Realm().write {
            self.thisData[0].name = self.groupNameField.text!
        }
        
        let alert = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("ChangedGroupName", comment: ""), preferredStyle: .alert)
        present(alert, animated: true, completion: {
            sleep(1)
            self.dismiss(animated: true, completion: {
                self.dismiss(animated: true, completion: nil)
            })
        })
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
        
        let messageLabelConst = {
            () in
            self.messageLabel.translatesAutoresizingMaskIntoConstraints = false
            self.messageLabel.text = NSLocalizedString("EnterGroupName", comment: "")
            self.messageLabel.textAlignment = .center
            self.messageLabel.textColor = UIColor.black
            self.messageLabel.adjustsFontSizeToFitWidth = true
            self.messageLabel.numberOfLines = 1
            self.messageLabel.minimumScaleFactor = 0.1
            var messageFont: CGFloat {
                if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 560 {
                    return 13.5
                } else {
                    return 17
                }
            }
            self.messageLabel.font = UIFont.systemFont(ofSize: messageFont)
            
            let centerX = NSLayoutConstraint(item: self.messageLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
            let centerY = NSLayoutConstraint(item: self.messageLabel, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: -50)
            let leading = NSLayoutConstraint(item: self.messageLabel, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 20)
            let trailing = NSLayoutConstraint(item: self.messageLabel, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -20)
            NSLayoutConstraint.activate([centerX,centerY,leading,trailing])
        }
        messageLabelConst()
        
        let groupNameFieldConst = {
            () in
            self.groupNameField.translatesAutoresizingMaskIntoConstraints = false
            self.groupNameField.borderStyle = .none
            self.groupNameField.tintColor = UIColor.black
            self.groupNameField.textAlignment = .center
            self.groupNameField.textColor = UIColor.darkGray
            var groupFont: CGFloat {
                if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 560 {
                    return 16
                } else {
                    return 20
                }
            }
            self.groupNameField.font = UIFont.systemFont(ofSize: groupFont)
            self.groupNameField.becomeFirstResponder()
            SokDesigner().insertLineForTextField(obj: self.groupNameField)
            
            let centerX = NSLayoutConstraint(item: self.groupNameField, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
            let centerY = NSLayoutConstraint(item: self.groupNameField, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
            let leading = NSLayoutConstraint(item: self.groupNameField, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 20)
            let trailing = NSLayoutConstraint(item: self.groupNameField, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -20)
            let height = NSLayoutConstraint(item: self.groupNameField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size*1.25)
            NSLayoutConstraint.activate([centerX,centerY,leading,trailing,height])
        }
        groupNameFieldConst()
        
        let saveButtonConst = {
            () in
            self.saveButton.translatesAutoresizingMaskIntoConstraints = false
            self.saveButton.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
            self.saveButton.setTitleColor(UIColor.black, for: .normal)
            self.saveButton.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
            SokDesigner().cornerRadius(obj: self.saveButton, value: 2)
            var fontSize: CGFloat {
                if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 560 {
                    return 16
                } else {
                    return 20
                }
            }
            self.saveButton.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .black)
            self.saveButton.isHidden = true
            
            let width = NSLayoutConstraint(item: self.saveButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size*5)
            let height = NSLayoutConstraint(item: self.saveButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size*1.5)
            let centerX = NSLayoutConstraint(item: self.saveButton, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
            let top = NSLayoutConstraint(item: self.saveButton, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 100)
            NSLayoutConstraint.activate([width,height,centerX,top])
        }
        saveButtonConst()
    }
}
