//
//  AuthorizationViewController.swift
//  Agentum
//
//  Created by Agentum on 25.08.15.
//
//

import UIKit

class AuthorizationViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate{
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet var scroll: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func authorize(sender: UIButton) {
        login.resignFirstResponder()
        password.resignFirstResponder()

        var result = User.authorize(self.login.text, password: self.password.text.md5)
        if result == true{
            self.performSegueWithIdentifier("modalSegue", sender: self)
        }
        else{
            var alert = UIAlertController(title: nil, message: "Неверный логин или пароль", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
    }

    // MARK: -UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        scroll.setContentOffset(CGPointMake(0, 100), animated: true)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        scroll.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
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
