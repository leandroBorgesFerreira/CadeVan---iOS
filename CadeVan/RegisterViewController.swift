//
//  RegisterViewController.swift
//  CadeVan
//
//  Created by Leandro Ferreira on 5/10/16.
//  Copyright © 2016 Leandro Ferreira. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift
import SwiftSpinner
class RegisterViewController: UIViewController {
    //MARK: Properties
    
    @IBOutlet weak var countryCodeTextInput: UITextField!
    @IBOutlet weak var phoneNumberTextInput: UITextField!
    @IBOutlet weak var firstNameTextInput: UITextField!
    @IBOutlet weak var lastNameTextInput: UITextField!
    @IBOutlet weak var emailTextInput: UITextField!
    @IBOutlet weak var passwordTextInput: UITextField!
    
    //MARK: Actions
    @IBAction func registerAction(sender: UIButton) {
        var cancel = false
        
        if(countryCodeTextInput.text!.isEmpty){
            Utils.addShakeAnimation(countryCodeTextInput)
            cancel = true;
        }
        if(phoneNumberTextInput.text!.isEmpty){
            Utils.addShakeAnimation(phoneNumberTextInput)
            cancel = true;
        }
        if(firstNameTextInput.text!.isEmpty){
            Utils.addShakeAnimation(firstNameTextInput)
            cancel = true;
        }
        if(lastNameTextInput.text!.isEmpty){
            Utils.addShakeAnimation(lastNameTextInput)
            cancel = true;
        }
        if(emailTextInput.text!.isEmpty){
            Utils.addShakeAnimation(emailTextInput)
            cancel = true;
        }
        if(passwordTextInput.text!.isEmpty){
            Utils.addShakeAnimation(passwordTextInput)
            cancel = true;
        }
        
        var phone = countryCodeTextInput.text! + phoneNumberTextInput.text!
        phone = phone.stringByReplacingOccurrencesOfString("+", withString: "")
        let name = firstNameTextInput.text! + " " + lastNameTextInput.text!
        let email = emailTextInput.text!
        let password = passwordTextInput.text!
        
        if(!cancel){
            self.view.endEditing(true)
            
            SwiftSpinner.show("Registrando")
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            let user = User(id: 0, name: name, email: email, gcmToken: defaults.stringForKey(Constants.APNS_TOKEN_KEY)!, password: password, phoneNumber: phone, accessToken: "")
            insertUser(user)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        
        bar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        bar.tintColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func insertUser(user : User){
        
        Alamofire.request(.POST, "http://simplepass.teramundi.com:8080/cadevan/users",
            parameters: Utils.toDic(user), encoding: .JSON).validate().responseJSON{
                response in
                
                SwiftSpinner.hide()
                
                print(response)
                
                if(response.result.isSuccess){
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "logedIn")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    let json = JSON(response.result.value!)
                    
                    let userFromServer : User = User(id: json["id"].int!,
                        name: json["name"].description,
                        email: json["email"].description,
                        gcmToken: json["gcmToken"].description,
                        password: "",
                        phoneNumber: json["phoneNumber"].description,
                        accessToken: json["accessToken"].description)
                    
                    self.saveUserInfo(userFromServer)
                    self.performSegueWithIdentifier("registerSuccessSegue", sender: self)
                } else{
                    let alert = UIAlertController(title: "Falha ao registrar", message: "Por favor, tente novamente", preferredStyle: UIAlertControllerStyle.Alert)
                    let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){
                        (UIAlertAction) -> Void in
                    }
                    
                    alert.addAction(alertAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
        }
    }
    
    func saveUserInfo(user: User){
        let realm = try! Realm()
        
        try! realm.write {
            realm.delete(realm.objects(UserRealm))
            realm.add(UserRealm.fromUser(user))
        }
    }

}
