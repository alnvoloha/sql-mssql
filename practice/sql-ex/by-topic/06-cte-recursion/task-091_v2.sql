-- Task #91 (exported from notes)
-- Source file: 1 курс/2 lesson/SQLQuery1.sql
-- Encoding normalized to UTF-8

--   Задание: 91 (Serge I: 2015-03-20)

--C точностью до двух десятичных знаков определить среднее количество краски на квадрате.
;
WITH T1 AS (
SELECT utQ.Q_ID, COALESCE(SUM(utB.B_VOL), 0) AS VOL

FROM utQ
    LEFT JOIN utB ON utQ.Q_ID=utB.B_Q_ID
    GROUP BY utQ.Q_ID
    )
    SELECT CAST(AVG(CAST(VOL AS DECIMAL(5,2))) AS decimal(5,2))
    FROM T1
