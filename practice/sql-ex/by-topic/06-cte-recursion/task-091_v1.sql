-- Task #91 (exported from notes)
-- Source file: 1 курс/2 lesson/SQLQuery1.sql
-- Encoding normalized to UTF-8

--Задание: 91 (Serge I: 2015-03-20)

--C точностью до двух десятичных знаков определить среднее количество краски на квадрате.

;

WITH T1 AS (

    --Null там где квадрат не покрасили, заменим на 0

	SELECT q.Q_NAME, SUM (cast(ISNULL(B_VOL, 0) as DECIMAL(10,2))) AS s

	FROM utQ AS Q

	--все квадраты СОХРАНИМ и соединим с квадратами покрашенными

	LEFT JOIN utB B on Q.Q_ID=B.B_Q_ID

	group by Q.Q_NAME

	)



SELECT CAST(sum(s)/count (s) AS NUMERIC(12,2)) 

FROM T1



--********************
