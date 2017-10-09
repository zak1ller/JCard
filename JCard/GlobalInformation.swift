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
    
    var top_menu_top_size: CGFloat {
        if screen.width <= 320 && screen.height <= 560 {
            return 35*0.83
        } else {
            return 35
        }
    }
    var top_menu_space: CGFloat {
        if screen.width <= 320 && screen.height <= 560 {
            return 20*0.83
        } else {
            return 20
        }
    }
    var top_menu_font_size: CGFloat {
        if screen.width <= 320 && screen.height <= 560 {
            return 11
        } else {
            return 14
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
    
    var tf_height_size: CGFloat {
        if screen.width <= 320 && screen.height <= 560 {
            return 30*0.83
        } else {
            return 30
        }
    }
    var tf_font_size: CGFloat {
        if screen.width <= 320 && screen.height <= 560 {
            return 14
        } else {
            return 17
        }
    }
}
