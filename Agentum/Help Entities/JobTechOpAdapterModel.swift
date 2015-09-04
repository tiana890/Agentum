//
//  JobTechOpAdapterModel.swift
//  Agentum
//
//  Created by Agentum on 27.08.15.
//
//

import UIKit

class JobTechOpAdapterModel: NSObject {
    enum State: String{
        case STATE_NOT_STARTED = "notstarted"
        case STATE_IN_PROGRESS = "inprogress"
        case STATE_DONE = "done"
        case STATE_DEFAULT = "--"
    }
    
    struct VerifyWayType{
        static var PHOTO = "photo"
        static var VIDEO = "video"
        static var PHOTOFORM = "photoform"
        static var SUPERVISION = "supervision"
        static var EMPTY = "empty"
        static var FORM = "form"
    }
    
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
    
    var verifyWay: NSString?
    var state: State? = State.STATE_DEFAULT{
        didSet{
            stateChanged()
        }
    }
    
    var stateTypeValue: NSString?
    
    var countFiles: NSNumber?

    func setStateTypeValue(){
        if(IsDone?.intValue == 1){
            self.state = State.STATE_DONE
        } else if(StartedDay == "" || StartedDay == nil){
            self.state = State.STATE_NOT_STARTED
        } else if (StartedDay != nil){
            self.state = State.STATE_IN_PROGRESS
        } else if (FinishedDay != nil && IsDone?.intValue == 1){
            self.state = State.STATE_DONE
        } else{
            self.state = State.STATE_DEFAULT
        }
    }
    
    func stateChanged(){
        if let s = state{
            switch (s) {
            case .STATE_DONE:
                self.stateTypeValue = "исполнена"
                break;
            case .STATE_DEFAULT:
                self.stateTypeValue = "--"
                break
            case .STATE_IN_PROGRESS:
                self.stateTypeValue = "исполняется"
                break
            case .STATE_NOT_STARTED:
                self.stateTypeValue = "не начиналась"
                break
            default:
                self.stateTypeValue = "--"
                break;
            }
        }
    }
    
}
