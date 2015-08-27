//
//  JobReposit.swift
//  Agentum
//
//  Created by IMAC  on 25.08.15.
//
//

import UIKit

class JobReposit: NSObject {
    var actualJobs: Array<JobAdapterModel> = []
    var completeJobs: Array<JobAdapterModel> = []
    var finishJobs: Array<JobAdapterModel> = []
    
    var jobDict = Dictionary<NSNumber, JobAdapterModel>()
    
    func generateJobLists(){
        var jobPlanAdapterModelArray = APP.i().databaseController!.getJobPlanAdapterModelBy(APP.i().workerID!, brigadeIDs: APP.i().brigadeIDs!)
        
        var jobPlanIDs = String()
        
        for (var i = 0; i < jobPlanAdapterModelArray.count; i++){
            var jpam = jobPlanAdapterModelArray[i]
            jobPlanIDs = jobPlanIDs + "\(jpam.jobPlanID!.intValue),"
            jobDict[jpam.jobID!] = JobAdapterModel(jobID: jpam.jobID!, jobPlanID: jpam.jobPlanID!)
        }
        
        if(count(jobPlanIDs) > 0){
            if(jobPlanIDs[jobPlanIDs.endIndex.predecessor()] == ","){
                jobPlanIDs = dropLast(jobPlanIDs)
            }
        }
        
        APP.i().jobPlanIDs = jobPlanIDs
        
        var jobArray = APP.i().databaseController!.getJobsBy(APP.i().jobPlanIDs!, limit: 0, workerID: APP.i().workerID!, brigadeIDs: APP.i().brigadeIDs!)
        
        var jobIDs = String()
        
        for(var i = 0; i < jobArray.count; i++){
           var job = jobArray[i]
           
           jobIDs = jobIDs + "\(job.ID!.intValue),"
            if var jam = jobDict[job.ID!]{
               jam.ID = job.ID
               jam.name = job.Name
               jam.state = job.State
               jam.descr = job.Description
               jam.finishDay = job.FinishedDay
               jam.deadline = job.Deadline
               jam.projectName = job.ProjectName
                
               jobDict[jam.ID!] = jam
            }
        }
        
        if(count(jobIDs) > 0){
            if(jobIDs[jobIDs.endIndex.predecessor()] == ","){
                jobIDs = dropLast(jobIDs)
            }
        }
        
        var countFileResponseArray = APP.i().databaseController!.getFilesForJob(jobIDs)
        
        for(var i = 0; i < countFileResponseArray.count; i++){
            var cfr = countFileResponseArray[i]
            if var jobAdapterModel = jobDict[cfr.jobID!]{
                jobAdapterModel.countFile = cfr.countFile
            }
        }
        
        var countTechOpsResponseArray = APP.i().databaseController!.getTechOpsForJob(APP.i().jobPlanIDs!,workerID: APP.i().workerID!, brigadeIDs: APP.i().brigadeIDs!)
        
        for(var i = 0; i < countTechOpsResponseArray.count; i++){
            var ctor = countTechOpsResponseArray[i]
            if var jobAdapterModel = jobDict[ctor.jobID!]{
                jobAdapterModel.operationTotalCount = ctor.totalCount
                jobAdapterModel.isOperationDone = ctor.isDone
                jobAdapterModel.hasProblems = ctor.hasProblems
                jobAdapterModel.hasStartedTechOp = ctor.started
            }
        }
      
        for (var i = 0; i < jobArray.count; i++){
            var job = jobArray[i]
            println("job ID \(job.ID!)" )
            var jam = jobDict[job.ID!]
            jam?.setStateTypeValue()
            
            if(jam?.state == Job.STATE_DONE){
                //считаем прошло ли более 5 суток от момента выполнения работы до текущего времени
                let finishDateStr: NSString? = jam?.finishDay
                if finishDateStr != "null" {
                    var finishDate = NSDate(dateString: finishDateStr as! String)
                    var currentDate = NSDate()
                    var differenceDays = self.daysBetweenThisDate(finishDate, andThisDate: currentDate)
                    if(differenceDays < 5){
                        finishJobs.append(jam!)
                    }
                } else {
                    finishJobs.append(jam!)
                }
            } else if((jam?.operationTotalCount!.intValue == jam?.isOperationDone!.intValue) && jam?.operationTotalCount?.intValue > 0){
                completeJobs.append(jam!)
            } else {
                actualJobs.append(jam!)
            }
        }
    }
    
   func daysBetweenThisDate(fromDateTime:NSDate, andThisDate toDateTime:NSDate)->Int?{
        
        var fromDate:NSDate? = nil
        var toDate:NSDate? = nil
        
        let calendar = NSCalendar.currentCalendar()
        
        calendar.rangeOfUnit(.CalendarUnitDay, startDate: &fromDate, interval: nil, forDate: fromDateTime)
        
        calendar.rangeOfUnit(.CalendarUnitDay, startDate: &toDate, interval: nil, forDate: toDateTime)
        
        if let from = fromDate {
            
            if let to = toDate {
                
                let difference = calendar.components(.CalendarUnitDay, fromDate: from, toDate: to, options: NSCalendarOptions.allZeros)
                
                return difference.day
            }
        }
        
        return nil
    }
}
