//
//  BackUpViewBrain.swift
//  JCard
//
//  Created by 민수 on 2017. 10. 22..
//  Copyright © 2017년 김민수. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import SwiftyJSON
import SystemConfiguration

class BackUpViewBrain {
    internal func isConnectToNetwork(handler: (_ result:Bool) -> ()) {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            handler(false)
        }
    
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        if ret == true { handler(true) }
        else { handler(false) }
    }
    
    internal func CheckAlreadyAccount(username: String, complete: @escaping (_ result: String) -> ()) {
        let url = NSURL(string: "http://suhz23.cafe24.com/JCard/CheckAlreadyAccount.php?username=\(username)")!
        let request = URLRequest(url: url as URL)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            if error != nil {
                complete("false")
                return
            }
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                let resultData = jsonData as! NSDictionary
                complete(resultData["result"] as! String)
            } catch {
                complete("false")
            }
        })
        task.resume()
    }
    
    internal func CreateAccount(username: String, pw: String, hint: String = "0", complete: @escaping (_ result: String) -> ()) {
        let url = NSURL(string: "http://suhz23.cafe24.com/JCard/CreateAccount.php?username=\(username)&password=\(pw)&hint=\(hint)")!
        let request = URLRequest(url: url as URL)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            if error != nil {
                complete("false")
                return
            }
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                let resultData = jsonData as! NSDictionary
                complete(resultData["result"] as! String)
            } catch {
                complete("false")
            }
        })
        task.resume()
    }
    
    internal func login(username: String, password: String, complete: @escaping (_ result: String) -> ()) {
        let url = NSURL(string: "http://suhz23.cafe24.com/JCard/Login.php?username=\(username)&password=\(password)")!
        let request = URLRequest(url: url as URL)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            if error != nil {
                complete("false")
                return
            }
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                let resultData = jsonData as! NSDictionary
                complete(resultData["result"] as! String)
            } catch {
                complete("false")
            }
        })
        task.resume()
    }

}
