-- Task #77 (exported from notes)
-- Source file: 1 курс/SQLQuery1.sql
-- Encoding normalized to UTF-8

--Задание: 77 
--Определить дни, когда было выполнено максимальное число рейсов из
--Ростова ('Rostov'). Вывод: число рейсов, дата.

SELECT P.date,  T.trip_no
FROM Trip AS T
JOIN Pass_in_trip AS P ON P.trip_no=T.trip_no
WHERE T.town_to='Rostov'
--group by P.date
ORDER BY P.date, T.trip_no


SELECT *
FroM Trip



WITH Years AS (
    SELECT DISTINCT YEAR(launched) AS YearLaunched
    FROM Ships
    WHERE launched IS NOT NULL
),
EasterDates AS (
    -- Расчет даты Пасхи (алгоритм Гаусса)
    SELECT 
        YearLaunched,
        DATEADD(DAY, 
            ((19 * (YearLaunched % 19) + 24) % 30 + 
            (2 * (YearLaunched % 4) + 4 * (YearLaunched % 7) + 6 * ((19 * (YearLaunched % 19) + 24) % 30) + 5) % 7),
            CAST(YearLaunched AS CHAR(4)) + '-03-21'
        ) AS EasterDate
    FROM Years
),
RadunitsaDates AS (
    -- Дата Радуницы (9 дней после Пасхи)
    SELECT 
        YearLaunched,
        DATEADD(DAY, 9, EasterDate) AS RadunitsaDate
    FROM EasterDates
),
ThanksgivingUS AS (
    -- День благодарения в США (четвертый четверг ноября)
    SELECT 
        YearLaunched,
        DATEADD(DAY, 
            ((7 - DATEPART(WEEKDAY, CAST(YearLaunched AS CHAR(4)) + '-11-01') + 5) % 7 + 21),
            CAST(YearLaunched AS CHAR(4)) + '-11-01'
        ) AS ThanksgivingUSDate
    FROM Years
),
ThanksgivingCanada AS (
    -- День благодарения в Канаде (второй понедельник октября)
    SELECT 
        YearLaunched,
        DATEADD(DAY, 
            ((7 - DATEPART(WEEKDAY, CAST(YearLaunched AS CHAR(4)) + '-10-01') + 1) % 7 + 7),
            CAST(YearLaunched AS CHAR(4)) + '-10-01'
        ) AS ThanksgivingCanadaDate
    FROM Years
)
SELECT 
    y.YearLaunched AS Year,
    CONVERT(CHAR(10), r.RadunitsaDate, 120) AS Radunitsa,
    CONVERT(CHAR(10), tUS.ThanksgivingUSDate, 120) AS ThanksgivingUS,
    CONVERT(CHAR(10), tCA.ThanksgivingCanadaDate, 120) AS ThanksgivingCanada
FROM Years y
JOIN RadunitsaDates r ON y.YearLaunched = r.YearLaunched
JOIN ThanksgivingUS tUS ON y.YearLaunched = tUS.YearLaunched
JOIN ThanksgivingCanada tCA ON y.YearLaunched = tCA.YearLaunched
ORDER BY y.YearLaunched;
