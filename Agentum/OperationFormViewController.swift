//
//  OperationFormViewController.swift
//  Agentum
//
//  Created by IMAC  on 04.09.15.
//
//

import UIKit

class OperationFormViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let cellIdentifier = "cell"
    @IBOutlet var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Navigation Bar Button Item's actions
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
    @IBAction func save(sender: AnyObject) {
        let alert = UIAlertController(title: "",
            message: "Уверены, что хотите сохранить результаты операции?",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        let callCancelActionHandler = { (action:UIAlertAction!) -> Void in
            self.dismissViewControllerAnimated(true, completion: {});
        }
        let cancelAction = UIAlertAction(title: "OK",
            style: .Cancel, handler: callCancelActionHandler)
                alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true,
            completion:nil)
        
    }
    
    //MARK: - UITable Delegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func configureTableView() {
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 160.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: AnyObject = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        return cell as! UITableViewCell
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
