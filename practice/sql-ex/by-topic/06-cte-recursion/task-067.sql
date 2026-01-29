-- Task #67 (exported from notes)
-- Source file: 1 курс/2 lesson/SQLQuery1.sql
-- Encoding normalized to UTF-8

--Задание: 67 (Serge I: 2010-03-27)



--Найти количество маршрутов, которые обслуживаются наибольшим числом рейсов.

--Замечания.

--1) A - B и B - A считать РАЗНЫМИ маршрутами.

--2) Использовать только таблицу Trip

;

WITH T1 AS (

	SELECT TOP(1) WITH TIES town_from, town_to, count(*) AS num

	FROM trip

	GROUP BY town_from, town_to

	ORDER BY num DESC

	)



SELECT COUNT(*) AS [number of routes]

FROM T1



--********************
