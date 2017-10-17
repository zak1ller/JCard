//
//  CardManagementViewController.swift
//  JCard
//
//  Created by 민수 on 2017. 10. 17..
//  Copyright © 2017년 김민수. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class CardManagementViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    override func viewDidLoad() {
        setLayout()
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    let data = try! Realm().objects(cards.self)
    
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var backButton: UIButton!
    @IBAction private func pressBackButton(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet private weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardManagementCell", for: indexPath) as! CardManagementCell
        cell.card_word.text = data[indexPath.row].word!
        cell.card_meaning.text = data[indexPath.row].meaning!
        
        if data[indexPath.row].isGroup == true {
            let groupData = try! Realm().objects(group.self).filter("number = '\(data[indexPath.row].group_number!)'")[0]
            cell.card_group.text = "[\(groupData.name!)]"
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
            cell.card_group.textColor = groupColor
        } else {
            cell.card_group.text = "[\(NSLocalizedString("NoGroup", comment: ""))]"
            cell.card_group.textColor = UIColor.gray
        }
        
        var groupFontSize: CGFloat {
            if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 560 {
                return 10
            } else {
                return 13
            }
        }
        cell.card_group.font = UIFont.systemFont(ofSize: groupFontSize)
        var wordFontSize: CGFloat {
            if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 560 {
                return 13.5
            } else {
                return 17
            }
        }
        cell.card_word.font = UIFont.systemFont(ofSize: wordFontSize)
        var meaningFontSize: CGFloat {
            if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 560 {
                return 10
            } else {
                return 13
            }
        }
        cell.card_meaning.font = UIFont.systemFont(ofSize: meaningFontSize)
        
        cell.card_word.adjustsFontSizeToFitWidth = true
        cell.card_word.numberOfLines = 1
        cell.card_word.minimumScaleFactor = 0.1
        
        cell.card_meaning.adjustsFontSizeToFitWidth = true
        cell.card_meaning.numberOfLines = 2
        cell.card_meaning.minimumScaleFactor = 0.1
        
        return cell
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
        
        let countConst = {
            () in
            self.countLabel.translatesAutoresizingMaskIntoConstraints = false
            self.countLabel.textColor = UIColor.black
            self.countLabel.text = String(self.data.count)
            self.countLabel.textAlignment = .center
            
            var countFontSize: CGFloat {
                if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 560 {
                    return 16
                } else {
                    return 20
                }
            }
            self.countLabel.font = UIFont.systemFont(ofSize: countFontSize, weight: UIFont.Weight.black)
            
            let height = NSLayoutConstraint(item: self.countLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size)
            let top = NSLayoutConstraint(item: self.countLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: GlobalInformation().top_menu_top_size)
            let centerX = NSLayoutConstraint(item: self.countLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
            NSLayoutConstraint.activate([height,top,centerX])
        }
        countConst()
    }
}
