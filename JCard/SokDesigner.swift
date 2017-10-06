//
//  AddViewDesinger.swift
//  Soksok
//
//  Created by 민수 on 2017. 4. 20..
//  Copyright © 2017년 김민수. All rights reserved.
//

import Foundation
import UIKit

class SokDesigner {
    
    // 기기별 사이즈 초기화를 위한 프로퍼티
    let s_subViewTitleFont = UIFont.systemFont(ofSize: 13)
    let s_textfieldFont = UIFont.systemFont(ofSize: 13)
    let s_viewHeight = CGFloat(100)
    let b_subViewTitleFont = UIFont.systemFont(ofSize: 17)
    let b_textfieldFont = UIFont.systemFont(ofSize: 20)
    let b_viewHeight = CGFloat(140)
    
    // 테두디에 사용 될 객체
    let topLine = UILabel()
    let bottomLine = UILabel()
    let leftLine = UILabel()
    let rightLine = UILabel()
    let color = UIColor.darkGray
    
    // 테두리를 그리는 작업을 위해 객체들을 초기화
    init() {
        topLine.backgroundColor = color
        bottomLine.backgroundColor = color
        leftLine.backgroundColor = color
        rightLine.backgroundColor = color
        
        topLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        rightLine.translatesAutoresizingMaskIntoConstraints = false
        
        topLine.tag = 1
        bottomLine.tag = 2
        leftLine.tag = 3
        rightLine.tag = 4
    }
    
    // 객체를 받아서 테두리를 둥글게 한다
    public func cornerRadius(obj: AnyObject, value: CGFloat = 16) {
        if let result = obj as? UIView {
            result.layer.cornerRadius = result.frame.width/value
            result.clipsToBounds = true
        } else if let result = obj as? UIButton {
            result.layer.cornerRadius = result.frame.width/value
            result.clipsToBounds = true
        } else if let result = obj as? UITextField {
            result.layer.cornerRadius = result.frame.width/value
            result.clipsToBounds = true
        } else if let result = obj as? UILabel {
            result.layer.cornerRadius = result.frame.width/value
            result.clipsToBounds = true
        } else if let result = obj as? UITextView {
            result.layer.cornerRadius = result.frame.width/value
            result.clipsToBounds = true
        }
    }
    
    // 뷰를 받아서 뷰에 테두리를 그린다
    public func activateView(view: UIView) {
        view.addSubview(topLine)
        view.addSubview(bottomLine)
        view.addSubview(leftLine)
        view.addSubview(rightLine)
        draw(view: view, label: topLine, direction: .top)
        draw(view: view, label: bottomLine, direction: .bottom)
        draw(view: view, label: leftLine, direction: .left)
        draw(view: view, label: rightLine, direction: .right)
    }
    
    // 객체를 받아서 테두리를 지운다
    public func unActivateView(obj:AnyObject) {
        if let result = obj as? UIView {
            var sub = result.subviews
            sub.removeAll()
        } else if let result = obj as? UITextField {
            var sub = result.subviews
            sub.removeAll()
        }
    }
    
    // 객체를 받아서 밑줄을 그어줌
    public func insertLineForTextField(obj:AnyObject, color: UIColor = UIColor.black, stroke: CGFloat = 2, alpha: CGFloat = 0.05) {
        let line = UILabel()
        line.backgroundColor = color
        line.translatesAutoresizingMaskIntoConstraints = false
        line.alpha = alpha
        
        if let ob = obj as? UITextField {
          obj.addSubview(line)
            let lbo = NSLayoutConstraint(item: line, attribute: .bottom, relatedBy: .equal, toItem: ob, attribute: .bottom, multiplier: 1, constant: 0)
            let hei = NSLayoutConstraint(item: line, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: stroke)
            let le = NSLayoutConstraint(item: line, attribute: .leading, relatedBy: .equal, toItem: ob, attribute: .leading, multiplier: 1, constant: 0)
            let tr = NSLayoutConstraint(item: line, attribute: .trailing, relatedBy: .equal, toItem: ob, attribute: .trailing, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([lbo,hei,le,tr])
            return
        }
        
        if let ob = obj as? UIButton {
            obj.addSubview(line)
            let lbo = NSLayoutConstraint(item: line, attribute: .bottom, relatedBy: .equal, toItem: ob, attribute: .bottom, multiplier: 1, constant: 0)
            let hei = NSLayoutConstraint(item: line, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: stroke)
            let le = NSLayoutConstraint(item: line, attribute: .leading, relatedBy: .equal, toItem: ob, attribute: .leading, multiplier: 1, constant: 0)
            let tr = NSLayoutConstraint(item: line, attribute: .trailing, relatedBy: .equal, toItem: ob, attribute: .trailing, multiplier: 1, constant: 0)
            NSLayoutConstraint.activate([lbo,hei,le,tr])
            return
        }
        
        if let ob = obj as? UILabel {
            obj.addSubview(line)
            let lbo = NSLayoutConstraint(item: line, attribute: .bottom, relatedBy: .equal, toItem: ob, attribute: .bottom, multiplier: 1, constant: 0)
            let hei = NSLayoutConstraint(item: line, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: stroke)
            let le = NSLayoutConstraint(item: line, attribute: .leading, relatedBy: .equal, toItem: ob, attribute: .leading, multiplier: 1, constant: 0)
            let tr = NSLayoutConstraint(item: line, attribute: .trailing, relatedBy: .equal, toItem: ob, attribute: .trailing, multiplier: 1, constant: 0)
            NSLayoutConstraint.activate([lbo,hei,le,tr])
        }
        
        if let ob = obj as? UIView {
            obj.addSubview(line)
            let lbo = NSLayoutConstraint(item: line, attribute: .bottom, relatedBy: .equal, toItem: ob, attribute: .bottom, multiplier: 1, constant: 0)
            let hei = NSLayoutConstraint(item: line, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: stroke)
            let le = NSLayoutConstraint(item: line, attribute: .leading, relatedBy: .equal, toItem: ob, attribute: .leading, multiplier: 1, constant: 0)
            let tr = NSLayoutConstraint(item: line, attribute: .trailing, relatedBy: .equal, toItem: ob, attribute: .trailing, multiplier: 1, constant: 0)
            NSLayoutConstraint.activate([lbo,hei,le,tr])
            return
        }
        
    }
    
    // UI 객체를 받아서 사이즈 초기화
    public func resizing(obj:AnyObject, wi:CGFloat, he:CGFloat) {
        if let button = obj as? UIButton {
            let width = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: wi)
            let height = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: he)
            NSLayoutConstraint.activate([width,height])
        }
        if let field = obj as? UITextField {
            let width = NSLayoutConstraint(item: field, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: wi)
            let height = NSLayoutConstraint(item: field, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: he)
            NSLayoutConstraint.activate([width,height])
        }
        if let label = obj as? UILabel {
            let width = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: wi)
            let height = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: he)
            NSLayoutConstraint.activate([width,height])
        }
        if let vi = obj as? UIView {
            let width = NSLayoutConstraint(item: vi, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: wi)
            let height = NSLayoutConstraint(item: vi, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: he)
            NSLayoutConstraint.activate([width,height])
        }
    }
    
    // activateView 함수에서 사용하는 테두리 구현의 상세한 내용
    private func draw(view:UIView ,label:UILabel, direction:drawDirection) {
        let bold = CGFloat(2.0)
        switch direction {
        case .top:
            let le = NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
            let tr = NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
            let top = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
            let he = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: bold)
            NSLayoutConstraint.activate([le,tr,top,he])
            break
        case .bottom:
            let le = NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
            let tr = NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
            let he = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: bold)
            let bt = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
            NSLayoutConstraint.activate([le,tr,he,bt])
            break
        case .left:
            let le = NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
            let top = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
            let bottom = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
            let wi = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: bold)
            NSLayoutConstraint.activate([le,top,bottom,wi])
            break
        case .right:
            let tr = NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
            let top = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
            let bottom = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
            let wi = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: bold)
            NSLayoutConstraint.activate([tr,top,bottom,wi])
            break
        }
    }
}

// draw 함수에서 테두리를 그릴 방향 값
enum drawDirection {
    case top
    case bottom
    case left
    case right
}
