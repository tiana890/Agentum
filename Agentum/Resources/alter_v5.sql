-- version: 13

-- Таблицы

REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (37, 370, 'Action', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (38, 380, 'ActionWorker', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (39, 390, 'ActionProbe', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (40, 400, 'ActionTechOpFieldValue', '');

-- Связанные поля

--  SrcTable - имя таблицы, в записи которой поменялось поле id
--  TargetTable - имя таблицы, записи которой требуется обновить
--  Field - имя поля в TargetTable, значение которого обновляем

REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (50, 'User', 'Action', 'id_User');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (51, 'JobTechOp', 'Action', 'id_JobTechOp');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (52, 'Brigade', 'Action', 'id_Brigade');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (53, 'Action', 'ActionWorker', 'id_Action');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (54, 'Worker', 'ActionWorker', 'id_Worker');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (55, 'Action', 'ActionProbe', 'id_Action');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (56, 'Probe', 'ActionProbe', 'id_Probe');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (57, 'Action', 'ActionTechOpFieldValue', 'id_Action');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (58, 'TechOpFieldValue', 'ActionTechOpFieldValue', 'id_TechOpFieldValue');
