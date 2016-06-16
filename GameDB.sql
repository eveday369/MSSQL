-- DB ����
CREATE DATABASE GameDB;
GO
USE GameDB;
GO
-- ���� ���̺�
CREATE TABLE Account
	(ID VARCHAR(20) PRIMARY KEY, PW VARCHAR(20) NOT NULL, Email VARCHAR(30) NULL);
GO
-- ������ �Է�
INSERT INTO Account VALUES('eveday369', '12345', 'eveday369@gmail.com');
INSERT INTO Account VALUES('flower', '45678', 'flower@gmail.com');
INSERT INTO Account VALUES('apple', '67890', 'apple@gmail.com');
GO
-- ���� ������ ���̺�
CREATE TABLE GameData
	(ID VARCHAR(20) PRIMARY KEY, HP INT NOT NULL, Pow INT NOT NULL);
GO
-- ������ �Է�
INSERT INTO GameData VALUES('eveday369', 100, 20);
INSERT INTO GameData VALUES('flower', 50, 10);
INSERT INTO GameData VALUES('apple', 200, 30);
-- ���� ���� ���� ���̺�
CREATE TABLE ChangeCode
	(Code SMALLINT PRIMARY KEY, Name VARCHAR(20) NOT NULL);
GO
-- ������ �Է�
INSERT INTO ChangeCode VALUES(1, 'Create');
INSERT INTO ChangeCode VALUES(2, 'Delete');
INSERT INTO ChangeCode VALUES(3, 'Update');
-- ���� ���� ���� ���̺�
CREATE TABLE ChangeAccount
	(ID VARCHAR(20) PRIMARY KEY, Code SMALLINT FOREIGN KEY REFERENCES ChangeCode(Code),
	ChangeTime DATETIME NOT NULL);
GO
-- ���� ���̺� Ʈ���� ����
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
-- ���ο� ���� ���� �� ������ �Է�
INSERT Account VALUES('banana', '111222', 'banana@fruits.com');
INSERT GameData VALUES('banana', 10, 50);
-- ���� �������� ���̺� Ȯ��
--SELECT * FROM ChangeAccount;

-- ���� ���ν��� ����
-- HP�� �Է°� �̻��� ������ ���
CREATE PROC HP_OVER_PROC
	@HP INT
AS
SELECT Acc.ID AS 'ID', Acc.PW AS 'Password', Acc.Email AS 'Email', Data.HP AS 'HP', Data.Pow AS 'Power'
FROM Account Acc INNER JOIN GameData Data
ON Acc.ID = Data.ID
WHERE Data.HP >= @HP;
-- Ȯ��
EXEC HP_OVER_PROC 50;
-- ���ݷ��� �Է°� ������ ������ ��
CREATE PROC POW_UNDER_COUNT_PROC
	@POW INT,
	@CNT INT OUTPUT
AS
SELECT @CNT = COUNT(Acc.ID)
FROM Account Acc INNER JOIN GameData Data
ON Acc.ID = Data.ID
WHERE Data.Pow <= @POW;
-- Ȯ��
DECLARE @CNT INT;
EXEC POW_UNDER_COUNT_PROC 20, @CNT OUTPUT;
SELECT @CNT AS '������';