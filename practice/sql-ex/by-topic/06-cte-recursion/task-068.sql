-- Task #68 (exported from notes)
-- Source file: 1 курс/2 lesson/SQLQuery1.sql
-- Encoding normalized to UTF-8

--Задание: 68 (Serge I: 2010-03-27)



--Найти количество маршрутов, которые обслуживаются наибольшим числом рейсов.

--Замечания.

--1) A - B и B - A считать ОДНИМ И ТЕМ ЖЕ маршрутом.

--2) Использовать только таблицу Trip

;

WITH T1 AS (

  SELECT TOP(1) WITH TIES COUNT(*) AS num, 

  IIF(town_from >= town_to, town_from, town_to)as T2, IIF(town_from < town_to, town_from, town_to) as T3 --ТУТ ВОПРОС!!! ЧТО ЗНАЧИТ ТАКОЕ СРАВНЕНИЕ

  FROM trip

  GROUP BY

	IIF(town_from >= town_to, town_from, town_to),

	IIF(town_from < town_to, town_from, town_to)

  ORDER BY num DESC

)

SELECT COUNT(*) AS [number of routes]

FROM T1



--********************
