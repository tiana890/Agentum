-- ----------------------------------------------------------------------------------------- --
-- сотрудники с указанными должностями, подразделениями и квалификацией
-- * один сотрудник может занимать несколько должностей в разных подразделениях
-- * один сотрудник может иметь несколько квалификаций
-- ----------------------------------------------------------------------------------------- --
 
-- подразделение компании
CREATE TABLE Division (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Sync INTEGER NOT NULL default 0,
  Name TEXT NOT NULL,
  Phone TEXT NOT NULL,
  Comments TEXT NOT NULL
);
 
-- должность в компании
CREATE TABLE Post (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Sync INTEGER NOT NULL default 0,
  Name TEXT NOT NULL
);
 
-- квалификация
CREATE TABLE Skill (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Sync INTEGER NOT NULL default 0,
  Name TEXT NOT NULL
);
 
-- сотрудник компании, не обязательно пользователь системы
CREATE TABLE Worker (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Sync INTEGER NOT NULL default 0,
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
-- для частых сортировок может пригодиться
CREATE INDEX Worker_FIO ON Worker (LastName, FirstName, MiddleName);
-- для отбора только работающих в настоящий момент, мало ли
CREATE INDEX Worker_Active ON Worker (IsWorkingNow);
 
-- связка для определения должности сотрудника с учётом подразделения
-- одна запись описывает должность в подразделении для сотрудника, может быть много записей
CREATE TABLE WorkerPost (
  id INTEGER PRIMARY KEY AUTOINCREMENT, -- потребуется позже именно в таком виде для синхронизации
  Sync INTEGER NOT NULL default 0,
  id_Worker INTEGER NOT NULL,
  id_Division INTEGER NOT NULL,
  id_Post INTEGER NOT NULL
);
CREATE INDEX WorkerPost_I1 ON WorkerPost (id_Worker);
CREATE INDEX WorkerPost_I2 ON WorkerPost (id_Division, id_Post);
 
-- квалификация сотрудников
CREATE TABLE WorkerSkill (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Sync INTEGER NOT NULL default 0,
  id_Worker INTEGER NOT NULL,
  id_Skill INTEGER NOT NULL
);
CREATE INDEX WorkerSkill_I1 ON WorkerSkill (id_Worker, id_Skill);
 
-- ----------------------------------------------------------------------------------------- --
-- бригады
-- * у сотрудников в бригаде заданы роли
-- * пока не ясно, может ли сотрудник иметь несколько ролей, но потенциально не исключено
-- * текущей бригадой пока считаем первую попавшеюся, а потом по авторизованному бригадиру
-- ----------------------------------------------------------------------------------------- --
 
-- бригада
CREATE TABLE Brigade (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Sync INTEGER NOT NULL default 0,
  Name TEXT NOT NULL
);
 
-- справочник ролей сотрудников в бригаде
CREATE TABLE BrigadeRole (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Sync INTEGER NOT NULL default 0,
  Name TEXT NOT NULL,
  IsChief INTEGER NOT NULL -- 1 - роль бригадира или главного в бригаде, 0 - какая-то другая роль
);
 
-- связка сотрудников с бригадой и своей ролью в бригаде
CREATE TABLE BrigadeWorker (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Sync INTEGER NOT NULL default 0,
  id_Worker INTEGER NOT NULL,
  id_Brigade INTEGER NOT NULL,
  id_BrigadeRole INTEGER NOT NULL
);
CREATE INDEX BrigadeWorker_I1 ON BrigadeWorker (id_Worker);
CREATE INDEX BrigadeWorker_I2 ON BrigadeWorker (id_Brigade, id_BrigadeRole);
 
-- ----------------------------------------------------------------------------------------- --
-- технологические операции
-- * работы на объектах состоят из тех.операций
-- * тех.операции - справочник того, из чего может состоять работа, а не конкретное действие
--   для какой-либо работы на объекте
-- * у тех.операций могут быть обязательные предварительные операции, которые
--   необходимо будет выполнить в работе прежде, чем приступить к текущей;
--   при этом, все зависимые операции будут в работе заданы, но обязательность выполнения
--   определяется по связям в этом блоке таблиц базы данных
-- ----------------------------------------------------------------------------------------- --
 
-- единица измерения
CREATE TABLE Unit (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Sync INTEGER NOT NULL default 0,
  Code TEXT NOT NULL, -- код единицы измерения
  ShortName TEXT NOT NULL, -- краткое наименование
  Name TEXT NOT NULL -- полное наименование
);
 
-- техника
CREATE TABLE Machinery (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Sync INTEGER NOT NULL default 0,
  Code TEXT NOT NULL, -- код
  Name TEXT NOT NULL -- наименование
);
 
-- материал (всякий металл, провода и прочее сырьё)
CREATE TABLE Material (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Sync INTEGER NOT NULL default 0,
  Code TEXT NOT NULL, -- код
  Name TEXT NOT NULL -- наименование
);
 
-- технологическая операция
CREATE TABLE TechOp (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Sync INTEGER NOT NULL default 0,
  Name TEXT NOT NULL, -- наименование операции
  TimeNormHours REAL NOT NULL, -- норма времени в человеко-часах, может быть дробным числом
  MakeInstructions TEXT NOT NULL, -- инструкции по выполнению операции
  VerifyWay TEXT NOT NULL, -- способ проведения контроля: photo, video, form
  VerifyValue TEXT NOT NULL, -- контролируемая величина текстом
  VerifyInstructions TEXT NOT NULL, -- инструкции по проведению контроля
  Conditions TEXT NOT NULL, -- технические и климатические условия
  id_Unit INTEGER NOT NULL -- единицы измерения получаемого результата
);
 
-- поля формы для случаев, когда операция подтверждается набором полей
CREATE TABLE TechOpFormField (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Sync INTEGER NOT NULL default 0,
  Name TEXT NOT NULL, -- заголовок поля
  Type TEXT NOT NULL, -- тип поля: string, text, number, range
  id_TechOp INTEGER NOT NULL, -- привязка к конкретной технологической операции
  Ord INTEGER NOT NULL -- порядок следования поля в форме
);
CREATE INDEX TechOpFormField_I1 ON TechOpFormField (id_TechOp);
CREATE INDEX TechOpFormField_Ord ON TechOpFormField (Ord);
 
-- необходимые исполнители технологической операции по квалификации
CREATE TABLE TechOpDoer (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Sync INTEGER NOT NULL default 0,
  Amount REAL NOT NULL, -- количество исполнителей; double - это потому что в СНиПах бывает полтора землекопа
  id_TechOp INTEGER NOT NULL, -- привязка к конкретной технологической операции
  id_Skill INTEGER NOT NULL -- привязка к квалификации
);
CREATE INDEX TechOpDoer_I1 ON TechOpDoer (id_TechOp);
 
-- используемая в технологической операции техника
CREATE TABLE TechOpMachinery (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Sync INTEGER NOT NULL default 0,
  ValueHours REAL NOT NULL, -- норма машино-времени на одну единицу измерения результата операции
  id_TechOp INTEGER NOT NULL, -- привязка к конкретной технологической операции
  id_Machinery INTEGER NOT NULL -- привязка к технике
);
CREATE INDEX TechOpMachinery_I1 ON TechOpMachinery (id_TechOp);
 
-- используемый в технологической операции материал
CREATE TABLE TechOpMaterial (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Sync INTEGER NOT NULL default 0,
  Value REAL NOT NULL, -- норма использования материала в связанных ед.изм. на одну ед.изм. результата операции
  id_TechOp INTEGER NOT NULL, -- привязка к конкретной технологической операции
  id_Material INTEGER NOT NULL, -- привязка к материалу
  id_Unit INTEGER NOT NULL -- единицы измерения Value в текущей записи
);
CREATE INDEX TechOpMaterial_I1 ON TechOpMaterial (id_TechOp);
 
-- обязательные предшествующие операции
CREATE TABLE TechOpPrevious (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Sync INTEGER NOT NULL default 0,
  id_TechOp INTEGER NOT NULL, -- текущая операция, для которой ищем предшествующие
  id_TechOp_Previous INTEGER NOT NULL -- предшествующая операция
);
-- not sure about this key
CREATE INDEX TechOpPrevious_I1 ON TechOpPrevious (id_TechOp, id_TechOp_Previous);
 
-- ----------------------------------------------------------------------------------------- --
-- проекты, объекты
-- * у проекта есть руководитель из числа сотрудников (может не понадобиться, но связь есть)
-- ----------------------------------------------------------------------------------------- --
 
-- проект
CREATE TABLE Project (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Sync INTEGER NOT NULL default 0,
  Name TEXT NOT NULL,
  Deadline TEXT NOT NULL, -- дата: срок завершения
  Notes TEXT NOT NULL, -- пометки
  id_Worker INTEGER NOT NULL -- руководитель из числа сотрудников
);
 
-- объект
CREATE TABLE Object (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Sync INTEGER NOT NULL default 0,
  Name TEXT NOT NULL, -- наименование объекта
  State TEXT NOT NULL default 'inplan', -- текущий статус: inplan, inprogress, done
  Address TEXT NOT NULL, -- адрес проведения работ
  Description TEXT NOT NULL, -- описание обычными человеческими словами
  Deadline TEXT NOT NULL, -- дата: плановый срок завершения
  id_Project INTEGER NOT NULL -- проект, к которому относится объект
);
-- для быстрого поиска с учётом проекта
CREATE INDEX Object_I1 ON Object (id_Project);
-- для сортировки по дедлайну
CREATE INDEX Object_DL ON Object (Deadline);
-- ну, и по статусу, чего уж, правда это для поиска, а не для сортировки
CREATE INDEX Object_St ON Object (State);
 
-- ----------------------------------------------------------------------------------------- --
-- работы на объектах, распределение работ по бригадам
-- * работы состоят из технологических операций
-- ----------------------------------------------------------------------------------------- --
 
-- работа на объекте
CREATE TABLE Job (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Sync INTEGER NOT NULL default 0,
  Name TEXT NOT NULL, -- наименование
  State TEXT NOT NULL default 'inplan', -- текущий статус: inplan, inprogress, done
  Description TEXT NOT NULL, -- описание обычными человеческими словами
  Deadline TEXT NOT NULL, -- дата: плановый срок завершения
  CalcDurationMins INTEGER NOT NULL, -- нормативное время выполнения в минутах, расчитанное для связанной в текущий момент бригады
  PlanDurationMins INTEGER NOT NULL, -- запланированное при распределении время выполнения, указанное для связанной в текущий момент бригады
  StartedDay TEXT default NULL, -- дата фактического начала работ или NULL
  FinishedDay TEXT default NULL, -- дата фактического завершения работ или NULL
  PlanStartedDay TEXT default NULL, -- запланированная дата начала работ или NULL
  PlanFinishedDay TEXT default NULL, -- запланированная дата завершения работ или NULL
  id_Object INTEGER NOT NULL, -- объект, к которому относится работа
  id_Brigade INTEGER NOT NULL -- текущая привязанная к работе бригада -- исполнитель
);
CREATE INDEX Job_I1 ON Job (id_Object);
CREATE INDEX Job_DL ON Job (Deadline);
CREATE INDEX Job_St ON Job (State);
CREATE INDEX Job_Brgd ON Job (id_Brigade);
-- позже поймём какие ещё ключи нужны
 
-- одна операция внутри работы на объекте
CREATE TABLE JobTechOp (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Sync INTEGER NOT NULL default 0,
  Amount REAL NOT NULL, -- плановое количество единиц результата
  StartedDay TEXT default NULL, -- дата фактического начала или NULL
  FinishedDay TEXT default NULL, -- дата фактического завершения или NULL
  IsDone INTEGER NOT NULL default 0, -- 1 - операция уже выполнена, 0 - пока не выполнена
  id_Job INTEGER NOT NULL, -- работа, к которой привязана технологическая операция
  id_TechOp INTEGER NOT NULL, -- связанная технологическая операция
  Ord INTEGER NOT NULL, -- порядок следования операции в работе
  DoneAmount REAL NOT NULL default 0 -- выполненный объём с точки зрения бригадира
);
CREATE INDEX JobTechOp_I1 ON JobTechOp (id_Job, id_TechOp);
CREATE INDEX JobTechOp_Ord ON JobTechOp (Ord);
 
-- работа в конкретном дне, в распределении по бригадам -- план
-- * работа может быть растянута на несколько дней,
--   текущая таблица показывает, сколько конкретная работа должна
--   выполняться в конкретный день
CREATE TABLE Schedule (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Sync INTEGER NOT NULL default 0,
  Day TEXT NOT NULL, -- дата, когда по плану должна быть выполнена работа
  DurationMins INTEGER NOT NULL, -- длительность выполнения связанной работы в конкретно этот день, в минутах
  id_Job INTEGER NOT NULL, -- работа
  Ord INTEGER NOT NULL -- порядок следования связанной работы внутри дня относительно других работ бригады
);
CREATE INDEX Schedule_Day ON Schedule (Day);
CREATE INDEX Schedule_I1 ON Schedule (id_Job);
CREATE INDEX Schedule_Ord ON Schedule (Ord);
 
-- ----------------------------------------------------------------------------------------- --
-- результаты произведённых замеров
-- * сохранённые значения полей формы при способе контроля "поля формы"
-- * фото и видео файлы
-- ----------------------------------------------------------------------------------------- --
 
-- внесённый бригадиром результат в поле формы при фиксировании работы
CREATE TABLE TechOpFieldValue (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Sync INTEGER NOT NULL default 0,
  Moment TEXT NOT NULL, -- дата-время: момент записи значения поля в базу
  Value TEXT NOT NULL default '', -- значение, введённое в поле
  ItemIndex INTEGER NOT NULL default 0, -- указатель на конкретную работу среди всего количества (5-ый столб из 15-ти, например)
  Lat REAL NOT NULL default 0,
  Lon REAL NOT NULL default 0,
  EquipmentData TEXT NOT NULL default '', -- данные оборудования в формате json: { "sensorName": "sensor probe value", ... }
  id_JobTechOp INTEGER NOT NULL, -- привязка результата замера, внесённого в поле формы, к технологической операции в работе
  id_TechOpFormField INTEGER NOT NULL, -- указание на поле формы, для которого сохранен результат в замере
  id_Worker INTEGER NOT NULL, -- сотрудник, сделавший замер и указавший значение поля формы
  id_Brigade INTEGER NOT NULL -- бригада, к которой относился сотрудник в момент указания результата для поля формы
);
CREATE INDEX TechOpFieldValue_I1 ON TechOpFieldValue (id_JobTechOp);
CREATE INDEX TechOpFieldValue_I2 ON TechOpFieldValue (id_Worker, id_Brigade);
CREATE INDEX TechOpFieldValue_I3 ON TechOpFieldValue (id_TechOpFormField);
 
-- замер, произведённый сотрудником на объекте
CREATE TABLE Probe (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Sync INTEGER NOT NULL default 0,
  Moment TEXT NOT NULL, -- дата-время: момент записи замера в базу
  MediaFile TEXT NOT NULL, -- имя файла в локальной папке на устройстве
  ItemIndex INTEGER NOT NULL default 0, -- указатель на конкретную работу среди всего количества (5-ый столб из 15-ти, например)
  Lat REAL NOT NULL default 0,
  Lon REAL NOT NULL default 0,
  EquipmentData TEXT NOT NULL default '', -- данные оборудования в формате json: { "sensorName": "sensor probe value", ... }
  id_JobTechOp INTEGER NOT NULL, -- привязка замера к технологической операции в работе
  id_Worker INTEGER NOT NULL, -- сотрудник, сделавший замер
  id_Brigade INTEGER NOT NULL, -- бригада, к которой относился сотрудник в момент замера
  IsSent_MediaFile INTEGER NOT NULL default 0
);
CREATE INDEX Probe_I1 ON Probe (id_JobTechOp);
CREATE INDEX Probe_I2 ON Probe (id_Worker, id_Brigade);
 
-- ----------------------------------------------------------------------------------------- --
-- пользователи, авторизация
-- * связь показывает как авторизованный пользователь связан с Worker
-- * Worker, в свою очередь, связан с бригадой (см. v1)
-- * предусмотрена роль (группа прав) для работы в интерфейсе
-- ----------------------------------------------------------------------------------------- --
 
-- пользователь мобильного интерфейса
CREATE TABLE User (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Sync INTEGER NOT NULL default 0,
  Login TEXT NOT NULL,
  Password TEXT NOT NULL, -- md5-закодированный пароль
  id_Worker INTEGER NOT NULL -- может быть 0, если это не бригадир, например
);
CREATE INDEX User_Login ON User (Login);
 
-- роль пользователя при работе с интерфейсом
CREATE TABLE InterfaceRole (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Sync INTEGER NOT NULL default 0,
  Alias TEXT NOT NULL,  -- программный код роли; НЕЛЬЗЯ ПРИВЯЗЫВАТЬСЯ К id, ТОЛЬКО К АЛИАСУ!
  Name TEXT NOT NULL -- видимое пользователю название роли
);
 
-- связь пользователей с ролями
CREATE TABLE UserInterfaceRoles (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Sync INTEGER NOT NULL default 0,
  id_User INTEGER NOT NULL,
  id_InterfaceRole INTEGER NOT NULL
);
CREATE INDEX UserInterfaceRoles_I1 ON UserInterfaceRoles (id_User, id_InterfaceRole);
 
-- ----------------------------------------------------------------------------------------- --
-- синхронизация
-- БЕЗ УЧЁТА САМИХ ЗАПИСЕЙ
-- ----------------------------------------------------------------------------------------- --
 
-- таблица последовательности синхронизации
CREATE TABLE SyncTables (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Ord INTEGER NOT NULL, -- порядок обработки
  Name TEXT NOT NULL, -- имя таблицы или вспомогательного элемента
  Params TEXT NOT NULL -- фильтр запроса или другие параметры
);
CREATE INDEX SyncTables_Ord ON SyncTables (Ord);
 
-- таблица подмены связанных полей при синхронизации
CREATE TABLE SyncLinked (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  SrcTable TEXT NOT NULL, -- имя таблицы, в записи которой поменялось поле id
  TargetTable TEXT NOT NULL, -- имя таблицы, записи которой требуется обновить
  Field TEXT NOT NULL -- имя поля в TargetTable, значение которого необходимо обновить
);
CREATE INDEX SyncLinked_SrcTab ON SyncLinked (SrcTable);

-- version: 9

-- ----------------------------------------------------------------------------------------- --
-- документы
-- * отдельно таблица файлов документов
-- * отдельно связи с проектами, объектами, работами и тех.операциями
-- * файл может быть привязан к нескольким сущностям
-- ----------------------------------------------------------------------------------------- --

-- файлы документов
CREATE TABLE DocFile (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  Name TEXT NOT NULL, -- удобо-читаемое название файла: Схема подключения
  Ext TEXT NOT NULL, -- расширение, например: pdf, doc, docx
  Filename TEXT NOT NULL, -- имя файла в локальной папке: some123123.pdf
  Sync INTEGER NOT NULL default 0
);

-- привязка файлов к проектам
CREATE TABLE DocFileProject (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  id_DocFile INTEGER NOT NULL,
  id_Project INTEGER NOT NULL,
  Sync INTEGER NOT NULL default 0
);
CREATE INDEX DocFileProject_I1 ON DocFileProject (id_DocFile, id_Project);

-- привязка файлов к объектам
CREATE TABLE DocFileObject (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  id_DocFile INTEGER NOT NULL,
  id_Object INTEGER NOT NULL,
  Sync INTEGER NOT NULL default 0
);
CREATE INDEX DocFileObject_I1 ON DocFileObject (id_DocFile, id_Object);

-- привязка файлов к работам
CREATE TABLE DocFileJob (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  id_DocFile INTEGER NOT NULL,
  id_Job INTEGER NOT NULL,
  Sync INTEGER NOT NULL default 0
);
CREATE INDEX DocFileJob_I1 ON DocFileJob (id_DocFile, id_Job);

-- привязка файлов к технологическим операциям
CREATE TABLE DocFileTechOp (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  id_DocFile INTEGER NOT NULL,
  id_TechOp INTEGER NOT NULL,
  Sync INTEGER NOT NULL default 0
);
CREATE INDEX DocFileTechOp_I1 ON DocFileTechOp (id_DocFile, id_TechOp);

