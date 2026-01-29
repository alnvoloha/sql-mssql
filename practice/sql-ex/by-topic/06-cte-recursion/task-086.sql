-- Task #86 (exported from notes)
-- Source file: 1 курс/HW2/SQLQuery1.sql
-- Encoding normalized to UTF-8

--Задание: 86 (Serge I: 2012-04-20)
--Для каждого производителя перечислить в алфавитном порядке с разделителем "/" все типы выпускаемой им продукции.
--Вывод: maker, список типов продукции



WITH T1 AS
(
SELECT maker, type
FROM Product
GROUP BY maker, type
)
SELECT maker, STRING_AGG(type, '/')
FROM T1
GROUP BY maker


SELECT CAST(AVG(numGuns*1.0) AS decimal(6,2))
--ROUND(AVG(numGuns), 2) AS AverageGuns
FROM Classes
WHERE type = 'bb';
