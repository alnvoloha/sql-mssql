-- Task #102 (exported from notes)
-- Source file: 1 курс/2 lesson/SQLQuery1.sql
-- Encoding normalized to UTF-8

--Задание: 102 (Serge I: 2003-04-29)

--Определить имена разных пассажиров, которые летали
--только между двумя городами (туда и/или обратно).

SELECT P.name
 FROM Passenger AS P
  INNER JOIN Pass_in_trip AS PIT ON P.ID_psg = PIT.ID_psg
  INNER JOIN TRIP AS T ON T.trip_no = PIT.trip_no

  GROUP BY P.ID_psg, P.name
  HAVING COUNT(DISTINCT T.town_from)= 1 AND COUNT(DISTINCT T.town_to) = 1 
   OR COUNT(DISTINCT T.town_from)= 2 AND COUNT(DISTINCT T.town_to) = 2
   AND MIN(T.town_from) = MIN(T.town_to)
   AND MAX(T.town_from) = MAX(T.town_to)
