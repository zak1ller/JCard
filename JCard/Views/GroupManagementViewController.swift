//
//  GroupManagementViewController.swift
//  JCard
//
//  Created by 민수 on 2017. 10. 19..
//  Copyright © 2017년 김민수. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds
import RealmSwift

class GroupManagementViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var data = try! Realm().objects(group.self)
    override func viewDidLoad() {
        setLayout()
        tableView.delegate = self
        tableView.dataSource = self
    }
    @IBOutlet private weak var backButton: UIButton!
    @IBAction private func pressBackButton(sender: UIButton) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    private func changeColor(button: UIButton,color: String) {
        if color == "Red" {
            button.tintColor = GlobalInformation().card_color_red
        } else if color == "Green" {
            button.tintColor = GlobalInformation().card_color_green
        } else if color == "Blue" {
            button.tintColor = GlobalInformation().card_color_blue
        } else if color == "Black" {
            button.tintColor = GlobalInformation().card_color_black
        } else {
            button.tintColor = GlobalInformation().card_color_gray
        }
    }
    @IBAction private func pressChangeColor(sender: UIButton) {
        let alert = UIAlertController(title: "", message: NSLocalizedString("SelectColor", comment: ""), preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor.black
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Red", comment: ""), style: .default, handler: {
            (_) in
            let groupData = try! Realm().objects(group.self).filter("number = '\(sender.accessibilityValue!)'")
            try! Realm().write {
                groupData[0].color = "Red"
            }
            self.changeColor(button: sender, color: "Red")
            self.data = try! Realm().objects(group.self)
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Green", comment: ""), style: .default, handler: {
            (_) in
            let groupData = try! Realm().objects(group.self).filter("number = '\(sender.accessibilityValue!)'")
            try! Realm().write {
                groupData[0].color = "Green"
            }
            self.changeColor(button: sender, color: "Green")
            self.data = try! Realm().objects(group.self)
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Blue", comment: ""), style: .default, handler: {
            (_) in
            let groupData = try! Realm().objects(group.self).filter("number = '\(sender.accessibilityValue!)'")
            try! Realm().write {
                groupData[0].color = "Blue"
            }
            self.changeColor(button: sender, color: "Blue")
            self.data = try! Realm().objects(group.self)
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Black", comment: ""), style: .default, handler: {
            (_) in
            let groupData = try! Realm().objects(group.self).filter("number = '\(sender.accessibilityValue!)'")
            try! Realm().write {
                groupData[0].color = "Black"
            }
            self.changeColor(button: sender, color: "Black")
            self.data = try! Realm().objects(group.self)
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Gray", comment: ""), style: .default, handler: {
            (_) in
            let groupData = try! Realm().objects(group.self).filter("number = '\(sender.accessibilityValue!)'")
            try! Realm().write {
                groupData[0].color = "Gray"
            }
            self.changeColor(button: sender, color: "Gray")
            self.data = try! Realm().objects(group.self)
            self.tableView.reloadData()
        }))
        present(alert, animated: true, completion: nil)
    }
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupManagementCell", for: indexPath) as! GroupManagementCell
        var nameFontSize: CGFloat {
            if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 560 {
                return 16
            } else {
                return 20
            }
        }
        cell.group_name.text = data[indexPath.row].name!
        cell.group_name.font = UIFont.systemFont(ofSize: nameFontSize)
        
        let card = try! Realm().objects(cards.self).filter("group_number = '\(data[indexPath.row].number!)'")
        var haveFontSize: CGFloat {
            if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 560 {
                return 10
            } else {
                return 13
            }
        }
        cell.group_have_words.text = NSLocalizedString("OwnedWords", comment: "")+" [\(card.count)]"
        cell.group_have_words.font = UIFont.systemFont(ofSize: haveFontSize)
        cell.group_have_words.textColor = UIColor.gray
        
        var groupColor: UIColor {
            if data[indexPath.row].color! == "Red" {
                return GlobalInformation().card_color_red
            } else if data[indexPath.row].color == "Green" {
                return GlobalInformation().card_color_green
            } else if data[indexPath.row].color == "Blue" {
                return GlobalInformation().card_color_blue
            } else if data[indexPath.row].color == "Black" {
                return GlobalInformation().card_color_black
            } else {
                return GlobalInformation().card_color_gray
            }
        }
        cell.group_color.setTitle("", for: .normal)
        cell.group_color.setImage(UIImage(named: "color.png"), for: .normal)
        cell.group_color.tintColor = groupColor
        cell.group_color.accessibilityValue = data[indexPath.row].number!
        
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
        
        let titleLabelConst = {
            () in
            self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
            self.titleLabel.text = NSLocalizedString("GroupCount", comment: "")+" \(self.data.count)"
            self.titleLabel.textColor = UIColor.black
            var titleFontSize: CGFloat {
                if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 560 {
                    return 14
                } else {
                    return 18
                }
            }
            self.titleLabel.font = UIFont.systemFont(ofSize: titleFontSize, weight: .black)
            let height = NSLayoutConstraint(item: self.titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size)
            let top = NSLayoutConstraint(item: self.titleLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: GlobalInformation().top_menu_top_size)
            let centerX = NSLayoutConstraint(item: self.titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
            NSLayoutConstraint.activate([height,top,centerX])
        }
        titleLabelConst()
    }
}
