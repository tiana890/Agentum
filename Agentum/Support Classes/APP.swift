//
//  APP.swift
//  DBAccessInUse
//
//  Created by Agentum on 24.08.15.
//  Copyright (c) 2015 IMAC . All rights reserved.
//

import UIKit


class APP {
    var worker: Worker?
    var user: User?
    var brigade: Brigade?
    var brigadeWorker: BrigadeWorker?
    
    func i() -> APP{
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : APP? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = APP()
        }
        return Static.instance!
    }
}

