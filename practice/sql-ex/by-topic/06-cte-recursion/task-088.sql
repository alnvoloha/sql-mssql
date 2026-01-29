-- Task #88 (exported from notes)
-- Source file: 1 курс/2 lesson/SQLQuery1.sql
-- Encoding normalized to UTF-8

--Задание: 88 (Serge I: 2003-04-29)

--Среди тех, кто пользуется услугами только одной компании, определить имена разных пассажиров, летавших чаще других.

--Вывести: имя пассажира, число полетов и название компании.

;

WITH T1 AS (

	SELECT TOP(1) WITH TIES P.ID_psg, MIN(T.ID_comp) AS ID_comp, COUNT(*) AS trip_Qty

    FROM Pass_in_trip AS P 

	     INNER JOIN Trip AS T ON P.trip_no = T.trip_no

    GROUP BY P.ID_psg

    HAVING MIN(T.ID_comp) = MAX(T.ID_comp) --чтобы компании были одинаковыми

	ORDER BY trip_Qty DESC

	)



SELECT P.name, T1.trip_Qty ,C.name

FROM T1 INNER JOIN Passenger AS P ON T1.ID_psg = P.ID_psg

        INNER JOIN Company as C ON T1.ID_comp = C.ID_comp



--********************
