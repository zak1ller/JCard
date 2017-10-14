//
//  CardEditViewController.swift
//  JCard
//
//  Created by 민수 on 2017. 10. 14..
//  Copyright © 2017년 김민수. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class CardEditViewController: UIViewController {
    override func viewDidLoad() {
        if number != nil {
            card = try! Realm().objects(cards.self).filter("number = '\(number!)'")
        }
        setLayout()
    }
    
    internal var number: String?
    private var card = try! Realm().objects(cards.self)
    
    @IBOutlet private var backButton: UIButton!
    @IBAction private func pressBackButton(sender: UIButton) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet private var wordField: UITextField!
    @IBOutlet private var meaningField: UITextField!
    @IBOutlet private var exampleField: UITextField!
    
    @IBOutlet private var saveButton: UIButton!
    @IBAction private func pressSaveButton(sender: UIButton) {
        if wordField.text != card[0].word {
            if wordField.text!.lengthOfBytes(using: .utf8) < 1 {
                let alert = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("TooShortWord", comment: ""), preferredStyle: .alert)
                self.present(alert, animated: true, completion: {
                    sleep(1)
                    self.dismiss(animated: true, completion: {
                        self.wordField.becomeFirstResponder()
                    })
                })
                return
            } else if wordField.text!.lengthOfBytes(using: .utf8) > 200 {
                let alert = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("TooLongWord", comment: ""), preferredStyle: .alert)
                self.present(alert, animated: true, completion: {
                    sleep(1)
                    self.dismiss(animated: true, completion: {
                        self.wordField.becomeFirstResponder()
                    })
                })
                return
            }
        }
        
        if meaningField.text != card[0].meaning {
            if meaningField.text!.lengthOfBytes(using: .utf8) < 1 {
                let alert = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("TooShortMeaning", comment: ""), preferredStyle: .alert)
                self.present(alert, animated: true, completion: {
                    sleep(1)
                    self.dismiss(animated: true, completion: {
                        self.meaningField.becomeFirstResponder()
                    })
                })
                return
            } else if meaningField.text!.lengthOfBytes(using: .utf8) > 200 {
                let alert = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("TooLongMeaning", comment: ""), preferredStyle: .alert)
                self.present(alert, animated: true, completion: {
                    sleep(1)
                    self.dismiss(animated: true, completion: {
                        self.meaningField.becomeFirstResponder()
                    })
                })
                return
            }
        }
        
        if exampleField.text != card[0].example1 {
            if exampleField.text!.lengthOfBytes(using: .utf8) > 2000 {
                let alert = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("TooLongExtra", comment: ""), preferredStyle: .alert)
                self.present(alert, animated: true, completion: {
                    sleep(1)
                    self.dismiss(animated: true, completion: {
                        self.exampleField.becomeFirstResponder()
                    })
                })
                return
            }
        }
        
        try! Realm().write {
            self.card[0].word = self.wordField.text!
            self.card[0].meaning = self.meaningField.text!
            self.card[0].example1 = self.exampleField.text!
        }
        
        let alert = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("ChangedCard", comment: ""), preferredStyle: .alert)
        present(alert, animated: true, completion: {
            self.view.endEditing(true)
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
        
        let wordFieldConst = {
            () in
            self.wordField.translatesAutoresizingMaskIntoConstraints = false
            self.wordField.borderStyle = .none
            SokDesigner().insertLineForTextField(obj: self.wordField)
            
            let groupData = try! Realm().objects(group.self).filter("number = '\(self.card[0].group_number!)'")[0]
            var groupColor: UIColor {
                if groupData.color == "Red" {
                    return GlobalInformation().card_color_red
                } else if groupData.color == "Green" {
                    return GlobalInformation().card_color_green
                } else if groupData.color == "Blue" {
                    return GlobalInformation().card_color_blue
                } else if groupData.color == "Black" {
                    return GlobalInformation().card_color_black
                } else {
                    return GlobalInformation().card_color_gray
                }
            }
            self.wordField.tintColor = groupColor
            self.wordField.text = self.card[0].word!
            self.wordField.textAlignment = .center
            
            var fontSize: CGFloat {
                if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 560 {
                    return 11
                } else {
                    return 14
                }
            }
            self.wordField.font = UIFont.systemFont(ofSize: fontSize)
            self.wordField.placeholder = NSLocalizedString("Word", comment: "")
            
            let height = NSLayoutConstraint(item: self.wordField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size)
            let leading = NSLayoutConstraint(item: self.wordField, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 5)
            let trailing = NSLayoutConstraint(item: self.wordField, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -5)
            let top = NSLayoutConstraint(item: self.wordField, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: GlobalInformation().top_menu_top_size+50)
            NSLayoutConstraint.activate([leading,trailing,top,height])
        }
        wordFieldConst()
        
        let meaningFieldConst = {
            () in
            self.meaningField.translatesAutoresizingMaskIntoConstraints = false
            self.meaningField.borderStyle = .none
            SokDesigner().insertLineForTextField(obj: self.meaningField)
            
            let groupData = try! Realm().objects(group.self).filter("number = '\(self.card[0].group_number!)'")[0]
            var groupColor: UIColor {
                if groupData.color == "Red" {
                    return GlobalInformation().card_color_red
                } else if groupData.color == "Green" {
                    return GlobalInformation().card_color_green
                } else if groupData.color == "Blue" {
                    return GlobalInformation().card_color_blue
                } else if groupData.color == "Black" {
                    return GlobalInformation().card_color_black
                } else {
                    return GlobalInformation().card_color_gray
                }
            }
            self.meaningField.tintColor = groupColor
            self.meaningField.text = self.card[0].meaning!
            self.meaningField.textAlignment = .center
            self.meaningField.adjustsFontSizeToFitWidth = true
            self.meaningField.contentScaleFactor = 0.1
            var fontSize: CGFloat {
                if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 560 {
                    return 11
                } else {
                    return 14
                }
            }
            self.meaningField.font = UIFont.systemFont(ofSize: fontSize)
            self.meaningField.placeholder = NSLocalizedString("Meaning", comment: "")
            
            let height = NSLayoutConstraint(item: self.meaningField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size)
            let leading = NSLayoutConstraint(item: self.meaningField, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 5)
            let trailing = NSLayoutConstraint(item: self.meaningField, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -5)
            let top = NSLayoutConstraint(item: self.meaningField, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: GlobalInformation().top_menu_top_size+100)
            NSLayoutConstraint.activate([leading,trailing,top,height])
        }
        meaningFieldConst()
        
        let exampleFieldConst = {
            () in
            self.exampleField.translatesAutoresizingMaskIntoConstraints = false
            self.exampleField.borderStyle = .none
            self.exampleField.adjustsFontSizeToFitWidth = true
            self.exampleField.contentScaleFactor = 0.1
            SokDesigner().insertLineForTextField(obj: self.exampleField)
            
            let groupData = try! Realm().objects(group.self).filter("number = '\(self.card[0].group_number!)'")[0]
            var groupColor: UIColor {
                if groupData.color == "Red" {
                    return GlobalInformation().card_color_red
                } else if groupData.color == "Green" {
                    return GlobalInformation().card_color_green
                } else if groupData.color == "Blue" {
                    return GlobalInformation().card_color_blue
                } else if groupData.color == "Black" {
                    return GlobalInformation().card_color_black
                } else {
                    return GlobalInformation().card_color_gray
                }
            }
            self.exampleField.tintColor = groupColor
            self.exampleField.text = self.card[0].example1!
            self.exampleField.textAlignment = .center
            var fontSize: CGFloat {
                if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 560 {
                    return 11
                } else {
                    return 14
                }
            }
            self.exampleField.font = UIFont.systemFont(ofSize: fontSize)
            self.exampleField.placeholder = NSLocalizedString("Example", comment: "")
            
            let height = NSLayoutConstraint(item: self.exampleField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size)
            let leading = NSLayoutConstraint(item: self.exampleField, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 5)
            let trailing = NSLayoutConstraint(item: self.exampleField, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -5)
            let top = NSLayoutConstraint(item: self.exampleField, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: GlobalInformation().top_menu_top_size+150)
            NSLayoutConstraint.activate([leading,trailing,top,height])
        }
        exampleFieldConst()
        
        let saveButtonConst = {
            () in
            self.saveButton.translatesAutoresizingMaskIntoConstraints = false
            self.saveButton.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
            self.saveButton.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
            self.saveButton.setTitleColor(UIColor.black, for: .normal)
            SokDesigner().cornerRadius(obj: self.saveButton, value: 4)
            
            var fontSize: CGFloat {
                if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 560 {
                    return 12
                } else {
                    return 15
                }
            }
            self.saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize)
            
            let height = NSLayoutConstraint(item: self.saveButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size)
            let width = NSLayoutConstraint(item: self.saveButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size*4)
            let top = NSLayoutConstraint(item: self.saveButton, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: GlobalInformation().top_menu_top_size+200)
            let centerX = NSLayoutConstraint(item: self.saveButton, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
            NSLayoutConstraint.activate([height,width,top,centerX])
        }
        saveButtonConst()
    }
}
