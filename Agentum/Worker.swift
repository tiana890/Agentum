//
//  Worker.swift
//  Agentum
//
//  Created by IMAC  on 17.08.15.
//
//

import UIKit

@objc(Worker)
/*
-- сотрудник компании, не обязательно пользователь системы
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
class Worker: DBObject {
//class Worker: ActiveRecord{
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
