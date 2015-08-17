//
//  DatabaseController.swift
//  Agentum
//
//  Created by IMAC  on 12.08.15.
//
//

import UIKit

class DatabaseController: NSObject {
   
    typealias DatabaseUpdateBlock = (database:FMDatabase?)->Void
    typealias DatabaseFetchBlock = (database:FMDatabase?)->FMResultSet
    typealias DatabaseFetchResultsBlock = ()
    
    let serialDispatchQueue = dispatch_queue_create("serialQueue", nil)
    
    var database: FMDatabase?
    
    func initWithDatabase(path: String){
        database = FMDatabase(path: path)
    }
  
    private func beginTransaction (){
        self.database?.beginTransaction()
    }
    
    private func endTransaction (){
        self.database?.commit()
    }
    
    private func runDatabaseBlockInTransaction(databaseBlock: DatabaseUpdateBlock){
        dispatch_async(self.serialDispatchQueue, { () -> Void in
            self.beginTransaction()
            databaseBlock(database: self.database)
            self.endTransaction()
        })
    }
    
    private func runFetchForClass(databaseObjectClass: AnyClass, fetchBlock: DatabaseFetchBlock, fetchResultsBlock: DatabaseFetchResultsBlock){
        var result = fetchBlock(database: self.database)
        
    }
    
    func addNewWorker(worker: AnyObject)
    {
        //вместо AnyObject должен быть тип объекта
        self.runDatabaseBlockInTransaction { (database) -> Void in
            self.database?.executeUpdate("insert into Worker (Photo, LastName, FirstName, MiddleName, Birthday, MobilePhone, HomePhone, Email, HomeAddress, OtherContacts) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", withArgumentsInArray: ["photo.jpg", "Zayceva", "Marina", "Alekseevna", "15.04.1989", "89098734783", "2334512", "smth@smth.ru", "Lenina 82-15", "2451678"])
        }
    }
    
    func getWorkers()
    {
        self.runFetchForClass(Worker.classForCoder(), fetchBlock: { (database) -> FMResultSet in
            //res = self.database?.executeQuery("select * from Worker", withArgumentsInArray: nil)
            
            if let res = self.database?.executeQuery("select count(*) from Worker", withArgumentsInArray: nil){
                while res.next() {
                    let x = res.stringForColumn("count(*)")
                    
                    println("name = \(x); ")
                    return res
                }
            } else {
                println("select failed: \(self.database?.lastErrorMessage())")
                //return self.database?.executeQuery("select count(*) from Worker", withArgumentsInArray: nil)
            }
            return nil;
           
            }, fetchResultsBlock: ())
    }
    
    
    func upgradeDatabaseIfRequired(){
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let previousVersion = defaults.stringForKey("version")
        let currentVersion = self.versionNumberString()
        
        if (previousVersion == nil || previousVersion!.compare(currentVersion as String, options: NSStringCompareOptions.NumericSearch) == NSComparisonResult.OrderedAscending) {
            
            let plistPath = NSBundle.mainBundle().pathForResource("UpgradeDatabase", ofType: "plist")
            var plist:NSArray = NSArray(contentsOfFile: plistPath!) as! [[String:String]]
            
            //perform all upgrades
            if (previousVersion == nil){
                for (var i = 0; i < plist.count; i++){
                    var dict = plist[i] as! Dictionary<String, String>
                    var version = (dict as Dictionary)["version"]
                    var fileName = dict["updateFileName"]
                    var filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: "sql");
                    println("file path for update" + filePath!)
                    self.executeSqlFileWith(filePath!, andDatabase: self.database!)
                }
            }
            //perform needed upgrades
            else{
                for (var i = 0; i < plist.count; i++){
                    var dict = plist[i] as! Dictionary<String, String>
                    var version = (dict as Dictionary)["version"]
                    var fileName = dict["updateFileName"]
                    var filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: "sql");
                    println("file path for update" + filePath!)
                    if (previousVersion!.compare(currentVersion as String, options: NSStringCompareOptions.NumericSearch) == NSComparisonResult.OrderedAscending) {
                        self.executeSqlFileWith(filePath!, andDatabase: self.database!)
                    }
                }
            }
            
        }
        
        defaults.setValue(currentVersion, forKey: "version")
        defaults.synchronize()
    }

    private func versionNumberString() -> NSString{
        var version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as! NSString
        return version
    }
    
    private func executeSqlFileWith(path:String, andDatabase db:FMDatabase)
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
