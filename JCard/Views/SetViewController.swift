//
//  SetViewController.swift
//  JCard
//
//  Created by 민수 on 2017. 10. 16..
//  Copyright © 2017년 김민수. All rights reserved.
//

import Foundation
import RealmSwift

class SetViewController: UITableViewController {
    override func viewDidLoad() {
        backButton.setTitle(NSLocalizedString("Back", comment: ""), for: .normal)
        backButton.tintColor = UIColor.black
        
        var fontSize: CGFloat {
            if UIScreen.main.bounds.width <= 320 && UIScreen.main.bounds.height <= 560 {
                return 12
            } else {
                return 15
            }
        }
        wordManagement.text = NSLocalizedString("WordManagement", comment: "")
        wordManagement.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        wordManagement.textColor = UIColor.black
        wordManagement.tag = 101
        groupManagement.text = NSLocalizedString("GroupManagement", comment: "")
        groupManagement.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        groupManagement.textColor = UIColor.black
        groupManagement.tag = 102
        backup.text = NSLocalizedString("BackUp", comment: "")
        backup.font = UIFont.systemFont(ofSize: fontSize)
        backup.textColor = UIColor.black
        backup.tag = 103
    }
    
    @IBOutlet private var backButton: UIButton!
    @IBAction private func pressBackButton(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet private var wordManagement: UILabel!
    @IBOutlet private var groupManagement: UILabel!
    @IBOutlet private var backup: UILabel!
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        
        if cell.tag == 101 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CardManagementViewController")
            self.present(vc!, animated: true, completion: nil)
        } else if cell.tag == 102 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupManagementViewController")
            self.present(vc!, animated: true, completion: nil)
        } else if cell.tag == 103 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BackUpViewController")
            self.present(vc!, animated: true, completion: nil)
        }
    }
}
