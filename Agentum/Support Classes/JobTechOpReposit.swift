//
//  JobTechOpReposit.swift
//  Agentum
//
//  Created by IMAC  on 28.08.15.
//
//

import UIKit

class JobTechOpReposit: NSObject {
    var jobTechOps: Array<JobTechOpAdapterModel> = []

    var jobTechOpDict = Dictionary<NSNumber, JobTechOp>()
    
    func generateJobTechOpList(jobPlanID: String){
        var jobTechOpsArray = APP.i().databaseController!.getJobTechOps("\(jobPlanID)", isDone: false, findProblemOperation: false)
        
        var techOpIDs = ""
        var jobTechOpIDs = ""
        for(var i = 0; i < jobTechOpsArray.count; i++){
            var jobTechOp = jobTechOpsArray[i]
            if(jobTechOp.ID != nil){
                jobTechOpDict[jobTechOp.ID!] = jobTechOp
            }
            if(jobTechOp.id_TechOp != nil){
                techOpIDs = techOpIDs + "\(jobTechOp.id_TechOp!),"
            }
            if(jobTechOp.ID != nil){
                jobTechOpIDs = jobTechOpIDs + "\(jobTechOp.ID!),"
            }
        }
        if(count(techOpIDs) > 0){
            if(techOpIDs[techOpIDs.endIndex.predecessor()] == ","){
                techOpIDs = dropLast(techOpIDs)
            }
        }
        
        if(count(jobTechOpIDs) > 0){
            if(jobTechOpIDs[jobTechOpIDs.endIndex.predecessor()] == ","){
                jobTechOpIDs = dropLast(jobTechOpIDs)
            }
        }
        jobTechOps = APP.i().databaseController!.getJobTechOpAdapterModel(jobTechOpIDs, techOpIDs: techOpIDs)
        for(var i = 0; i < jobTechOps.count; i++){
            var jtopam = jobTechOps[i]
            jtopam.StartedDay = jobTechOpsArray[i].StartedDay
            jtopam.FinishedDay = jobTechOpsArray[i].FinishedDay
            jtopam.IsDone = jobTechOpsArray[i].IsDone
        }
    }
}
