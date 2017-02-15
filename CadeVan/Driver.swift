//
//  Driver.swift
//  CadeVan
//
//  Created by Leandro Ferreira on 5/11/16.
//  Copyright © 2016 Leandro Ferreira. All rights reserved.
//

import Foundation
import RealmSwift

class Driver : Object{
    var id : Int?
    var name : String?
    var email : String?
    var phoneNumber : String?
    var gcmToken : String?
    
}