//
//  ViewController.swift
//  CadeVan
//
//  Created by Leandro Ferreira on 5/6/16.
//  Copyright © 2016 Leandro Ferreira. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Descomente a linha abaixo para imprimir onde está localizada a pasta do Realm.
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        if(NSUserDefaults.standardUserDefaults().boolForKey("logedIn")){
            let realm = try! Realm()
            
            if(realm.objects(DriverChosen).filter("chosen == true").isEmpty){
                self.performSegueWithIdentifier("logedInSegue", sender: self)
            } else{
                self.performSegueWithIdentifier("logedAndDriverChosenSegue", sender: self)
            }
            
        }
        
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        
        bar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor(red: 0.0, green: 0.3, blue: 0.5, alpha: 0.0)
        bar.tintColor = UIColor.whiteColor()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

