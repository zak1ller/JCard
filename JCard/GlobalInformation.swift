//
//  GlobalInformation.swift
//  JCard
//
//  Created by 민수 on 2017. 10. 6..
//  Copyright © 2017년 김민수. All rights reserved.
//

import Foundation
import UIKit

class GlobalInformation {
    private let screen = UIScreen.main.bounds
    
    var top_menu_font_size: CGFloat {
        if screen.width <= 320 && screen.height <= 560 {
            return 1*0.83
        } else {
            return 1
        }
    }
    var top_menu_size: CGFloat {
        if screen.width <= 320 && screen.height <= 560 {
            return 32*0.83
        } else {
            return 32
        }
    }
    var top_menu_color: UIColor {
        if UserDefaults.standard.string(forKey: "TopMenuColor") == "black" {
            return UIColor.black
        }
        return UIColor.black
    }
}
