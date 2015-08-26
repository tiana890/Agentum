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
    
    func setStateTypeValue() -> JobAdapterModel{
        if(hasProblems == true){
            self.stateTypeValue = "исправление замечаний"
            
        } else if (!hasStartedTechOp && isOperationDone.intValue == 0){
            self.stateTypeValue = "ожидание"
            
        } else if (hastStartedTechOp && isOperationDone.intValue == 0){
            self.stateTypeValue = "в работе"
            
        } else if (operationIsDone.intValue == totalCount.intValue && state == ){
            self.stateTypeValue = "ожидание"
            
        } else if (!hastStartedTechOp && operationIsDone.intValue == 0){
            self.stateTypeValue = "ожидание"
            
        } else if (!hastStartedTechOp && operationIsDone.intValue == 0){
            self.stateTypeValue = "ожидание"
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
