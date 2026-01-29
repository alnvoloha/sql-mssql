/*
Created: 02.04.2025
Modified: 04.04.2025
Project: volohaLab2
Model: Учет внутриофисных расходов
Author: Alina Voloha
Database: MS SQL Server 2019
*/



USE [Учет внутриофисных расходов];
GO
ALTER DATABASE Office SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE IF EXISTS Office;

CREATE DATABASE Office;
GO
USE Office;
-- Table Department

CREATE TABLE dbo.Department
(
 [PK_DepartmentName] Varchar(50) PRIMARY KEY,
 [EmployeeQuantity] Int NOT NULL,
 StartDate DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
 EndDate DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
 PERIOD FOR SYSTEM_TIME(StartDate, EndDate)
)
WITH(SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.DepartmentHistory));



-- Table Purchase

CREATE TABLE dbo.Purchase
(
 [PK_IDEmployee] INT NOT NULL,
 [PK_DepartmentName] Varchar(50) NULL,
 [PK_ExpenseTypeName] Varchar(50) NULL,
 [DataLimit] Date NULL,
 [PK_IDPurchase] INT IDENTITY(1,1) NOT NULL,
 PRIMARY KEY ([PK_IDEmployee],[PK_IDPurchase]),
 [PurchaseData] Date NOT NULL,
 [PurchaseSum] Decimal(19,4) NOT NULL,
 StartDate DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
 EndDate DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
 PERIOD FOR SYSTEM_TIME(StartDate, EndDate)
)
WITH(SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.PurchaseHistory));









-- Table ExpenseType

CREATE TABLE dbo.ExpenseType
(
 [PK_ExpenseTypeName] Varchar(50)  PRIMARY KEY,
 [Description] Varchar(100) NULL,
 StartDate DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
 EndDate DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
 PERIOD FOR SYSTEM_TIME(StartDate, EndDate)
)
WITH(SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.ExpenseTypeHistory));




-- Table Employee

CREATE TABLE dbo.Employee
(
 [PK_IDEmployee] INT IDENTITY(1,1) PRIMARY KEY,
 [Lastname] Varchar(50) NULL,
 [Middlename] Varchar(50) NULL,
 [Name] Varchar(50) NULL,
 StartDate DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
 EndDate DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
 PERIOD FOR SYSTEM_TIME(StartDate, EndDate)
)
WITH(SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.EmployeeHistory));







-- Table ExpenseLimit

CREATE TABLE dbo.ExpenseLimit
(
 [PK_DepartmentName] Varchar(50) NOT NULL,
 [PK_ExpenseTypeName] Varchar(50) NOT NULL,
 [DataLimit] Date NOT NULL,
 [MaxPayment] Decimal(19,4) NOT NULL,
 PRIMARY KEY (PK_DepartmentName, PK_ExpenseTypeName, DataLimit),
 StartDate DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
 EndDate DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
 PERIOD FOR SYSTEM_TIME(StartDate, EndDate)
)
WITH(SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.ExpenseLimitHistory));





-- Table EmployeePosition


CREATE TABLE dbo.EmployeePosition
(
 [PK_DepartmentName] Varchar(50) NOT NULL,
 [Название должности] Char(1) NOT NULL,
 [PK_IDEmployee] INT NOT NULL,
 PRIMARY KEY ([PK_DepartmentName],[Название должности]),
 StartDate DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
 EndDate DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
 PERIOD FOR SYSTEM_TIME(StartDate, EndDate)
)
WITH(SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.EmployeePositionHistory));




-- Table DepartmentExpenses

CREATE TABLE dbo.DepartmentExpenses
(
 [PK_DepartmentName] Varchar(50) NOT NULL,
 [PK_ExpenseTypeName] Varchar(50) NOT NULL,
 [PK_IDEmployee] INT NOT NULL,
  [PK_IDPurchase] INT  NOT NULL,
 [DataLimit] Date NOT NULL,
 
 [Remains] Decimal(19,4) NULL,
 PRIMARY KEY ([PK_DepartmentName],[PK_ExpenseTypeName],[PK_IDEmployee],[DataLimit], PK_IDPurchase),
 StartDate DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
 EndDate DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
 PERIOD FOR SYSTEM_TIME(StartDate, EndDate)
)
WITH(SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.DepartmentExpensesHistory));






-- Create foreign keys (relationships) section ------------------------------------------------- 


ALTER TABLE [EmployeePosition] ADD CONSTRAINT [Include] FOREIGN KEY ([PK_DepartmentName]) REFERENCES [Department] ([PK_DepartmentName]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [EmployeePosition] ADD CONSTRAINT [WorkIn] FOREIGN KEY ([PK_IDEmployee]) REFERENCES [Employee] ([PK_IDEmployee]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [ExpenseLimit] ADD CONSTRAINT [Have] FOREIGN KEY ([PK_DepartmentName]) REFERENCES [Department] ([PK_DepartmentName]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [ExpenseLimit] ADD CONSTRAINT [Made] FOREIGN KEY ([PK_ExpenseTypeName]) REFERENCES [ExpenseType] ([PK_ExpenseTypeName]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [Purchase] ADD CONSTRAINT [Do] FOREIGN KEY ([PK_IDEmployee]) REFERENCES [Employee] ([PK_IDEmployee]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [Purchase] ADD CONSTRAINT [UseIn] FOREIGN KEY ([PK_DepartmentName], [PK_ExpenseTypeName], [DataLimit]) REFERENCES [ExpenseLimit] ([PK_DepartmentName], [PK_ExpenseTypeName], [DataLimit]) ON UPDATE NO ACTION ON DELETE NO ACTION
go



ALTER TABLE [DepartmentExpenses] ADD CONSTRAINT [Restrict] FOREIGN KEY ([PK_DepartmentName], [PK_ExpenseTypeName], [DataLimit]) REFERENCES [ExpenseLimit] ([PK_DepartmentName], [PK_ExpenseTypeName], [DataLimit]) ON UPDATE NO ACTION ON DELETE NO ACTION
go

ALTER TABLE DepartmentExpenses
ADD CONSTRAINT IntroducedIn FOREIGN KEY (PK_IDEmployee, PK_IDPurchase)
REFERENCES Purchase(PK_IDEmployee, PK_IDPurchase);













--Заполнение БД (01.01.2022)

-- Таблица Department
INSERT INTO dbo.Department (PK_DepartmentName, EmployeeQuantity) VALUES
('HR', 5),
('Finance', 7),
('IT', 12),
('Marketing', 6),
('Sales', 8),
('Logistics', 4),
('Support', 5),
('Legal', 3),
('R&D', 9),
('Operations', 10),
('Design', 4),
('QA', 6),
('Procurement', 3),
('Administration', 2),
('Security', 4);




--Таблица Employee
INSERT INTO dbo.Employee (Lastname, Middlename, Name) VALUES
('Ivanov', 'Ivanovich', 'Petr'),
('Petrova', 'Sergeevna', 'Anna'),
('Smirnov', 'Andreevich', 'Maksim'),
('Volkova', 'Petrovna', 'Elena'),
('Sidorov', 'Vladimirovich', 'Dmitry'),
('Kuznetsova', 'Ivanovna', 'Maria'),
('Popov', 'Alexeevich', 'Kirill'),
('Lebedeva', 'Mihailovna', 'Svetlana'),
('Mikhailov', 'Olegovich', 'Oleg'),
('Nikolaeva', 'Sergeevna', 'Irina'),
('Egorov', 'Antonovich', 'Roman'),
('Pavlova', 'Dmitrievna', 'Yulia'),
('Vasiliev', 'Nikolayevich', 'Nikolay'),
('Sorokina', 'Igorevna', 'Polina'),
('Fedorov', 'Vladimirovich', 'Denis');


--таблица ExpenseType
INSERT INTO dbo.ExpenseType (PK_ExpenseTypeName, Description) VALUES
('OfficeSupplies', 'Канцелярия'),
('Transport', 'Транспортные расходы'),
('Software', 'Покупка ПО'),
('Hardware', 'Покупка оборудования'),
('Catering', 'Питание'),
('MarketingAds', 'Реклама'),
('LegalServices', 'Юридические услуги'),
('Consulting', 'Консалтинг'),
('Training', 'Обучение персонала'),
('Travel', 'Командировки'),
('Maintenance', 'Обслуживание техники'),
('Cleaning', 'Уборка помещений'),
('Security', 'Охрана и безопасность'),
('Subscriptions', 'Подписки и лицензии'),
('HRServices', 'Аутсорсинг HR-услуг');



--Таблица ExpenseLimit
INSERT INTO dbo.ExpenseLimit (PK_DepartmentName, PK_ExpenseTypeName, DataLimit, MaxPayment) VALUES
('HR', 'OfficeSupplies', '2022-01-01', 3000.00),
('Finance', 'Software', '2022-01-01', 8000.00),
('IT', 'Hardware', '2022-01-01', 15000.00),
('Marketing', 'MarketingAds', '2022-01-01', 12000.00),
('Sales', 'Travel', '2022-01-01', 10000.00),
('Logistics', 'Transport', '2022-01-01', 7000.00),
('Support', 'Catering', '2022-01-01', 4000.00),
('Legal', 'LegalServices', '2022-01-01', 9000.00),
('R&D', 'Subscriptions', '2022-01-01', 11000.00),
('Operations', 'Maintenance', '2022-01-01', 9500.00),
('Design', 'Software', '2022-01-01', 5000.00),
('QA', 'Cleaning', '2022-01-01', 3000.00),
('Procurement', 'OfficeSupplies', '2022-01-01', 3500.00),
('HR', 'Training', '2022-01-01', 6000.00),
('Finance', 'Consulting', '2022-01-01', 7000.00),
('IT', 'Subscriptions', '2022-01-01', 4500.00),
('Marketing', 'Travel', '2022-01-01', 8000.00),
('Sales', 'Hardware', '2022-01-01', 9000.00),
('Logistics', 'Maintenance', '2022-01-01', 4000.00),
('Support', 'Cleaning', '2022-01-01', 3200.00),
('Legal', 'Security', '2022-01-01', 8700.00),
('R&D', 'Software', '2022-01-01', 10000.00),
('Operations', 'Catering', '2022-01-01', 4300.00),
('Design', 'OfficeSupplies', '2022-01-01', 2700.00),
('QA', 'Training', '2022-01-01', 5200.00),
('Procurement', 'Transport', '2022-01-01', 6100.00),
('HR', 'Catering', '2022-01-01', 3900.00),
('Finance', 'Subscriptions', '2022-01-01', 7200.00),
('IT', 'Cleaning', '2022-01-01', 2100.00),
('Marketing', 'LegalServices', '2022-01-01', 6400.00),
('Sales', 'Consulting', '2022-01-01', 7700.00),
('Logistics', 'Security', '2022-01-01', 8200.00),
('Support', 'Software', '2022-01-01', 5100.00),
('Legal', 'Training', '2022-01-01', 6900.00),
('R&D', 'Hardware', '2022-01-01', 9800.00),
('Operations', 'Consulting', '2022-01-01', 7300.00);



-- Таблица Purchase

INSERT INTO dbo.Purchase (PK_IDEmployee, PK_DepartmentName, PK_ExpenseTypeName, DataLimit, PurchaseData, PurchaseSum) VALUES
(1, 'HR', 'OfficeSupplies', '2022-01-01', '2022-01-06', 1200.00),
(2, 'Finance', 'Software', '2022-01-01', '2022-01-06', 2300.00),
(3, 'IT', 'Hardware', '2022-01-01', '2022-01-06', 4500.00),
(4, 'Marketing', 'MarketingAds', '2022-01-01', '2022-01-06', 3200.00),
(5, 'Sales', 'Travel', '2022-01-01', '2022-01-06', 2800.00),
(6, 'Logistics', 'Transport', '2022-01-01', '2022-01-06', 1700.00),
(7, 'Support', 'Catering', '2022-01-01', '2022-01-06', 1400.00),
(8, 'Legal', 'LegalServices', '2022-01-01', '2022-01-06', 3000.00),
(9, 'R&D', 'Subscriptions', '2022-01-01', '2022-01-06', 2500.00),
(10, 'Operations', 'Maintenance', '2022-01-01', '2022-01-06', 1800.00),
(11, 'Design', 'Software', '2022-01-01', '2022-01-06', 2100.00),
(12, 'QA', 'Cleaning', '2022-01-01', '2022-01-06', 1000.00),
(13, 'Procurement', 'OfficeSupplies', '2022-01-01', '2022-01-06', 1800.00),
(1, 'HR', 'Training', '2022-01-01', '2022-01-06', 2200.00),
(2, 'Finance', 'Consulting', '2022-01-01', '2022-01-06', 2700.00),
(3, 'IT', 'Subscriptions', '2022-01-01', '2022-01-06', 1900.00),
(4, 'Marketing', 'Travel', '2022-01-01', '2022-01-06', 2000.00),
(5, 'Sales', 'Hardware', '2022-01-01', '2022-01-06', 3000.00),
(6, 'Logistics', 'Maintenance', '2022-01-01', '2022-01-06', 1700.00),
(7, 'Support', 'Cleaning', '2022-01-01', '2022-01-06', 1000.00),
(8, 'Legal', 'Security', '2022-01-01', '2022-01-06', 2600.00),
(9, 'R&D', 'Software', '2022-01-01', '2022-01-06', 3100.00),
(10, 'Operations', 'Catering', '2022-01-01', '2022-01-06', 1300.00),
(11, 'Design', 'OfficeSupplies', '2022-01-01', '2022-01-06', 1600.00),
(12, 'QA', 'Training', '2022-01-01', '2022-01-06', 2400.00),
(13, 'Procurement', 'Transport', '2022-01-01', '2022-01-06', 2800.00),
(1, 'HR', 'Catering', '2022-01-01', '2022-01-06', 1500.00),
(2, 'Finance', 'Subscriptions', '2022-01-01', '2022-01-06', 2700.00),
(3, 'IT', 'Cleaning', '2022-01-01', '2022-01-06', 1000.00),
(4, 'Marketing', 'LegalServices', '2022-01-01', '2022-01-06', 3100.00),
(5, 'Sales', 'Consulting', '2022-01-01', '2022-01-06', 2900.00),
(6, 'Logistics', 'Security', '2022-01-01', '2022-01-06', 2400.00),
(7, 'Support', 'Software', '2022-01-01', '2022-01-06', 2200.00),
(8, 'Legal', 'Training', '2022-01-01', '2022-01-06', 2600.00),
(9, 'R&D', 'Hardware', '2022-01-01', '2022-01-06', 3800.00),
(10, 'Operations', 'Consulting', '2022-01-01', '2022-01-06', 3300.00);

--Тбалица EmployeePosition
INSERT INTO dbo.EmployeePosition (PK_DepartmentName, [Название должности], PK_IDEmployee) VALUES
('Finance', 'A', 1),
('IT', 'B', 2),
('Marketing', 'C', 3),
('Sales', 'D', 4),
('Legal', 'E', 5),
('Support', 'F', 6),
('QA', 'G', 7),
('R&D', 'H', 8),
('Operations', 'I', 9),
('Design', 'J', 10),
('Logistics', 'K', 11),
('Procurement', 'L', 12),
('HR', 'M', 13),
('Security', 'N', 14),
('Administration', 'O', 15);


--Таблица DepartmentExpenses
INSERT INTO DepartmentExpenses 
(PK_DepartmentName, PK_ExpenseTypeName, PK_IDEmployee, DataLimit, PK_IDPurchase, Remains) VALUES
('HR', 'OfficeSupplies', 1, '2022-01-01', 1, 1800.00),
('Finance', 'Software', 2, '2022-01-01', 2, 5700.00),
('IT', 'Hardware', 3, '2022-01-01', 3, 10500.00),
('Marketing', 'MarketingAds', 4, '2022-01-01', 4, 8800.00),
('Sales', 'Travel', 5, '2022-01-01', 5, 7200.00),
('Logistics', 'Transport', 6, '2022-01-01', 6, 5300.00),
('Support', 'Catering', 7, '2022-01-01', 7, 2600.00),
('Legal', 'LegalServices', 8, '2022-01-01', 8, 6000.00),
('R&D', 'Subscriptions', 9, '2022-01-01', 9, 8500.00),
('Operations', 'Maintenance', 10, '2022-01-01', 10, 7700.00),
('Design', 'Software', 11, '2022-01-01', 11, 2900.00),
('QA', 'Cleaning', 12, '2022-01-01', 12, 2000.00),
('Procurement', 'OfficeSupplies', 13, '2022-01-01', 13, 1700.00),
('HR', 'Training', 1, '2022-01-01', 14, 3800.00),
('Finance', 'Consulting', 2, '2022-01-01', 15, 4300.00),
('IT', 'Subscriptions', 3, '2022-01-01', 16, 2600.00),
('Marketing', 'Travel', 4, '2022-01-01', 17, 6000.00),
('Sales', 'Hardware', 5, '2022-01-01', 18, 6000.00),
('Logistics', 'Maintenance', 6, '2022-01-01', 19, 2300.00),
('Support', 'Cleaning', 7, '2022-01-01', 20, 2200.00),
('Legal', 'Security', 8, '2022-01-01', 21, 6100.00),
('R&D', 'Software', 9, '2022-01-01', 22, 6900.00),
('Operations', 'Catering', 10, '2022-01-01', 23, 3000.00),
('Design', 'OfficeSupplies', 11, '2022-01-01', 24, 1100.00),
('QA', 'Training', 12, '2022-01-01', 25, 2800.00),
('Procurement', 'Transport', 13, '2022-01-01', 26, 3300.00),
('HR', 'Catering', 1, '2022-01-01', 27, 2400.00),
('Finance', 'Subscriptions', 2, '2022-01-01', 28, 4500.00),
('IT', 'Cleaning', 3, '2022-01-01', 29, 1100.00),
('Marketing', 'LegalServices', 4, '2022-01-01', 30, 3300.00),
('Sales', 'Consulting', 5, '2022-01-01', 31, 4800.00),
('Logistics', 'Security', 6, '2022-01-01', 32, 5800.00),
('Support', 'Software', 7, '2022-01-01', 33, 2900.00),
('Legal', 'Training', 8, '2022-01-01', 34, 4300.00),
('R&D', 'Hardware', 9, '2022-01-01', 35, 6000.00);









--01 02 2022

-- ДОБАВЛЕНИЯ 
INSERT INTO dbo.Employee (Lastname, Middlename, Name) 
VALUES ('Ermakova', 'Vladimirovna', 'Diana');

INSERT INTO dbo.Department (PK_DepartmentName, EmployeeQuantity)
VALUES ('Analytics', 6);

INSERT INTO dbo.ExpenseType (PK_ExpenseTypeName, Description)
VALUES ('Translation', 'Переводческие услуги');

INSERT INTO dbo.ExpenseLimit (PK_DepartmentName, PK_ExpenseTypeName, DataLimit, MaxPayment)
VALUES ('Analytics', 'Translation', '2022-01-01', 5000.00);

INSERT INTO dbo.Purchase (PK_IDEmployee, PK_DepartmentName, PK_ExpenseTypeName, DataLimit, PurchaseData, PurchaseSum)
VALUES (1, 'Analytics', 'Translation', '2022-01-01', '2022-01-15', 1500.00);

-- ОБНОВЛЕНИЯ
UPDATE dbo.Employee
SET Middlename = 'Andreevna'
WHERE Name = 'Elena' AND Lastname = 'Volkova';

UPDATE dbo.Department
SET EmployeeQuantity = 9
WHERE PK_DepartmentName = 'Support';

UPDATE dbo.ExpenseType
SET Description = 'Уборка помещений и прилегающей территории'
WHERE PK_ExpenseTypeName = 'Cleaning';

UPDATE dbo.Purchase
SET PurchaseSum = 2500.00
WHERE PK_IDEmployee = 3 AND PK_IDPurchase = 3;

UPDATE dbo.ExpenseLimit
SET MaxPayment = 5100.00
WHERE PK_DepartmentName = 'Support' AND PK_ExpenseTypeName = 'Software' AND DataLimit = '2022-01-01';

-- УДАЛЕНИЯ 
DELETE FROM dbo.DepartmentExpenses
WHERE PK_DepartmentName = 'Support' AND PK_ExpenseTypeName = 'Software' AND DataLimit = '2022-01-01';

DELETE FROM dbo.EmployeePosition
WHERE PK_IDEmployee = 15 AND PK_DepartmentName = 'Administration';

DELETE FROM dbo.ExpenseType
WHERE PK_ExpenseTypeName = 'CourierServices';


SELECT LastName
FROM dbo.Employee