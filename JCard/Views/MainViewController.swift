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
        
        level1.tag = 1
        level2.tag = 2
        level3.tag = 3
        level4.tag = 4
        level5.tag = 5
        
        startBlink(label: titleLabel)
        wordLabel.text = ""
        titleLabel.text = ""
        meaningLabel.text = ""
    }
    override func viewDidAppear(_ animated: Bool) {
        if showOption == "all" {
            cardDatas = try! Realm().objects(cards.self)
        } else if showOption == "memorized" {
            cardDatas = try! Realm().objects(cards.self).filter("isMemorized = true")
        } else if showOption == "unmemorized" {
            cardDatas = try! Realm().objects(cards.self).filter("isMemorized = false")
        }
        setLayout()
    }
    
    @IBOutlet private var level1: UIButton!
    @IBOutlet private var level2: UIButton!
    @IBOutlet private var level3: UIButton!
    @IBOutlet private var level4: UIButton!
    @IBOutlet private var level5: UIButton!
    
    private var cardStatus = true {
        willSet(new) {
            if new == false {
                self.wordLabel.isHidden = true
                self.meaningLabel.isHidden = false
                self.titleLabel.text = NSLocalizedString("PressCard2", comment: "")
            } else {
                self.wordLabel.isHidden = false
                self.meaningLabel.isHidden = true
                self.titleLabel.text = NSLocalizedString("PressCard", comment: "")
            }
        }
    }
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var wordLabel: UILabel!
    @IBOutlet private var meaningLabel: UILabel!
    
    private func renewLevel(level: Int) {
        if level == 1 {
            level1.setImage(UIImage(named: "star.png"), for: .normal)
            level2.setImage(UIImage(named: "empty_star.png"), for: .normal)
            level3.setImage(UIImage(named: "empty_star.png"), for: .normal)
            level4.setImage(UIImage(named: "empty_star.png"), for: .normal)
            level5.setImage(UIImage(named: "empty_star.png"), for: .normal)
        } else if level == 2 {
            level1.setImage(UIImage(named: "star.png"), for: .normal)
            level2.setImage(UIImage(named: "star.png"), for: .normal)
            level3.setImage(UIImage(named: "empty_star.png"), for: .normal)
            level4.setImage(UIImage(named: "empty_star.png"), for: .normal)
            level5.setImage(UIImage(named: "empty_star.png"), for: .normal)
        } else if level == 3 {
            level1.setImage(UIImage(named: "star.png"), for: .normal)
            level2.setImage(UIImage(named: "star.png"), for: .normal)
            level3.setImage(UIImage(named: "star.png"), for: .normal)
            level4.setImage(UIImage(named: "empty_star.png"), for: .normal)
            level5.setImage(UIImage(named: "empty_star.png"), for: .normal)
        } else if level == 4 {
            level1.setImage(UIImage(named: "star.png"), for: .normal)
            level2.setImage(UIImage(named: "star.png"), for: .normal)
            level3.setImage(UIImage(named: "star.png"), for: .normal)
            level4.setImage(UIImage(named: "star.png"), for: .normal)
            level5.setImage(UIImage(named: "empty_star.png"), for: .normal)
        } else if level == 5 {
            level1.setImage(UIImage(named: "star.png"), for: .normal)
            level2.setImage(UIImage(named: "star.png"), for: .normal)
            level3.setImage(UIImage(named: "star.png"), for: .normal)
            level4.setImage(UIImage(named: "star.png"), for: .normal)
            level5.setImage(UIImage(named: "star.png"), for: .normal)
        }
    }
    
    @IBOutlet private var statusLabel: UILabel!
    @IBOutlet private var cardBackground: UIView!
    @IBOutlet private var card: UIButton!
    @IBAction private func pressCard(sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            sender.alpha = 0.25
            sender.alpha = 1
        })
        if cardDatas.count <= currentIndex {
            return
        }
        if cardStatus == true {
            cardStatus = false
        } else {
            cardStatus = true
        }
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
    private var currentIndex = 0
    
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
        
        let levelsConst = {
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
            
            let levelColor = UIColor.black
            self.level1.tintColor = levelColor
            self.level2.tintColor = levelColor
            self.level3.tintColor = levelColor
            self.level4.tintColor = levelColor
            self.level5.tintColor = levelColor
            
            if self.cardDatas.count != 0 {
                self.renewLevel(level: self.cardDatas[self.currentIndex].imporment)
            }
            
            let width1 = NSLayoutConstraint(item: self.level1, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size*0.7)
            let width2 = NSLayoutConstraint(item: self.level2, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size*0.7)
            let width3 = NSLayoutConstraint(item: self.level3, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size*0.7)
            let width4 = NSLayoutConstraint(item: self.level4, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size*0.7)
            let width5 = NSLayoutConstraint(item: self.level5, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size*0.7)
            NSLayoutConstraint.activate([width1,width2,width3,width4,width5])
            
            let height1 = NSLayoutConstraint(item: self.level1, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size*0.7)
            let height2 = NSLayoutConstraint(item: self.level2, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size*0.7)
            let height3 = NSLayoutConstraint(item: self.level3, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size*0.7)
            let height4 = NSLayoutConstraint(item: self.level4, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size*0.7)
            let height5 = NSLayoutConstraint(item: self.level5, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size*0.7)
            NSLayoutConstraint.activate([height1,height2,height3,height4,height5])
            
            var topSize2: CGFloat {
                if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 560 {
                    return 15*0.83
                } else {
                    return 15
                }
            }
            let top1 = NSLayoutConstraint(item: self.level1, attribute: .top, relatedBy: .equal, toItem: self.cardBackground, attribute: .top, multiplier: 1, constant: topSize2)
            let top2 = NSLayoutConstraint(item: self.level2, attribute: .top, relatedBy: .equal, toItem: self.cardBackground, attribute: .top, multiplier: 1, constant: topSize2)
            let top3 = NSLayoutConstraint(item: self.level3, attribute: .top, relatedBy: .equal, toItem: self.cardBackground, attribute: .top, multiplier: 1, constant: topSize2)
            let top4 = NSLayoutConstraint(item: self.level4, attribute: .top, relatedBy: .equal, toItem: self.cardBackground, attribute: .top, multiplier: 1, constant: topSize2)
            let top5 = NSLayoutConstraint(item: self.level5, attribute: .top, relatedBy: .equal, toItem: self.cardBackground, attribute: .top, multiplier: 1, constant: topSize2)
            NSLayoutConstraint.activate([top1,top2,top3,top4,top5])
            
            let lv3 = NSLayoutConstraint(item: self.level3, attribute: .centerX, relatedBy: .equal, toItem: self.cardBackground, attribute: .centerX, multiplier: 1, constant: 0)
            let lv2 = NSLayoutConstraint(item: self.level2, attribute: .trailing, relatedBy: .equal, toItem: self.level3, attribute: .trailing, multiplier: 1, constant: -35)
            let lv1 = NSLayoutConstraint(item: self.level1, attribute: .trailing, relatedBy: .equal, toItem: self.level3, attribute: .trailing, multiplier: 1, constant: -70)
            let lv4 = NSLayoutConstraint(item: self.level4, attribute: .leading, relatedBy: .equal, toItem: self.level3, attribute: .leading, multiplier: 1, constant: 35)
            let lv5 = NSLayoutConstraint(item: self.level5, attribute: .leading, relatedBy: .equal, toItem: self.level3, attribute: .leading, multiplier: 1, constant: 70)
            NSLayoutConstraint.activate([lv1,lv2,lv3,lv4,lv5])
        }
        levelsConst()
        
        let titleLabelConst = {
            () in
            self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
            if self.cardDatas.count != 0 {
                self.titleLabel.text = NSLocalizedString("PressCard", comment: "")
            }
            
            var titleFont: CGFloat {
                if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 560 {
                    return 11
                } else {
                    return 14
                }
            }
            self.titleLabel.font = UIFont.systemFont(ofSize: titleFont)
            
            let centerX = NSLayoutConstraint(item: self.titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self.cardBackground, attribute: .centerX, multiplier: 1, constant: 0)
            let top = NSLayoutConstraint(item: self.titleLabel, attribute: .top, relatedBy: .equal, toItem: self.cardBackground, attribute: .top, multiplier: 1, constant: 70)
            NSLayoutConstraint.activate([centerX,top])
        }
        titleLabelConst()
        
        let wordLabelConst = {
            () in
            self.wordLabel.translatesAutoresizingMaskIntoConstraints = false
            if self.cardDatas.count != 0 {
                self.wordLabel.text = self.cardDatas[self.currentIndex].word!
            }
            self.wordLabel.numberOfLines = 1
            self.wordLabel.adjustsFontSizeToFitWidth = true
            self.wordLabel.minimumScaleFactor = 0.1
            
            var wordFont: CGFloat {
                if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 560 {
                    return 34
                } else {
                    return 40
                }
            }
            self.wordLabel.font = UIFont.systemFont(ofSize: wordFont)
            
            let centerX = NSLayoutConstraint(item: self.wordLabel, attribute: .centerX, relatedBy: .equal, toItem: self.cardBackground, attribute: .centerX, multiplier: 1, constant: 0)
            let centerY = NSLayoutConstraint(item: self.wordLabel, attribute: .centerY, relatedBy: .equal, toItem: self.cardBackground, attribute: .centerY, multiplier: 1, constant: 0)
            let leading = NSLayoutConstraint(item: self.wordLabel, attribute: .leading, relatedBy: .equal, toItem: self.cardBackground, attribute: .leading, multiplier: 1, constant: 10)
            let trailing = NSLayoutConstraint(item: self.wordLabel, attribute: .trailing, relatedBy: .equal, toItem: self.cardBackground, attribute: .trailing, multiplier: 1, constant: -10)
            NSLayoutConstraint.activate([centerX,centerY,leading,trailing])
        }
        wordLabelConst()
        
        let meaningLabelConst = {
            () in
            self.meaningLabel.translatesAutoresizingMaskIntoConstraints = false
            if self.cardDatas.count != 0 {
                self.meaningLabel.text = self.cardDatas[self.currentIndex].meaning!
            }
            self.meaningLabel.isHidden = true
            self.meaningLabel.numberOfLines = 1
            self.meaningLabel.adjustsFontSizeToFitWidth = true
            self.meaningLabel.minimumScaleFactor = 0.1
            
            var meaningFont: CGFloat {
                if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 560 {
                    return 34
                } else {
                    return 40
                }
            }
            self.meaningLabel.font = UIFont.systemFont(ofSize: meaningFont)
            
            let centerX = NSLayoutConstraint(item: self.meaningLabel, attribute: .centerX, relatedBy: .equal, toItem: self.cardBackground, attribute: .centerX, multiplier: 1, constant: 0)
            let centerY = NSLayoutConstraint(item: self.meaningLabel, attribute: .centerY, relatedBy: .equal, toItem: self.cardBackground, attribute: .centerY, multiplier: 1, constant: 0)
            let leading = NSLayoutConstraint(item: self.meaningLabel, attribute: .leading, relatedBy: .equal, toItem: self.cardBackground, attribute: .leading, multiplier: 1, constant: 10)
            let trailing = NSLayoutConstraint(item: self.meaningLabel, attribute: .trailing, relatedBy: .equal, toItem: self.cardBackground, attribute: .trailing, multiplier: 1, constant: -10)
            NSLayoutConstraint.activate([centerX,centerY,leading,trailing])
        }
        meaningLabelConst()
    }
    
    func startBlink(label: UILabel) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.0, animations: {
                label.alpha = 0.05
            }, completion: {
                (_) in
                UIView.animate(withDuration: 0.5, animations: {
                    label.alpha = 1
                }, completion: {
                    (_) in
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
                        self.startBlink(label: label)
                    })
                })
            })
        }
    }
}

