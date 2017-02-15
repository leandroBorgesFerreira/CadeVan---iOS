//
//  LoginDto.swift
//  CadeVan
//
//  Created by Leandro Ferreira on 5/11/16.
//  Copyright © 2016 Leandro Ferreira. All rights reserved.
//

import Foundation
class LoginDto{
    var username : String
    var password : String
    var grant_type = "password"
    
    init(userName : String, password : String){
        self.username = userName
        self.password = Utils.md5(string: password)
    }
}