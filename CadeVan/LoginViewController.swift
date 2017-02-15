//
//  LoginViewController.swift
//  CadeVan
//
//  Created by Leandro Ferreira on 5/10/16.
//  Copyright © 2016 Leandro Ferreira. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner
import SwiftyJSON
import RealmSwift

class LoginViewController: UIViewController, UITextFieldDelegate {
    //MARK: Properties
    
    @IBOutlet weak var contryCodeTextInput: UITextField!
    @IBOutlet weak var phoneTextInput: UITextField!
    @IBOutlet weak var passwordTextInput: UITextField! 
    
    //MARK: Actions
    
    @IBAction func actionsLogin(sender: UIButton) {
        var cancel = false;
        
        if(contryCodeTextInput.text!.isEmpty){
            Utils.addShakeAnimation(contryCodeTextInput)
            cancel = true
        }
        if(phoneTextInput.text!.isEmpty){
            Utils.addShakeAnimation(phoneTextInput)
            cancel = true
        }
        if(passwordTextInput.text!.isEmpty){
            Utils.addShakeAnimation(passwordTextInput)
            cancel = true
        }
        
        if(!cancel){
            self.view.endEditing(true)
            
            var phone : String = contryCodeTextInput.text! + phoneTextInput.text!
            phone = phone.stringByReplacingOccurrencesOfString("+", withString: "")
            
            let password = passwordTextInput.text!
            
            SwiftSpinner.show("Aguarde")
            
            login(LoginDto(userName: phone, password: password))
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func login(loginDto : LoginDto){
        let credentialData = "\(Constants.CLIENT_ID):\(Constants.CLIENT_SECRET)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        Alamofire.request(.POST, "http://simplepass.teramundi.com:8080/cadevan/oauth/token", headers: headers, parameters : Utils.toDic(loginDto), encoding: .URL).validate().responseJSON { response in
            SwiftSpinner.hide()
            
            if(response.result.isSuccess){
                let json = JSON(response.result.value!)
                
                let accessToken : AccessToken = AccessToken()
                accessToken.acessToken = json["access_token"].description
                accessToken.scope = json["scope"].description
                accessToken.tokenType = json["token_type"].description
                
                let realm = try! Realm()
                try! realm.write {
                    realm.add(accessToken)
                    realm.objects(UserRealm).first?.accessToken = accessToken
                }
                
                let defaults = NSUserDefaults.standardUserDefaults()
                let updatePushToken = UpdatePushToken(pushToken: defaults.stringForKey(Constants.APNS_TOKEN_KEY))
                
                if(updatePushToken.pushToken != nil){
                    Alamofire.request(.POST, "http://simplepass.teramundi.com:8080/cadevan/users/updatePushToken/" + loginDto.username , parameters: Utils.toDic(updatePushToken), encoding: .JSON).validate().response{
                        response in
                        
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "logedIn")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
                        self.performSegueWithIdentifier("loginSuccessSegue", sender: self)
                    }
                } else{
                    self.performSegueWithIdentifier("loginSuccessSegue", sender: self)
                }
                
            } else{                
                let alert = UIAlertController(title: "Falha ao entrar", message: "Por favor, tente novamente", preferredStyle: UIAlertControllerStyle.Alert)
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
    
    func hau() -> Int{
        return 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

}
