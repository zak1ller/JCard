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
                return 13
            } else {
                return 17
            }
        }
        wordManagement.text = NSLocalizedString("WordManagement", comment: "")
        wordManagement.font = UIFont.systemFont(ofSize: fontSize, weight: .black)
        wordManagement.textColor = UIColor.darkGray
        wordManagement.tag = 101
        groupManagement.text = NSLocalizedString("GroupManagement", comment: "")
        groupManagement.font = UIFont.systemFont(ofSize: fontSize, weight: .black)
        groupManagement.textColor = UIColor.darkGray
        groupManagement.tag = 102
    }
    
    @IBOutlet private var backButton: UIButton!
    @IBAction private func pressBackButton(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet private var wordManagement: UILabel!
    @IBOutlet private var groupManagement: UILabel!
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        
        if cell.tag == 101 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CardManagementViewController")
            self.present(vc!, animated: true, completion: nil)
        } else if cell.tag == 102 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupManagementViewController")
            self.present(vc!, animated: true, completion: nil)
        }
    }
}
