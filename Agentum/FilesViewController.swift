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
        
       
        
        /*************************************************************************************************/
        //Пример работы dbAccess
        /*
        var w = Worker.newRecord()
        
        Worker.registerDatabaseName("test", useDirectory: ARStorageDocuments)
        w.Photo = "photo.png"
        w.FirstName = "Irina"
        w.LastName = "Dec"
        w.MiddleName = "Ig"
        w.MobilePhone = "6384573495"
        w.HomeAddress = "Lenina - 8"
        w.HomePhone = "3463746"
        w.IsWorkingNow = 0;
        w.JobType = "fulltime"
        w.Birthday = "12.08.97"
        w.OtherContacts = "contacts"
        w.Email = "Irina@gmail.com"
        w.save()
        */
        
        /*************************************************************************************************/
        //Пример работы iActiveRecord
        //JOIN осуществляется только по одному столбцу
        /*
        var w = Worker.newRecord()
        
        Worker.registerDatabaseName("test", useDirectory: ARStorageDocuments)
        w.Photo = "photo.png"
        w.FirstName = "Irina"
        w.LastName = "Dec"
        w.MiddleName = "Ig"
        w.MobilePhone = "6384573495"
        w.HomeAddress = "Lenina - 8"
        w.HomePhone = "3463746"
        w.IsWorkingNow = 0;
        w.JobType = "fulltime"
        w.Birthday = "12.08.97"
        w.OtherContacts = "contacts"
        w.Email = "Irina@gmail.com"
        w.save()


        WorkerSkill.registerDatabaseName("test", useDirectory: ARStorageDocuments)
        
        var w0 = WorkerSkill.newRecord()
        w0.id_Skill = 34;
        w0.id_Worker = 2;
        w0.save()
        
        var w1 = WorkerSkill.newRecord()
        w1.id_Skill = 33;
        w1.id_Worker = 2;
        w1.save()
        
        var w2 = WorkerSkill.newRecord()
        w2.id_Skill = 100;
        w2.id_Worker = 2;
        w2.save()

        //JOIN
        //Worker.registerDatabaseName("test", useDirectory: ARStorageDocuments)
        //WorkerSkill.registerDatabaseName("test", useDirectory: ARStorageDocuments)
        var fetcher = Worker.lazyFetcher()
        fetcher.join(WorkerSkill.classForCoder(), useJoin: ARJoinInner, onField: "id", andField: "id_Worker")
        //Возвращает массив словарей, где ключ - строка название класса, а value - объект типа ActiveRecord 
        //Array<Dictionary<NSString, ActiveRecord>>
        var joinedRecords = fetcher.fetchJoinedRecords() as NSArray
        println(joinedRecords.count)
        /*
        var workers = Worker.allRecords()
        var worker: AnyObject? = workers.first
        worker?.dropRecord()
       */
        
        /*************************************************************************************************/
        //Пример работы с чистым FMDB

        //var object = "Worker"
        //databaseController.addNewWorker(object)
        
        
        var filePath = NSBundle.mainBundle().pathForResource("20141203-v1-base", ofType: "sql");
        println("Path = "+filePath!)
        self.executeSqlFileWith(filePath!, andDatabase: databaseController.database!)
        var filePath2 = NSBundle.mainBundle().pathForResource("20141203-v2-update", ofType: "sql");
        self.executeSqlFileWith(filePath2!, andDatabase: databaseController.database!)
        */
        
        //var success = database.executeStatements("create table if not exists test_table (test_no NUMBER, test_name TEXT);")
        
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

    
    
   
}
