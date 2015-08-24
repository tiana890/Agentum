-- version: 15

-- поле дедлайна в JobTechOp
ALTER TABLE JobTechOp
	ADD Deadline TEXT default NULL; -- дата-время: плановый срок завершения или NULL, если срок не указан

-- ----------------------------------------------------------------------------------------- --
-- план - это привязка исполнителей к работам и операциям с указанием порядка
--        выполнения работ / операций
-- * существует два плана: для работ и для операций
-- * исполнителю строится план выполнения работ по первому списку, затем, при
--   входе в конкретную запись, формируется список операций из второго плана
-- * операции связаны с работами дважды: через поле id_Job в таблице JobTechOp
--   и через связь JobPlan--JobTechOpPlan и поле id_Job в JobPlan.
--   только когда все связи указывают на одно и то же, операции видны
--   исполнител
-- * планы работ и операций могут быть связаны с бригадами и сотрудниками
-- * предусмотрена зависимость работ и операций в плане от выполнения
--   других работ или операций - только при соблюдении правил зависимости
--   работа или операция могут быть начаты исполняться
-- * записи плана работ и операций могут быть связаны с событиями
-- ----------------------------------------------------------------------------------------- --

-- план выполнения работ (не операций - для них отдельный план)
CREATE TABLE JobPlan (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  id_Job INTEGER NOT NULL, -- привязка к работе
  IsVisible INTEGER NOT NULL default 0, -- видна ли работа исполнителям (0 - не видна, 1 - видна)
  StartingMoment TEXT default NULL, -- дата-время: время, раньше которого работу не следует выполнять, NULL - можно выполнять без ограничений
  -- дедлайн работы берётся из самой работы (Job), но он просто отображается пользователю и ни на что не влияет
  Ord INTEGER NOT NULL, -- порядок следования работы в списке
  Sync INTEGER NOT NULL default 0
);
CREATE INDEX JobPlan_Jb ON JobPlan (id_Job);
CREATE INDEX JobPlan_Vs ON JobPlan (IsVisible);

-- работы, раньше выполнения которых выполнять текущую работу плана нельзя
CREATE TABLE JobPrevToJobPlan (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  id_JobPlan INTEGER NOT NULL,
  id_Job INTEGER NOT NULL,
  Sync INTEGER NOT NULL default 0
);
CREATE INDEX JobPrevToJobPlan_I1 ON JobPrevToJobPlan (id_JobPlan, id_Job);
	
CREATE TABLE JobPlanWorker (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  id_JobPlan INTEGER NOT NULL,
  id_Worker INTEGER NOT NULL,
  Sync INTEGER NOT NULL default 0
);
CREATE INDEX JobPlanWorker_I1 ON JobPlanWorker (id_JobPlan, id_Worker);

CREATE TABLE JobPlanBrigade (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  id_JobPlan INTEGER NOT NULL,
  id_Brigade INTEGER NOT NULL,
  Sync INTEGER NOT NULL default 0
);
CREATE INDEX JobPlanBrigade_I1 ON JobPlanBrigade (id_JobPlan, id_Brigade);

-- действия, привязанные непосредственно к работе (не к операциям внутри работы)	
CREATE TABLE JobPlanAction (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  id_JobPlan INTEGER NOT NULL,
  id_Action INTEGER NOT NULL,
  Sync INTEGER NOT NULL default 0
);
CREATE INDEX JobPlanAction_I1 ON JobPlanAction (id_JobPlan, id_Action);

-- ----------------------------------------------------------------------------------------- --

-- план выполнения конкретных операций
CREATE TABLE JobTechOpPlan (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  id_JobPlan INTEGER NOT NULL, -- привязка к плану выполнения работы
  id_JobTechOp INTEGER NOT NULL, -- привязка к операции работы
  IsVisible INTEGER NOT NULL default 0, -- видна ли операция исполнителям (0 - не видна, 1 - видна)
  StartingMoment TEXT default NULL, -- дата-время: время, раньше которого операцию не следует выполнять, NULL - можно выполнять без ограничений
  -- дедлайн операции берётся из JobTechOp
  Ord INTEGER NOT NULL, -- порядок следования операции в списке
  Sync INTEGER NOT NULL default 0
);
CREATE INDEX JobTechOpPlan_Pl ON JobTechOpPlan (id_JobPlan);
CREATE INDEX JobTechOpPlan_Jt ON JobTechOpPlan (id_JobTechOp);
CREATE INDEX JobTechOpPlan_Vs ON JobTechOpPlan (IsVisible);

-- операции, раньше выполнения которых выполнять текущую операцию плана нельзя
CREATE TABLE JobTechOpPrevToJobTechOpPlan (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  id_JobTechOpPlan INTEGER NOT NULL,
  id_JobTechOp INTEGER NOT NULL,
  Sync INTEGER NOT NULL default 0
);
CREATE INDEX JobTechOpPrevToJobTechOpPlan_I1 ON JobTechOpPrevToJobTechOpPlan (id_JobTechOpPlan, id_JobTechOp);

CREATE TABLE JobTechOpPlanWorker (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  id_JobTechOpPlan INTEGER NOT NULL,
  id_Worker INTEGER NOT NULL,
  Sync INTEGER NOT NULL default 0
);
CREATE INDEX JobTechOpPlanWorker_I1 ON JobTechOpPlanWorker (id_JobTechOpPlan, id_Worker);

CREATE TABLE JobTechOpPlanBrigade (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  id_JobTechOpPlan INTEGER NOT NULL,
  id_Brigade INTEGER NOT NULL,
  Sync INTEGER NOT NULL default 0
);
CREATE INDEX JobTechOpPlanBrigade_I1 ON JobTechOpPlanBrigade (id_JobTechOpPlan, id_Brigade);
	
-- действия, связанные с тех.операцией из плана выполнения
CREATE TABLE JobTechOpPlanAction (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  id_JobTechOpPlan INTEGER NOT NULL,
  id_Action INTEGER NOT NULL,
  Sync INTEGER NOT NULL default 0
);
CREATE INDEX JobTechOpPlanAction_I1 ON JobTechOpPlanAction (id_JobTechOpPlan, id_Action);
