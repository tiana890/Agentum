//
//  BrigadeWorker.swift
//  DBAccessInUse
//
//  Created by Agentum on 24.08.15.
//  Copyright (c) 2015 IMAC . All rights reserved.
//

import UIKit
@objc(BrigadeWorker)

class BrigadeWorker: DBObject {
    dynamic var Sync: NSNumber?
    dynamic var id_Worker: NSNumber?
    dynamic var id_Brigade: NSNumber?
    dynamic var id_BrigadeRole: NSNumber?
    
    static func saveBrigadeIDsWithUser(user: User){
       // var query = Worker.query().whereWithFormat("id = %@", withParameters: [Int(workerID!)])
        var query = BrigadeWorker.query().whereWithFormat("id_Worker = %@", withParameters:[Int(user.id_Worker!)])
        
        var resSet = query.fetch() as DBResultSet
        var array = [NSNumber]()
        
        for (var i = 0;i < resSet.count; i++){
            var brigadeWorker = resSet[i] as! BrigadeWorker
            array.append(brigadeWorker.id_Brigade!)
        }
        var brigadeIDs = ""
        for (var i = 0; i < array.count; i++){
            if i != array.count-1 {
               brigadeIDs = brigadeIDs + "\(array[i]),"
            } else {
               brigadeIDs = brigadeIDs + "\(array[i])"
            }
        }
        APP.i().brigadeIDs = brigadeIDs
    }
}
