-- version: 12

-- ----------------------------------------------------------------------------------------- --
-- действия сотрудников - абстракция, к которой удобно привязывать все остальные сущности
-- объединяющая сущность для событий, происходящих в системе
-- с участием работников
-- * связаны с пользователем системы (кроме случаев, когда действие порождено системой)
-- * могут быть связаны с сотрудником(ами) (не обязательно пользователи системы)
-- * могут быть связаны с бригадой, к которой относится само действие
-- * могут быть связаны с операциями, работами, результатами и другими сущностями
-- ----------------------------------------------------------------------------------------- --

-- действия сотрудников
CREATE TABLE Action (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Type TEXT NOT NULL default 'resultfixing', -- пока только resultfixing
  Moment TEXT NOT NULL, -- дата-время: момент записи в базу
  id_User INTEGER NOT NULL, -- пользователь системы, который зафиксировал действие, или 0 (обычно бригадир)
  id_JobTechOp INTEGER NOT NULL, -- операция конкретной работы на объекте или 0
  id_Brigade INTEGER NOT NULL, -- бригада, с которой связано действие, или 0
  Sync INTEGER NOT NULL default 0
);

-- привязка действий к сотрудникам
CREATE TABLE ActionWorker (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  id_Action INTEGER NOT NULL,
  id_Worker INTEGER NOT NULL,
  Sync INTEGER NOT NULL default 0
);
-- CREATE INDEX ActionWorker_I1 ON ActionWorker (id_Action, id_Worker);

-- привязка действий к пробам
CREATE TABLE ActionProbe (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  id_Action INTEGER NOT NULL,
  id_Probe INTEGER NOT NULL,
  Sync INTEGER NOT NULL default 0
);
-- CREATE INDEX ActionProbe_I1 ON ActionProbe (id_Action, id_Probe);

-- привязка действий к записям в полях формы результата
CREATE TABLE ActionTechOpFieldValue (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  id_Action INTEGER NOT NULL,
  id_TechOpFieldValue INTEGER NOT NULL,
  Sync INTEGER NOT NULL default 0
);
-- CREATE INDEX ActionTechOpFieldValue_I1 ON ActionTechOpFieldValue (id_Action, id_TechOpFieldValue);
