-- version: 18

-- поля для работы с замечаниями в JobTechOp
ALTER TABLE JobTechOp
	ADD ValidateDescription TEXT NOT NULL default '';
ALTER TABLE JobTechOp
	ADD HasProblems int NOT NULL default 0;
