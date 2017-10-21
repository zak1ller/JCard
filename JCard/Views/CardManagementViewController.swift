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
import GoogleMobileAds

class CardManagementViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    override func viewDidLoad() {
        setLayout()
        tableView.dataSource = self
        tableView.delegate = self
        searchField.delegate = self
        
        let bannerConst = {
            () in
            self.bannerView = GADBannerView(adSize: kGADAdSizeLargeBanner, origin: CGPoint(x: 0, y: self.view.frame.size.height-58))
            self.bannerView.rootViewController = self
            self.bannerView.adUnitID = "ca-app-pub-2853823596405573/9754638812"
            
            self.bannerView.frame = CGRect(x: -2, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 58)
            self.view.addSubview(self.bannerView)
            self.bannerView.load(GADRequest())
            
        }
        bannerConst()
    }
    override func viewWillAppear(_ animated: Bool) {
        data = try! Realm().objects(cards.self)
        titleButton.setTitle(NSLocalizedString("AllWord", comment: "")+" \(self.data.count)", for: .normal)
        tableView.reloadData()
    }
    var data = try! Realm().objects(cards.self)
    var bannerView: GADBannerView!

    @IBOutlet private weak var moreButton: UIButton!
    @IBAction private func pressMoreButton(sender: UIButton) {
        let alert = UIAlertController(title: NSLocalizedString("Menu", comment: ""), message: "", preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor.black
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("NewCard", comment: ""), style: .default, handler: {
            (_) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CardAddViewController")
            self.present(vc!, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("DeleteAll", comment: ""), style: .destructive, handler: {
            (_) in
            let alert = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("DeleteAllCard", comment: ""), preferredStyle: .alert)
            alert.view.tintColor = UIColor.black
            alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: {
                (_) in
                try! Realm().write {
                    try! Realm().delete(try! Realm().objects(cards.self))
                }
                self.data = try! Realm().objects(cards.self)
                self.titleButton.setTitle(NSLocalizedString("AllWord", comment: "")+" \(self.data.count)", for: .normal)
                self.tableView.reloadData()
            }))
            self.present(alert, animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet private weak var searchField: UISearchBar!
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        data = try! Realm().objects(cards.self).filter("word CONTAINS '\(searchText)' OR meaning CONTAINS '\(searchText)'")
        titleButton.setTitle(NSLocalizedString("SearchResult", comment: "")+" \(data.count)", for: .normal)
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        data = try! Realm().objects(cards.self)
        titleButton.setTitle(NSLocalizedString("AllWord", comment: "")+" \(self.data.count)", for: .normal)
        tableView.reloadData()
    }
    
    @IBOutlet private weak var titleButton: UIButton!
    @IBAction private func pressTitleButton(sender: UIButton) {
        let alert = UIAlertController(title: "", message: NSLocalizedString("ShowGroup", comment: ""), preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor.black
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("AllWord", comment: ""), style: .destructive, handler: {
            (_) in
            self.data = try! Realm().objects(cards.self)
            self.titleButton.setTitle(NSLocalizedString("AllWord", comment: "")+" \(self.data.count)", for: .normal)
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("NoGroup", comment: ""), style: .destructive, handler: {
            (_) in
            self.data = try! Realm().objects(cards.self).filter("isGroup = false")
            self.titleButton.setTitle(NSLocalizedString("NoGroup", comment: "")+" \(self.data.count)", for: .normal)
            self.tableView.reloadData()
        }))
        var index = 0
        let groupData = try! Realm().objects(group.self)
        while(groupData.count > index) {
            alert.addAction(UIAlertAction(title: groupData[index].name!, style: .default, handler: {
                (title) in
                let groupData = try! Realm().objects(group.self).filter("name = '\(title.title!)'")
                self.data = try! Realm().objects(cards.self).filter("group_number = '\(groupData[0].number!)'")
                self.titleButton.setTitle(NSLocalizedString(groupData[0].name!+" \(self.data.count)", comment: ""), for: .normal)
                self.tableView.reloadData()
            }))
            index = index+1
        }
        present(alert, animated: true, completion: nil)
    }
    @IBOutlet private weak var backButton: UIButton!
    @IBAction private func pressBackButton(sender: UIButton) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet private weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CardManagementCell
        let data = try! Realm().objects(cards.self).filter("number = '\(cell.card_word.accessibilityValue!)'")[0]
        let alert = UIAlertController(title: NSLocalizedString("Menu", comment: ""), message: data.word!, preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor.black
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("EditCard", comment: ""), style: .default, handler: {
            (_) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CardEditViewController") as! CardEditViewController
            vc.number = data.number
            self.present(vc, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("ChangeGroup", comment: ""), style: .default, handler: {
            (_) in
            let alert = UIAlertController(title: NSLocalizedString("Menu", comment: ""), message: NSLocalizedString("ChangeGroup", comment: ""), preferredStyle: .actionSheet)
            alert.view.tintColor = UIColor.black
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: NSLocalizedString("NoGroup", comment: ""), style: .destructive, handler: {
                (_) in
                try! Realm().write {
                    self.data.filter("number = '\(cell.card_word.accessibilityValue!)'")[0].isGroup = false
                    self.data.filter("number = '\(cell.card_word.accessibilityValue!)'")[0].group_number = nil
                }
                let alert = MinsuLibrarys().alert_confirm(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("ChangedGroup", comment: ""))
                self.present(alert, animated: true, completion: nil)
            }))
            let data = try! Realm().objects(group.self)
            var index = 0
            while(data.count > index) {
                alert.addAction(UIAlertAction(title: data[index].name!, style: .default, handler: {
                    (title) in
                    let gg = try! Realm().objects(group.self).filter("name = '\(title.title!)'")[0]
                    try! Realm().write {
                        self.data.filter("number = '\(cell.card_word.accessibilityValue!)'")[0].group_number = gg.number
                        self.data.filter("number = '\(cell.card_word.accessibilityValue!)'")[0].isGroup = true
                    }
                    let alert = MinsuLibrarys().alert_confirm(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("ChangedGroup", comment: ""))
                    self.present(alert, animated: true, completion: {
                        self.data = try! Realm().objects(cards.self)
                        self.tableView.reloadData()
                    })
                }))
                index = index + 1
            }
            self.present(alert, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("DeleteCard", comment: ""), style: .destructive, handler: {
            (_) in
            let alert = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("DoYouWantDelete", comment: ""), preferredStyle: .alert)
            alert.view.tintColor = UIColor.black
            alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: {
                (_) in
                try! Realm().write {
                    try! Realm().delete(self.data.filter("number = '\(cell.card_word.accessibilityValue!)'"))
                    self.data = try! Realm().objects(cards.self)
                    self.tableView.reloadData()
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardManagementCell", for: indexPath) as! CardManagementCell
        cell.card_word.text = data[indexPath.row].word!
        cell.card_word.accessibilityValue = data[indexPath.row].number!
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
            self.titleButton.translatesAutoresizingMaskIntoConstraints = false
            self.titleButton.setTitle(NSLocalizedString("AllWord", comment: "")+" \(String(self.data.count))", for: .normal)
            self.titleButton.setTitleColor(UIColor.black, for: .normal)
            var titleFontSize: CGFloat {
                if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 560 {
                    return 14
                } else {
                    return 18
                }
            }
            self.titleButton.titleLabel?.font = UIFont.systemFont(ofSize: titleFontSize, weight: .black)
            
            let height = NSLayoutConstraint(item: self.titleButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size)
            let top = NSLayoutConstraint(item: self.titleButton, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: GlobalInformation().top_menu_top_size)
            let centerX = NSLayoutConstraint(item: self.titleButton, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
            NSLayoutConstraint.activate([height,top,centerX])
        }
        countConst()
        
        let searchBarConst = {
            () in
            self.searchField.translatesAutoresizingMaskIntoConstraints = false
            self.searchField.placeholder = NSLocalizedString("SearchWord", comment: "")
            self.searchField.tintColor = UIColor.black
            
            let top = NSLayoutConstraint(item: self.searchField, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 75)
            let leading = NSLayoutConstraint(item: self.searchField, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
            let trailing = NSLayoutConstraint(item: self.searchField, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
            NSLayoutConstraint.activate([top,leading,trailing])
        }
        searchBarConst()
        
        let moreButtonConst = {
            () in
            self.moreButton.translatesAutoresizingMaskIntoConstraints = false
            self.moreButton.tintColor = UIColor.black
            self.moreButton.setTitle("", for: .normal)
            self.moreButton.setImage(UIImage(named: "more.png"), for: .normal)
            
            let width = NSLayoutConstraint(item: self.moreButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size)
            let height = NSLayoutConstraint(item: self.moreButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size)
            let top = NSLayoutConstraint(item: self.moreButton, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: GlobalInformation().top_menu_top_size)
            let trailing = NSLayoutConstraint(item: self.moreButton, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -GlobalInformation().top_menu_space)
            NSLayoutConstraint.activate([width,height,trailing,top])
        }
        moreButtonConst()
    }
}
