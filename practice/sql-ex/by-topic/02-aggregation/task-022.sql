-- Task #22 (exported from notes)
-- Source file: 1 курс/HW2/SQLQuery1.sql
-- Encoding normalized to UTF-8

--Задание: 22 (Serge I: 2003-02-13)
--Для каждого значения скорости ПК, превышающего 600 МГц, определите среднюю цену ПК с такой же скоростью. Вывести: speed, средняя цена.

SELECT speed, AVG(price)
FROM PC
WHERE speed > 600
GROUP BY speed
