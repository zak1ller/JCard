//
//  ViewController.swift
//  JCard
//
//  Created by 민수 on 2017. 10. 5..
//  Copyright © 2017년 김민수. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        
        if showOption == "all" {
            cardDatas = try! Realm().objects(cards.self)
        } else if showOption == "memorized" {
            cardDatas = try! Realm().objects(cards.self).filter("isMemorized = true")
        } else if showOption == "unmemorized" {
            cardDatas = try! Realm().objects(cards.self).filter("isMemorized = false")
        }
    }
    
    @IBOutlet private var statusLabel: UILabel!
    @IBOutlet private var cardBackground: UIView!
    @IBOutlet private var card: UIButton!
    @IBAction private func pressCard(sender: UIButton) {
    }
    @IBOutlet private var addCard: UIButton!
    @IBAction private func pressAddCard(sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CardAddViewController")
        present(vc!, animated: true, completion: nil)
    }
    @IBOutlet private var set: UIButton!
    @IBAction private func pressSet(sender: UIButton) {
    }
    
    private var showOption: String {
        return UserDefaults.standard.string(forKey: "CardShowOption")!
    }
    private var cardDatas = try! Realm().objects(cards.self)
    
    private func setLayout() {
        var topSize: CGFloat {
            let size = UIScreen.main.bounds
            if size.width <= 320 && size.height <= 560 {
                return 80 * 0.83
            } else {
                return 80
            }
        }
        var spaceSize: CGFloat {
            let size = UIScreen.main.bounds
            if size.width <= 320 && size.height <= 520 {
                return 20 * 0.83
            } else {
                return 20
            }
        }
        let cardBackgroundConst = {
            () in
            self.cardBackground.translatesAutoresizingMaskIntoConstraints = false
            self.cardBackground.backgroundColor = UIColor.black
            SokDesigner().cornerRadius(obj: self.cardBackground, value: 12)
            let top = NSLayoutConstraint(item: self.cardBackground, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: topSize)
            let leading = NSLayoutConstraint(item: self.cardBackground, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: spaceSize)
            let trailing = NSLayoutConstraint(item: self.cardBackground, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -spaceSize)
            let bottom = NSLayoutConstraint(item: self.cardBackground, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -topSize)
            NSLayoutConstraint.activate([top,leading,trailing,bottom])
        }
        cardBackgroundConst()
        
        let cardConst = {
            () in
            self.card.translatesAutoresizingMaskIntoConstraints = false
            self.card.setTitle("", for: .normal)
            self.card.backgroundColor = UIColor.white
            SokDesigner().cornerRadius(obj: self.card, value: 12)
            
            let top = NSLayoutConstraint(item: self.card, attribute: .top, relatedBy: .equal, toItem: self.cardBackground, attribute: .top, multiplier: 1, constant: 2.5)
            let leading = NSLayoutConstraint(item: self.card, attribute: .leading, relatedBy: .equal, toItem: self.cardBackground, attribute: .leading, multiplier: 1, constant: 2.5)
            let trailing = NSLayoutConstraint(item: self.card, attribute: .trailing, relatedBy: .equal, toItem: self.cardBackground, attribute: .trailing, multiplier: 1, constant: -2.5)
            let bottom = NSLayoutConstraint(item: self.card, attribute: .bottom, relatedBy: .equal, toItem: self.cardBackground, attribute: .bottom, multiplier: 1, constant: -2.5)
            NSLayoutConstraint.activate([top,leading,trailing,bottom])
        }
        cardConst()
        
        let statusConst = {
            () in
            self.statusLabel.translatesAutoresizingMaskIntoConstraints = false
            self.statusLabel.textColor = UIColor.gray
            if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 560 {
                self.statusLabel.font = UIFont.systemFont(ofSize: 11)
            } else {
                self.statusLabel.font = UIFont.systemFont(ofSize: 14)
            }
            if self.cardDatas.count == 0 {
                self.statusLabel.text = NSLocalizedString("ThereAreNotCard", comment: "")
            } else {
                self.statusLabel.isHidden = true
            }
            
            let centerX = NSLayoutConstraint(item: self.statusLabel, attribute: .centerX, relatedBy: .equal, toItem: self.cardBackground, attribute: .centerX, multiplier: 1, constant: 0)
            let centerY = NSLayoutConstraint(item: self.statusLabel, attribute: .centerY, relatedBy: .equal, toItem: self.cardBackground, attribute: .centerY, multiplier: 1, constant: 0)
            NSLayoutConstraint.activate([centerX,centerY])
        }
        statusConst()
        
        let addCardConst = {
            () in
            self.addCard.translatesAutoresizingMaskIntoConstraints = false
            self.addCard.setTitle(NSLocalizedString("", comment: ""), for: .normal)
            self.addCard.setImage(UIImage(named: "new.png"), for: .normal)
            self.addCard.tintColor = UIColor.black
            
            let top = NSLayoutConstraint(item: self.addCard, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: GlobalInformation().top_menu_top_size)
            let centerX = NSLayoutConstraint(item: self.addCard, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
            let width = NSLayoutConstraint(item: self.addCard, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size)
            let height = NSLayoutConstraint(item: self.addCard, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size)
            NSLayoutConstraint.activate([top,centerX,width,height])
        }
        addCardConst()
        
        let setConst = {
            () in
            self.set.translatesAutoresizingMaskIntoConstraints = false
            self.set.setTitle(NSLocalizedString("", comment: ""), for: .normal)
            self.set.setTitleColor(UIColor.black, for: .normal)
            //self.set.titleLabel?.font = UIFont.systemFont(ofSize: GlobalInformation().top_menu_font_size, weight: .medium)
            //SokDesigner().insertLineForTextField(obj: self.set, color: UIColor.black, stroke: 1, alpha: 1)
            
            var topSize: CGFloat {
                if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 560 {
                    return 35*0.83
                } else {
                    return 35
                }
            }
            let top = NSLayoutConstraint(item: self.set, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: topSize)
            let trailing = NSLayoutConstraint(item: self.set, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -GlobalInformation().top_menu_space)
            NSLayoutConstraint.activate([top,trailing])
        }
        setConst()
    }
}

