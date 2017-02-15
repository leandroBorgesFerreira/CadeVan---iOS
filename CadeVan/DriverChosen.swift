//
//  DriverChosen.swift
//  CadeVan
//
//  Created by Leandro Ferreira on 5/16/16.
//  Copyright © 2016 Leandro Ferreira. All rights reserved.
//

import Foundation
import RealmSwift

class DriverChosen : Object{
    dynamic var id = 0
    dynamic var name : String?
    dynamic var email : String?
    dynamic var phoneNumber : String?
    dynamic var gcmToken : String?
    dynamic var trackingCode : String?
    dynamic var chosen = false
    
}