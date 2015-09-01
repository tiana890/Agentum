//
//  JobTechOpAdapterModel.swift
//  Agentum
//
//  Created by Agentum on 27.08.15.
//
//

import UIKit

class JobTechOpAdapterModel: NSObject {
    var jobTechOpID: NSNumber?
    var techOpID: NSNumber?
    
    var techOpName: NSString?
    var makeInstructions: NSString?
    
    var StartedDay: NSString?
    var FinishedDay: NSString?
    var IsDone: NSNumber?
    var Ord: NSNumber?
    var DoneAmount: NSNumber?
    var Deadline: NSString?
    var ValidateDescription: NSString?
    var HasProblems: NSNumber?
    
    var stateTypeValue: NSString?
    
    var countFiles: NSNumber?

    func setStateTypeValue(){
        if(IsDone?.intValue == 1){
            self.stateTypeValue = "исполнена"
        } else if(StartedDay == "" || StartedDay == nil){
            self.stateTypeValue = "не начиналась"
        } else if (StartedDay != nil){
            self.stateTypeValue = "исполняется"
        } else if (FinishedDay != nil && IsDone?.intValue == 1){
            self.stateTypeValue = "исполнена"
        } else {
            self.stateTypeValue = "--"
        }
    }

}
