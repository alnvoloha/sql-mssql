-- Task #40 (exported from notes)
-- Source file: 1 курс/HW2/SQLQuery1.sql
-- Encoding normalized to UTF-8

--Задание: 40 (Serge I: 2012-04-20)
--Найти производителей, которые выпускают более одной модели, при этом все выпускаемые производителем модели являются продуктами одного типа.
--Вывести: maker, type

SELECT maker, MAX(type)
FROM Product
GROUP BY maker
HAVING COUNT(model)>1 AND MIN(type)=MAX(type)--COUNT(DISTINCT type)=1
