-- version: 16

-- Таблицы

REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (42, 420, 'JobPlan', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (43, 430, 'JobPrevToJobPlan', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (44, 440, 'JobPlanWorker', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (45, 450, 'JobPlanBrigade', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (46, 460, 'JobPlanAction', '');

REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (47, 470, 'JobTechOpPlan', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (48, 480, 'JobTechOpPrevToJobTechOpPlan', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (49, 490, 'JobTechOpPlanWorker', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (50, 500, 'JobTechOpPlanBrigade', '');
REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (51, 510, 'JobTechOpPlanAction', '');

-- Связанные поля

--  SrcTable - имя таблицы, в записи которой поменялось поле id
--  TargetTable - имя таблицы, записи которой требуется обновить
--  Field - имя поля в TargetTable, значение которого обновляем

REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (61, 'Job', 'JobPlan', 'id_Job');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (62, 'JobPlan', 'JobPrevToJobPlan', 'id_JobPlan');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (63, 'Job', 'JobPrevToJobPlan', 'id_Job');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (64, 'JobPlan', 'JobPlanWorker', 'id_JobPlan');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (65, 'Worker', 'JobPlanWorker', 'id_Worker');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (66, 'JobPlan', 'JobPlanBrigade', 'id_JobPlan');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (67, 'Brigade', 'JobPlanBrigade', 'id_Brigade');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (68, 'JobPlan', 'JobPlanAction', 'id_JobPlan');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (69, 'Action', 'JobPlanAction', 'id_Action');

REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (70, 'JobPlan', 'JobTechOpPlan', 'id_JobPlan');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (71, 'JobTechOp', 'JobTechOpPlan', 'id_JobTechOp');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (72, 'JobTechOpPlan', 'JobTechOpPrevToJobTechOpPlan', 'id_JobTechOpPlan');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (73, 'JobTechOp', 'JobTechOpPrevToJobTechOpPlan', 'id_JobTechOp');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (74, 'JobTechOpPlan', 'JobTechOpPlanWorker', 'id_JobTechOpPlan');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (75, 'Worker', 'JobTechOpPlanWorker', 'id_Worker');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (76, 'JobTechOpPlan', 'JobTechOpPlanBrigade', 'id_JobTechOpPlan');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (77, 'Brigade', 'JobTechOpPlanBrigade', 'id_Brigade');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (78, 'JobTechOpPlan', 'JobTechOpPlanAction', 'id_JobTechOpPlan');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (79, 'Action', 'JobTechOpPlanAction', 'id_Action');
