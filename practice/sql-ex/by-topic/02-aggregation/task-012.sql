-- Task #12 (exported from notes)
-- Source file: 1 курс/HW2/SQLQuery1.sql
-- Encoding normalized to UTF-8

--Задание: 12 (Serge I: 2002-11-02)
--Найдите среднюю скорость ПК-блокнотов, цена которых превышает 1000 дол.

SELECT AVG(speed)
FROM Laptop
WHERE price> 1000
