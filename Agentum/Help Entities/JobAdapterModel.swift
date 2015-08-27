//
//  JopAdapterModel.swift
//  Agentum
//
//  Created by Agentum on 26.08.15.
//
//

import UIKit

class JobAdapterModel: NSObject {
    var ID: NSNumber?
    var idJobPlan: NSNumber?
    var name: NSString?
    var state: NSString?
    var stateTypeValue: NSString?
    var descr: NSString?
    var deadline: NSString?
    var finishDay: NSString?
    var projectName: NSString?
    var countFile: NSString?
    var isOperationDone: NSNumber?
    var operationTotalCount: NSNumber?
    var hasProblems: Bool?
    var hasStartedTechOp: Bool?
    
    init(jobID: NSNumber, jobPlanID : NSNumber) {
        self.ID = jobID
        self.idJobPlan = jobPlanID
    }
    
    func setStateTypeValue() -> JobAdapterModel{
        if(hasProblems == true){
            self.stateTypeValue = "исправление замечаний"
            
        } else if (hasStartedTechOp == false && isOperationDone!.intValue == 0){
            self.stateTypeValue = "ожидание"
            
        } else if (hasStartedTechOp == true && isOperationDone!.intValue == 0){
            self.stateTypeValue = "в работе"
            
        } else if (isOperationDone!.intValue != operationTotalCount!.intValue && state == Job.STATE_PARTLY){
            self.stateTypeValue = "частично готово"
            
        } else if (isOperationDone!.intValue == operationTotalCount!.intValue && isOperationDone!.intValue > 0 && state == Job.STATE_PARTLY){
            self.stateTypeValue = "на проверке"
            
        } else if (isOperationDone!.intValue == operationTotalCount!.intValue && isOperationDone!.intValue > 0 && state == Job.STATE_DONE){
            self.stateTypeValue = "готово"
        } else {
            self.stateTypeValue = "--"
        }
        
        
        return self
    }
    /*
    public JobAdapterModel setStateTypeValue() {
    if (hasProblem) {
    this.stateTypeValue = "исправление замечаний";
    
    } else if (!hasStartedTechOp && operationIsDone == 0) {
    this.stateTypeValue = "ожидание";
    
    } else if (hasStartedTechOp && operationIsDone == 0) {
    this.stateTypeValue = "в работе";
    
    } else if (operationIsDone != operationTotalCount && state.equals(Job.STATE_PARTLY)) {
    this.stateTypeValue = "частично готово";
    
    } else if (operationIsDone == operationTotalCount && operationIsDone > 0 && state.equals(Job.STATE_PARTLY)) {
    this.stateTypeValue = "на проверке";
    
    } else if (operationIsDone == operationTotalCount && operationIsDone > 0 && state.equals(Job.STATE_DONE)) {
    this.stateTypeValue = "готово";
    
    } else {
    this.stateTypeValue = "--";
    }
    
    return this;
    }

    */
}
