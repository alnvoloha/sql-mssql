-- Task #11 (exported from notes)
-- Source file: 1 курс/HW2/SQLQuery1.sql
-- Encoding normalized to UTF-8

--Задание: 11 (Serge I: 2002-11-02)
--Найдите среднюю скорость ПК.



SELECT AVG(speed)
    --, AVG(speed*1.0)
    -- , ROUND(AVG(CAST(speed AS float)),2)
FROM PC
