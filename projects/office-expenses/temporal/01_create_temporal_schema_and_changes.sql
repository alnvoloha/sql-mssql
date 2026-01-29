/*
Created: 02.04.2025
Modified: 04.04.2025
Project: volohaLab2
Model: Учет внутриофисных расходов
Author: Alina Voloha
Database: MS SQL Server 2019
*/

-- Создание БД 
USE [Учет внутриофисных расходов];
GO
ALTER DATABASE Office SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE IF EXISTS Office;

CREATE DATABASE Office;
GO
USE Office;

-- Таблица Department
CREATE TABLE dbo.Department
(
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL UNIQUE,
    EmployeeQuantity INT NOT NULL,
    StartDate DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    EndDate DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
    PERIOD FOR SYSTEM_TIME(StartDate, EndDate)
)
WITH(SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.DepartmentHistory));

-- Таблица ExpenseType
CREATE TABLE dbo.ExpenseType
(
    ExpenseTypeID INT IDENTITY(1,1) PRIMARY KEY,
    ExpenseTypeName VARCHAR(50) NOT NULL UNIQUE,
    Description VARCHAR(100),
    StartDate DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    EndDate DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
    PERIOD FOR SYSTEM_TIME(StartDate, EndDate)
)
WITH(SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.ExpenseTypeHistory));

-- Таблица Employee
CREATE TABLE dbo.Employee
(
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    Lastname VARCHAR(50),
    Middlename VARCHAR(50),
    Name VARCHAR(50),
    StartDate DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    EndDate DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
    PERIOD FOR SYSTEM_TIME(StartDate, EndDate)
)
WITH(SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.EmployeeHistory));

-- Таблица ExpenseLimit
CREATE TABLE dbo.ExpenseLimit
(
    LimitID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentID INT NOT NULL,
    ExpenseTypeID INT NOT NULL,
    DataLimit DATE NOT NULL,
    MaxPayment DECIMAL(19,4) NOT NULL,
    StartDate DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    EndDate DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
    PERIOD FOR SYSTEM_TIME(StartDate, EndDate)
)
WITH(SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.ExpenseLimitHistory));

-- Таблица Purchase
CREATE TABLE dbo.Purchase
(
    PurchaseID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    LimitID INT NOT NULL,
    PurchaseData DATE NOT NULL,
    PurchaseSum DECIMAL(19,4) NOT NULL,
    StartDate DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    EndDate DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
    PERIOD FOR SYSTEM_TIME(StartDate, EndDate)
)
WITH(SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.PurchaseHistory));

-- Таблица EmployeePosition
CREATE TABLE dbo.EmployeePosition
(
    PositionID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentID INT NOT NULL,
    PositionCode VARCHAR(30) NOT NULL,
    EmployeeID INT NOT NULL,
    StartDate DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
    EndDate DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
    PERIOD FOR SYSTEM_TIME(StartDate, EndDate)
)
WITH(SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.EmployeePositionHistory));

-- Внешние ключи
ALTER TABLE dbo.ExpenseLimit ADD CONSTRAINT FK_ExpenseLimit_Department FOREIGN KEY (DepartmentID) REFERENCES dbo.Department(DepartmentID);
ALTER TABLE dbo.ExpenseLimit ADD CONSTRAINT FK_ExpenseLimit_ExpenseType FOREIGN KEY (ExpenseTypeID) REFERENCES dbo.ExpenseType(ExpenseTypeID);
ALTER TABLE dbo.Purchase ADD CONSTRAINT FK_Purchase_Employee FOREIGN KEY (EmployeeID) REFERENCES dbo.Employee(EmployeeID);
ALTER TABLE dbo.Purchase ADD CONSTRAINT FK_Purchase_Limit FOREIGN KEY (LimitID) REFERENCES dbo.ExpenseLimit(LimitID);
ALTER TABLE dbo.EmployeePosition ADD CONSTRAINT FK_EmployeePosition_Department FOREIGN KEY (DepartmentID) REFERENCES dbo.Department(DepartmentID);
ALTER TABLE dbo.EmployeePosition ADD CONSTRAINT FK_EmployeePosition_Employee FOREIGN KEY (EmployeeID) REFERENCES dbo.Employee(EmployeeID);



-- Добавление флага IsActive во все ключевые таблицы, где могут быть "удаления"

-- Таблица Department
ALTER TABLE dbo.Department ADD IsActive BIT NOT NULL DEFAULT 1;

-- Таблица ExpenseType
ALTER TABLE dbo.ExpenseType ADD IsActive BIT NOT NULL DEFAULT 1;

-- Таблица Employee
ALTER TABLE dbo.Employee ADD IsActive BIT NOT NULL DEFAULT 1;

-- Таблица ExpenseLimit
ALTER TABLE dbo.ExpenseLimit ADD IsActive BIT NOT NULL DEFAULT 1;

-- Таблица Purchase
ALTER TABLE dbo.Purchase ADD IsActive BIT NOT NULL DEFAULT 1;

-- Таблица EmployeePosition
ALTER TABLE dbo.EmployeePosition ADD IsActive BIT NOT NULL DEFAULT 1;




--Заполнение БД (01.01.2022)

-- Таблица Department
INSERT INTO dbo.Department (DepartmentName, EmployeeQuantity) VALUES
('Кадры', 5),
('Финансы', 7),
('IT', 12),
('Маркетинг', 6),
('Продажи', 8),
('Логистика', 4),
('Поддержка', 5),
('Юридический отдел', 3),
('НИОКР', 9),
('Операционный отдел', 10),
('Дизайн', 4),
('Тестирование', 6),
('Закупки', 3),
('Администрация', 2),
('Охрана', 4),
('Обслуживание', 5),
('Снабжение', 6),
('Переводы', 2),
('Обучение', 3),
('Консалтинг', 2),
('Уборка', 2),
('Безопасность', 2),
('Аналитика', 6),
('Планирование', 3),
('Производство', 10),
('Архив', 1),
('Связи с общественностью', 2),
('Доставка', 3),
('Склад', 4),
('Контроль качества', 3);


--Таблица Employee
INSERT INTO dbo.Employee (Lastname, Middlename, Name) VALUES
('Иванов', 'Иванович', 'Пётр'),
('Петрова', 'Сергеевна', 'Анна'),
('Смирнов', 'Андреевич', 'Максим'),
('Волкова', 'Петровна', 'Елена'),
('Сидоров', 'Владимирович', 'Дмитрий'),
('Кузнецова', 'Ивановна', 'Мария'),
('Попов', 'Алексеевич', 'Кирилл'),
('Лебедева', 'Михайловна', 'Светлана'),
('Михайлов', 'Олегович', 'Олег'),
('Николаева', 'Сергеевна', 'Ирина'),
('Егоров', 'Антонович', 'Роман'),
('Павлова', 'Дмитриевна', 'Юлия'),
('Васильев', 'Николаевич', 'Николай'),
('Сорокина', 'Игоревна', 'Полина'),
('Фёдоров', 'Владимирович', 'Денис'),
('Орлова', 'Валерьевна', 'Алиса'),
('Новиков', 'Степанович', 'Александр'),
('Морозова', 'Львовна', 'Наталья'),
('Белов', 'Юрьевич', 'Сергей'),
('Калинина', 'Александровна', 'Татьяна'),
('Григорьев', 'Фёдорович', 'Лев'),
('Макарова', 'Валентиновна', 'Дарья'),
('Зайцев', 'Алексеевич', 'Евгений'),
('Медведева', 'Григорьевна', 'Вероника'),
('Козлов', 'Ильич', 'Илья'),
('Киселёва', 'Владимировна', 'Кристина'),
('Андреев', 'Андреевич', 'Аркадий'),
('Романова', 'Никитична', 'Оксана'),
('Семенов', 'Матвеевич', 'Матвей'),
('Дементьева', 'Павловна', 'Алина');


--таблица ExpenseType
INSERT INTO dbo.ExpenseType (ExpenseTypeName, Description) VALUES
('Канцелярия', 'Расходы на канцтовары'),
('Транспорт', 'Проезд и доставка'),
('ПО', 'Покупка программного обеспечения'),
('Оборудование', 'Покупка техники'),
('Питание', 'Корпоративное питание'),
('Реклама', 'Рекламные расходы'),
('ЮрУслуги', 'Услуги юристов'),
('Консалтинг', 'Консультационные услуги'),
('Обучение', 'Повышение квалификации'),
('Командировки', 'Поездки сотрудников'),
('Обслуживание', 'Обслуживание оборудования'),
('Уборка', 'Услуги по уборке'),
('Охрана', 'Физическая охрана'),
('Подписки', 'Сервисы и лицензии'),
('HR-услуги', 'Аутсорсинг HR'),
('Переводы', 'Языковой перевод'),
('Мероприятия', 'Организация ивентов'),
('Связь', 'Мобильная и интернет-связь'),
('Почта', 'Почтовые расходы'),
('Аренда', 'Аренда помещений'),
('Хозтовары', 'Хозяйственные нужды'),
('Мебель', 'Приобретение мебели'),
('Логистика', 'Складские и доставочные расходы'),
('Налоги', 'Налоговые выплаты'),
('Сервис', 'Технический сервис'),
('Бухучет', 'Услуги бухгалтеров'),
('Архив', 'Услуги по архивированию'),
('Маркетинг', 'Маркетинговые исследования'),
('PR', 'Связи с общественностью'),
('Дизайн', 'Услуги дизайнеров');

--Таблица ExpenseLimit
INSERT INTO dbo.ExpenseLimit (DepartmentID, ExpenseTypeID, DataLimit, MaxPayment) VALUES
(1, 1, '2022-01-01', 3000.00),
(2, 3, '2022-01-01', 8000.00),
(3, 4, '2022-01-01', 15000.00),
(4, 6, '2022-01-01', 12000.00),
(5, 10, '2022-01-01', 10000.00),
(6, 2, '2022-01-01', 7000.00),
(7, 5, '2022-01-01', 4000.00),
(8, 7, '2022-01-01', 9000.00),
(9, 14, '2022-01-01', 11000.00),
(10, 11, '2022-01-01', 9500.00),
(11, 3, '2022-01-01', 5000.00),
(12, 12, '2022-01-01', 3000.00),
(13, 1, '2022-01-01', 3500.00),
(1, 9, '2022-01-01', 6000.00),
(2, 8, '2022-01-01', 7000.00),
(3, 14, '2022-01-01', 4500.00),
(4, 10, '2022-01-01', 8000.00),
(5, 4, '2022-01-01', 9000.00),
(6, 11, '2022-01-01', 4000.00),
(7, 12, '2022-01-01', 3200.00),
(8, 13, '2022-01-01', 8700.00),
(9, 3, '2022-01-01', 10000.00),
(10, 5, '2022-01-01', 4300.00),
(11, 1, '2022-01-01', 2700.00),
(12, 9, '2022-01-01', 5200.00),
(13, 2, '2022-01-01', 6100.00),
(1, 5, '2022-01-01', 3900.00),
(2, 14, '2022-01-01', 7200.00),
(3, 12, '2022-01-01', 2100.00),
(4, 7, '2022-01-01', 6400.00);


-- Таблица Purchase

INSERT INTO dbo.Purchase (EmployeeID, LimitID, PurchaseData, PurchaseSum) VALUES
(1, 1, '2022-01-06', 1200.00),
(2, 2, '2022-01-06', 2300.00),
(3, 3, '2022-01-06', 4500.00),
(4, 4, '2022-01-06', 3200.00),
(5, 5, '2022-01-06', 2800.00),
(6, 6, '2022-01-06', 1700.00),
(7, 7, '2022-01-06', 1400.00),
(8, 8, '2022-01-06', 3000.00),
(9, 9, '2022-01-06', 2500.00),
(10, 10, '2022-01-06', 1800.00),
(11, 11, '2022-01-06', 2100.00),
(12, 12, '2022-01-06', 1000.00),
(13, 13, '2022-01-06', 1800.00),
(14, 14, '2022-01-06', 2200.00),
(15, 15, '2022-01-06', 2700.00),
(16, 16, '2022-01-06', 1900.00),
(17, 17, '2022-01-06', 2000.00),
(18, 18, '2022-01-06', 3000.00),
(19, 19, '2022-01-06', 1700.00),
(20, 20, '2022-01-06', 1000.00),
(21, 21, '2022-01-06', 2600.00),
(22, 22, '2022-01-06', 3100.00),
(23, 23, '2022-01-06', 1300.00),
(24, 24, '2022-01-06', 1600.00),
(25, 25, '2022-01-06', 2400.00),
(26, 26, '2022-01-06', 2800.00),
(27, 27, '2022-01-06', 1500.00),
(28, 28, '2022-01-06', 2700.00),
(29, 29, '2022-01-06', 1000.00),
(30, 30, '2022-01-06', 3100.00);


--Тбалица EmployeePosition

INSERT INTO dbo.EmployeePosition (DepartmentID, PositionCode, EmployeeID) VALUES
(1, 'Директор', 1),
(2, 'Бухгалтер', 2),
(3, 'Системный администратор', 3),
(4, 'Маркетолог', 4),
(5, 'Менеджер по продажам', 5),
(6, 'Логист', 6),
(7, 'Оператор поддержки', 7),
(8, 'Юрист', 8),
(9, 'Инженер-исследователь', 9),
(10, 'Менеджер по операциям', 10),
(11, 'Дизайнер', 11),
(12, 'Тестировщик', 12),
(13, 'Закупщик', 13),
(14, 'Администратор офиса', 14),
(15, 'Охранник', 15),
(1, 'HR-менеджер', 16),
(2, 'Финансовый аналитик', 17),
(3, 'Разработчик ПО', 18),
(4, 'Контент-менеджер', 19),
(5, 'Региональный менеджер', 20),
(6, 'Специалист по доставке', 21),
(7, 'Служба поддержки', 22),
(8, 'Нотариус', 23),
(9, 'Аналитик данных', 24),
(10, 'Операционный директор', 25),
(11, 'UI/UX дизайнер', 26),
(12, 'Инженер по качеству', 27),
(13, 'Специалист по закупкам', 28),
(14, 'Ресепшионист', 29),
(15, 'Начальник службы безопасности', 30);








-----------------------------------------------------------------------
--Изменения на:
-- 01.02.2022


-- ДОБАВЛЕНИЯ
INSERT INTO dbo.Employee (Lastname, Middlename, Name)
VALUES ('Широкова', 'Ивановна', 'Алиса');

INSERT INTO dbo.Purchase (EmployeeID, LimitID, PurchaseData, PurchaseSum)
VALUES (2, 6, '2022-02-18', 2400.00);



INSERT INTO dbo.Employee (Lastname, Middlename, Name)
VALUES ('Громова', 'Дмитриевна', 'Марина');


INSERT INTO dbo.ExpenseLimit (DepartmentID, ExpenseTypeID, DataLimit, MaxPayment)
VALUES (1, 15, '2022-02-01', 6500.00);

INSERT INTO dbo.Purchase (EmployeeID, LimitID, PurchaseData, PurchaseSum)
VALUES (1, 5, '2022-02-10', 1600.00);

INSERT INTO dbo.EmployeePosition (DepartmentID, PositionCode, EmployeeID)
VALUES (5, 'Юрист', 15);


-- ОБНОВЛЕНИЯ
UPDATE dbo.Employee
SET Middlename = 'Ильинична'
WHERE Name = 'Юлия' AND Lastname = 'Павлова';

UPDATE dbo.ExpenseLimit
SET MaxPayment = 7800.00
WHERE LimitID = 3;

UPDATE dbo.Purchase
SET PurchaseSum = 2700.00
WHERE PurchaseID = 3;

UPDATE dbo.EmployeePosition
SET PositionCode = 'Специалист'
WHERE PositionID = 3;

UPDATE dbo.Employee
SET Lastname = 'Фёдоров'
WHERE EmployeeID = 14;


-- УДАЛЕНИЯ 
DELETE FROM dbo.Purchase WHERE PurchaseID = 36;


DELETE FROM dbo.EmployeePosition
WHERE PositionID = 30;

DELETE FROM dbo.ExpenseType
WHERE ExpenseTypeID = 30;

DELETE FROM dbo.ExpenseLimit
WHERE LimitID = 34;







-----------------------------------------------------------------------
-- 01.03.2022

-- ДОБАВЛЕНИЯ
INSERT INTO dbo.Employee (Lastname, Middlename, Name)
VALUES ('Крылов', 'Сергеевич', 'Алексей');

INSERT INTO dbo.Purchase (EmployeeID, LimitID, PurchaseData, PurchaseSum)
VALUES (3, 7, '2022-03-28', 2600.00);




INSERT INTO dbo.Employee (Lastname, Middlename, Name)
VALUES ('Мельникова', 'Олеговна', 'Татьяна');


INSERT INTO dbo.ExpenseLimit (DepartmentID, ExpenseTypeID, DataLimit, MaxPayment)
VALUES (2, 16, '2022-03-01', 8500.00);

INSERT INTO dbo.Purchase (EmployeeID, LimitID, PurchaseData, PurchaseSum)
VALUES (2, 6, '2022-03-15', 3000.00);

INSERT INTO dbo.EmployeePosition (DepartmentID, PositionCode, EmployeeID)
VALUES (6, 'Бухгалтер', 16);


-- ОБНОВЛЕНИЯ
UPDATE dbo.Employee
SET Middlename = 'Сергеевна'
WHERE EmployeeID = 5;

UPDATE dbo.ExpenseLimit
SET MaxPayment = 9900.00
WHERE LimitID = 5;

UPDATE dbo.Purchase
SET PurchaseSum = 1950.00
WHERE PurchaseID = 5;

UPDATE dbo.EmployeePosition
SET PositionCode = 'Менеджер'
WHERE PositionID = 6;

UPDATE dbo.Employee
SET Lastname = 'Зайцева'
WHERE EmployeeID = 6;


-- УДАЛЕНИЯ
DELETE FROM dbo.Purchase WHERE PurchaseID = 35;


DELETE FROM dbo.EmployeePosition
WHERE PositionID = 31;

DELETE FROM dbo.ExpenseType
WHERE ExpenseTypeID = 29;

DELETE FROM dbo.ExpenseLimit
WHERE LimitID = 33;



-- ПРОСМОТР ИСТОРИИ
SELECT * FROM dbo.EmployeeHistory;
SELECT * FROM dbo.ExpenseTypeHistory;
SELECT * FROM dbo.ExpenseLimitHistory;
SELECT * FROM dbo.PurchaseHistory;
SELECT * FROM dbo.EmployeePositionHistory;




-----------------------------------------------------------------------
-- 01.04.2022

-- ДОБАВЛЕНИЯ
INSERT INTO dbo.Employee (Lastname, Middlename, Name)
VALUES ('Назаров', 'Анатольевич', 'Дмитрий');


INSERT INTO dbo.Employee (Lastname, Middlename, Name)
VALUES ('Гаврилов', 'Игоревич', 'Павел');


INSERT INTO dbo.ExpenseLimit (DepartmentID, ExpenseTypeID, DataLimit, MaxPayment)
VALUES (3, 17, '2022-04-01', 4000.00);

INSERT INTO dbo.Purchase (EmployeeID, LimitID, PurchaseData, PurchaseSum)
VALUES (3, 7, '2022-04-12', 1100.00);

INSERT INTO dbo.EmployeePosition (DepartmentID, PositionCode, EmployeeID)
VALUES (3, 'Куратор', 17);


-- ОБНОВЛЕНИЯ
UPDATE dbo.Employee
SET Middlename = 'Алексеевна'
WHERE EmployeeID = 4;

UPDATE dbo.ExpenseLimit
SET MaxPayment = 10000.00
WHERE LimitID = 6;

UPDATE dbo.Purchase
SET PurchaseSum = 3800.00
WHERE PurchaseID = 6;

UPDATE dbo.EmployeePosition
SET PositionCode = 'Консультант'
WHERE PositionID = 4;

UPDATE dbo.Employee
SET Lastname = 'Соловьёв'
WHERE EmployeeID = 3;


-- УДАЛЕНИЯ
DELETE FROM dbo.Purchase WHERE PurchaseID = 34;


DELETE FROM dbo.EmployeePosition
WHERE PositionID = 32;

DELETE FROM dbo.ExpenseType
WHERE ExpenseTypeID = 28;

DELETE FROM dbo.ExpenseLimit
WHERE LimitID = 32;



-- ПРОСМОТР ИСТОРИИ
SELECT * FROM dbo.EmployeeHistory;
SELECT * FROM dbo.ExpenseTypeHistory;
SELECT * FROM dbo.ExpenseLimitHistory;
SELECT * FROM dbo.PurchaseHistory;
SELECT * FROM dbo.EmployeePositionHistory;




-----------------------------------------------------------------------
-- 01.05.2022

-- ДОБАВЛЕНИЯ
INSERT INTO dbo.Employee (Lastname, Middlename, Name)
VALUES ('Белякова', 'Николаевна', 'Людмила');


INSERT INTO dbo.Employee (Lastname, Middlename, Name)
VALUES ('Данилова', 'Романовна', 'Ирина');

INSERT INTO dbo.ExpenseType (ExpenseTypeName, Description)
VALUES ('Маркетинговые исследования', 'Анализ рынка и целевой аудитории');

INSERT INTO dbo.ExpenseLimit (DepartmentID, ExpenseTypeID, DataLimit, MaxPayment)
VALUES (4, 18, '2022-05-01', 7200.00);

INSERT INTO dbo.Purchase (EmployeeID, LimitID, PurchaseData, PurchaseSum)
VALUES (4, 8, '2022-05-08', 3100.00);

INSERT INTO dbo.EmployeePosition (DepartmentID, PositionCode, EmployeeID)
VALUES (4, 'Аналитик', 18);


-- ОБНОВЛЕНИЯ
UPDATE dbo.Employee
SET Middlename = 'Андреевна'
WHERE EmployeeID = 2;

UPDATE dbo.ExpenseLimit
SET MaxPayment = 4600.00
WHERE LimitID = 2;

UPDATE dbo.Purchase
SET PurchaseSum = 1850.00
WHERE PurchaseID = 2;

UPDATE dbo.EmployeePosition
SET PositionCode = 'Ассистент'
WHERE PositionID = 2;

UPDATE dbo.Employee
SET Lastname = 'Петрова'
WHERE EmployeeID = 1;


-- УДАЛЕНИЯ
DELETE FROM dbo.Purchase WHERE PurchaseID = 33;


DELETE FROM dbo.EmployeePosition
WHERE PositionID = 33;

DELETE FROM dbo.ExpenseType
WHERE ExpenseTypeID = 27;

DELETE FROM dbo.ExpenseLimit
WHERE LimitID = 31;



-- ПРОСМОТР ИСТОРИИ
SELECT * FROM dbo.EmployeeHistory;
SELECT * FROM dbo.ExpenseTypeHistory;
SELECT * FROM dbo.ExpenseLimitHistory;
SELECT * FROM dbo.PurchaseHistory;
SELECT * FROM dbo.EmployeePositionHistory;




-----------------------------------------------------------------------
-- 01.06.2022

-- ДОБАВЛЕНИЯ
INSERT INTO dbo.Employee (Lastname, Middlename, Name)
VALUES ('Яковлев', 'Михайлович', 'Артём');
INSERT INTO dbo.Employee (Lastname, Middlename, Name)
VALUES ('Прокофьев', 'Алексеевич', 'Матвей');




INSERT INTO dbo.ExpenseLimit (DepartmentID, ExpenseTypeID, DataLimit, MaxPayment)
VALUES (5, 19, '2022-06-01', 5500.00);

INSERT INTO dbo.Purchase (EmployeeID, LimitID, PurchaseData, PurchaseSum)
VALUES (5, 9, '2022-06-10', 1600.00);

INSERT INTO dbo.EmployeePosition (DepartmentID, PositionCode, EmployeeID)
VALUES (5, 'Старший менеджер', 19);


-- ОБНОВЛЕНИЯ
UPDATE dbo.Employee
SET Middlename = 'Артемович'
WHERE EmployeeID = 6;

UPDATE dbo.ExpenseLimit
SET MaxPayment = 7700.00
WHERE LimitID = 7;

UPDATE dbo.Purchase
SET PurchaseSum = 2100.00
WHERE PurchaseID = 7;

UPDATE dbo.EmployeePosition
SET PositionCode = 'Эксперт'
WHERE PositionID = 7;

UPDATE dbo.Employee
SET Lastname = 'Николаев'
WHERE EmployeeID = 7;


-- УДАЛЕНИЯ
DELETE FROM dbo.EmployeePosition
WHERE PositionID = 34;

DELETE FROM dbo.ExpenseType
WHERE ExpenseTypeID = 26;

DELETE FROM dbo.Purchase WHERE PurchaseID = 32;


-- ПРОСМОТР ИСТОРИИ
SELECT * FROM dbo.EmployeeHistory;
SELECT * FROM dbo.ExpenseTypeHistory;
SELECT * FROM dbo.ExpenseLimitHistory;
SELECT * FROM dbo.PurchaseHistory;
SELECT * FROM dbo.EmployeePositionHistory;





-----------------------------------------------------------------------
-- 01.07.2022

-- ДОБАВЛЕНИЯ
INSERT INTO dbo.Employee (Lastname, Middlename, Name)
VALUES ('Крылов', 'Сергеевич', 'Алексей');
INSERT INTO dbo.Employee (Lastname, Middlename, Name)
VALUES ('Чесноков', 'Георгиевич', 'Руслан');

INSERT INTO dbo.Purchase (EmployeeID, LimitID, PurchaseData, PurchaseSum)
VALUES (3, 7, '2022-07-28', 2600.00);
INSERT INTO dbo.Employee (Lastname, Middlename, Name)
VALUES ('Синицын', 'Евгеньевич', 'Лев');


INSERT INTO dbo.ExpenseLimit (DepartmentID, ExpenseTypeID, DataLimit, MaxPayment)
VALUES (6, 20, '2022-07-01', 6300.00);

INSERT INTO dbo.Purchase (EmployeeID, LimitID, PurchaseData, PurchaseSum)
VALUES (6, 10, '2022-07-11', 3000.00);

INSERT INTO dbo.EmployeePosition (DepartmentID, PositionCode, EmployeeID)
VALUES (6, 'Специалист', 20);


-- ОБНОВЛЕНИЯ
UPDATE dbo.Employee
SET Middlename = 'Викторовна'
WHERE EmployeeID = 8;

UPDATE dbo.ExpenseLimit
SET MaxPayment = 5100.00
WHERE LimitID = 8;

UPDATE dbo.Purchase
SET PurchaseSum = 1750.00
WHERE PurchaseID = 8;

UPDATE dbo.EmployeePosition
SET PositionCode = 'HR-менеджер'
WHERE PositionID = 8;

UPDATE dbo.Employee
SET Lastname = 'Козлова'
WHERE EmployeeID = 9;


-- УДАЛЕНИЯ
DELETE FROM dbo.EmployeePosition
WHERE PositionID = 35;

DELETE FROM dbo.ExpenseType
WHERE ExpenseTypeID = 25;

DELETE FROM dbo.Purchase WHERE PurchaseID = 31;


-- ПРОСМОТР ИСТОРИИ
SELECT * FROM dbo.EmployeeHistory;
SELECT * FROM dbo.ExpenseTypeHistory;
SELECT * FROM dbo.ExpenseLimitHistory;
SELECT * FROM dbo.PurchaseHistory;
SELECT * FROM dbo.EmployeePositionHistory;





-----------------------------------------------------------------------
-- 01.08.2022

-- ДОБАВЛЕНИЯ
INSERT INTO dbo.Employee (Lastname, Middlename, Name)
VALUES ('Корнеев', 'Геннадьевич', 'Евгений');



INSERT INTO dbo.ExpenseLimit (DepartmentID, ExpenseTypeID, DataLimit, MaxPayment)
VALUES (7, 21, '2022-08-01', 7900.00);

INSERT INTO dbo.Purchase (EmployeeID, LimitID, PurchaseData, PurchaseSum)
VALUES (7, 11, '2022-08-12', 3300.00);

INSERT INTO dbo.EmployeePosition (DepartmentID, PositionCode, EmployeeID)
VALUES (7, 'Стажёр', 21);
INSERT INTO dbo.Employee (Lastname, Middlename, Name)
VALUES ('Фомина', 'Александровна', 'Инна');

-- ОБНОВЛЕНИЯ
UPDATE dbo.Employee
SET Middlename = 'Георгиевич'
WHERE EmployeeID = 10;

UPDATE dbo.ExpenseLimit
SET MaxPayment = 6900.00
WHERE LimitID = 9;

UPDATE dbo.Purchase
SET PurchaseSum = 2400.00
WHERE PurchaseID = 9;

UPDATE dbo.EmployeePosition
SET PositionCode = 'Backend-разработчик'
WHERE PositionID = 9;

UPDATE dbo.Employee
SET Lastname = 'Мельник'
WHERE EmployeeID = 11;


-- УДАЛЕНИЯ
DELETE FROM dbo.EmployeePosition
WHERE PositionID = 36;

DELETE FROM dbo.ExpenseType
WHERE ExpenseTypeID = 24;

DELETE FROM dbo.Purchase WHERE PurchaseID = 30;


-- ПРОСМОТР ИСТОРИИ
SELECT * FROM dbo.EmployeeHistory;
SELECT * FROM dbo.ExpenseTypeHistory;
SELECT * FROM dbo.ExpenseLimitHistory;
SELECT * FROM dbo.PurchaseHistory;
SELECT * FROM dbo.EmployeePositionHistory;





-----------------------------------------------------------------------
-- 01.09.2022

-- ДОБАВЛЕНИЯ
INSERT INTO dbo.Employee (Lastname, Middlename, Name)
VALUES ('Тимофеев', 'Сергеевич', 'Вадим');

INSERT INTO dbo.Employee (Lastname, Middlename, Name)
VALUES ('Маслов', 'Григорьевич', 'Константин');
INSERT INTO dbo.ExpenseLimit (DepartmentID, ExpenseTypeID, DataLimit, MaxPayment)
VALUES (8, 22, '2022-09-01', 8700.00);

INSERT INTO dbo.Purchase (EmployeeID, LimitID, PurchaseData, PurchaseSum)
VALUES (8, 12, '2022-09-15', 3100.00);

INSERT INTO dbo.EmployeePosition (DepartmentID, PositionCode, EmployeeID)
VALUES (8, 'Аналитик', 22);


-- ОБНОВЛЕНИЯ
UPDATE dbo.Employee
SET Middlename = 'Фёдорович'
WHERE EmployeeID = 12;

UPDATE dbo.ExpenseLimit
SET MaxPayment = 7100.00
WHERE LimitID = 10;

UPDATE dbo.Purchase
SET PurchaseSum = 2000.00
WHERE PurchaseID = 10;

UPDATE dbo.EmployeePosition
SET PositionCode = 'Руководитель проектов'
WHERE PositionID = 10;

UPDATE dbo.Employee
SET Lastname = 'Громов'
WHERE EmployeeID = 13;


-- УДАЛЕНИЯ
DELETE FROM dbo.EmployeePosition
WHERE PositionID = 37;

DELETE FROM dbo.Purchase WHERE PurchaseID = 29;
DELETE FROM dbo.EmployeePosition WHERE PositionID = 41;

-- ПРОСМОТР ИСТОРИИ
SELECT * FROM dbo.EmployeeHistory;
SELECT * FROM dbo.ExpenseTypeHistory;
SELECT * FROM dbo.ExpenseLimitHistory;
SELECT * FROM dbo.PurchaseHistory;
SELECT * FROM dbo.EmployeePositionHistory;




-----------------------------------------------------------------------
-- 01.10.2022

-- ДОБАВЛЕНИЯ
INSERT INTO dbo.EmployeePosition (DepartmentID, PositionCode, EmployeeID)
VALUES (8, 'Аналитик', 22);

INSERT INTO dbo.Employee (Lastname, Middlename, Name)
VALUES ('Рябова', 'Никитична', 'Алёна');

INSERT INTO dbo.Employee (Lastname, Middlename, Name)
VALUES ('Терентьев', 'Владиславович', 'Артур');

INSERT INTO dbo.Purchase (EmployeeID, LimitID, PurchaseData, PurchaseSum)
VALUES (9, 13, '2022-10-18', 2800.00);

INSERT INTO dbo.EmployeePosition (DepartmentID, PositionCode, EmployeeID)
VALUES (9, 'Координатор', 23);


-- ОБНОВЛЕНИЯ
UPDATE dbo.Employee
SET Middlename = 'Валентинович'
WHERE EmployeeID = 14;

UPDATE dbo.ExpenseLimit
SET MaxPayment = 6900.00
WHERE LimitID = 11;

UPDATE dbo.Purchase
SET PurchaseSum = 2100.00
WHERE PurchaseID = 11;

UPDATE dbo.EmployeePosition
SET PositionCode = 'Scrum-мастер'
WHERE PositionID = 11;

UPDATE dbo.Employee
SET Lastname = 'Соловьёв'
WHERE EmployeeID = 15;


-- УДАЛЕНИЯ
DELETE FROM dbo.EmployeePosition
WHERE PositionID = 38;
DELETE FROM dbo.EmployeePosition
WHERE PositionID = 37;

DELETE FROM dbo.Purchase WHERE PurchaseID = 28;

-- ПРОСМОТР ИСТОРИИ
SELECT * FROM dbo.EmployeeHistory;
SELECT * FROM dbo.ExpenseTypeHistory;
SELECT * FROM dbo.ExpenseLimitHistory;
SELECT * FROM dbo.PurchaseHistory;
SELECT * FROM dbo.EmployeePositionHistory;






-- 01.11.2022

-- ДОБАВЛЕНИЯ
INSERT INTO dbo.Employee (Lastname, Middlename, Name)
VALUES ('Савина', 'Олеговна', 'Марина');

INSERT INTO dbo.Employee (Lastname, Middlename, Name)
VALUES ('Кузнецова', 'Михайловна', 'Олеся');

INSERT INTO dbo.EmployeePosition (DepartmentID, PositionCode, EmployeeID)
VALUES (2, 'Ассистент', 26);
INSERT INTO dbo.Purchase (EmployeeID, LimitID, PurchaseData, PurchaseSum)
VALUES (10, 14, '2022-11-12', 2600.00);

INSERT INTO dbo.EmployeePosition (DepartmentID, PositionCode, EmployeeID)
VALUES (10, 'Бухгалтер', 24);


-- ОБНОВЛЕНИЯ
UPDATE dbo.Employee
SET Middlename = 'Константиновна'
WHERE EmployeeID = 16;

UPDATE dbo.ExpenseLimit
SET MaxPayment = 7600.00
WHERE LimitID = 12;

UPDATE dbo.Purchase
SET PurchaseSum = 2900.00
WHERE PurchaseID = 12;

UPDATE dbo.EmployeePosition
SET PositionCode = 'UX-дизайнер'
WHERE PositionID = 12;

UPDATE dbo.Employee
SET Lastname = 'Орлова'
WHERE EmployeeID = 17;


-- УДАЛЕНИЯ
DELETE FROM dbo.EmployeePosition
WHERE PositionID = 39;
DELETE FROM dbo.Purchase WHERE PurchaseID = 27;
DELETE FROM dbo.EmployeePosition WHERE PositionID = 42;

-- ПРОСМОТР ИСТОРИИ
SELECT * FROM dbo.EmployeeHistory;
SELECT * FROM dbo.ExpenseTypeHistory;
SELECT * FROM dbo.ExpenseLimitHistory;
SELECT * FROM dbo.PurchaseHistory;
SELECT * FROM dbo.EmployeePositionHistory;






-- 01.12.2022

-- ДОБАВЛЕНИЯ
INSERT INTO dbo.Employee (Lastname, Middlename, Name)
VALUES ('Григорьев', 'Львович', 'Александр');

INSERT INTO dbo.Purchase (EmployeeID, LimitID, PurchaseData, PurchaseSum)
VALUES (11, 15, '2022-12-10', 3500.00);

INSERT INTO dbo.EmployeePosition (DepartmentID, PositionCode, EmployeeID)
VALUES (11, 'Медицинский инспектор', 25);
INSERT INTO dbo.Employee (Lastname, Middlename, Name)
VALUES ('Игнатова', 'Всеволодовна', 'Злата');

INSERT INTO dbo.EmployeePosition (DepartmentID, PositionCode, EmployeeID)
VALUES (3, 'HR', 27);

-- ОБНОВЛЕНИЯ
UPDATE dbo.Employee
SET Middlename = 'Олегович'
WHERE EmployeeID = 18;

UPDATE dbo.ExpenseLimit
SET MaxPayment = 8700.00
WHERE LimitID = 13;

UPDATE dbo.Purchase
SET PurchaseSum = 1900.00
WHERE PurchaseID = 13;

UPDATE dbo.EmployeePosition
SET PositionCode = 'Руководитель отдела'
WHERE PositionID = 13;

UPDATE dbo.Employee
SET Lastname = 'Миронов'
WHERE EmployeeID = 19;


-- УДАЛЕНИЯ
DELETE FROM dbo.EmployeePosition
WHERE PositionID = 40;
DELETE FROM dbo.Purchase WHERE PurchaseID = 26;
DELETE FROM dbo.EmployeePosition WHERE PositionID = 43;
-- ПРОСМОТР ИСТОРИИ
SELECT * FROM dbo.EmployeeHistory;
SELECT * FROM dbo.ExpenseTypeHistory;
SELECT * FROM dbo.ExpenseLimitHistory;
SELECT * FROM dbo.PurchaseHistory;
SELECT * FROM dbo.EmployeePositionHistory;
