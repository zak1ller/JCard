//
//  Minsu Librarys.swift
//  JCard
//
//  Created by 민수 on 2017. 10. 6..
//  Copyright © 2017년 김민수. All rights reserved.
//

import Foundation
import UIKit

class MinsuLibrarys {
    
    var alertColor: UIColor {
        if UserDefaults.standard.string(forKey: "AlertColor") == "black" {
            return UIColor.black
        }
        return UIColor.black
    }
    func alert_confirm(title: String, message: String, handle: ()) -> UIAlertController {
        let alert = UIAlertController()
        alert.view.tintColor = alertColor
        alert.addAction(UIAlertAction(title: "Confirm", style: .cancel, handler: nil))
        return alert
    }
    func alert_yes_no(title: String, message: String, handle: ()) -> UIAlertController {
        let alert = UIAlertController()
        alert.view.tintColor = alertColor
        alert.addAction(UIAlertAction(title: "YES", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
        return alert
    }
}
