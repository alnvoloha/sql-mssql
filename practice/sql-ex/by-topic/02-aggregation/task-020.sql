-- Task #20 (exported from notes)
-- Source file: 1 курс/HW2/SQLQuery1.sql
-- Encoding normalized to UTF-8

--Задание: 20 (Serge I: 2003-02-13)
--Найдите производителей, выпускающих по меньшей мере три различных модели ПК. Вывести: Maker, число моделей ПК.

SELECT maker, COUNT(model) AS Quantity_model--, COUNT(*) AS Quantity
FROM Product
WHERE type='PC'
group by maker
HAVING COUNT(model)>=3
