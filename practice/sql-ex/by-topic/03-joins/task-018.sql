-- Task #18 (exported from notes)
-- Source file: 1 курс/SQLQuery1.sql
-- Encoding normalized to UTF-8

--Задание: 18 
--Найдите производителей самых дешевых цветных принтеров. Вывести: maker, price

Select DISTINCT TOP 1 Pro.maker, Pri.price
FROM Product AS Pro
JOIN Printer AS Pri ON Pri.model=Pro.model 
WHERE Pri.color='y' 
ORDER BY price
