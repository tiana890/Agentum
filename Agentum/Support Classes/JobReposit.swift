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
    
    var jobDict: Dictionary<NSNumber, JobAdapterModel> = [:]
    
    func generateJobLists(){
        var jobPlanAdapterModelArray: Array<JobPlanAdapterModel> = []
        jobPlanAdapterModelArray = APP.i().databaseController!.getJobPlanAdapterModelBy(APP.i().workerID!, brigadeIDs: APP.i().brigadeIDs!)
        
        var jobPlanIDs = String()
        for (var i = 0; i < jobPlanAdapterModelArray.count; i++){
            var jpam = jobPlanAdapterModelArray[i]
            jobPlanIDs = jobPlanIDs + "\(jpam.jobPlanID!.intValue),"
        }
        if(count(jobPlanIDs) > 0){
            jobPlanIDs = dropLast(jobPlanIDs)
        }
        APP.i().jobPlanIDs = jobPlanIDs
        
        var jobArray: Array<Job> = []
        
        jobArray = APP.i().databaseController!.getJobsBy(APP.i().jobPlanIDs!, limit: 0, workerID: APP.i().workerID!, brigadeIDs: APP.i().brigadeIDs!)
        
        for(var i = 0; i < jobPlanAdapterModelArray.count; i++){
           var jam = JobAdapterModel()
        
           var job = jobArray[i]
           var jpam = jobPlanAdapterModelArray[i]
            
           jam.ID = jpam.jobID
           jam.name = job.Name
           jam.state = job.State
           jam.descr = job.Description
           jam.finishDay = job.FinishedDay
           jam.deadline = job.Deadline
            
           self.jobDict[jam.ID!] = jam
        }
        
        var countTechOpsResponseArray: Array<CountTechOpsResponse> = []
        
        countTechOpsResponseArray = APP.i().databaseController!.getTechOpsForJob(APP.i().jobPlanIDs!,workerID: APP.i().workerID!, brigadeIDs: APP.i().brigadeIDs!)
        
        for(var i = 0; i < countTechOpsResponseArray.count; i++){
            var ctor = countTechOpsResponseArray[i]
            var jobAdapterModel = jobDict[ctor.jobID!]
            
            jobAdapterModel?.operationTotalCount = ctor.totalCount
            jobAdapterModel?.isOperationDone = ctor.isDone
            jobAdapterModel?.hasProblems = ctor.hasProblems
            jobAdapterModel?.hasStartedTechOp = ctor.started
        }
      
        for (var i = 0; i < jobArray.count; i++){
            var job = jobArray[i]
            var jam = jobDict[job.ID!]
            
            
            
            
        }
    }
}
