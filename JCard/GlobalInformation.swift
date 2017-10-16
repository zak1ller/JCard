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
    
    var card_color_green = UIColor(red: 0/255, green: 168/255, blue: 107/255, alpha: 1)
    var card_color_red = UIColor(red: 169/255, green: 5/255, blue: 51/255, alpha: 1)
    var card_color_blue = UIColor(red: 0/255, green: 71/255, blue: 133/255, alpha: 1)
    var card_color_black = UIColor(red: 45/255, green: 45/255, blue: 45/255, alpha: 1)
    var card_color_gray = UIColor.lightGray
    var color_lightBlue = UIColor(red: 52/255, green: 204/255, blue: 255/255, alpha: 1)
    
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
            return 12
        } else {
            return 15
        }
    }
}
