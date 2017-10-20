//
//  ViewController.swift
//  JCard
//
//  Created by 민수 on 2017. 10. 5..
//  Copyright © 2017년 김민수. All rights reserved.
//

import UIKit
import RealmSwift

extension Array {
    var shuffled: Array {
        var elements = self
        return elements.shuffle()
    }
    @discardableResult
    mutating func shuffle() -> Array {
        indices.dropLast().forEach { a in
            guard case let b = Int(arc4random_uniform(UInt32(count - a))) + a, b != a else { return }
            self.swapAt(a, b)
        }
        return self
    }
    var chooseOne: Element { return self[Int(arc4random_uniform(UInt32(count)))] }
    func choose(_ n: Int) -> Array { return Array(shuffled.prefix(n)) }
}
class MainViewController: UIViewController {
    
    private func reCard() {
        if showOption == "all" {
            cardDatas = try! Realm().objects(cards.self)
        } else if showOption == "memorized" {
            cardDatas = try! Realm().objects(cards.self).filter("isMemorized = true")
        } else if showOption == "unmemorized" {
            cardDatas = try! Realm().objects(cards.self).filter("isMemorized = false")
        }
    }
    
    private var cardNumbers: Array<String> = []
    
    private func reshuffle() {
        cardNumbers.removeAll()
        var index = 0
        while(cardDatas.count > index) {
            cardNumbers.append(cardDatas[index].number!)
            index = index + 1
        }
        cardNumbers.shuffle()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        level1.tag = 1
        level2.tag = 2
        level3.tag = 3
        level4.tag = 4
        level5.tag = 5
        
        startBlink(label: titleLabel)
        wordLabel.text = ""
        titleLabel.text = ""
        meaningLabel.text = ""
        extraLabel.text = ""
    }
    override func viewDidAppear(_ animated: Bool) {
        if showOption == "all" {
            cardDatas = try! Realm().objects(cards.self)
        } else if showOption == "memorized" {
            cardDatas = try! Realm().objects(cards.self).filter("isMemorized = true")
        } else if showOption == "unmemorized" {
            cardDatas = try! Realm().objects(cards.self).filter("isMemorized = false")
        }
        reshuffle()
        currentIndex = 0
        cardStatus = true
        setLayout()
    }
    
    @IBOutlet private var level1: UIButton!
    @IBOutlet private var level2: UIButton!
    @IBOutlet private var level3: UIButton!
    @IBOutlet private var level4: UIButton!
    @IBOutlet private var level5: UIButton!
    @IBAction private func pressLevels(sender: UIButton) {
        try! Realm().write {
            self.cardDatas.filter("number = '\(self.cardNumbers[self.currentIndex])'")[0].imporment = sender.tag
        }
        self.renewLevel(level: sender.tag)
    }
    
    @IBOutlet private var groupInformation: UILabel!
    
    @IBOutlet private var setButton: UIButton!
    @IBAction private func pressSetButton(sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SetViewController")
        present(vc!, animated: true, completion: nil)
    }
    
    @IBOutlet private var isMemorized: UIButton!
    @IBAction private func pressIsMemorized(sender: UIButton) {
        if sender.tag == 0 {
            try! Realm().write {
                self.cardDatas.filter("number = '\(self.cardNumbers[self.currentIndex])'")[0].isMemorized = true
            }
            sender.tag = 1
            sender.setImage(UIImage(named: "completed.png"), for: .normal)
        } else {
            try! Realm().write {
                self.cardDatas.filter("number = '\(self.cardNumbers[self.currentIndex])'")[0].isMemorized = false
            }
            sender.tag = 0
            sender.setImage(UIImage(named: "uncompleted.png"), for: .normal)
        }
    }
    
    @IBOutlet private var moreButton: UIButton!
    @IBAction private func pressMoreButton(sender: UIButton) {
        let alert = UIAlertController(title: NSLocalizedString("Menu", comment: ""), message: self.cardDatas.filter("number = '\(self.cardNumbers[self.currentIndex])'")[0].word!, preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor.black
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("EditCard", comment: ""), style: .default, handler: {
            (_) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CardEditViewController") as! CardEditViewController
            vc.number = self.cardDatas.filter("number = '\(self.cardNumbers[self.currentIndex])'")[0].number!
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
                    self.cardDatas.filter("number = '\(self.cardNumbers[self.currentIndex])'")[0].group_number = nil
                    self.cardDatas.filter("number = '\(self.cardNumbers[self.currentIndex])'")[0].isGroup = false
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
                        self.cardDatas.filter("number = '\(self.cardNumbers[self.currentIndex])'")[0].group_number = gg.number
                        self.cardDatas.filter("number = '\(self.cardNumbers[self.currentIndex])'")[0].isGroup = true
                    }
                    let alert = MinsuLibrarys().alert_confirm(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("ChangedGroup", comment: ""))
                    self.present(alert, animated: true, completion: nil)
                }))
                index = index + 1
            }
            self.present(alert, animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet private var reloadButton: UIButton!
    @IBAction private func pressReloadButton(sender: UIButton) {
        if try! Realm().objects(cards.self).count == 0 {
            let alert = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("ThereAreNotCard", comment: ""), preferredStyle: .alert)
            alert.view.tintColor = UIColor.black
            present(alert, animated: true, completion: {
                sleep(1)
                self.dismiss(animated: true, completion: nil)
            })
        } else {
            cardStatus = true
            currentIndex = 0
            reCard()
            reshuffle()
            setLayout()
        }
    }
    
    @IBOutlet private var cardDeleteButton: UIButton!
    @IBAction private func pressCardDeleteButton(sender: UIButton) {
        let alert = UIAlertController(title: NSLocalizedString("Message", comment: ""), message: NSLocalizedString("DoYouWantDelete", comment: ""), preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: {
            (_) in
            try! Realm().write {
                try! Realm().delete(self.cardDatas.filter("number = '\(self.cardNumbers[self.currentIndex])'")[0])
            }
            self.reCard()
            self.cardStatus = false
            self.pressCard(sender: self.card)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private var cardStatus = true {
        willSet(new) {
            self.cardDeleteButton.isHidden = false
            if new == false {
                self.wordLabel.isHidden = true
                self.groupInformation.isHidden = false
                self.meaningLabel.isHidden = false
                self.extraLabel.isHidden = false
                self.titleLabel.text = NSLocalizedString("PressCard2", comment: "")
            } else {
                self.wordLabel.isHidden = false
                self.meaningLabel.isHidden = true
                self.extraLabel.isHidden = true
                self.groupInformation.isHidden = true
                self.titleLabel.text = NSLocalizedString("PressCard", comment: "")
            }
        }
    }
    private func nextCard() {
        wordLabel.text = self.cardDatas.filter("number = '\(self.cardNumbers[self.currentIndex])'")[0].word!
        meaningLabel.text = self.cardDatas.filter("number = '\(self.cardNumbers[self.currentIndex])'")[0].meaning!
        extraLabel.text = self.cardDatas.filter("number = '\(self.cardNumbers[self.currentIndex])'")[0].example1!
        renewLevel(level: self.cardDatas.filter("number = '\(self.cardNumbers[self.currentIndex])'")[0].imporment)
        if self.cardDatas.filter("number = '\(self.cardNumbers[self.currentIndex])'")[0].isMemorized == true {
            isMemorized.tag = 1
            isMemorized.setImage(UIImage(named: "completed.png"), for: .normal)
        } else {
            isMemorized.tag = 0
            isMemorized.setImage(UIImage(named: "uncompleted.png"), for: .normal)
        }
        if self.cardDatas.filter("number = '\(self.cardNumbers[self.currentIndex])'")[0].isGroup == true {
            let groupData = try! Realm().objects(group.self).filter("number = '\(self.cardDatas.filter("number = '\(self.cardNumbers[self.currentIndex])'")[0].group_number!)'")[0]
            groupInformation.text = "[\(groupData.name!)]"
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
            groupInformation.textColor = groupColor
        } else {
            groupInformation.text = "[\(NSLocalizedString("NoGroup", comment: ""))]"
            groupInformation.textColor = UIColor.gray
        }
    }
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var wordLabel: UILabel!
    @IBOutlet private var meaningLabel: UILabel!
    @IBOutlet private var extraLabel: UILabel!
    
    private func renewLevel(level: Int) {
        level1.isHidden = false
        level2.isHidden = false
        level3.isHidden = false
        level4.isHidden = false
        level5.isHidden = false
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
    
    @IBOutlet private var cardBackground: UIView!
    @IBOutlet private var card: UIButton!
    @IBAction private func pressCard(sender: UIButton) {
        if cardStatus == false {
            currentIndex = currentIndex + 1
        }
        if cardDatas.count <= currentIndex {
            wordLabel.isHidden = true
            meaningLabel.isHidden = true
            extraLabel.isHidden = true
            cardDeleteButton.isHidden = true
            level1.isHidden = true
            level2.isHidden = true
            level3.isHidden = true
            level4.isHidden = true
            level5.isHidden = true
            titleLabel.isHidden = true
            moreButton.isHidden = true
            isMemorized.isHidden = true
            groupInformation.isHidden = true
            reloadButton.isHidden = false
        } else {
            if cardStatus == true {
                cardStatus = false
            } else {
                cardStatus = true
                nextCard()
            }
        }
    }
    @IBOutlet private var addCard: UIButton!
    @IBAction private func pressAddCard(sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CardAddViewController")
        present(vc!, animated: true, completion: nil)
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
        
        let setButtonConst = {
            () in
            self.setButton.translatesAutoresizingMaskIntoConstraints = false
            self.setButton.setTitle("", for: .normal)
            self.setButton.setImage(UIImage(named: "set.png"), for: .normal)
            self.setButton.tintColor = UIColor.black
            
            let top = NSLayoutConstraint(item: self.setButton, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: GlobalInformation().top_menu_top_size)
            let width = NSLayoutConstraint(item: self.setButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size)
            let height = NSLayoutConstraint(item: self.setButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size)
            let trailing = NSLayoutConstraint(item: self.setButton, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -GlobalInformation().top_menu_space)
            NSLayoutConstraint.activate([top,width,height,trailing])
        }
        setButtonConst()
        
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
            
            let levelColor = UIColor.darkGray
            self.level1.tintColor = levelColor
            self.level2.tintColor = levelColor
            self.level3.tintColor = levelColor
            self.level4.tintColor = levelColor
            self.level5.tintColor = levelColor
            
            if self.cardDatas.count != 0 {
                self.renewLevel(level: self.cardDatas.filter("number = '\(self.cardNumbers[self.currentIndex])'")[0].imporment)
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
                self.titleLabel.isHidden = false
                self.titleLabel.text = NSLocalizedString("PressCard", comment: "")
            } else {
                self.titleLabel.isHidden = true
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
                self.wordLabel.isHidden = false
                self.wordLabel.text = self.cardDatas.filter("number = '\(self.cardNumbers[self.currentIndex])'")[0].word!
            } else {
                self.wordLabel.isHidden = true
            }
            self.wordLabel.numberOfLines = 1
            self.wordLabel.adjustsFontSizeToFitWidth = true
            self.wordLabel.minimumScaleFactor = 0.1
            self.wordLabel.textAlignment = .center
            
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
                self.meaningLabel.isHidden = false
                self.meaningLabel.text = self.cardDatas.filter("number = '\(self.cardNumbers[self.currentIndex])'")[0].meaning!
            } else {
                self.meaningLabel.isHidden = true
            }
            self.meaningLabel.isHidden = true
            self.meaningLabel.numberOfLines = 1
            self.meaningLabel.adjustsFontSizeToFitWidth = true
            self.meaningLabel.minimumScaleFactor = 0.1
            self.meaningLabel.textAlignment = .center
            
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
        
        let extraConst = {
            () in
            self.extraLabel.translatesAutoresizingMaskIntoConstraints = false
            if self.cardDatas.count != 0 {
                self.extraLabel.isHidden = false
                self.extraLabel.text = self.cardDatas.filter("number = '\(self.cardNumbers[self.currentIndex])'")[0].example1!
            } else {
                self.extraLabel.isHidden = true
            }
            self.extraLabel.isHidden = true
            self.extraLabel.numberOfLines = 3
            self.extraLabel.adjustsFontSizeToFitWidth = true
            self.extraLabel.minimumScaleFactor = 0.1
            self.extraLabel.textAlignment = .center
            
            var extraFont: CGFloat {
                if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 560 {
                    return 11
                } else {
                    return 14
                }
            }
            self.extraLabel.font = UIFont.systemFont(ofSize: extraFont)
            let centerX = NSLayoutConstraint(item: self.extraLabel, attribute: .centerX, relatedBy: .equal, toItem: self.cardBackground, attribute: .centerX, multiplier: 1, constant: 0)
            let centerY = NSLayoutConstraint(item: self.extraLabel, attribute: .centerY, relatedBy: .equal, toItem: self.cardBackground, attribute: .centerY, multiplier: 1, constant: 60)
            let leading = NSLayoutConstraint(item: self.extraLabel, attribute: .leading, relatedBy: .equal, toItem: self.cardBackground, attribute: .leading, multiplier: 1, constant: 10)
            let trailing = NSLayoutConstraint(item: self.extraLabel, attribute: .trailing, relatedBy: .equal, toItem: self.cardBackground, attribute: .trailing, multiplier: 1, constant: -10)
            NSLayoutConstraint.activate([centerX,centerY,leading,trailing])
        }
        extraConst()
        
        let cardDeleteConst = {
            () in
            self.cardDeleteButton.translatesAutoresizingMaskIntoConstraints = false
            self.cardDeleteButton.setTitle("", for: .normal)
            self.cardDeleteButton.tintColor = UIColor.black
            self.cardDeleteButton.setImage(UIImage(named: "delete.png"), for: .normal)
            if self.cardDatas.count == 0 {
                self.cardDeleteButton.isHidden = true
            } else {
                self.cardDeleteButton.isHidden = false
            }
            
            let width = NSLayoutConstraint(item: self.cardDeleteButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size)
            let height = NSLayoutConstraint(item: self.cardDeleteButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size)
            let bottom = NSLayoutConstraint(item: self.cardDeleteButton, attribute: .bottom, relatedBy: .equal, toItem: self.cardBackground, attribute: .bottom, multiplier: 1, constant: -20)
            let trailing = NSLayoutConstraint(item: self.cardDeleteButton, attribute: .trailing, relatedBy: .equal, toItem: self.cardBackground, attribute: .trailing, multiplier: 1, constant: -20)
            NSLayoutConstraint.activate([width,height,bottom,trailing])
        }
        cardDeleteConst()
        
        let reloadButtonConst = {
            () in
            self.reloadButton.translatesAutoresizingMaskIntoConstraints = false
            self.reloadButton.setTitle("", for: .normal)
            self.reloadButton.setImage(UIImage(named: "reload.png"), for: .normal)
            self.reloadButton.tintColor = UIColor.black
            if self.cardDatas.count == 0 {
                self.reloadButton.isHidden = false
            } else {
                self.reloadButton.isHidden = true
            }
            
            let width = NSLayoutConstraint(item: self.reloadButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size*2)
            let height = NSLayoutConstraint(item: self.reloadButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size*2)
            let centerX = NSLayoutConstraint(item: self.reloadButton, attribute: .centerX, relatedBy: .equal, toItem: self.cardBackground, attribute: .centerX, multiplier: 1, constant: 0)
            let centerY = NSLayoutConstraint(item: self.reloadButton, attribute: .centerY, relatedBy: .equal, toItem: self.cardBackground, attribute: .centerY, multiplier: 1, constant: 0)
            NSLayoutConstraint.activate([width,height,centerX,centerY])
        }
        reloadButtonConst()
        
        let moreButtonConst = {
            () in
            self.moreButton.translatesAutoresizingMaskIntoConstraints = false
            self.moreButton.setTitle("", for: .normal)
            self.moreButton.setImage(UIImage(named: "more.png"), for: .normal)
            self.moreButton.tintColor = UIColor.black
            if self.cardDatas.count == 0 {
                self.moreButton.isHidden = true
            } else {
                self.moreButton.isHidden = false
            }
            
            let width = NSLayoutConstraint(item: self.moreButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size)
            let height = NSLayoutConstraint(item: self.moreButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size)
            let centerX = NSLayoutConstraint(item: self.moreButton, attribute: .centerX, relatedBy: .equal, toItem: self.cardBackground, attribute: .centerX, multiplier: 1, constant: 0)
            let bottom = NSLayoutConstraint(item: self.moreButton, attribute: .bottom, relatedBy: .equal, toItem: self.cardBackground, attribute: .bottom, multiplier: 1, constant: -20)
            NSLayoutConstraint.activate([width,height,centerX,bottom])
        }
        moreButtonConst()
        
        let isMemorizedConst = {
            () in
            self.isMemorized.translatesAutoresizingMaskIntoConstraints = false
            self.isMemorized.setTitle("", for: .normal)
            self.isMemorized.tintColor = UIColor.black
            if self.cardDatas.count == 0 {
                self.isMemorized.isHidden = true
            } else {
                self.isMemorized.isHidden = false
                if self.cardDatas.filter("number = '\(self.cardNumbers[self.currentIndex])'")[0].isMemorized == true {
                    self.isMemorized.tag = 1
                    self.isMemorized.setImage(UIImage(named: "completed.png"), for: .normal)
                } else {
                    self.isMemorized.tag = 0
                    self.isMemorized.setImage(UIImage(named: "uncompleted.png"), for: .normal)
                }
            }
            let width = NSLayoutConstraint(item: self.isMemorized, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size)
            let height = NSLayoutConstraint(item: self.isMemorized, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: GlobalInformation().top_menu_size)
            let bottom = NSLayoutConstraint(item: self.isMemorized, attribute: .bottom, relatedBy: .equal, toItem: self.cardBackground, attribute: .bottom, multiplier: 1, constant: -20)
            let leading = NSLayoutConstraint(item: self.isMemorized, attribute: .leading, relatedBy: .equal, toItem: self.cardBackground, attribute: .leading, multiplier: 1, constant: 20)
            NSLayoutConstraint.activate([width,height,bottom,leading])
        }
        isMemorizedConst()
        
        let groupInformationConst = {
            () in
            self.groupInformation.translatesAutoresizingMaskIntoConstraints = false
            if self.cardDatas.count != 0 {
                if self.cardDatas.filter("number = '\(self.cardNumbers[self.currentIndex])'")[0].isGroup == true {
                    let gg = try! Realm().objects(group.self).filter("number = '\(self.cardDatas.filter("number = '\(self.cardNumbers[self.currentIndex])'")[0].group_number!)'")
                    self.groupInformation.text = "[\(gg[0].name!)]"
                    var groupColor: UIColor {
                        if gg[0].color == "Red" {
                            return GlobalInformation().card_color_red
                        } else if gg[0].color == "Green" {
                            return GlobalInformation().card_color_green
                        } else if gg[0].color == "Blue" {
                            return GlobalInformation().card_color_blue
                        } else if gg[0].color == "Black" {
                            return GlobalInformation().card_color_black
                        } else {
                            return GlobalInformation().card_color_gray
                        }
                    }
                    self.groupInformation.textColor = groupColor
                } else {
                    self.groupInformation.textColor = UIColor.gray
                    self.groupInformation.text = "[\(NSLocalizedString("NoGroup", comment: ""))]"
                }
            }
            
            var groupFont: CGFloat {
                if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 560 {
                    return 14
                } else {
                    return 17
                }
            }
            self.groupInformation.font = UIFont.systemFont(ofSize: groupFont)
            self.groupInformation.isHidden = true
            
            let centerX = NSLayoutConstraint(item: self.groupInformation, attribute: .centerX, relatedBy: .equal, toItem: self.cardBackground, attribute: .centerX, multiplier: 1, constant: 0)
            let centerY = NSLayoutConstraint(item: self.groupInformation, attribute: .centerY, relatedBy: .equal, toItem: self.cardBackground, attribute: .centerY, multiplier: 1, constant: -45)
            NSLayoutConstraint.activate([centerX,centerY])
        }
        groupInformationConst()
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

