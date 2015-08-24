-- version: 2
-- Таблицы и Связанные поля

REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (1, 10, 'Worker', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (2, 20, 'User', '');

REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (1, 10, 'Worker', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (2, 20, 'Division', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (3, 30, 'Post', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (4, 40, 'Skill', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (5, 50, 'WorkerPost', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (6, 60, 'WorkerSkill', '');

REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (7, 70, 'Brigade', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (8, 80, 'BrigadeRole', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (9, 90, 'BrigadeWorker', '');

REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (10, 100, 'Unit', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (11, 110, 'Machinery', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (12, 120, 'Material', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (13, 130, 'TechOp', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (14, 140, 'TechOpFormField', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (15, 150, 'TechOpDoer', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (16, 160, 'TechOpMachinery', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (17, 170, 'TechOpMaterial', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (18, 180, 'TechOpPrevious', '');

REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (19, 190, 'Project', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (20, 200, 'Object', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (21, 210, 'Job', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (22, 220, 'JobTechOp', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (23, 230, 'Schedule', '');

REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (24, 240, 'TechOpFieldValue', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (25, 250, 'Probe', '');

REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (26, 260, 'User', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (27, 270, 'InterfaceRole', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (28, 280, 'UserInterfaceRoles', '');

-- Связанные поля

--  SrcTable - имя таблицы, в записи которой поменялось поле id
--  TargetTable - имя таблицы, записи которой требуется обновить
--  Field - имя поля в TargetTable, значение которого обновляем

REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (1, 'Worker', 'User', 'id_Worker');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (2, 'Worker', 'WorkerPost', 'id_Worker');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (3, 'Division', 'WorkerPost', 'id_Division');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (4, 'Post', 'WorkerPost', 'id_Post');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (5, 'Worker', 'WorkerSkill', 'id_Worker');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (6, 'Skill', 'WorkerSkill', 'id_Skill');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (7, 'Worker', 'BrigadeWorker', 'id_Worker');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (8, 'Brigade', 'BrigadeWorker', 'id_Brigade');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (9, 'BrigadeRole', 'BrigadeWorker', 'id_BrigadeRole');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (10, 'Unit', 'TechOp', 'id_Unit');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (11, 'TechOp', 'TechOpFormField', 'id_TechOp');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (12, 'TechOp', 'TechOpDoer', 'id_TechOp');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (13, 'Skill', 'TechOpDoer', 'id_Skill');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (14, 'TechOp', 'TechOpMachinery', 'id_TechOp');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (15, 'Machinery', 'TechOpMachinery', 'id_Machinery');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (16, 'TechOp', 'TechOpMaterial', 'id_TechOp');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (17, 'Material', 'TechOpMaterial', 'id_Material');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (18, 'Unit', 'TechOpMaterial', 'id_Unit');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (19, 'TechOp', 'TechOpPrevious', 'id_TechOp');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (20, 'TechOp', 'TechOpPrevious', 'id_TechOp_Previous');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (21, 'Worker', 'Project', 'id_Worker');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (22, 'Project', 'Object', 'id_Project');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (23, 'Object', 'Job', 'id_Object');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (24, 'Brigade', 'Job', 'id_Brigade');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (25, 'Job', 'JobTechOp', 'id_Job');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (26, 'TechOp', 'JobTechOp', 'id_TechOp');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (27, 'Job', 'Schedule', 'id_Job');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (28, 'JobTechOp', 'TechOpFieldValue', 'id_JobTechOp');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (29, 'TechOpFormField', 'TechOpFieldValue', 'id_TechOpFormField');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (30, 'Worker', 'TechOpFieldValue', 'id_Worker');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (31, 'Brigade', 'TechOpFieldValue', 'id_Brigade');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (32, 'JobTechOp', 'Probe', 'id_JobTechOp');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (33, 'Worker', 'Probe', 'id_Worker');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (34, 'Brigade', 'Probe', 'id_Brigade');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (35, 'User', 'UserInterfaceRoles', 'id_User');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (36, 'InterfaceRole', 'UserInterfaceRoles', 'id_InterfaceRole');
