//
//  DriversViewController.swift
//  CadeVan
//
//  Created by Leandro Ferreira on 5/11/16.
//  Copyright © 2016 Leandro Ferreira. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class DriversViewController: UIViewController {
    

    //MARK: Properties
    @IBOutlet weak var loadingButton: LoadingButton!
    @IBOutlet weak var trackingCodeTextInput: UITextField!
    
    
    //MARK: Actions
    
    @IBAction func submitAction(sender: LoadingButton) {
        if(trackingCodeTextInput.text!.isEmpty){
            Utils.addShakeAnimation(trackingCodeTextInput)
        } else{
            getDriverByCode(trackingCodeTextInput.text!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDriverByCode(code : String){
        loadingButton.showLoading()
        
        Alamofire.request(.GET, "http://simplepass.teramundi.com:8080/cadevan/drivers", parameters: ["trackingCode" : code]).validate().responseJSON{
            response in
            
            self.loadingButton.hideLoading()
            
            if(response.result.isSuccess){
                let json = JSON(response.result.value!)
                
                for(_, driver) in json{
                    let alertController = UIAlertController(title: "Motorista", message: "Esse é o motorista correto: \"" + driver["name"].description + "\"?", preferredStyle: .Alert)
                    
                    let cancelAction = UIAlertAction(title: "NÃO", style: .Cancel) { (action) in
                    }
                    alertController.addAction(cancelAction)
                    
                    let OKAction = UIAlertAction(title: "SIM", style: .Default) { (action:UIAlertAction!) in
                        let chosenDriver = DriverChosen()
                        
                        chosenDriver.id = driver["id"].int!
                        chosenDriver.name = driver["name"].description
                        chosenDriver.phoneNumber = driver["phoneNumber"].description
                        chosenDriver.trackingCode = driver["trackingCode"].description
                        chosenDriver.chosen = true;
                        
                        let realm = try! Realm()
                        
                        try! realm.write {                            
                            for driver in realm.objects(DriverChosen).filter("chosen == true") {
                                driver.chosen = false
                            }
                            
                            realm.add(chosenDriver)
                        }
                        
                        self.performSegueWithIdentifier("driverChosenSegue", sender: self)
                    }
                    
                    alertController.addAction(OKAction)
                    
                    self.presentViewController(alertController, animated: true, completion:nil)
                }
            } else{
                let alertController = UIAlertController(title: "Motorista", message: "Nenhum motorista foi encontrado com o código: " + code, preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
                }
                alertController.addAction(cancelAction)
                
                self.presentViewController(alertController, animated: true, completion:nil)
            }
        }
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
