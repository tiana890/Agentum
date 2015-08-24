-- version: 17

-- ----------------------------------------------------------------------------------------- --
-- ...
-- ----------------------------------------------------------------------------------------- --

-- план выполнения работ (не операций - для них отдельный план)
CREATE TABLE PushLog (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Moment TEXT NOT NULL default '0000-00-00 00:00:00', -- дата-время
  Hash TEXT NOT NULL default '',
  Data TEXT NOT NULL default '',
  Channel TEXT NOT NULL default ''
);
CREATE INDEX PushLog_I1 ON PushLog (Hash);
