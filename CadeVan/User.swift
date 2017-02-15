//
//  User.swift
//  CadeVan
//
//  Created by Leandro Ferreira on 5/10/16.
//  Copyright © 2016 Leandro Ferreira. All rights reserved.
//

import Foundation
class User {
    var id : Int
    var name : String
    var email : String
    var gcmToken : String
    var password : String
    var phoneNumber : String
    var os : String
    var accessToken : String
    
    init(id : Int, name: String, email : String, gcmToken : String, password : String, phoneNumber : String, accessToken : String){
        self.id = id
        self.name = name
        self.email = email
        self.gcmToken = gcmToken
        self.password = Utils.md5(string: password)
        self.phoneNumber =  phoneNumber
        self.os = "iOS"
        self.accessToken = accessToken
    }
}