//
//  JobTechOpPlan.swift
//  DBAccessInUse
//
//  Created by Agentum on 24.08.15.
//  Copyright (c) 2015 IMAC . All rights reserved.
//

import UIKit
@objc(JobTechOpPlan)

class JobTechOpPlan: DBObject {
    dynamic var id_JobPlan: NSNumber?
    dynamic var id_JobTechOp: NSNumber?
    dynamic var IsVisible: NSNumber?
    dynamic var StartingMoment: NSString?
    dynamic var Ord: NSNumber?
    dynamic var Sync: NSNumber?
}
