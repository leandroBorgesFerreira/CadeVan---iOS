//
//  MapCustomAnnotation.swift
//  CadeVan
//
//  Created by Leandro Ferreira on 6/7/16.
//  Copyright © 2016 Leandro Ferreira. All rights reserved.
//

import UIKit
import MapKit

class MapCustomAnnotation: NSObject, MKAnnotation {
    
    var title: String?
    var subtitle: String?
    var timeToArrive: String?
    var coordinate: CLLocationCoordinate2D
    
    
    init(   title: String,
            subtitle: String,
            timeToArrive: String,
            coordinate: CLLocationCoordinate2D ){
        
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.timeToArrive = timeToArrive
        
        super.init()
    }
}