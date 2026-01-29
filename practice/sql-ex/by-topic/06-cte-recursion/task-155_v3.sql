-- Task #155 (exported from notes)
-- Source file: 1 курс/3 lesson/SQLQuery1.sql
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





;
WITH T1 AS(
SELECT trip_no,
trip_no/16 AS int_part,
iif (Trip_no%16 <=9, cast(trip_no % 16 as NVARCHAR(4000)), char(ascii('A')+trip_no%16-10)) as remain
FROM Trip
UNION ALL
SELECT trip_no, 
int_part/16, 

iif (int_part %16 <=9, cast(int_part % 16 as NVARCHAR(4000)), char(ascii('A')+int_part%16-10)) as remain
FROM T1
WHERE int_part>0
)
select trip_no, STRING_AGG(remain, '' ) within group (order by int_part asc)
from T1
group by trip_no 


----84
