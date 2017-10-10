//
//  CardAddViewController.swift
//  JCard
//
//  Created by 민수 on 2017. 10. 7..
//  Copyright © 2017년 김민수. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class CardAddViewController: UIViewController {
    override func viewDidLoad() {
        setLayout()
        level1.tag = 1
        level2.tag = 2
        level3.tag = 3
        level4.tag = 4
        level5.tag = 5
    }
    
    @IBOutlet private var subview: UIView!
    @IBOutlet private var back: UIButton!
    @IBAction private func pressBack(sender: UIButton) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    private var cardLevel: Int?
    @IBOutlet private var level1: UIButton!
    @IBOutlet private var level2: UIButton!
    @IBOutlet private var level3: UIButton!
    @IBOutlet private var level4: UIButton!
    @IBOutlet private var level5: UIButton!
    @IBAction private func pressLevel(sender: UIButton) {
        if sender.tag == 1 {
            level1.setImage(UIImage(named: "star.png"), for: .normal)
            level2.setImage(UIImage(named: "empty_star.png"), for: .normal)
            level3.setImage(UIImage(named: "empty_star.png"), for: .normal)
            level4.setImage(UIImage(named: "empty_star.png"), for: .normal)
            level5.setImage(UIImage(named: "empty_star.png"), for: .normal)
        } else if sender.tag == 2 {
            level1.setImage(UIImage(named: "star.png"), for: .normal)
            level2.setImage(UIImage(named: "star.png"), for: .normal)
            level3.setImage(UIImage(named: "empty_star.png"), for: .normal)
            level4.setImage(UIImage(named: "empty_star.png"), for: .normal)
            level5.setImage(UIImage(named: "empty_star.png"), for: .normal)
        } else if sender.tag == 3 {
            level1.setImage(UIImage(named: "star.png"), for: .normal)
            level2.setImage(UIImage(named: "star.png"), for: .normal)
            level3.setImage(UIImage(named: "star.png"), for: .normal)
            level4.setImage(UIImage(named: "empty_star.png"), for: .normal)
            level5.setImage(UIImage(named: "empty_star.png"), for: .normal)
        } else if sender.tag == 4 {
            level1.setImage(UIImage(named: "star.png"), for: .normal)
            level2.setImage(UIImage(named: "star.png"), for: .normal)
            level3.setImage(UIImage(named: "star.png"), for: .normal)
            level4.setImage(UIImage(named: "star.png"), for: .normal)
            level5.setImage(UIImage(named: "empty_star.png"), for: .normal)
        } else if sender.tag == 5 {
            level1.setImage(UIImage(named: "star.png"), for: .normal)
            level2.setImage(UIImage(named: "star.png"), for: .normal)
            level3.setImage(UIImage(named: "star.png"), for: .normal)
            level4.setImage(UIImage(named: "star.png"), for: .normal)
            level5.setImage(UIImage(named: "star.png"), for: .normal)
        }
        cardLevel = sender.tag
        
    }
    
    @IBOutlet private var importantLabel: UILabel!
    @IBOutlet private var wordField: UITextField!
    @IBOutlet private var meaningField: UITextField!
    @IBOutlet private var extraField: UITextField!
    @IBOutlet private var save: UIButton!
    @IBAction private func pressSave(sender: UIButton) {
        if wordField.text!.lengthOfBytes(using: .utf8) < 1 {
            let alert = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("TooShortWord", comment: ""), preferredStyle: .alert)
            alert.view.tintColor = UIColor.black
            alert.addAction(UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .cancel, handler: {
                (_) in
                self.wordField.becomeFirstResponder()
            }))
            present(alert, animated: true, completion: nil)
        } else if wordField.text!.lengthOfBytes(using: .utf8) > 99 {
            let alert = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("TooShortWord", comment: ""), preferredStyle: .alert)
            alert.view.tintColor = UIColor.black
            alert.addAction(UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .cancel, handler: {
                (_) in
                self.wordField.becomeFirstResponder()
            }))
            present(alert, animated: true, completion: nil)
        } else if meaningField.text!.lengthOfBytes(using: .utf8) < 1 {
            let alert = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("TooShortMeaning", comment: ""), preferredStyle: .alert)
            alert.view.tintColor = UIColor.black
            alert.addAction(UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .cancel, handler: {
                (_) in
                self.meaningField.becomeFirstResponder()
            }))
            present(alert, animated: true, completion: nil)
        } else if meaningField.text!.lengthOfBytes(using: .utf8) > 99 {
            let alert = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("TooLongMeaning", comment: ""), preferredStyle: .alert)
            alert.view.tintColor = UIColor.black
            alert.addAction(UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .cancel, handler: {
                (_) in
                self.meaningField.becomeFirstResponder()
            }))
        } else if extraField.text!.lengthOfBytes(using: .utf8) > 2000 {
            let alert = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("TooLongExtra", comment: ""), preferredStyle: .alert)
            alert.view.tintColor = UIColor.black
            alert.addAction(UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .cancel, handler: {
                (_) in
                self.meaningField.becomeFirstResponder()
            }))
        } else {
            let data = cards()
            data.word = self.wordField.text!
            data.meaning = self.meaningField.text!
            
            if self.isGroup == true {
                data.isGroup = true
                let number = try! Realm().objects(group.self).filter("name = '\(self.groupSelect.title(for: .normal)!)'")
                data.group_number = number[0].number!
                data.group_color = number[0].color!
            }
            
            data.example1 = self.extraField.text!
            data.number = String(UserDefaults.standard.integer(forKey: "CardNumber"))
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "CardNumber")+1, forKey: "CardNumber")
            
            if cardLevel != nil {
                data.imporment = cardLevel!
            }
            
            try! Realm().write {
                try! Realm().add(data)
            }
            
            let alert = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("Registered", comment: ""), preferredStyle: .alert)
            alert.view.tintColor = UIColor.black
            alert.addAction(UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .cancel, handler: {
                (_) in
                self.view.endEditing(true)
                self.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    private var isGroup = false
    @IBOutlet private var groupSelect: UIButton!
    @IBAction private func pressGroupSelect(sender: UIButton) {
        if try! Realm().objects(group.self).count == 0 {
            let alert = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("ThereAreNoGroupToChoose", comment: ""), preferredStyle: .alert)
            alert.view.tintColor = UIColor.black
            alert.addAction(UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: NSLocalizedString("CreateGroup", comment: ""), style: .default, handler: {
                (_) in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupAddViewController")
                self.present(vc!, animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: NSLocalizedString("Group", comment: ""), message: "", preferredStyle: .actionSheet)
            alert.view.tintColor = UIColor.black
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: NSLocalizedString("NoGroup", comment: ""), style: .default, handler: {
                (_) in
                self.isGroup = false
                self.groupSelect.setTitle(NSLocalizedString("NoGroup", comment: ""), for: .normal)
            }))
            
            var count = 0
            let dd = try! Realm().objects(group.self)
            while(count < dd.count) {
                alert.addAction(UIAlertAction(title: dd[count].name!, style: .default, handler: {
                    (title) in
                    self.isGroup = true
                    self.groupSelect.setTitle(title.title!, for: .normal)
                }))
                count = count + 1
            }
            
            self.present(alert, animated: true, completion: nil)
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
            let leading = NSLayoutConstraint(item: self.back, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: GlobalInformation().top_menu_space)
            NSLayoutConstraint.activate([width,height,top,leading])
        }
        backConst()
        
        let wordConst = {
            () in
            self.wordField.translatesAutoresizingMaskIntoConstraints = false
            self.wordField.borderStyle = .none
            self.wordField.placeholder = NSLocalizedString("Word", comment: "")
            self.wordField.font = UIFont.systemFont(ofSize: GlobalInformation().tf_font_size)
            self.wordField.tintColor = UIColor.black
            SokDesigner().insertLineForTextField(obj: self.wordField)
            
            let height = NSLayoutConstraint(item: self.wordField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size)
            let top = NSLayoutConstraint(item: self.wordField, attribute: .top, relatedBy: .equal, toItem: self.subview, attribute: .top, multiplier: 1, constant: 0)
            let leading = NSLayoutConstraint(item: self.wordField, attribute: .leading, relatedBy: .equal, toItem: self.subview, attribute: .leading, multiplier: 1, constant: 5)
            let trailing = NSLayoutConstraint(item: self.wordField, attribute: .trailing, relatedBy: .equal, toItem: self.subview, attribute: .trailing, multiplier: 1, constant: -5)
            NSLayoutConstraint.activate([top,leading,trailing,height])
        }
        wordConst()
        
        let meaningConst = {
            () in
            self.meaningField.translatesAutoresizingMaskIntoConstraints = false
            self.meaningField.borderStyle = .none
            self.meaningField.placeholder = NSLocalizedString("Meaning", comment: "")
            self.meaningField.font = UIFont.systemFont(ofSize: GlobalInformation().tf_font_size)
            self.meaningField.tintColor = UIColor.black
            SokDesigner().insertLineForTextField(obj: self.meaningField)
            
            let height = NSLayoutConstraint(item: self.meaningField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size)
            let leading = NSLayoutConstraint(item: self.meaningField, attribute: .leading, relatedBy: .equal, toItem: self.subview, attribute: .leading, multiplier: 1, constant: 5)
            let trailing = NSLayoutConstraint(item: self.meaningField, attribute: .trailing, relatedBy: .equal, toItem: self.subview, attribute: .trailing, multiplier: 1, constant: -5)
            let top = NSLayoutConstraint(item: self.meaningField, attribute: .top, relatedBy: .equal, toItem: self.subview, attribute: .top, multiplier: 1, constant: 60)
            NSLayoutConstraint.activate([height,leading,trailing,top])
        }
        meaningConst()
        
        let extraConst = {
            () in
            self.extraField.translatesAutoresizingMaskIntoConstraints = false
            self.extraField.borderStyle = .none
            self.extraField.placeholder = NSLocalizedString("Example", comment: "")
            self.extraField.font = UIFont.systemFont(ofSize: GlobalInformation().tf_font_size)
            self.extraField.tintColor = UIColor.black
            SokDesigner().insertLineForTextField(obj: self.extraField)
            
            let height = NSLayoutConstraint(item: self.extraField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size)
            let leading = NSLayoutConstraint(item: self.extraField, attribute: .leading, relatedBy: .equal, toItem: self.subview, attribute: .leading, multiplier: 1, constant: 5)
            let trailing = NSLayoutConstraint(item: self.extraField, attribute: .trailing, relatedBy: .equal, toItem: self.subview, attribute: .trailing, multiplier: 1, constant: -5)
            let top = NSLayoutConstraint(item: self.extraField, attribute: .top, relatedBy: .equal, toItem: self.subview, attribute: .top, multiplier: 1, constant: 120)
            NSLayoutConstraint.activate([height,leading,trailing,top])
        }
        extraConst()
        
        let groupSelectConst = {
            () in
            self.groupSelect.translatesAutoresizingMaskIntoConstraints = false
            self.groupSelect.setTitle(NSLocalizedString("SelectGroup", comment: ""), for: .normal)
            self.groupSelect.setTitleColor(UIColor.white, for: .normal)
            self.groupSelect.backgroundColor = UIColor.darkGray
            SokDesigner().cornerRadius(obj: self.groupSelect, value: 8)
            
            let height = NSLayoutConstraint(item: self.groupSelect, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size+15)
            let leading = NSLayoutConstraint(item: self.groupSelect, attribute: .leading, relatedBy: .equal, toItem: self.subview, attribute: .leading, multiplier: 1, constant: 5)
            let trailing = NSLayoutConstraint(item: self.groupSelect, attribute: .trailing, relatedBy: .equal, toItem: self.subview, attribute: .trailing, multiplier: 1, constant: -5)
            let top = NSLayoutConstraint(item: self.groupSelect, attribute: .top, relatedBy: .equal, toItem: self.subview, attribute: .top, multiplier: 1, constant: 170)
            NSLayoutConstraint.activate([height,leading,trailing,top])
        }
        groupSelectConst()
        
        let importantLabelConst = {
            () in
            self.importantLabel.translatesAutoresizingMaskIntoConstraints = false
            self.importantLabel.text = NSLocalizedString("CardLevel", comment: "")
            self.importantLabel.textColor = UIColor.black
            
            var fontSize: CGFloat {
                if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 560 {
                    return 11
                } else {
                    return 14
                }
            }
            self.importantLabel.font = UIFont.systemFont(ofSize: fontSize)
            
            let leading = NSLayoutConstraint(item: self.importantLabel, attribute: .leading, relatedBy: .equal, toItem: self.subview, attribute: .leading, multiplier: 1, constant: 5)
            let trailing = NSLayoutConstraint(item: self.importantLabel, attribute: .trailing, relatedBy: .equal, toItem: self.subview, attribute: .trailing, multiplier: 1, constant: -5)
            let top = NSLayoutConstraint(item: self.importantLabel, attribute: .top, relatedBy: .equal, toItem: self.subview, attribute: .top, multiplier: 1, constant: 240)
            NSLayoutConstraint.activate([leading,trailing,top])
        }
        importantLabelConst()
        
        let levelButtonsConst = {
            () in
            self.level1.translatesAutoresizingMaskIntoConstraints = false
            self.level2.translatesAutoresizingMaskIntoConstraints = false
            self.level3.translatesAutoresizingMaskIntoConstraints = false
            self.level4.translatesAutoresizingMaskIntoConstraints = false
            self.level5.translatesAutoresizingMaskIntoConstraints = false
            
            self.level1.setTitle("", for: .normal)
            self.level2.setTitle("", for: .normal)
            self.level3.setTitle("", for: .normal)
            self.level4.setTitle("", for: .normal)
            self.level5.setTitle("", for: .normal)
            
            self.level1.tintColor = UIColor.darkGray
            self.level2.tintColor = UIColor.darkGray
            self.level3.tintColor = UIColor.darkGray
            self.level4.tintColor = UIColor.darkGray
            self.level5.tintColor = UIColor.darkGray
            
            self.level1.setImage(UIImage(named: "star.png"), for: .normal)
            self.level2.setImage(UIImage(named: "empty_star.png"), for: .normal)
            self.level3.setImage(UIImage(named: "empty_star.png"), for: .normal)
            self.level4.setImage(UIImage(named: "empty_star.png"), for: .normal)
            self.level5.setImage(UIImage(named: "empty_star.png"), for: .normal)
            
            let width1 = NSLayoutConstraint(item: self.level1, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size)
            let width2 = NSLayoutConstraint(item: self.level2, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size)
            let width3 = NSLayoutConstraint(item: self.level3, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size)
            let width4 = NSLayoutConstraint(item: self.level4, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size)
            let width5 = NSLayoutConstraint(item: self.level5, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size)
            NSLayoutConstraint.activate([width1,width2,width3,width4,width5])
            
            let height1 = NSLayoutConstraint(item: self.level1, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size)
            let height2 = NSLayoutConstraint(item: self.level2, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size)
            let height3 = NSLayoutConstraint(item: self.level3, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size)
            let height4 = NSLayoutConstraint(item: self.level4, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size)
            let height5 = NSLayoutConstraint(item: self.level5, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size)
            NSLayoutConstraint.activate([height1,height2,height3,height4,height5])
            
            let leading1 = NSLayoutConstraint(item: self.level1, attribute: .leading, relatedBy: .equal, toItem: self.subview, attribute: .leading, multiplier: 1, constant: 5)
            let leading2 = NSLayoutConstraint(item: self.level2, attribute: .leading, relatedBy: .equal, toItem: self.subview, attribute: .leading, multiplier: 1, constant: 50)
            let leading3 = NSLayoutConstraint(item: self.level3, attribute: .leading, relatedBy: .equal, toItem: self.subview, attribute: .leading, multiplier: 1, constant: 95)
            let leading4 = NSLayoutConstraint(item: self.level4, attribute: .leading, relatedBy: .equal, toItem: self.subview, attribute: .leading, multiplier: 1, constant: 140)
            let leading5 = NSLayoutConstraint(item: self.level5, attribute: .leading, relatedBy: .equal, toItem: self.subview, attribute: .leading, multiplier: 1, constant: 185)
            NSLayoutConstraint.activate([leading1,leading2,leading3,leading4,leading5])
            
            let top1 = NSLayoutConstraint(item: self.level1, attribute: .top, relatedBy: .equal, toItem: self.subview, attribute: .top, multiplier: 1, constant: 260)
            let top2 = NSLayoutConstraint(item: self.level2, attribute: .top, relatedBy: .equal, toItem: self.subview, attribute: .top, multiplier: 1, constant: 260)
            let top3 = NSLayoutConstraint(item: self.level3, attribute: .top, relatedBy: .equal, toItem: self.subview, attribute: .top, multiplier: 1, constant: 260)
            let top4 = NSLayoutConstraint(item: self.level4, attribute: .top, relatedBy: .equal, toItem: self.subview, attribute: .top, multiplier: 1, constant: 260)
            let top5 = NSLayoutConstraint(item: self.level5, attribute: .top, relatedBy: .equal, toItem: self.subview, attribute: .top, multiplier: 1, constant: 260)
            NSLayoutConstraint.activate([top1,top2,top3,top4,top5])
        }
        levelButtonsConst()
        
        let saveButtonConst = {
            () in
            self.save.translatesAutoresizingMaskIntoConstraints = false
            self.save.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
            self.save.setTitleColor(UIColor.white, for: .normal)
            self.save.backgroundColor = UIColor.darkGray
            SokDesigner().cornerRadius(obj: self.save, value: 8)
            
            let height = NSLayoutConstraint(item: self.save, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size+15)
            let leading = NSLayoutConstraint(item: self.save, attribute: .leading, relatedBy: .equal, toItem: self.subview, attribute: .leading, multiplier: 1, constant: 5)
            let trailing = NSLayoutConstraint(item: self.save, attribute: .trailing, relatedBy: .equal, toItem: self.subview, attribute: .trailing, multiplier: 1, constant: -5)
            let top = NSLayoutConstraint(item: self.save, attribute: .top, relatedBy: .equal, toItem: self.subview, attribute: .top, multiplier: 1, constant: 325)
            NSLayoutConstraint.activate([height,leading,trailing,top])
        }
        saveButtonConst()
    }
}
