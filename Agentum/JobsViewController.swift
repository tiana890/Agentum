//
//  JobsViewController.swift
//  Agentum
//
//  Created by Agentum on 27.08.15.
//
//

import UIKit


class JobsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var table: UITableView!
    @IBOutlet var segmentControl: UISegmentedControl!
    
    var currentJobs: Array<JobAdapterModel> = []
    
    enum jobState {
        case actualJobState
        case completeJobState
        case finishJobState
    }
    
    var currentJobState: jobState = jobState.actualJobState{
        didSet{
            self.jobStateChanged()
        }
    }
    
    let textCellIdentifier = "workCell"
    let textCellIdentifier2 = "workCell2"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTableView()
        
        var instance = APP.i()
        APP.i().jobReposit?.generateJobLists()
        println("log")
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: getters and setters
    func jobStateChanged()
    {
        switch (currentJobState) {
           case .actualJobState:
              currentJobs = APP.i().jobReposit!.actualJobs
              break;
           case .completeJobState:
               currentJobs = APP.i().jobReposit!.completeJobs
               break;
           case .finishJobState:
               currentJobs = APP.i().jobReposit!.finishJobs
               default:
           break;
    }
        table.reloadData()
    }
    
    // MARK: Configures
    
    func configureTableView() {
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 160.0
    }
    
    
    // MARK:  UITableViewDelegate Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*
        switch (currentWorkState) {
        case .actualWorkState:
        return actualWorks.count
        case .testWorkState:
        return testWorks.count
        case .readyWorkState:
        return actualWorks.count
        
        default:
        return 0
        }
        */
        return currentJobs.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        /*
        if indexPath.row % 2 == 0
        {
            let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier2, forIndexPath: indexPath) as? WorkCell
            cell!.name.text = "Залить фундамент, покрасить стены"
            cell!.numberOfOperations.text = "Выполнено 2 из 2 операций"
            cell!.numberOfFiles.text = "Файлы(2)"
            cell!.layoutIfNeeded()
            return cell!
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as? WorkCell
            cell!.name.text = "Залить фундамент, покрасить стены"
            cell!.numberOfOperations.text = "Выполнено 2 из 2 операций"
            cell!.layoutIfNeeded()
            return cell!
        }
*/
        var jam = currentJobs[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as? WorkCell
        cell!.name.text = jam.name! as String
        cell!.numberOfOperations.text = "Выполнено \(jam.isOperationDone!.intValue) из \(jam.operationTotalCount!.intValue)"
        cell!.layoutIfNeeded()
        return cell!
    }
    
    
    
    // MARK:  UISegmentedControl Methods
    
    @IBAction func segmentChangedValue(sender: UISegmentedControl) {
        
        switch (sender.selectedSegmentIndex) {
        case 0:
            currentJobState = jobState.actualJobState
            break
        case 1:
            currentJobState = jobState.completeJobState
            break
        case 2:
            currentJobState = jobState.finishJobState
            break
        default:
            break;
        }
    }
    
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "operationSegue"{
            var oc = segue.destinationViewController as! OperationsViewController
            
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