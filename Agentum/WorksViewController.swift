//
//  WorksViewController.swift
//  Agentum
//
//  Created by IMAC  on 07.08.15.
//
//

import UIKit


class WorksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet var table: UITableView!
    @IBOutlet var segmentControl: UISegmentedControl!
    
    var actualWorks: NSArray!
    var testWorks: NSArray!
    var readyWorks: NSArray!
    
    enum workState {
        case actualWorkState
        case testWorkState
        case readyWorkState
    }
    
    var currentWorkState: workState = workState.actualWorkState{
        didSet{
            self.workStateChanged()
        }
    }
    
    let textCellIdentifier = "workCell"
    let textCellIdentifier2 = "workCell2"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: getters and setters
    func workStateChanged()
    {
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
        return 10;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
    }

    
    
    // MARK:  UISegmentedControl Methods
    
    @IBAction func segmentChangedValue(sender: UISegmentedControl) {
        
        switch (sender.selectedSegmentIndex) {
        case 0:
            currentWorkState = workState.actualWorkState
            break
        case 1:
            currentWorkState = workState.testWorkState
            break
        case 2:
            currentWorkState = workState.readyWorkState
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
