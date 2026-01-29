-- Task #85 (exported from notes)
-- Source file: 1 курс/HW2/SQLQuery1.sql
-- Encoding normalized to UTF-8

--Задание: 85 (Serge I: 2012-03-16)

--Найти производителей, которые выпускают только принтеры или только PC.
--При этом искомые производители PC должны выпускать не менее 3 моделей.

SELECT maker 
FROM Product
GROUP BY maker 
HAVING COUNT(DISTINCT type)=1 AND (MIN(type)='Printer' OR (MIN(type)='PC' AND COUNT(model)>=3))

--MIN(type)=MAX(type) AND (MIN(type)='Printer' OR (MIN(type)='PC' AND COUNT(model)>=3))
