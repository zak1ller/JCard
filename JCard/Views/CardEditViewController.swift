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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    internal var number: String?
    private var card = try! Realm().objects(cards.self)
    
    @IBOutlet private var backButton: UIButton!
    @IBAction private func pressBackButton(sender: AnyObject) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet private var wordField: UITextField!
    @IBOutlet private var meaningField: UITextField!
    @IBOutlet private var exampleTextView: UITextView!
    @IBAction private func pressReturnKey(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
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
        
        if exampleTextView.text != card[0].example1 {
            if exampleTextView.text.lengthOfBytes(using: .utf8) > 2000 {
                let alert = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("TooLongExtra", comment: ""), preferredStyle: .alert)
                self.present(alert, animated: true, completion: {
                    sleep(1)
                    self.dismiss(animated: true, completion: {
                        self.exampleTextView.becomeFirstResponder()
                    })
                })
                return
            }
        }

        try! Realm().write {
            self.card[0].word = self.wordField.text!
            self.card[0].meaning = self.meaningField.text!
            self.card[0].example1 = self.exampleTextView.text
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
        
        var fontSize: CGFloat {
            if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 560 {
                return 16
            } else {
                return 20
            }
        }
        let wordFieldConst = {
            () in
            self.wordField.translatesAutoresizingMaskIntoConstraints = false
            self.wordField.borderStyle = .none
            self.wordField.text = self.card[0].word!
            self.wordField.textAlignment = .left
            self.wordField.font = UIFont.systemFont(ofSize: fontSize)
            self.wordField.placeholder = NSLocalizedString("Word", comment: "")
            self.wordField.tintColor = UIColor.black
            SokDesigner().insertLineForTextField(obj: self.wordField)
            
            let height = NSLayoutConstraint(item: self.wordField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size*1.5)
            let leading = NSLayoutConstraint(item: self.wordField, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 15)
            let trailing = NSLayoutConstraint(item: self.wordField, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -15)
            let top = NSLayoutConstraint(item: self.wordField, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: GlobalInformation().top_menu_top_size+50)
            NSLayoutConstraint.activate([leading,trailing,top,height])
        }
        wordFieldConst()
        
        let meaningFieldConst = {
            () in
            self.meaningField.translatesAutoresizingMaskIntoConstraints = false
            self.meaningField.borderStyle = .none
            self.meaningField.text = self.card[0].meaning!
            self.meaningField.textAlignment = .left
            self.meaningField.adjustsFontSizeToFitWidth = true
            self.meaningField.contentScaleFactor = 0.1
            self.meaningField.font = UIFont.systemFont(ofSize: fontSize)
            self.meaningField.placeholder = NSLocalizedString("Meaning", comment: "")
            self.meaningField.tintColor = UIColor.black
            SokDesigner().insertLineForTextField(obj: self.meaningField)
            
            let height = NSLayoutConstraint(item: self.meaningField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size*1.5)
            let leading = NSLayoutConstraint(item: self.meaningField, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 15)
            let trailing = NSLayoutConstraint(item: self.meaningField, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -15)
            let top = NSLayoutConstraint(item: self.meaningField, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: GlobalInformation().top_menu_top_size+100)
            NSLayoutConstraint.activate([leading,trailing,top,height])
        }
        meaningFieldConst()
        
        let exampleTextViewConst = {
            () in
            self.exampleTextView.translatesAutoresizingMaskIntoConstraints = false
            self.exampleTextView.contentScaleFactor = 0.1
            self.exampleTextView.textAlignment = .left
            self.exampleTextView.text = self.card[0].example1!
            self.exampleTextView.font = UIFont.systemFont(ofSize: fontSize)
            self.exampleTextView.tintColor = UIColor.black
            
            let height = NSLayoutConstraint(item: self.exampleTextView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size*6)
            let leading = NSLayoutConstraint(item: self.exampleTextView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 10)
            let trailing = NSLayoutConstraint(item: self.exampleTextView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -10)
            let top = NSLayoutConstraint(item: self.exampleTextView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: GlobalInformation().top_menu_top_size+150)
            NSLayoutConstraint.activate([leading,trailing,top,height])
        }
        exampleTextViewConst()
        
        let saveButtonConst = {
            () in
            self.saveButton.translatesAutoresizingMaskIntoConstraints = false
            self.saveButton.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
            self.saveButton.setTitleColor(UIColor.white, for: .normal)
            self.saveButton.backgroundColor = UIColor.black
            
            var fontSize: CGFloat {
                if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 560 {
                    return 16
                } else {
                    return 20
                }
            }
            self.saveButton.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .black)
            
            let height = NSLayoutConstraint(item: self.saveButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size*2)
            let leading = NSLayoutConstraint(item: self.saveButton, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
            let trailing = NSLayoutConstraint(item: self.saveButton, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
            let bottom = NSLayoutConstraint(item: self.saveButton, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
            NSLayoutConstraint.activate([height,leading,trailing,bottom])
        }
        saveButtonConst()
    }
}
