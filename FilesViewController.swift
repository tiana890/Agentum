//
//  FilesViewController.swift
//  Agentum
//
//  Created by IMAC  on 11.08.15.
//
//

import UIKit

class FilesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let documentsFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as? String
        let path = documentsFolder!.stringByAppendingPathComponent("test.sqlite")
        
        var databaseController = DatabaseController()
        
        databaseController.initWithDatabase(path)
        
        if !databaseController.database!.open() {
            println("Unable to open database")
            return
        }
        
        var object = "Worker"
        databaseController.addNewWorker(object)
        
        /*
        var filePath = NSBundle.mainBundle().pathForResource("20141203-v1-base", ofType: "sql");
        println("Path = "+filePath!)
        
        self.executeSqlFileWith(filePath!, andDatabase: database)
        database.setUserVersion(1)
        println("Version = \(database.userVersion())")
        
        var success = database.executeStatements("create table if not exists test_table (test_no NUMBER, test_name TEXT);")
        */
        //[db executeUpdate:@"INSERT INTO mytable (desc,sdate,interval,itype,price) VALUES (?,?,?,?,?);",
       // strDesc, datStartDate, numInterval, strIntervalType, strAmount, nil];
        //database.close()
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func executeSqlFileWith(path:String, andDatabase db:FMDatabase)
    {
        let fileManager = NSFileManager.defaultManager()
        var error: NSError?
        
        if fileManager.fileExistsAtPath(path){
            let sqlString = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: &error)
            
            
            if sqlString != nil{
                var sqlStatements = sqlString?.componentsSeparatedByString(";\n")
                
                for sqlStatement: String in sqlStatements! {
                    var success = db.executeStatements(sqlStatement.stringByAppendingString(";"))
                }
            }
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
