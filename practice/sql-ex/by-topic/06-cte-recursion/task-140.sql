-- Task #140 (exported from notes)
-- Source file: 1 курс/2 lesson/SQLQuery1.sql
-- Encoding normalized to UTF-8

--Задание: 140 (no_more: 2017-07-07)



--Определить, сколько битв произошло в течение каждого десятилетия, начиная с даты первого сражения в базе данных и до даты последнего.

--Вывод: десятилетие в формате "1940s", количество битв.



;

WITH T1 AS (

  SELECT (YEAR(date)/10) * 10 AS years

          ,COUNT(*) AS battles

  FROM Battles

  GROUP BY (YEAR(date)/10) * 10

),



T2 AS (

  SELECT 0 AS years

        ,0 AS battles

   UNION ALL 

  SELECT years + 10, 0

  FROM T2

  WHERE years + 10 <= YEAR(GETDATE())

),



T3 AS (

  SELECT *

  FROM T1

   UNION ALL

  SELECT *

  FROM T2

)



SELECT CAST(years AS varchar(4)) + 's' AS years, SUM(battles) AS battles

FROM T3

WHERE years <= (SELECT MAX(years) FROM T1) AND (years >= (SELECT MIN(years) FROM T1))

GROUP BY CAST(years AS varchar(4)) + 's'

OPTION (maxrecursion 0)



--********************
