//
//  BackUpViewController.swift
//  JCard
//
//  Created by 민수 on 2017. 10. 22..
//  Copyright © 2017년 김민수. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class BackUpViewController: UIViewController {
    override func viewDidLoad() {
        setLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    
    @IBOutlet private weak var backButton: UIButton!
    @IBAction private func pressBackButton(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet private weak var cardUpload: UIButton!
    @IBAction private func pressCardUpload(sender: UIButton) {
        if try! Realm().objects(cards.self).count == 0 {
            let alert = MinsuLibrarys().alert_confirm(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("ThereAreNoCardsDownload", comment: ""))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("KeepUploding", comment: ""), preferredStyle: .alert)
            alert.view.tintColor = UIColor.black
            alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: {
                (_) in
                BackUpViewBrain().isConnectToNetwork(handler: {
                    result in
                    if result == false {
                        let alert = MinsuLibrarys().alert_confirm(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("NetworkFailed", comment: ""))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        if let username = UserDefaults.standard.string(forKey: "username") {
                            // Here
                        } else {
                            let alert = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("NeedUsername", comment: ""), preferredStyle: .alert)
                            alert.view.tintColor = UIColor.black
                            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
                            alert.addAction(UIAlertAction(title: NSLocalizedString("SignIn", comment: ""), style: .default, handler: {
                                (_) in
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
                                self.present(vc!, animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                })
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBOutlet private weak var cardDownload: UIButton!
    @IBAction private func pressCardDownload(sender: UIButton) {
        
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
        
        var buttonFontSize: CGFloat {
            if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 560 {
                return 20
            } else {
                return 25
            }
        }
        let cardUploadButtonConst = {
            () in
            self.cardUpload.translatesAutoresizingMaskIntoConstraints = false
            self.cardUpload.setTitle(NSLocalizedString("UploadMyCards", comment: ""), for: .normal)
            self.cardUpload.setTitleColor(UIColor.black, for: .normal)
            self.cardUpload.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize, weight: .black)
            SokDesigner().insertLineForTextField(obj: self.cardUpload)
            
            let height = NSLayoutConstraint(item: self.cardUpload, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size*1.75)
            let leading = NSLayoutConstraint(item: self.cardUpload, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 30)
            let trailing = NSLayoutConstraint(item: self.cardUpload, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -30)
            let top = NSLayoutConstraint(item: self.cardUpload, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 80)
            NSLayoutConstraint.activate([height,leading,trailing,top])
        }
        cardUploadButtonConst()
        let cardDownloadButtonConst = {
            () in
            self.cardDownload.translatesAutoresizingMaskIntoConstraints = false
            self.cardDownload.setTitle(NSLocalizedString("DownloadMyCards", comment: ""), for: .normal)
            self.cardDownload.setTitleColor(UIColor.black, for: .normal)
            self.cardDownload.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize, weight: .black)
            SokDesigner().insertLineForTextField(obj: self.cardDownload)
            
            let height = NSLayoutConstraint(item: self.cardDownload, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().tf_height_size*1.75)
            let leading = NSLayoutConstraint(item: self.cardDownload, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 30)
            let trailing = NSLayoutConstraint(item: self.cardDownload, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -30)
            let top = NSLayoutConstraint(item: self.cardDownload, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 160)
            NSLayoutConstraint.activate([height,leading,trailing,top])
        }
        cardDownloadButtonConst()
    }
}
