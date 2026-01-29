-- Task #102 (exported from notes)
-- Source file: 1 курс/2 lesson/SQLQuery1.sql
-- Encoding normalized to UTF-8

--Задание: 102 (Serge I: 2003-04-29)

--Определить имена разных пассажиров, которые летали

--только между двумя городами (туда и/или обратно).

;

WITH T1 AS (

	SELECT id_psg, town_to as towncount 

	FROM pass_in_trip left join trip on pass_in_trip.trip_no=trip.trip_no

	--убираем дубли, значит пассажир летел 

	  UNION

	SELECT id_psg, town_from from pass_in_trip left join trip on pass_in_trip.trip_no=trip.trip_no

	)



SELECT MIN(passenger.name) 

FROM T1

	 LEFT JOIN passenger on passenger.id_psg=T1.id_psg

GROUP BY T1.id_psg

HAVING COUNT(towncount)=2



--********************
