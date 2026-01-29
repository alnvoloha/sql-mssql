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

CREATE TABLE [Department]
(
 [PK_DepartmentName] Varchar(50) NOT NULL,
 [EmployeeQuantity] Int NOT NULL
)
go

-- Add keys for table Department

ALTER TABLE [Department] ADD CONSTRAINT [PK_DepartmentName] PRIMARY KEY ([PK_DepartmentName])
go

-- Table Purchase

CREATE TABLE [Purchase]
(
 [PK_IDEmployee] INT NOT NULL,
 [PK_DepartmentName] Varchar(50) NULL,
 [PK_ExpenseTypeName] Varchar(50) NULL,
 [DataLimit] Date NULL,
 [PK_IDPurchase] INT IDENTITY(1,1) NOT NULL,
 [PurchaseData] Date NOT NULL,
 [PurchaseSum] Decimal(19,4) NOT NULL
)
go

-- Create indexes for table Purchase

CREATE INDEX [IX_Relationship6] ON [Purchase] ([PK_DepartmentName],[PK_ExpenseTypeName],[DataLimit])
go

-- Add keys for table Purchase

ALTER TABLE [Purchase] ADD CONSTRAINT [PK_Purchase] PRIMARY KEY ([PK_IDEmployee],[PK_IDPurchase])
go



-- Table ExpenseType

CREATE TABLE [ExpenseType]
(
 [PK_ExpenseTypeName] Varchar(50)  NOT NULL,
 [Description] Varchar(100) NULL
)
go

-- Add keys for table ExpenseType

ALTER TABLE [ExpenseType] ADD CONSTRAINT [PK_ExpenseType] PRIMARY KEY ([PK_ExpenseTypeName])
go

-- Table Employee

CREATE TABLE [Employee]
(
 [PK_IDEmployee] INT IDENTITY(1,1) NOT NULL,
 [Lastname] Varchar(50) NULL,
 [Middlename] Varchar(50) NULL,
 [Name] Varchar(50) NULL
)
go

-- Add keys for table Employee

ALTER TABLE [Employee] ADD CONSTRAINT [PK_Employee] PRIMARY KEY ([PK_IDEmployee])
go



-- Table ExpenseLimit

CREATE TABLE [ExpenseLimit]
(
 [PK_DepartmentName] Varchar(50) NOT NULL,
 [PK_ExpenseTypeName] Varchar(50) NOT NULL,
 [DataLimit] Date NOT NULL,
 [MaxPayment] Decimal(19,4) NOT NULL
)
go

-- Add keys for table ExpenseLimit

ALTER TABLE [ExpenseLimit] ADD CONSTRAINT [PK_ExpenseLimit] PRIMARY KEY ([PK_DepartmentName],[PK_ExpenseTypeName],[DataLimit])
go

-- Table EmployeePosition
DROP TABLE IF EXISTS [EmployeePosition];

CREATE TABLE [EmployeePosition]
(
 [PK_DepartmentName] Varchar(50) NOT NULL,
 [Название должности] Char(1) NOT NULL,
 [PK_IDEmployee] INT NOT NULL
)
go

-- Create indexes for table EmployeePosition

CREATE INDEX [IX_WorkIn] ON [EmployeePosition] ([PK_IDEmployee])
go

-- Add keys for table EmployeePosition

ALTER TABLE [EmployeePosition] ADD CONSTRAINT [PK_EmployeePosition] PRIMARY KEY ([PK_DepartmentName],[Название должности])
go

-- Table DepartmentExpenses

CREATE TABLE [DepartmentExpenses]
(
 [PK_DepartmentName] Varchar(50) NOT NULL,
 [PK_ExpenseTypeName] Varchar(50) NOT NULL,
 [PK_IDEmployee] INT NOT NULL,
 [DataLimit] Date NOT NULL,
 [Attribute1] INT NOT NULL,
 [Remains] Decimal(19,4) NULL
)
go

-- Add keys for table DepartmentExpenses

ALTER TABLE [DepartmentExpenses] ADD CONSTRAINT [PK_DepartmentExpenses] PRIMARY KEY ([PK_DepartmentName],[PK_ExpenseTypeName],[PK_IDEmployee],[DataLimit],[Attribute1])
go

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



ALTER TABLE [DepartmentExpenses] ADD CONSTRAINT [IntroducedIn] FOREIGN KEY ([PK_IDEmployee], [Attribute1]) REFERENCES [Purchase] ([PK_IDEmployee], [PK_IDPurchase]) ON UPDATE NO ACTION ON DELETE NO ACTION
go






