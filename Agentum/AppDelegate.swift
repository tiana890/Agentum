//
//  AppDelegate.swift
//  Agentum
//
//  Created by IMAC  on 07.08.15.
//
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, DBDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //init things
        //let documentsFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as? String
        //let path = documentsFolder!.stringByAppendingPathComponent("vizirBase.db")
        let path = NSBundle.mainBundle().pathForResource("vizirBase", ofType: "db")
        
        var databaseController = DatabaseController()
        
        databaseController.initWithDatabase(path!)
        APP.i().databaseController = databaseController
        if !databaseController.database!.open() {
            println("Unable to open database")
        }
        
        //databaseController.upgradeDatabaseIfRequired()
        
        /* start the DBAccess engine by specifying the delegate and opening a database connection */
        DBAccess.setDelegate(self)
        DBAccess.openDatabaseNamed("vizirBase")
        DBAccess.setPersistSynthesizedProperties(true)
        
        return true
    }
    
    func getCustomSettings() -> DBAccessSettings! {
        var settings = DBAccessSettings()
        let path = NSBundle.mainBundle().pathForResource("vizirBase", ofType: "db")
        let dbPath = path?.stringByDeletingLastPathComponent
        println(dbPath)
        settings.defaultDatabaseName = "vizirBase"
        settings.databaseLocation = dbPath
        return settings
    }

    func databaseOpened() {
        println("Database successfully opened")
    }

    func databaseError(error: DBError!) {
        println("Error description = " + error.errorMessage!)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

