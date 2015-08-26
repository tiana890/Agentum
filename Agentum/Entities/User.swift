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
    
    static func authorize(login: String, password: String) -> Bool{
        var query = User.query().whereWithFormat("login = %@ and password = %@", withParameters: [login, password])
        
        var resSet = query.fetch() as DBResultSet
        
        if resSet.count > 0 {
            var user = resSet[0] as! User
            APP.i().user = user
            Worker.saveWorkerIDBy(user)
            BrigadeWorker.saveBrigadeIDsWithUser(user)
        }
        
        if resSet.count > 0{
            return true
        } else {
            return false
        }
    }
}
