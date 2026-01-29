-- Task #155 (exported from notes)
-- Source file: 1 курс/2 lesson/SQLQuery1.sql
-- Encoding normalized to UTF-8

--ЗАДАНИЕ 155
    --ПРЕДПОЛАГАЕМ ЧТО НЕ СУЩЕСТВУЕТ НОМЕРА РЕЙСА БОЛЬШЕГО 65535, ВЫВЕСТИ НОМЕР РЕЙСА И ЕГО ПРЕДСТАВЛЕНИЕ В ДВОИЧНОЙ СИСТЕМЕ СЧИСЛЕНИЯ (БЕЗ ВЕДУЩИХ НУЛЕЙ)

WITH T1 AS(
SELECT trip_no, trip_no/2 AS INT_PART, Trip_no%2 AS REMAIN
FROM Trip
UNION ALL
SELECT trip_no, INT_PART/2, INT_PART%2
FROM T1
WHERE INT_PART>0
)
SELECT trip_no, STRING_AGG(REMAIN, '') WITHIN GROUP(ORDER BY INT_PART ASC)
FROM T1
GROUP BY trip_no
