//
//  Utils.swift
//  CadeVan
//
//  Created by Leandro Ferreira on 5/10/16.
//  Copyright © 2016 Leandro Ferreira. All rights reserved.
//

import Foundation
import UIKit

class Utils{
    static func toDic(target : AnyObject) -> [String : AnyObject] {
        var dict = [String : AnyObject]()
        let otherSelf = Mirror(reflecting: target)
        for child in otherSelf.children {
            if let key = child.label {
                dict[key] = child.value as? AnyObject
            }
        }
        return dict
    }
    
    static func md5(string string: String) -> String {
        var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
        if let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
            CC_MD5(data.bytes, CC_LONG(data.length), &digest)
        }
        
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex
    }
    
    
    static func addShakeAnimation(txtField : UITextField){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(txtField.center.x - 10, txtField.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(txtField.center.x + 10, txtField.center.y))
        txtField.layer.addAnimation(animation, forKey: "position")
        
    }
}