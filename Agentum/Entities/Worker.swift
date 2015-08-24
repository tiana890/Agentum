//
//  Worker.swift
//  DBAccessInUse
//
//  Created by IMAC  on 18.08.15.
//  Copyright (c) 2015 IMAC . All rights reserved.
//

import UIKit
@objc(Worker)

class Worker: DBObject {
    dynamic var Sync: NSNumber?
    dynamic var Photo: NSString?
    dynamic var LastName: NSString?
    dynamic var FirstName: NSString?
    dynamic var MiddleName: NSString?
    dynamic var Birthday: NSString?
    dynamic var MobilePhone: NSString?
    dynamic var HomePhone: NSString?
    dynamic var Email: NSString?
    dynamic var HomeAddress: NSString?
    dynamic var OtherContacts: NSString?
    dynamic var JobType: NSString?
    dynamic var IsWorkingNow: NSNumber?
}
