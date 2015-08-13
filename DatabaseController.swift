//
//  DatabaseController.swift
//  Agentum
//
//  Created by IMAC  on 12.08.15.
//
//

import UIKit

class DatabaseController: NSObject {
   
    typealias DatabaseUpdateBlock = (database:FMDatabase?)->Void
    typealias DatabaseFetchBlock = (database:FMDatabase?)->FMResultSet
    typealias DatabaseFetchResultsBlock = ()
    
    let serialDispatchQueue = dispatch_queue_create("serialQueue", nil)
    
    var database: FMDatabase?
    
    func initWithDatabase(path: String){
        database = FMDatabase(path: path)
    }
  
    private func beginTransaction (){
        self.database?.beginTransaction()
    }
    
    private func endTransaction (){
        self.database?.commit()
    }
    
    private func runDatabaseBlockInTransaction(databaseBlock: DatabaseUpdateBlock){
        dispatch_async(self.serialDispatchQueue, { () -> Void in
            self.beginTransaction()
            databaseBlock(database: self.database)
            self.endTransaction()
        })
    }
    
    private func runFetchForClass(databaseObjectClass: AnyClass, fetchBlock: DatabaseFetchBlock, fetchResultsBlock: DatabaseFetchResultsBlock)
    {
        var resultSet = fetchBlock(self.database)
        NSArray *fetchedObjects = self.databaseObjectWithResultSet(resultSet, databaseObjectClass)
        
    }
    
/*
    -[VSDatabaseController runFetchForClass:(Class)databaseObjectClass
    fetchBlock:(VSDatabaseFetchBlock)fetchBlock
    fetchResultsBlock:(VSDatabaseFetchResultsBlock)fetchResultsBlock];
    These two lines do much of the work:
    SELECT ALL
    FMResultSet *resultSet = fetchBlock(self.database);
    NSArray *fetchedObjects = [self databaseObjectsWithResultSet:resultSet
    class:databaseObjectClass];
    /*
*/
CREATE TABLE Worker (
id INTEGER PRIMARY KEY AUTOINCREMENT,
Photo TEXT NOT NULL, -- имя файла-аватарки в папке с картинками
LastName TEXT NOT NULL,
FirstName TEXT NOT NULL,
MiddleName TEXT NOT NULL,
Birthday TEXT NOT NULL, -- дата: день рождения для расчёта возраста и т.п.
MobilePhone TEXT NOT NULL,
HomePhone TEXT NOT NULL,
Email TEXT NOT NULL,
HomeAddress TEXT NOT NULL,
OtherContacts TEXT NOT NULL,
JobType TEXT NOT NULL default 'fulltime', -- тип трудоустройства: fulltime, parttime, temporary, seasonal, piecework, other
IsWorkingNow INTEGER NOT NULL default 1 -- 0 - уволен, 1 - действующий сотрудник
);
*/
    func addNewWorker(worker: AnyObject)
    {
        //вместо AnyObject должен быть тип объекта
        self.runDatabaseBlockInTransaction { (database) -> Void in
            self.database?.executeUpdate("insert into Worker (Photo, LastName, FirstName, MiddleName, Birthday, MobilePhone, HomePhone, Email, HomeAddress, OtherContacts) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", withArgumentsInArray: ["photo.jpg", "Zayceva", "Marina", "Alekseevna", "15.04.1989", "89098734783", "2334512", "smth@smth.ru", "Lenina 82-15", "2451678"])
        }
    }
    
    
}
