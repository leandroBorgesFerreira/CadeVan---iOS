//
//  MapViewController.swift
//  CadeVan
//
//  Created by Leandro Ferreira on 5/17/16.
//  Copyright © 2016 Leandro Ferreira. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Alamofire
import SwiftyJSON
import RealmSwift

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    //MARK:  Properties
    let locationManager = CLLocationManager()
    var usersCurrentLocation : CLLocationCoordinate2D?
    var vanAnnotation : MKPointAnnotation?
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var findingDriverLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*let bar:UINavigationBar! =  self.navigationController?.navigationBar
        
        bar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.4, alpha: 0.6)
        bar.tintColor = UIColor.whiteColor()*/
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.showsUserLocation = true
        mapView.delegate = self
        locationManager.startUpdatingLocation()
        
        let realm = try! Realm()
        //let driver : DriverChosen = realm.objects(DriverChosen).filter("chosen == true").first!
        let driver : DriverChosen = realm.objects(DriverChosen).first!
    
        startUpdatingVan(driver.id)

    }
    
    
    func startUpdatingVan(vanId : Int){
        Alamofire.request(.GET, "http://simplepass.teramundi.com:8080/cadevan/vans/" + vanId.description).validate().responseJSON {
            response in

            if(response.result.isSuccess){
                self.findingDriverLabel.hidden = true
                
                let driver = JSON(response.result.value!)
                let vanCoordinate = CLLocationCoordinate2DMake(driver["latitude"].double!, driver["longitude"].double!)
                var title = ""
                var subtitle = ""
                
                let pointAnnotation = MKPointAnnotation()
                
                if(self.vanAnnotation == nil){
                    title = driver["name"].string!
                    
                    if(driver["direction"].string != nil && !driver["direction"].string!.isEmpty){
                        subtitle = "direção: " + driver["direction"].string!
                    }
                    
                    if(driver["timeToArrive"].string != nil && !driver["timeToArrive"].string!.isEmpty){
                        title +=  " - " + driver["timeToArrive"].string!
                    }
                    
                    pointAnnotation.title = title
                    pointAnnotation.subtitle = subtitle
                    pointAnnotation.coordinate = vanCoordinate
                    
                    self.vanAnnotation = pointAnnotation
                    
                    if(self.mapView != nil){
                        self.mapView.addAnnotation(self.vanAnnotation!)
                        
                        let center = CLLocationCoordinate2D(latitude: self.vanAnnotation!.coordinate.latitude, longitude: self.vanAnnotation!.coordinate.longitude)
                        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                        self.mapView.setRegion(region, animated: true)
                    }
                } else{
                    UIView.animateWithDuration(0.5){
                        self.vanAnnotation!.coordinate = vanCoordinate
                        
                        title = driver["name"].string!
                        
                        if(driver["direction"].string != nil && !driver["direction"].string!.isEmpty){
                            subtitle = "direção: " + driver["direction"].string!
                        }
                        
                        if(driver["timeToArrive"].string != nil && !driver["timeToArrive"].string!.isEmpty){
                            title +=  " - " + driver["timeToArrive"].string!
                        }
                        
                        
                        self.vanAnnotation?.title = title
                        self.vanAnnotation?.subtitle = subtitle
                    }
                }
                
                self.mapView.selectAnnotation(self.vanAnnotation!, animated: true)
            } else {
                self.findingDriverLabel.hidden = false
            }
            
            self.runAfterDelay(8.0){
                self.startUpdatingVan(vanId)
            }
        }
    }
    
    func runAfterDelay(delay: NSTimeInterval, block: dispatch_block_t) {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), block)
    }
    
    //MARK: Location Delegate Methods
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(vanAnnotation == nil){
            let location = locations.last
            let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            
            self.mapView.setRegion(region, animated: true)
        }
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        //print("Erro ao localizar: " + error.localizedDescription)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "id"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.enabled = true
            anView!.canShowCallout = true
            
            if(annotation is MKPointAnnotation){
                anView!.image = UIImage(named: "ic_bus.png")
            } else{
                
            }
        } else {
            anView!.annotation = annotation
        }
        
        return anView
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
