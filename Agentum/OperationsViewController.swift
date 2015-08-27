//
//  OperationsViewController.swift
//  Agentum
//
//  Created by IMAC  on 09.08.15.
//
//

import UIKit

class OperationsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var table: UITableView!
    
    let textCellIdentifier = "operationCell"
    var jobPlanID: Int = 0
    
    var jobTechOpAdapterArray: Array<JobTechOpAdapterModel> = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTableView()

        var operations = APP.i().databaseController!.getJobTechOps("\(jobPlanID)", isDone: false, findProblemOperation: false)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Configures
    
    func configureTableView() {
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 160.0
    }

    
    // MARK:  UITableViewDelegate Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return jobTechOpAdapterArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as? OperationViewCell
        
        var jobTechOp = operations[indexPath.row]
        //cell!.name.text = jobTechOp.
        
        return cell!
    }


    /*
    // MARK: - Navigation

cation, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
