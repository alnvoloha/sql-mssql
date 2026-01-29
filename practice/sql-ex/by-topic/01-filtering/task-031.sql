-- Task #31 (exported from notes)
-- Source file: 1 курс/1 lesson/WHERE.sql
-- Encoding normalized to UTF-8

--Задание: 31 (Serge I: 2002-10-22)
--Для классов кораблей, калибр орудий которых не менее 16 дюймов, укажите класс и страну.
SELECT class, country
FROM Classes
WHERE bore>=16;
