//
//  CardInformation.swift
//  JCard
//
//  Created by 민수 on 2017. 10. 6..
//  Copyright © 2017년 김민수. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class CardInformation {
}

class cards: Object {
    @objc dynamic var number: String?
    @objc dynamic var group_number: String?
    @objc dynamic var group_color: String?
    @objc dynamic var word: String?
    @objc dynamic var meaning: String?
    @objc dynamic var example1: String?
    @objc dynamic var example2: String?
    @objc dynamic var imporment = 3
    @objc dynamic var isMemorized = false
    @objc dynamic var isHidden = false
    @objc dynamic var isGroup = false
}

class group: Object {
    @objc dynamic var number: String?
    @objc dynamic var name: String?
    @objc dynamic var color: String?
}
