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
    let textCellIdentifier2 = "operationCell2"
    
    var jobPlanID: Int = 0
    
    var jobTechOpAdapterArray: Array<JobTechOpAdapterModel> = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTableView()
        
        var jobTechOpReposit = JobTechOpReposit()
        jobTechOpReposit.generateJobTechOpList("\(jobPlanID)")
        jobTechOpAdapterArray =  jobTechOpReposit.jobTechOps
        table .reloadData()
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
        var jtopam = jobTechOpAdapterArray[indexPath.row]
        var cellIdentifier = textCellIdentifier
        
        if(jtopam.countFiles?.intValue > 0){
            cellIdentifier = textCellIdentifier2
        }
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? OperationViewCell{
            if let name = jtopam.techOpName{
                cell.name.text = name as String
            }
            if let finishedDay = jtopam.FinishedDay{
                cell.date.text = finishedDay as String
            }
            if let status = jtopam.stateTypeValue{
                cell.status.text = status as String
                
            }
            if let countFile = jtopam.countFiles{
                cell.numberOfFiles.text = "Файлы(\(countFile.intValue))"
            }
            
            return cell
        }
        
        return UITableViewCell()
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
