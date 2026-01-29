-- Создаем базу данных
USE master;
GO
DROP DATABASE IF EXISTS OfficeExpenses;
GO
CREATE DATABASE OfficeExpenses;
GO
USE OfficeExpenses;
GO

-- Таблица "Department" (Отдел)
CREATE TABLE Department (
    DepartmentName nvarchar(50) NOT NULL PRIMARY KEY,
    EmployeeCount int NOT NULL CHECK (EmployeeCount >= 0)
);
GO

-- Таблица "ExpenseType" (Вид расхода)
CREATE TABLE ExpenseType (
    ExpenseTypeName nvarchar(50) NOT NULL PRIMARY KEY,
    Description nvarchar(50) NULL
);
GO

-- Таблица "Employee" (Сотрудник)
CREATE TABLE Employee (
    EmployeeID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    LastName nvarchar(30) NOT NULL,
    FirstName nvarchar(30) NOT NULL,
    Patronymic nvarchar(30) NULL
);
GO

-- Таблица "EmployeeDepartment" (Связь сотрудника и отдела, M:N)
CREATE TABLE EmployeeDepartment (
    EmployeeID int NOT NULL,
    DepartmentName nvarchar(50) NOT NULL,
    JobTitle nvarchar(50) NOT NULL,
    PRIMARY KEY (EmployeeID, DepartmentName),
    CONSTRAINT FK_EmployeeDepartment_Employee FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    CONSTRAINT FK_EmployeeDepartment_Department FOREIGN KEY (DepartmentName) REFERENCES Department(DepartmentName)
);
GO

-- Таблица "ExpenseLimit" (Лимит расходов)
CREATE TABLE ExpenseLimit (
    ExpenseTypeName nvarchar(50) NOT NULL,
    DepartmentName nvarchar(50) NOT NULL,
    MonthYear date NOT NULL,
    MaxExpense money NOT NULL CHECK (MaxExpense > 0),
    PRIMARY KEY (ExpenseTypeName, DepartmentName, MonthYear),
    CONSTRAINT FK_ExpenseLimit_ExpenseType FOREIGN KEY (ExpenseTypeName) REFERENCES ExpenseType(ExpenseTypeName),
    CONSTRAINT FK_ExpenseLimit_Department FOREIGN KEY (DepartmentName) REFERENCES Department(DepartmentName)
);
GO

-- Таблица "Purchase" (Покупка)
CREATE TABLE Purchase (
    PurchaseID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    PurchaseDate date NOT NULL,
    Amount money NOT NULL CHECK (Amount > 0),
    ExpenseTypeName nvarchar(50) NOT NULL,
    EmployeeID int NOT NULL,
    DepartmentName nvarchar(50) NOT NULL,
    MonthYear date NOT NULL,
    CONSTRAINT FK_Purchase_ExpenseType FOREIGN KEY (ExpenseTypeName) REFERENCES ExpenseType(ExpenseTypeName),
    CONSTRAINT FK_Purchase_Employee FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    CONSTRAINT FK_Purchase_Department FOREIGN KEY (DepartmentName) REFERENCES Department(DepartmentName)
);
GO

-- Таблица "DepartmentExpense" (Расходы по отделу)
CREATE TABLE DepartmentExpense (
    PurchaseID int NOT NULL,
    ExpenseTypeName nvarchar(50) NOT NULL,
    DepartmentName nvarchar(50) NOT NULL, -- Исправлено: NOT NULL, чтобы работал PRIMARY KEY
    MonthYear date NOT NULL,
    EmployeeID int NOT NULL,
    EmployeeDepartmentName nvarchar(50) NOT NULL,
    PRIMARY KEY (PurchaseID, ExpenseTypeName, DepartmentName, MonthYear, EmployeeID, EmployeeDepartmentName),
    CONSTRAINT FK_DepartmentExpense_Purchase FOREIGN KEY (PurchaseID) REFERENCES Purchase(PurchaseID),
    CONSTRAINT FK_DepartmentExpense_ExpenseType FOREIGN KEY (ExpenseTypeName) REFERENCES ExpenseType(ExpenseTypeName),
    CONSTRAINT FK_DepartmentExpense_Department FOREIGN KEY (DepartmentName) REFERENCES Department(DepartmentName),
    CONSTRAINT FK_DepartmentExpense_ExpenseLimit FOREIGN KEY (ExpenseTypeName, DepartmentName, MonthYear) REFERENCES ExpenseLimit(ExpenseTypeName, DepartmentName, MonthYear),
    CONSTRAINT FK_DepartmentExpense_Employee FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    CONSTRAINT FK_DepartmentExpense_EmployeeDepartment FOREIGN KEY (EmployeeDepartmentName) REFERENCES Department(DepartmentName)
);
GO


-- Заполнение таблицы "Department" (Отдел)
INSERT INTO Department (DepartmentName, EmployeeCount) VALUES
(N'Отдел продаж', 15),
(N'Отдел маркетинга', 10),
(N'Отдел разработки', 20),
(N'Отдел бухгалтерии', 8),
(N'Отдел HR', 7),
(N'Отдел логистики', 12),
(N'Отдел закупок', 9),
(N'Отдел юридический', 6),
(N'Отдел поддержки клиентов', 11),
(N'Отдел IT', 14);

SELECT *
FROM Department; 
GO
-- Заполнение таблицы "ExpenseType" (Вид расхода)
INSERT INTO ExpenseType (ExpenseTypeName, Description) VALUES
(N'Канцелярия', N'Расходы на офисные принадлежности'),
(N'Обучение', N'Расходы на курсы и тренинги'),
(N'Командировки', N'Затраты на поездки сотрудников'),
(N'Оборудование', N'Покупка техники и инструментов'),
(N'Маркетинг', N'Рекламные кампании и исследования'),
(N'Связь', N'Оплата мобильной и интернет-связи'),
(N'Аренда', N'Оплата аренды офисных помещений'),
(N'Зарплата', N'Фонд оплаты труда'),
(N'IT-услуги', N'Разработка и обслуживание ПО'),
(N'Прочие', N'Другие расходы компании');
SELECT *
FROM ExpenseType; 
GO


-- Заполнение таблицы "Employee" (Сотрудник)
INSERT INTO Employee (LastName, FirstName, Patronymic) VALUES
(N'Иванов', N'Алексей', N'Сергеевич'),
(N'Петров', N'Дмитрий', N'Алексеевич'),
(N'Сидорова', N'Елена', N'Владимировна'),
(N'Васильев', N'Антон', N'Игоревич'),
(N'Морозова', N'Анна', N'Михайловна'),
(N'Козлов', N'Виктор', N'Олегович'),
(N'Захарова', N'Марина', N'Андреевна'),
(N'Смирнов', N'Игорь', N'Владимирович'),
(N'Тихонов', N'Сергей', N'Викторович'),
(N'Орлова', N'Татьяна', N'Анатольевна');
SELECT *
FROM Employee; 
GO
-- Заполнение таблицы "EmployeeDepartment" (Связь сотрудника и отдела)
INSERT INTO EmployeeDepartment (EmployeeID, DepartmentName, JobTitle) VALUES
(1, N'Отдел продаж', N'Менеджер по продажам'),
(2, N'Отдел маркетинга', N'Маркетолог'),
(3, N'Отдел разработки', N'Программист'),
(4, N'Отдел бухгалтерии', N'Бухгалтер'),
(5, N'Отдел HR', N'HR-специалист'),
(6, N'Отдел логистики', N'Логист'),
(7, N'Отдел закупок', N'Специалист по закупкам'),
(8, N'Отдел юридический', N'Юрист'),
(9, N'Отдел поддержки клиентов', N'Менеджер по работе с клиентами'),
(10, N'Отдел IT', N'Системный администратор');
SELECT *
FROM EmployeeDepartment; 
GO
-- Заполнение таблицы "ExpenseLimit" (Лимит расходов)
INSERT INTO ExpenseLimit (ExpenseTypeName, DepartmentName, MonthYear, MaxExpense) VALUES
(N'Канцелярия', N'Отдел продаж', '2025-03-01', 500.00),
(N'Обучение', N'Отдел маркетинга', '2025-03-01', 2000.00),
(N'Командировки', N'Отдел разработки', '2025-03-01', 5000.00),
(N'Оборудование', N'Отдел бухгалтерии', '2025-03-01', 3000.00),
(N'Маркетинг', N'Отдел HR', '2025-03-01', 1500.00),
(N'Связь', N'Отдел логистики', '2025-03-01', 800.00),
(N'Аренда', N'Отдел закупок', '2025-03-01', 10000.00),
(N'Зарплата', N'Отдел юридический', '2025-03-01', 50000.00),
(N'IT-услуги', N'Отдел IT', '2025-03-01', 7000.00),
(N'Прочие', N'Отдел поддержки клиентов', '2025-03-01', 1200.00);
SELECT *
FROM ExpenseLimit; 
GO
-- Заполнение таблицы "Purchase" (Покупки)
INSERT INTO Purchase (PurchaseDate, Amount, ExpenseTypeName, EmployeeID, DepartmentName, MonthYear) VALUES
('2025-03-05', 150.00, N'Канцелярия', 1, N'Отдел продаж', '2025-03-01'),
('2025-03-07', 300.00, N'Обучение', 2, N'Отдел маркетинга', '2025-03-01'),
('2025-03-10', 4500.00, N'Командировки', 3, N'Отдел разработки', '2025-03-01'),
('2025-03-12', 2800.00, N'Оборудование', 4, N'Отдел бухгалтерии', '2025-03-01'),
('2025-03-15', 1000.00, N'Маркетинг', 5, N'Отдел HR', '2025-03-01'),
('2025-03-18', 600.00, N'Связь', 6, N'Отдел логистики', '2025-03-01'),
('2025-03-20', 8500.00, N'Аренда', 7, N'Отдел закупок', '2025-03-01'),
('2025-03-22', 48000.00, N'Зарплата', 8, N'Отдел юридический', '2025-03-01'),
('2025-03-25', 5000.00, N'IT-услуги', 9, N'Отдел IT', '2025-03-01'),
('2025-03-28', 900.00, N'Прочие', 10, N'Отдел поддержки клиентов', '2025-03-01');
SELECT *
FROM Purchase; 
GO
-- Заполнение таблицы "DepartmentExpense" (Расходы по отделу)
INSERT INTO DepartmentExpense (PurchaseID, ExpenseTypeName, DepartmentName, MonthYear, EmployeeID, EmployeeDepartmentName) VALUES
(1, N'Канцелярия', N'Отдел продаж', '2025-03-01', 1, N'Отдел продаж'),
(2, N'Обучение', N'Отдел маркетинга', '2025-03-01', 2, N'Отдел маркетинга'),
(3, N'Командировки', N'Отдел разработки', '2025-03-01', 3, N'Отдел разработки'),
(4, N'Оборудование', N'Отдел бухгалтерии', '2025-03-01', 4, N'Отдел бухгалтерии'),
(5, N'Маркетинг', N'Отдел HR', '2025-03-01', 5, N'Отдел HR'),
(6, N'Связь', N'Отдел логистики', '2025-03-01', 6, N'Отдел логистики'),
(7, N'Аренда', N'Отдел закупок', '2025-03-01', 7, N'Отдел закупок'),
(8, N'Зарплата', N'Отдел юридический', '2025-03-01', 8, N'Отдел юридический'),
(9, N'IT-услуги', N'Отдел IT', '2025-03-01', 9, N'Отдел IT'),
(10, N'Прочие', N'Отдел поддержки клиентов', '2025-03-01', 10, N'Отдел поддержки клиентов');
SELECT *
FROM DepartmentExpense; 
GO

select *
from Department

INSERT INTO DepartmentExpense (PurchaseID, ExpenseTypeName, DepartmentName, MonthYear, EmployeeID, EmployeeDepartmentName)
VALUES (1, N'Несуществующий расход', N'Отдел продаж', '2024-03-01', 3, N'Менеджер');  
GO  

INSERT INTO DepartmentExpense (PurchaseID, ExpenseTypeName, DepartmentName, MonthYear, EmployeeID, EmployeeDepartmentName)
VALUES (1, N'Канцелярия', N'Отдел IT', '2024-03-01', 3, N'Менеджер');  
GO  

INSERT INTO DepartmentExpense (PurchaseID, ExpenseTypeName, DepartmentName, MonthYear, EmployeeID, EmployeeDepartmentName)
VALUES (5, N'Канцелярия', N'Отдел маркетинга', '2024-03-01', 2, N'Маркетолог');  
GO  
SELECT * FROM DepartmentExpense;  
GO  

INSERT INTO ExpenseType (ExpenseTypeName, Description)
VALUES 
    (N'Канцелярия', N'Офисные принадлежности'),
    (N'Обучение', N'Курсы и тренинги');
GO

SELECT * FROM ExpenseType;
