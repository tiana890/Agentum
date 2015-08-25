//
//  JobPlan.swift
//  DBAccessInUse
//
//  Created by Agentum on 24.08.15.
//  Copyright (c) 2015 IMAC . All rights reserved.
//

import UIKit
@objc(JobPlan)

class JobPlan: DBObject {
    dynamic var id_Job: NSNumber?
    dynamic var isVisible: NSNumber?
    dynamic var StartingMoment: NSString?
    dynamic var Ord: NSNumber?
    dynamic var Sync: NSNumber?
    
}
