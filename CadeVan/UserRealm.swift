//
//  UserRealm.swift
//  CadeVan
//
//  Created by Leandro Ferreira on 5/10/16.
//  Copyright © 2016 Leandro Ferreira. All rights reserved.
//

import Foundation
import RealmSwift

class UserRealm : Object{
    var id : Int?
    var name : String?
    var email : String?
    var gcmToken : String?
    var phoneNumber : String?
    var accessToken : AccessToken?
    var os : String?
    
    static func fromUser(user : User) -> UserRealm{
        let userRealm = UserRealm();
        
        userRealm.id = user.id
        userRealm.name = user.name
        userRealm.email = user.email
        userRealm.gcmToken = user.gcmToken
        userRealm.phoneNumber = user.phoneNumber
        userRealm.os = user.os
        
        let acessToken : AccessToken = AccessToken()
        acessToken.acessToken = user.accessToken
        
        userRealm.accessToken = acessToken
        
        return userRealm
    }
}
