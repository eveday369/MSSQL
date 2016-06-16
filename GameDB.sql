-- DB 생성
CREATE DATABASE GameDB;
GO
USE GameDB;
GO
-- 계정 테이블
CREATE TABLE Account
	(ID VARCHAR(20) PRIMARY KEY, PW VARCHAR(20) NOT NULL, Email VARCHAR(30) NULL);
GO
-- 데이터 입력
INSERT INTO Account VALUES('eveday369', '12345', 'eveday369@gmail.com');
INSERT INTO Account VALUES('flower', '45678', 'flower@gmail.com');
INSERT INTO Account VALUES('apple', '67890', 'apple@gmail.com');
GO
-- 게임 데이터 테이블
CREATE TABLE GameData
	(ID VARCHAR(20) PRIMARY KEY, HP INT NOT NULL, Pow INT NOT NULL);
GO
-- 데이터 입력
INSERT INTO GameData VALUES('eveday369', 100, 20);
INSERT INTO GameData VALUES('flower', 50, 10);
INSERT INTO GameData VALUES('apple', 200, 30);
-- 계정 변동 상태 테이블
CREATE TABLE ChangeCode
	(Code SMALLINT PRIMARY KEY, Name VARCHAR(20) NOT NULL);
GO
-- 데이터 입력
INSERT INTO ChangeCode VALUES(1, 'Create');
INSERT INTO ChangeCode VALUES(2, 'Delete');
INSERT INTO ChangeCode VALUES(3, 'Update');
-- 계정 변동 사항 테이블
CREATE TABLE ChangeAccount
	(ID VARCHAR(20) PRIMARY KEY, Code SMALLINT FOREIGN KEY REFERENCES ChangeCode(Code),
	ChangeTime DATETIME NOT NULL);
GO
-- 계정 테이블에 트리거 생성
CREATE TRIGGER Account_Insert
	ON Account AFTER INSERT AS
	BEGIN
		INSERT INTO ChangeAccount VALUES((SELECT ID FROM INSERTED), 1, GETDATE());
	END
GO
CREATE TRIGGER Account_Delete
	ON Account AFTER DELETE AS
	BEGIN
		INSERT INTO ChangeAccount VALUES((SELECT ID FROM DELETED), 2, GETDATE());
	END
GO
CREATE TRIGGER Account_Update
	ON Account AFTER UPDATE AS
	BEGIN
		INSERT INTO ChangeAccount VALUES((SELECT ID FROM DELETED), 3, GETDATE());
	END
GO
-- 새로운 계정 생성 및 데이터 입력
INSERT Account VALUES('banana', '111222', 'banana@fruits.com');
INSERT GameData VALUES('banana', 10, 50);
-- 계정 변동사항 테이블 확인
--SELECT * FROM ChangeAccount;

-- 저장 프로시저 생성
-- HP가 입력값 이상의 계정을 출력
CREATE PROC HP_OVER_PROC
	@HP INT
AS
SELECT Acc.ID AS 'ID', Acc.PW AS 'Password', Acc.Email AS 'Email', Data.HP AS 'HP', Data.Pow AS 'Power'
FROM Account Acc INNER JOIN GameData Data
ON Acc.ID = Data.ID
WHERE Data.HP >= @HP;
-- 확인
EXEC HP_OVER_PROC 50;
-- 공격력이 입력값 이하인 계정의 수
CREATE PROC POW_UNDER_COUNT_PROC
	@POW INT,
	@CNT INT OUTPUT
AS
SELECT @CNT = COUNT(Acc.ID)
FROM Account Acc INNER JOIN GameData Data
ON Acc.ID = Data.ID
WHERE Data.Pow <= @POW;
-- 확인
DECLARE @CNT INT;
EXEC POW_UNDER_COUNT_PROC 20, @CNT OUTPUT;
SELECT @CNT AS '계정수';