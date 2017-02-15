//
//  Token.swift
//  CadeVan
//
//  Created by Leandro Ferreira on 5/11/16.
//  Copyright © 2016 Leandro Ferreira. All rights reserved.
//

import Foundation
import RealmSwift

class AccessToken : Object{
    var acessToken : String?
    var scope : String?
    var tokenType : String?
}
