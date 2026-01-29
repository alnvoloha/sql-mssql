-- Task #83 (exported from notes)
-- Source file: 1 курс/2 lesson/SQLQuery1.sql
-- Encoding normalized to UTF-8

--Задание: 83 (dorin_larsen: 2006-03-14)



--Определить названия всех кораблей из таблицы Ships, которые удовлетворяют, по крайней мере, комбинации любых четырёх критериев из следующего списка:

--numGuns = 8

--bore = 15

--displacement = 32000

--type = bb

--launched = 1915

--class=Kongo

--country=USA

;



	SELECT name

	FROM Ships AS S 

		 INNER JOIN Classes AS C ON S.class = C.class

	WHERE IIF(C.numGuns = 8, 1, 0) +

		  IIF(C.bore = 15, 1, 0) + 

		  IIF(C.displacement = 32000, 1, 0) +

		  IIF(C.type = 'bb', 1, 0) +

		  IIF(S.launched = 1915, 1, 0) +

		  IIF(S.class = 'Kongo', 1, 0) +

		  IIF(C.country = 'USA', 1, 0) >= 4



--********************
