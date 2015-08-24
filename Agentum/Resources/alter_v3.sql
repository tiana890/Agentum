-- version: 10

-- ----------------------------------------------------------------------------------------- --
-- инспекции - проверки качества работ на местах
-- * могут быть запланированы, проведены или уже закрыты
-- * каждая инспекция связана с конкретным инспектором, и видна только ему
-- * с проверками связаны работы, которые требуется проверить
-- ----------------------------------------------------------------------------------------- --

-- инспекции
CREATE TABLE Inspection (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  State TEXT NOT NULL default 'added', -- added, inspected, closed
  DayPlanned TEXT NOT NULL, -- дата: день, когда планируется выполнить проверку
  DayInspected TEXT NOT NULL, -- дата: день фактического выполнения проверки
  id_Worker INTEGER NOT NULL,
  Sync INTEGER NOT NULL default 0
);

-- привязка работ к инспекциям
CREATE TABLE InspectionJob (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  id_Inspection INTEGER NOT NULL,
  id_Job INTEGER NOT NULL,
  Sync INTEGER NOT NULL default 0
);
CREATE INDEX InspectionJob_I1 ON InspectionJob (id_Inspection, id_Job);

-- ----------------------------------------------------------------------------------------- --
-- результат проверки работ
-- * работы, связанные с инспекциями, проходят проверку по одной
-- * результат каждой проверки пишется в эту таблицу
-- ----------------------------------------------------------------------------------------- --

-- результат проверки работы
CREATE TABLE JobInspectionResult (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Moment TEXT NOT NULL, -- дата-время: момент записи в базу
  id_Inspection INTEGER NOT NULL,
  id_Job INTEGER NOT NULL,
  HasProblems INTEGER NOT NULL default 0, -- 0 - нет проблем, 1 - есть проблемы
  Details TEXT NOT NULL, -- детали проблемы
  Sync INTEGER NOT NULL default 0
);
CREATE INDEX JobInspectionResult_I1 ON JobInspectionResult (id_Inspection, id_Job);

-- version: 11

-- Таблицы

REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (29, 290, 'DocFile', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (30, 300, 'DocFileProject', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (31, 310, 'DocFileObject', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (32, 320, 'DocFileJob', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (33, 330, 'DocFileTechOp', '');

REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (34, 340, 'Inspection', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (35, 350, 'InspectionJob', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (36, 360, 'JobInspectionResult', '');

-- Связанные поля

--  SrcTable - имя таблицы, в записи которой поменялось поле id
--  TargetTable - имя таблицы, записи которой требуется обновить
--  Field - имя поля в TargetTable, значение которого обновляем

REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (37, 'DocFile', 'DocFileProject', 'id_DocFile');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (38, 'Project', 'DocFileProject', 'id_Project');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (39, 'DocFile', 'DocFileObject', 'id_DocFile');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (40, 'Object', 'DocFileObject', 'id_Object');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (41, 'DocFile', 'DocFileJob', 'id_DocFile');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (42, 'Job', 'DocFileJob', 'id_Job');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (43, 'DocFile', 'DocFileTechOp', 'id_DocFile');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (44, 'TechOp', 'DocFileTechOp', 'id_TechOp');

REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (45, 'Worker', 'Inspection', 'id_Worker');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (46, 'Job', 'InspectionJob', 'id_Job');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (47, 'Job', 'JobInspectionResult', 'id_Job');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (48, 'Inspection', 'InspectionJob', 'id_Inspection');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (49, 'Inspection', 'JobInspectionResult', 'id_Inspection');

