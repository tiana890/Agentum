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
        
        currentJobState = jobState.actualJobState
        
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
        return currentJobs.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cellIdentifier = textCellIdentifier
        var jam = currentJobs[indexPath.row]
        if(jam.countFile?.intValue > 0){
            cellIdentifier = textCellIdentifier2
        }
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! WorkCell
        
        if let name = jam.name{
             cell.name.text = name as String
        }
        
        if let isDone = jam.isOperationDone{
            if let operationTotalCount = jam.operationTotalCount{
                cell.numberOfOperations.text = "Выполнено \(isDone.intValue) из \(operationTotalCount.intValue)"
            }
        }
        if let countFile = jam.countFile{
            if countFile.intValue > 0{
                cell.numberOfFiles.text = "Файлы(\(countFile))"
            }
        }
        if let pname = jam.projectName{
            cell.objectName.text = "Объект: " + String(pname)
        }
        if let status = jam.stateTypeValue{
            cell.status.text = "Статус: " + String(status)
        }
        
      
        cell.layoutIfNeeded()
        return cell
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
            var indexPath = table.indexPathForSelectedRow()
            var job = currentJobs[indexPath!.row]
            var jobPlanID = job.idJobPlan
            oc.jobPlanID = Int(jobPlanID!.intValue)
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
