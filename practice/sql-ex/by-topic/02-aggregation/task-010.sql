-- Task #10 (exported from notes)
-- Source file: 1 курс/HW2/SQLQuery1.sql
-- Encoding normalized to UTF-8

--Задание: 10 (Serge I: 2002-09-23)
--Найдите модели принтеров, имеющих самую высокую цену. Вывести: model, price

SELECT DISTINCT model, price
FROM Printer
WHERE price = (
SELECT MAX(price)
FROM Printer)

SELECT MAX(price)
FROM Printer
-- ----------------------

SELECT DISTINCT TOP (1) WITH TIES model, price
FROM Printer
ORDER BY price DESC
