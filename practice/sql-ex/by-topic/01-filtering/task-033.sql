-- Task #33 (exported from notes)
-- Source file: 1 курс/1 lesson/WHERE.sql
-- Encoding normalized to UTF-8

--Задание: 33 (Serge I: 2002-11-02)
--Укажите корабли, потопленные в сражениях в Северной Атлантике (North Atlantic). Вывод: ship.

SELECT ship
FROM Outcomes
WHERE result='sunk' AND battle='North Atlantic'
