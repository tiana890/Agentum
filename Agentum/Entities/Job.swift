//
//  Job.swift
//  DBAccessInUse
//
//  Created by Agentum on 24.08.15.
//  Copyright (c) 2015 IMAC . All rights reserved.
//

import UIKit
@objc(Job)

class Job: DBObject {
    dynamic var Sync: NSNumber?
    dynamic var Name: NSString?
    dynamic var State: NSString?
    dynamic var Description: NSString?
    dynamic var Deadline: NSString?
    dynamic var CalcDurationMins: NSNumber?
    dynamic var PlanDurationMins: NSNumber?
    dynamic var StartedDay: NSString?
    dynamic var FinishedDay: NSString?
    dynamic var PlanStartedDay: NSString?
    dynamic var PlanFinishedDay: NSString?
    dynamic var id_Object: NSNumber?
    dynamic var id_Brigade: NSNumber?
   
}
