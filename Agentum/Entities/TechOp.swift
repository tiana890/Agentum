//
//  TechOp.swift
//  DBAccessInUse
//
//  Created by Agentum on 24.08.15.
//  Copyright (c) 2015 IMAC . All rights reserved.
//

import UIKit
@objc(TechOp)

class TechOp: DBObject {
    dynamic var Sync: NSNumber?
    dynamic var Name: NSString?
    dynamic var TimeNormHours: NSNumber?
    dynamic var MakeInstructions: NSString?
    dynamic var VerifyWay: NSString?
    dynamic var VerifyValue: NSString?
    dynamic var VerifyInstructions: NSString?
    dynamic var Conditions: NSString?
    dynamic var id_Unit: NSNumber?
}
