//
//  GroupAddViewController.swift
//  JCard
//
//  Created by 민수 on 2017. 10. 7..
//  Copyright © 2017년 김민수. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class GroupAddViewController: UIViewController {
    override func viewDidLoad() {
        setLayout()
    }
    
    private var gColor: UIColor? {
        willSet(new) {
            if new  == UIColor.red {
                self.groupColor.setTitle(NSLocalizedString("Red", comment: ""), for: .normal)
                new?.accessibilityValue = "Red"
            } else if new == UIColor.green {
                self.groupColor.setTitle(NSLocalizedString("Green", comment: ""), for: .normal)
                new?.accessibilityValue = "Green"
            } else if new == UIColor.blue {
                self.groupColor.setTitle(NSLocalizedString("Blue", comment: ""), for: .normal)
                new?.accessibilityValue = "Blue"
            } else if new == UIColor.gray {
                self.groupColor.setTitle(NSLocalizedString("Gray", comment: ""), for: .normal)
                new?.accessibilityValue = "Gray"
            } else if new == UIColor.black {
                self.groupColor.setTitle(NSLocalizedString("Black", comment: ""), for: .normal)
                new?.accessibilityValue = "Black"
            }
        }
    }
    
    @IBOutlet private var back: UIButton!
    @IBAction private func pressBack(sender: UIButton) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet private var groupColor: UIButton!
    @IBAction private func pressGroupColor(sender: UIButton) {
        let alert = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("SelectGroupColor", comment: ""), preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor.black
        alert.addAction(UIAlertAction(title: NSLocalizedString("Red", comment: ""), style: .default, handler: {
            (_) in
            self.groupColor.backgroundColor = GlobalInformation().card_color_red
            self.gColor = UIColor.red
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Green", comment: ""), style: .default, handler: {
            (_) in
            self.groupColor.backgroundColor = GlobalInformation().card_color_green
            self.gColor = UIColor.green
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Blue", comment: ""), style: .default, handler: {
            (_) in
            self.groupColor.backgroundColor = GlobalInformation().card_color_blue
            self.gColor = UIColor.blue
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Black", comment: ""), style: .default, handler: {
            (_) in
            self.groupColor.backgroundColor = GlobalInformation().card_color_black
            self.gColor = UIColor.black
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Gray", comment: ""), style: .default, handler: {
            (_) in
            self.groupColor.backgroundColor = UIColor.lightGray
            self.gColor = UIColor.gray
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    @IBOutlet private var groupField: UITextField!
    @IBOutlet private var save: UIButton!
    @IBAction private func pressSave(sender: UIButton) {
        if groupField.text!.lengthOfBytes(using: .utf8) == 0 {
            let alert = MinsuLibrarys().alert_confirm(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("TooShortName", comment: ""))
            present(alert, animated: true, completion: nil)
        } else if groupField.text!.lengthOfBytes(using: .utf8) > 20 {
            let alert = MinsuLibrarys().alert_confirm(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("CanNotOverLengthGroup", comment: ""))
            present(alert, animated: true, completion: nil)
        } else if try! Realm().objects(group.self).filter("name = '\(self.groupField.text!)'").count > 0 {
            let alert = MinsuLibrarys().alert_confirm(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("AlreadyName", comment: ""))
            present(alert, animated: true, completion: nil)
        } else if gColor == nil {
            let alert = MinsuLibrarys().alert_confirm(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("SelectGroupColor", comment: ""))
            present(alert, animated: true, completion: nil)
        } else {
            let data = group()
            data.color = gColor?.accessibilityValue!
            data.name = groupField.text!
            data.number = String(UserDefaults.standard.integer(forKey: "GroupNumber"))
            let resum = UserDefaults.standard.integer(forKey: "GroupNumber") + 1
            UserDefaults.standard.set(resum, forKey: "GroupNumber")
            
            try! Realm().write {
                try! Realm().add(data)
            }
            
           let alert = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("Registered", comment: ""), preferredStyle: .alert)
            present(alert, animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    self.dismiss(animated: true, completion: {
                        self.view.endEditing(true)
                        self.dismiss(animated: true, completion: nil)
                    })
                })
            })
        }
        
    }
    
    private func setLayout() {
        let backConst = {
            () in
            self.back.translatesAutoresizingMaskIntoConstraints = false
            self.back.tintColor = UIColor.black
            self.back.setTitle("", for: .normal)
            self.back.setImage(UIImage(named: "left.png"), for: .normal)
            
            let width = NSLayoutConstraint(item: self.back, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size)
            let height = NSLayoutConstraint(item: self.back, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size)
            let top = NSLayoutConstraint(item: self.back, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: GlobalInformation().top_menu_top_size)
            let leading = NSLayoutConstraint(item: self.back, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 5)
            NSLayoutConstraint.activate([width,height,top,leading])
        }
        backConst()
        
        let groupFieldConst = {
            () in
            self.groupField.translatesAutoresizingMaskIntoConstraints = false
            self.groupField.tintColor = UIColor.black
            self.groupField.font = UIFont.systemFont(ofSize: GlobalInformation().tf_font_size-2)
            self.groupField.textAlignment = .center
            self.groupField.becomeFirstResponder()
            self.groupField.placeholder = NSLocalizedString("GroupName", comment: "")
            
            let leading = NSLayoutConstraint(item: self.groupField, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 5)
            let trailing = NSLayoutConstraint(item: self.groupField, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -5)
            let height = NSLayoutConstraint(item: self.groupField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size)
            let top = NSLayoutConstraint(item: self.groupField, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 100)
            NSLayoutConstraint.activate([leading,trailing,height,top])
        }
        groupFieldConst()
        
        let groupColorConst = {
            () in
            self.groupColor.translatesAutoresizingMaskIntoConstraints = false
            self.groupColor.setTitle(NSLocalizedString("SelectGroupColor", comment: ""), for: .normal)
            self.groupColor.setTitleColor(UIColor.white, for: .normal)
            self.groupColor.backgroundColor = UIColor.darkGray
            SokDesigner().cornerRadius(obj: self.groupColor, value: 8)
            
            let height = NSLayoutConstraint(item: self.groupColor, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size)
            let leading = NSLayoutConstraint(item: self.groupColor, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 5)
            let trailing = NSLayoutConstraint(item: self.groupColor, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -5)
            let top = NSLayoutConstraint(item: self.groupColor, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 150)
            NSLayoutConstraint.activate([leading,trailing,height,top])
        }
        groupColorConst()
        
        let saveConst = {
            () in
            self.save.translatesAutoresizingMaskIntoConstraints = false
            self.save.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
            self.save.setTitleColor(UIColor.white, for: .normal)
            self.save.backgroundColor = UIColor.darkGray
            SokDesigner().cornerRadius(obj: self.save, value: 8)
            
            let height = NSLayoutConstraint(item: self.save, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size)
            let leading = NSLayoutConstraint(item: self.save, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 5)
            let trailing = NSLayoutConstraint(item: self.save, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -5)
            let top = NSLayoutConstraint(item: self.save, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 200)
            NSLayoutConstraint.activate([leading,trailing,height,top])
        }
        saveConst()
    }
}
