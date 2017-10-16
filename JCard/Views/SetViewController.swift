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
                return 11
            } else {
                return 14
            }
        }
        wordManagement.text = NSLocalizedString("WordManagement", comment: "")
        wordManagement.font = UIFont.systemFont(ofSize: fontSize)
        wordManagement.tag = 101
    }
    
    @IBOutlet private var backButton: UIButton!
    @IBAction private func pressBackButton(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet private var wordManagement: UILabel!
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        
        if cell.tag == 101 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "")
            self.present(vc!, animated: true, completion: nil)
        } else if cell.tag == 102 {
            
        }
    }
}
