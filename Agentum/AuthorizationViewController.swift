//
//  AuthorizationViewController.swift
//  Agentum
//
//  Created by Agentum on 25.08.15.
//
//

import UIKit

class AuthorizationViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(keyboardWillAppear()), name: UIKeyboardWillShowNotification, object: nil)
        // Do any additional setup after loading the view.
    }

    func keyboardWillAppear(){
        println("Keyboard will appear")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func authorize(sender: UIButton) {
        var result = User.authorize("frodo", password: "123")
        
    }

    // MARK: -UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        
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
