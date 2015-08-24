//
//  JobTechOp.swift
//  DBAccessInUse
//
//  Created by Agentum on 24.08.15.
//  Copyright (c) 2015 IMAC . All rights reserved.
//

import UIKit
@objc(JobTechOp)

class JobTechOp: DBObject {
    dynamic var Sync: NSNumber?
    dynamic var Amount: NSNumber?
    dynamic var StartedDay: NSString?
    dynamic var FinishedDay: NSString?
    dynamic var IsDone: NSNumber?
    dynamic var id_Job: NSNumber?
    dynamic var id_TechOp: NSNumber?
    dynamic var Ord: NSNumber?
    dynamic var DoneAmount: NSNumber?
    dynamic var Deadline: NSString?
    dynamic var ValidateDescription: NSString?
    dynamic var HasProblems: NSNumber?
}
