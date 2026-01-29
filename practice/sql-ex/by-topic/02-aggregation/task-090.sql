-- Task #90 (exported from notes)
-- Source file: 1 курс/HW2/SQLQuery1.sql
-- Encoding normalized to UTF-8

--Задание: 90 (Serge I: 2012-05-04)

--Вывести все строки из таблицы Product, кроме трех строк с наименьшими номерами моделей и трех строк с наибольшими номерами моделей.

SELECT*
FROM Product
ORDER BY model 
OFFSET 3 rows
FETCH NEXT (SELECT COUNT(*) FROM Product)-3-3 rows ONLY
