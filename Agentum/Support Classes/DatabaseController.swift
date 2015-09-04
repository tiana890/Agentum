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
    
    let currentVersion = 10
    
    var database: FMDatabase?
    
    //MARK: Low level database methods
    
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
    
    private func runFetchForClass(databaseObjectClass: AnyClass, fetchBlock: DatabaseFetchBlock, fetchResultsBlock: DatabaseFetchResultsBlock) -> FMResultSet{
        var result = fetchBlock(database: self.database)
        return result
    }
    
    //MARK: methods for Entities
    func getJobPlansBy(workerID: String, brigadeIDs: String){
        self.runFetchForClass(JobPlan.classForCoder(), fetchBlock: { (database) -> FMResultSet in
            var sql1 = "SELECT jobPlan.* " +
                " FROM JobPlan AS jobPlan " +
                " INNER JOIN JobTechOpPlan AS jobTechOpPlan ON " +
                "  jobTechOpPlan.id_JobPlan = jobPlan.id AND " +
                "  jobTechOpPlan.IsVisible AND " +
                "  jobTechOpPlan.StartingMoment <= ? " +
                " LEFT JOIN JobPlanWorker AS jobWorker ON jobPlan.id = jobWorker.id_JobPlan AND jobWorker.id_Worker = " + "\(workerID)" + " " +
                " LEFT JOIN JobPlanBrigade AS jobBrigade ON jobPlan.id = jobBrigade.id_JobPlan AND jobBrigade.id_Brigade IN (" + brigadeIDs + ") " +
                " LEFT JOIN JobTechOpPlanWorker AS opWorker ON jobTechOpPlan.id = opWorker.id_JobTechOpPlan AND opWorker.id_Worker = " + "\(workerID)" + " " +
                " LEFT JOIN JobTechOpPlanBrigade AS opBrigade ON jobTechOpPlan.id = opBrigade.id_JobTechOpPlan AND opBrigade.id_Brigade IN (" + brigadeIDs + ") " +
                " WHERE jobPlan.IsVisible AND jobPlan.StartingMoment <= ? AND " +
                "  (jobWorker.id IS NOT NULL OR jobBrigade.id IS NOT NULL OR opWorker.id IS NOT NULL OR opBrigade.id IS NOT NULL)" +
            " GROUP BY jobPlan.id"
            
            //var timeString = NSDate(dateString:"2015-08-26 00:00:00")
            var currentDate = NSDate()
            var timeString = currentDate.toString()
            
            if let res = self.database?.executeQuery(sql1, withArgumentsInArray: [timeString, timeString]){
                var jobPlanIDs = ""
                while res.next() {
                    let idJobPlan = res.stringForColumn("id")
                    //println("id job plan = \(idJobPlan); ")
                    jobPlanIDs = jobPlanIDs + "\(idJobPlan),"
                }
                
                if(count(jobPlanIDs) > 0){
                    if(jobPlanIDs[jobPlanIDs.endIndex.predecessor()] == ","){
                        jobPlanIDs = dropLast(jobPlanIDs)
                    }
                }

                return res
            } else {
                println("select failed: \(self.database?.lastErrorMessage())")
                //return self.database?.executeQuery("select count(*) from Worker", withArgumentsInArray: nil)
            }
            return FMResultSet()
            
        }, fetchResultsBlock: ())

    }

    func getJobsBy(jobPlanIDs: String, limit: Int, workerID: String, brigadeIDs: String) -> Array<Job>{
        var result = self.runFetchForClass(Job.classForCoder(), fetchBlock: { (database) -> FMResultSet in
            var sql = "SELECT job.*, object.Name as objectName " +
                "FROM Job AS job " +
                "INNER JOIN JobPlan AS jobPlan ON job.id = jobPlan.id_Job AND jobPlan.IsVisible AND jobPlan.StartingMoment <= ? " +
                "LEFT JOIN JobPlanWorker AS worker ON jobPlan.id = worker.id_JobPlan " +
                "LEFT JOIN JobPlanBrigade AS brigade ON jobPlan.id = brigade.id_JobPlan " +
                "LEFT JOIN Object AS object ON job.id_Object = object.id " +
                "WHERE worker.id_Worker = " + "\(workerID)" + " OR brigade.id_Brigade IN (" + "\(brigadeIDs)" + ") OR jobPlan.id IN (" + "\(jobPlanIDs)" + ") " +
                "GROUP BY job.id " +
            "ORDER BY jobPlan.Ord, job.Deadline "
            
            if limit > 0{
                sql = sql + "\(limit)"
            }
            
            //var timeString = NSDate(dateString:"2015-08-26 00:00:00")
            var currentDate = NSDate()
            var timeString = currentDate.toString()
            
            if let res = self.database?.executeQuery(sql, withArgumentsInArray: [timeString, timeString]){
                return res
            } else {
                println("select failed: \(self.database?.lastErrorMessage())")
            }
            return FMResultSet()
            
            }, fetchResultsBlock: ())
        
        var jobArray: Array<Job> = []
        
        while result.next() {
            var j = Job()
           
            j.ID = NSNumber(int:result.intForColumn("id"))
        
            j.Name = result.stringForColumn("Name")
        
            j.State = result.stringForColumn("State")
    
            j.Description = result.stringForColumn("Description")
        
            j.FinishedDay = result.stringForColumn("FinishedDay")
        
            j.Deadline = result.stringForColumn("Deadline")
       
            j.ProjectName = result.stringForColumn("objectName")

            jobArray.append(j)
        }
        
        return jobArray

    }
    
    func getJobPlanAdapterModelBy(workerID: String, brigadeIDs: String) -> Array<JobPlanAdapterModel>{
        var result = self.runFetchForClass(Job.classForCoder(), fetchBlock: { (database) -> FMResultSet in
            
            var sql = "SELECT jobPlan.id, jobPlan.id_Job " +
                " FROM JobPlan AS jobPlan " +
                " LEFT JOIN JobTechOpPlan AS jobTechOpPlan ON " +
                "  jobTechOpPlan.id_JobPlan = jobPlan.id AND " +
                "  jobTechOpPlan.IsVisible AND " +
                "  jobTechOpPlan.StartingMoment <= ? " +
                " LEFT JOIN JobPlanWorker AS jobWorker ON jobPlan.id = jobWorker.id_JobPlan AND jobWorker.id_Worker = " + "\(workerID)" + " " +
                " LEFT JOIN JobPlanBrigade AS jobBrigade ON jobPlan.id = jobBrigade.id_JobPlan AND jobBrigade.id_Brigade IN (" + brigadeIDs + ") " +
                " LEFT JOIN JobTechOpPlanWorker AS opWorker ON jobTechOpPlan.id = opWorker.id_JobTechOpPlan AND opWorker.id_Worker = " + "\(workerID)" + " " +
                " LEFT JOIN JobTechOpPlanBrigade AS opBrigade ON jobTechOpPlan.id = opBrigade.id_JobTechOpPlan AND opBrigade.id_Brigade IN (" + brigadeIDs + ") " +
                " WHERE jobPlan.IsVisible AND jobPlan.StartingMoment <= ? AND " +
                "  (jobWorker.id IS NOT NULL OR jobBrigade.id IS NOT NULL OR opWorker.id IS NOT NULL OR opBrigade.id IS NOT NULL)" +
            " GROUP BY jobPlan.id";

            //var timeString = NSDate(dateString:"2015-08-26 00:00:00")
            var currentDate = NSDate()
            var timeString = currentDate.toString()
            
            if let res = self.database?.executeQuery(sql, withArgumentsInArray: [timeString, timeString]){

                return res
            } else {
                println("select failed: \(self.database?.lastErrorMessage())")
                //return self.database?.executeQuery("select count(*) from Worker", withArgumentsInArray: nil)
            }
            return FMResultSet()
            
            }, fetchResultsBlock: ())
        
        var jobPlanAdapterModelArray: Array<JobPlanAdapterModel> = []
        
        while result.next() {
            var jpam = JobPlanAdapterModel()
            jpam.jobPlanID = NSNumber(int: result.intForColumn("id"))
            jpam.jobID = NSNumber(int: result.intForColumn("id_Job"))
            jobPlanAdapterModelArray.append(jpam)
        }
        
        return jobPlanAdapterModelArray
    }

    func getCountTechOpsForJob(jobPlanIDs: String, workerID: String, brigadeIDs: String) -> Array<CountTechOpsResponse>{
        var result = self.runFetchForClass(Job.classForCoder(), fetchBlock: { (database) -> FMResultSet in
            
            var sql = "SELECT jobTechOp.id_Job AS idJob, COUNT(jobTechOp.id) totalCount, SUM(jobTechOp.IsDone) doneCount, SUM(jobTechOp.HasProblems) as hasProblems, SUM(jobTechOp.StartedDay) as startedCount" +
                " FROM JobTechOp AS jobTechOp" +
                " WHERE jobTechOp.id IN (" +
                "SELECT jobTechOpPlan.id_JobTechOp" +
                " FROM JobTechOpPlan AS jobTechOpPlan" +
                // таблицы для определения своя-чужая работа
                " INNER JOIN JobPlan as jobPlan ON jobPlan.id=jobTechOpPlan.id_JobPlan" +
                " AND jobPlan.IsVisible" +
                " AND jobPlan.StartingMoment <= ?" +
                " LEFT JOIN JobPlanWorker AS jobWorker ON jobPlan.id = jobWorker.id_JobPlan AND jobWorker.id_Worker = " + workerID +
                " LEFT JOIN JobPlanBrigade AS jobBrigade ON jobPlan.id = jobBrigade.id_JobPlan AND jobBrigade.id_Brigade IN (" + brigadeIDs + ")" +
                // таблицы для определения исполнителей, связанных с операциями
                " LEFT JOIN JobTechOpPlanWorker AS worker ON jobTechOpPlan.id = worker.id_JobTechOpPlan AND worker.id_Worker = " + workerID +
                " LEFT JOIN JobTechOpPlanBrigade AS brigade ON jobTechOpPlan.id = brigade.id_JobTechOpPlan AND brigade.id_Brigade IN (" + brigadeIDs + ")" +
                " LEFT JOIN JobTechOpPlanWorker AS otherWorker ON jobTechOpPlan.id = otherWorker.id_JobTechOpPlan" +
                " LEFT JOIN JobTechOpPlanBrigade AS otherBrigade ON jobTechOpPlan.id = otherBrigade.id_JobTechOpPlan" +
                // условие получения плана для операции, и следовательно, самой операции
                " WHERE jobTechOpPlan.id_JobPlan IN (" + jobPlanIDs + ")" +
                " AND jobTechOpPlan.IsVisible" +
                " AND jobTechOpPlan.StartingMoment <= ?" +
                " AND (" +
                // условие для своих работ
                "((jobWorker.id IS NOT NULL OR jobBrigade.id IS NOT NULL)" +
                " AND (worker.id IS NOT NULL OR brigade.id IS NOT NULL OR (otherWorker.id IS NULL AND otherBrigade.id IS NULL)))" +
                " OR " +
                // условия для не своих работ
                "(NOT (jobWorker.id IS NOT NULL OR jobBrigade.id IS NOT NULL)" +
                " AND (worker.id IS NOT NULL OR brigade.id IS NOT NULL))" +
                ")" +
                " GROUP BY jobTechOpPlan.id_JobTechOp" +
                ")" +
            " GROUP BY jobTechOp.id_Job"
            
            //var timeString = NSDate(dateString:"2015-08-26 00:00:00")
            var currentDate = NSDate()
            var timeString = currentDate.toString()
            
            if let res = self.database?.executeQuery(sql, withArgumentsInArray: [timeString, timeString]){
                
                return res
            } else {
                println("select failed: \(self.database?.lastErrorMessage())")
                //return self.database?.executeQuery("select count(*) from Worker", withArgumentsInArray: nil)
            }
            return FMResultSet()
            
            }, fetchResultsBlock: ())
        
        var countTechOpsResponseArray: Array<CountTechOpsResponse> = []
        
        while result.next() {
            var ctor = CountTechOpsResponse()
            
            ctor.jobID = NSNumber(int: result.intForColumn("idJob"))
            ctor.totalCount = NSNumber(int: result.intForColumn("totalCount"))
            ctor.isDone =  NSNumber(int: result.intForColumn("doneCount"))
            if(result.intForColumn("hasProblems") > 0){
                ctor.hasProblems = true
            } else {
                ctor.hasProblems = false
            }
            if(result.intForColumn("startedCount") > 0){
                ctor.started = true
            } else {
                ctor.started = false
            }
            countTechOpsResponseArray.append(ctor)
        }
        return countTechOpsResponseArray
    }
    
    func getFilesForJob(jobIDs: String) -> Array<CountFileResponse>{
        var result = self.runFetchForClass(Job.classForCoder(), fetchBlock: { (database) -> FMResultSet in
            var sql = "SELECT count(id) as count, id_Job as idJob " +
                "FROM DocFileJob " +
                "WHERE id_Job in (" + jobIDs + ") " +
            "GROUP BY id_Job";
            
            if let res = self.database?.executeQuery(sql, withArgumentsInArray: nil){
                
                return res
            } else {
                println("select failed: \(self.database?.lastErrorMessage())")
                //return self.database?.executeQuery("select count(*) from Worker", withArgumentsInArray: nil)
            }
            return FMResultSet()
            
            }, fetchResultsBlock: ())
        
        var countFileResponseArray: Array<CountFileResponse> = []
        
        while result.next() {
            var cfr = CountFileResponse()
            
            cfr.jobID = NSNumber(int: result.intForColumn("idJob"))
            cfr.countFile = NSNumber(int: result.intForColumn("count"))
            
            countFileResponseArray.append(cfr)
        }
        return countFileResponseArray
    }
    
    func getJobTechOps(jobPlanID: String, isDone: Bool, findProblemOperation: Bool) -> Array<JobTechOp>{
        var result = self.runFetchForClass(Job.classForCoder(), fetchBlock: { (database) -> FMResultSet in
            
            var isDoneQuery = " jobTechOp.isDone AND "
            var findProbleQuery = " jobTechOp.HasProblems AND "
            
            var currentDate = NSDate()
            var timeString = currentDate.toString()
            
            var sql: String?
            if(self.jobForMe(jobPlanID, workerID: APP.i().workerID!, brigadeIDs: APP.i().brigadeIDs!) == true){
                sql = "SELECT jobTechOp.* " +
                    "FROM JobTechOp AS jobTechOp " +
                    "INNER JOIN JobTechOpPlan AS jobTechOpPlan ON jobTechOpPlan.id_JobPlan = " + jobPlanID + " AND jobTechOp.id = jobTechOpPlan.id_JobTechOp AND jobTechOpPlan.IsVisible AND jobTechOpPlan.StartingMoment <= ? " +
                    "LEFT JOIN JobTechOpPlanWorker AS worker ON jobTechOpPlan.id = worker.id_JobTechOpPlan AND worker.id_Worker = " + APP.i().workerID! + " " +
                    "LEFT JOIN JobTechOpPlanBrigade AS brigade ON jobTechOpPlan.id = brigade.id_JobTechOpPlan AND brigade.id_Brigade IN (" + APP.i().brigadeIDs! + ") " +
                    "LEFT JOIN JobTechOpPlanWorker AS otherWorker ON jobTechOpPlan.id = otherWorker.id_JobTechOpPlan " +
                    "LEFT JOIN JobTechOpPlanBrigade AS otherBrigade ON jobTechOpPlan.id = otherBrigade.id_JobTechOpPlan " +
                    "WHERE " + (isDone ? isDoneQuery : "") + (findProblemOperation ? findProbleQuery : "") + " (worker.id IS NOT NULL OR brigade.id IS NOT NULL OR (otherWorker.id IS NULL AND otherBrigade.id IS NULL)) " +
                    "GROUP BY jobTechOp.id " +
                "ORDER BY jobTechOpPlan.Ord";
            } else {
                sql = "SELECT jobTechOp.* " +
                    "FROM JobTechOp AS jobTechOp " +
                    "INNER JOIN JobTechOpPlan AS jobTechOpPlan ON jobTechOpPlan.id_JobPlan = " + jobPlanID + " AND jobTechOp.id = jobTechOpPlan.id_JobTechOp AND jobTechOpPlan.IsVisible AND jobTechOpPlan.StartingMoment <= ? " +
                    "LEFT JOIN JobTechOpPlanWorker AS worker ON jobTechOpPlan.id = worker.id_JobTechOpPlan AND worker.id_Worker = " + APP.i().workerID! + " " +
                    "LEFT JOIN JobTechOpPlanBrigade AS brigade ON jobTechOpPlan.id = brigade.id_JobTechOpPlan AND brigade.id_Brigade IN (" + APP.i().brigadeIDs! + ") " +
                    "WHERE " + (isDone ? isDoneQuery : "") + (findProblemOperation ? findProbleQuery : "") + " (worker.id IS NOT NULL OR brigade.id IS NOT NULL) " +
                    "GROUP BY jobTechOp.id " +
                "ORDER BY jobTechOpPlan.Ord";
            }
            
            if let res = self.database?.executeQuery(sql, withArgumentsInArray: [timeString]){
                
                return res
            } else {
                println("select failed: \(self.database?.lastErrorMessage())")
                //return self.database?.executeQuery("select count(*) from Worker", withArgumentsInArray: nil)
            }
            return FMResultSet()
            
            }, fetchResultsBlock: ())
        
        var jobTechOpArray: Array<JobTechOp> = []
        
        while result.next() {
            var jtop = JobTechOp()
            
            //if(result.intForColumn("id")) != nil){
                jtop.ID = NSNumber(int:result.intForColumn("id"))
//}
            //if(result.intForColumn("Sync") != nil){
                jtop.Sync = NSNumber(int:result.intForColumn("Sync"))
           // }
           // if(NSNumber(int:result.intForColumn("Amount")) != nil){
                jtop.Amount = NSNumber(int:result.intForColumn("Amount"))
            //}
            //if(result.stringForColumn("StartedDay") != nil){
                jtop.StartedDay = result.stringForColumn("StartedDay")
            //}
            //if(result.stringForColumn("FinishedDay") != nil){
                jtop.FinishedDay = result.stringForColumn("FinishedDay")
            //}
            //if(NSNumber(int:result.intForColumn("IsDone")) != nil){
                jtop.IsDone = NSNumber(int:result.intForColumn("IsDone"))
           // }
            //if(NSNumber(int:result.intForColumn("id_Job")) != nil){
                jtop.id_Job = NSNumber(int:result.intForColumn("id_Job"))
            //}
           // if(NSNumber(int:result.intForColumn("id_TechOp")) != nil){
                jtop.id_TechOp = NSNumber(int:result.intForColumn("id_TechOp"))
            //}
            //if(NSNumber(int:result.intForColumn("Ord")) != nil){
                jtop.Ord = NSNumber(int:result.intForColumn("Ord"))
            //}
            //if(NSNumber(int:result.intForColumn("DoneAmount")) != nil){
                jtop.DoneAmount = NSNumber(int:result.intForColumn("DoneAmount"))
            //}
            //if(result.stringForColumn("Deadline") != nil){
                jtop.Deadline = result.stringForColumn("Deadline")
           // }
           // if(result.stringForColumn("ValidateDescription") != nil){
                jtop.ValidateDescription = result.stringForColumn("ValidateDescription")
            //}
            //if(NSNumber(int:result.intForColumn("HasProblems")) != nil){
                jtop.HasProblems = NSNumber(int:result.intForColumn("HasProblems"))
            //}
            
            jobTechOpArray.append(jtop)
        }
        return jobTechOpArray

    }
    
    func getJobTechOpAdapterModel(jobTechOpIDs: String, techOpIDs: String) -> Array<JobTechOpAdapterModel>{
        var result = self.runFetchForClass(Job.classForCoder(), fetchBlock: { (database) -> FMResultSet in
            var currentDate = NSDate()
            var timeString = currentDate.toString()
            
            var sql = "select techOp.*, jobTechOp.id as jobTechOp_id from TechOp as techOp left outer join JobTechOp as jobTechOp on techOp.id=jobTechOp.id_TechOp where jobTechOp.id in (" + jobTechOpIDs + ") and techOp.id in (" + techOpIDs + ") order by jobTechOp.Ord";
            
            if let res = self.database?.executeQuery(sql, withArgumentsInArray: [timeString]){
                
                return res
            } else {
                println("select failed: \(self.database?.lastErrorMessage())")
                //return self.database?.executeQuery("select count(*) from Worker", withArgumentsInArray: nil)
            }
            return FMResultSet()
            
            }, fetchResultsBlock: ())
        
        var jobTechOpAdapterModelArray: Array<JobTechOpAdapterModel> = []
        
        while result.next() {
            var jtopam = JobTechOpAdapterModel()
        
            jtopam.jobTechOpID = NSNumber(int:result.intForColumn("jobTechOp_id"))
            jtopam.techOpID = NSNumber(int:result.intForColumn("id"))
            jtopam.makeInstructions = result.stringForColumn("MakeInstructions")
            jtopam.techOpName = result.stringForColumn("Name")
            jtopam.verifyWay = result.stringForColumn("VerifyWay")
            
            jobTechOpAdapterModelArray.append(jtopam)
        }
        return jobTechOpAdapterModelArray
        
    }
    
    func getFilesForTechOps(techOpIDs: String) -> Array<CountFileResponse>{
        var result = self.runFetchForClass(Job.classForCoder(), fetchBlock: { (database) -> FMResultSet in
            //SELECT count(id) as count, id_TechOp as techOpId FROM DocFileTechOp where id_TechOp in (1) group by id_TechOp;
            
            var sql = "SELECT count(id) as count, id_TechOp as techOpId FROM DocFileTechOp where id_TechOp in(" + techOpIDs + ") group by id_TechOp";
            
            if let res = self.database?.executeQuery(sql, withArgumentsInArray: nil){
                
                return res
            } else {
                println("select failed: \(self.database?.lastErrorMessage())")
                //return self.database?.executeQuery("select count(*) from Worker", withArgumentsInArray: nil)
            }
            return FMResultSet()
            
            }, fetchResultsBlock: ())
        
        var countFileResponseArray: Array<CountFileResponse> = []
        
        while result.next() {
            var cfr = CountFileResponse()
            
            cfr.techOpID = NSNumber(int: result.intForColumn("techOpId"))
            cfr.countFile = NSNumber(int: result.intForColumn("count"))
            
            countFileResponseArray.append(cfr)
        }
        return countFileResponseArray
    }
    
    
    func jobForMe(jobPlanID: String, workerID: String, brigadeIDs: String) -> Bool{
       
        var result = self.runFetchForClass(Job.classForCoder(), fetchBlock: { (database) -> FMResultSet in
           
            var sql = "SELECT jobPlan.* " +
                "FROM JobPlan as jobPlan " +
                "LEFT JOIN JobPlanWorker AS jobWorker ON jobPlan.id = jobWorker.id_JobPlan AND jobWorker.id_Worker = " + workerID + " " +
                "LEFT JOIN JobPlanBrigade AS jobBrigade ON jobPlan.id = jobBrigade.id_JobPlan AND jobBrigade.id_Brigade IN (" + brigadeIDs + ") " +
                "WHERE jobPlan.IsVisible AND jobPlan.StartingMoment <= ? AND jobPlan.id = " + jobPlanID + " AND (jobWorker.id IS NOT NULL OR jobBrigade.id IS NOT NULL) " +
            "LIMIT 1";
            
            var currentDate = NSDate()
            var timeString = currentDate.toString()
            
            if let res = self.database?.executeQuery(sql, withArgumentsInArray: [timeString]){
                
                return res
            } else {
                println("select failed: \(self.database?.lastErrorMessage())")
                //return self.database?.executeQuery("select count(*) from Worker", withArgumentsInArray: nil)
            }
            return FMResultSet()
            
            }, fetchResultsBlock: ())
        
        while(result.next()){
            return true
        }
        return false
        
    }
    //MARK: Upgrade database
    func upgradeDatabaseIfRequired(){
        var previousVersion:UInt32?
        previousVersion = self.database?.userVersion()

        if (previousVersion == nil || previousVersion < UInt32(currentVersion)) {
            
            let plistPath = NSBundle.mainBundle().pathForResource("UpgradeDatabase", ofType: "plist")
            var plist:NSArray = NSArray(contentsOfFile: plistPath!)!
            
            //perform all upgrades
            if (previousVersion == nil){
                for (var i = 0; i < plist.count; i++){
                    var dict = plist[i] as! Dictionary<String, AnyObject>
                    var version = dict["version"] as! NSNumber
                    var fileName = dict["updateFileName"] as! NSString
                    var filePath = NSBundle.mainBundle().pathForResource(fileName as String, ofType: "sql")
                    
                    self.executeSqlFileWith(filePath!, andDatabase: self.database!)
                    println("file path for update" + filePath!)
                    self.database?.setUserVersion(UInt32(version.intValue))
                }
            }
            //perform needed upgrades
            else{
                for (var i = 0; i < plist.count; i++){
                    var dict = plist[i] as! Dictionary<String, AnyObject>
                    var version = dict["version"] as! NSNumber
                    var fileName = dict["updateFileName"] as! NSString
                    var filePath = NSBundle.mainBundle().pathForResource(fileName as String, ofType: "sql");
                    
                    if (previousVersion < UInt32(version.intValue)) {
                        self.executeSqlFileWith(filePath!, andDatabase: self.database!)
                        println("file path for update" + filePath!)
                        self.database?.setUserVersion(UInt32(version.intValue))
                    }
                }
            }
            
        }
        println("Current DB Version = \(self.database?.userVersion())")
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
