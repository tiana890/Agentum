-- version: 14

-- нельзя удалить столбец из таблицы простой командой, но
-- поля TechOpFormField:: id_TechOp и Ord больше не используются

-- поля формы для случаев, когда операция подтверждается набором полей
CREATE TABLE TechOpTechOpFormField (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  id_TechOp INTEGER NOT NULL, -- привязка к конкретной технологической операции
  id_TechOpFormField INTEGER NOT NULL, -- привязка к полю формы
  Ord INTEGER NOT NULL, -- порядок следования поля в форме конкретной операции
  Sync INTEGER NOT NULL default 0
);
CREATE INDEX TechOpTechOpFormField_I1 ON TechOpTechOpFormField (id_TechOp, id_TechOpFormField);
CREATE INDEX TechOpTechOpFormField_Ord ON TechOpTechOpFormField (Ord);

-- Sync

-- Таблицы

REPLACE INTO SyncTables (id,Ord,Name,Params) VALUES (41, 410, 'TechOpTechOpFormField', '');

-- Связанные поля

--  SrcTable - имя таблицы, в записи которой поменялось поле id
--  TargetTable - имя таблицы, записи которой требуется обновить
--  Field - имя поля в TargetTable, значение которого обновляем

REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (59, 'TechOp', 'TechOpTechOpFormField', 'id_TechOp');
REPLACE INTO SyncLinked (id,SrcTable,TargetTable,Field) VALUES (60, 'TechOpFormField', 'TechOpTechOpFormField', 'id_TechOpFormField');
