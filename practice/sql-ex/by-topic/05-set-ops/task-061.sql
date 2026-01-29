-- Task #61 (exported from notes)
-- Source file: 1 курс/2 lesson/SQLQuery1.sql
-- Encoding normalized to UTF-8

--Задание: 61 (Serge I: 2003-02-14)

--Посчитать остаток денежных средств на всех пунктах приема для базы данных с отчетностью не чаще одного раза в день.



SELECT sum(s) 

FROM(

	SELECT point, sum(inc) as s

	FROM Income_o

	GROUP BY point

	UNION ALL --приход и расход совпасть не могут, из за минуса но union all дешевле

	SELECT point, -sum(out) as s

	FROM Outcome_o

	GROUP BY point

	) as T1



--********************
