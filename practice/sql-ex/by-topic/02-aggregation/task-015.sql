-- Task #15 (exported from notes)
-- Source file: 1 курс/HW2/SQLQuery1.sql
-- Encoding normalized to UTF-8

--Задание: 15 (Serge I: 2003-02-03)
--Найдите размеры жестких дисков, совпадающих у двух и более PC. Вывести: HD

SELECT hd--, COUNT(*) AS Quantity
FROM PC
GROUP BY hd
HAVING COUNT(*)>1
