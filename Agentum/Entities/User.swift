//
//  User.swift
//  DBAccessInUse
//
//  Created by Agentum on 24.08.15.
//  Copyright (c) 2015 IMAC . All rights reserved.
//

import UIKit
@objc(User)

class User: DBObject {
    dynamic var Sync: NSNumber?
    dynamic var Login: NSString?
    dynamic var Password: NSString?
    dynamic var id_Worker: NSNumber?
}
