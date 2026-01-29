--2 задание.
-- первое решение, и более рациональоне

WITH T1 AS (
  SELECT Name,
         ProductNumber,
         ProductNumber AS C,
         CAST('' AS nvarchar(MAX)) AS Digits
  FROM AdventureWorks2022.Production.Product
  UNION ALL
  SELECT Name,
         ProductNumber,
         SUBSTRING(C, 2, LEN(C)) AS C,
         CAST(Digits + IIF(SUBSTRING(C, 1, 1) LIKE '[0-9]', SUBSTRING(C, 1, 1), '') AS nvarchar(MAX)) AS Digits
  FROM T1
  WHERE LEN(C) > 0
)
SELECT Name, ProductNumber
FROM T1
WHERE LEN(C) = 0
ORDER BY CAST(Digits AS int);

-- второе решение через методы строк
SELECT Name
  , ProductNumber
FROM AdventureWorks2022.Production.Product
ORDER BY CAST(REPLACE(TRANSLATE(ProductNumber, 'abcdefghijklmnopqrstuvwxyz-', REPLICATE('A', 27)), 'A', '') as int)






-- 1 задание
WITH YearData AS (
    SELECT DISTINCT
        YEAR(launched) AS launch_year
    FROM
        Ships
),
EasterDates AS (
    SELECT
        launch_year,
        DATEADD(DAY, 9, DATEADD(YEAR, launch_year - 1900, 
            DATEADD(DAY, 
                (DATEDIFF(DAY, '1900-03-21', DATEADD(YEAR, launch_year - 1900, '1900-04-01')) + 2) % 7, 
                DATEADD(DAY, 55, DATEADD(YEAR, launch_year - 1900, '1900-04-01'))
            )
        )) AS Radunitsa
    FROM
        YearData
),
ThanksgivingDates AS (
    SELECT
        launch_year,
        DATEADD(DAY, 22 + (DATEDIFF(DAY, '1900-01-01', DATEADD(MONTH, 11, DATEADD(YEAR, launch_year - 1900, '1900-01-01'))) / 7) * 7, 
            DATEADD(MONTH, 11, DATEADD(YEAR, launch_year - 1900, '1900-01-01'))) AS ThanksgivingUS,
        DATEADD(DAY, 14, DATEADD(MONTH, 10, DATEADD(YEAR, launch_year - 1900, '1900-01-01'))) AS ThanksgivingCanada
    FROM
        YearData
)
SELECT
    yd.launch_year,
    ed.Radunitsa,
    td.ThanksgivingUS,
    td.ThanksgivingCanada
FROM
    YearData yd
JOIN
    EasterDates ed ON yd.launch_year = ed.launch_year
JOIN
    ThanksgivingDates td ON yd.launch_year = td.launch_year
ORDER BY
    yd.launch_year;



    --еще одно решение 1 задания:
WITH YearData AS (
    SELECT DISTINCT YEAR(launched) AS launch_year
    FROM Ships
),
EasterAndRadunitsa AS (
    -- вычисляем Пасху и Радуницу
    SELECT 
        launch_year,
        CASE 
            WHEN ((19 * (launch_year % 19) + 15) % 30) + 
                 ((2 * (launch_year % 4) + 4 * (launch_year % 7) + 6 * ((19 * (launch_year % 19) + 15) % 30) + 6) % 7) <= 26 
                THEN DATEADD(DAY, 4 + 
                    ((19 * (launch_year % 19) + 15) % 30) + 
                    ((2 * (launch_year % 4) + 4 * (launch_year % 7) + 6 * ((19 * (launch_year % 19) + 15) % 30) + 6) % 7) - 1, 
                    DATEFROMPARTS(launch_year, 4, 1))
            ELSE DATEADD(DAY, 
                ((19 * (launch_year % 19) + 15) % 30) + 
                ((2 * (launch_year % 4) + 4 * (launch_year % 7) + 6 * ((19 * (launch_year % 19) + 15) % 30) + 6) % 7) - 27, 
                DATEFROMPARTS(launch_year, 5, 1))
        END AS Easter,
        DATEADD(DAY, 9, 
            CASE 
                WHEN ((19 * (launch_year % 19) + 15) % 30) + 
                     ((2 * (launch_year % 4) + 4 * (launch_year % 7) + 6 * ((19 * (launch_year % 19) + 15) % 30) + 6) % 7) <= 26 
                    THEN DATEADD(DAY, 4 + 
                        ((19 * (launch_year % 19) + 15) % 30) + 
                        ((2 * (launch_year % 4) + 4 * (launch_year % 7) + 6 * ((19 * (launch_year % 19) + 15) % 30) + 6) % 7) - 1, 
                        DATEFROMPARTS(launch_year, 4, 1))
                ELSE DATEADD(DAY, 
                    ((19 * (launch_year % 19) + 15) % 30) + 
                    ((2 * (launch_year % 4) + 4 * (launch_year % 7) + 6 * ((19 * (launch_year % 19) + 15) % 30) + 6) % 7) - 27, 
                    DATEFROMPARTS(launch_year, 5, 1))
            END
        ) AS Radunitsa
    FROM YearData
),
ThanksgivingDates AS (
    -- День Благодарения в США и Канаде
    SELECT 
        launch_year,
        DATEADD(DAY,
            (7 - DATEDIFF(DAY, '1900-01-01', DATEADD(MONTH, 11, DATEFROMPARTS(launch_year, 1, 1))) % 7) % 7 + 21, 
            DATEFROMPARTS(launch_year, 11, 1)
        ) AS ThanksgivingUS,
        -- 2-й понедельник октября для Канады
        DATEADD(DAY,
            (8 - DATEDIFF(DAY, '1900-01-01', DATEADD(MONTH, 10, DATEFROMPARTS(launch_year, 1, 1))) % 7) % 7 + 7, 
            DATEFROMPARTS(launch_year, 10, 1)
        ) AS ThanksgivingCanada
    FROM YearData
)
SELECT
    yd.launch_year AS YearLaunched,
    FORMAT(er.Radunitsa, 'yyyy-MM-dd') AS Radunitsa,
    FORMAT(td.ThanksgivingUS, 'yyyy-MM-dd') AS ThanksgivingUS,
    FORMAT(td.ThanksgivingCanada, 'yyyy-MM-dd') AS ThanksgivingCanada
FROM YearData yd
JOIN EasterAndRadunitsa er ON yd.launch_year = er.launch_year
JOIN ThanksgivingDates td ON yd.launch_year = td.launch_year
ORDER BY yd.launch_year;




SELECT 
    launched,
    CONVERT(varchar(10), DATEADD(day, 1, ed.easter_date), 120) AS easter,  
    DATENAME(weekday, DATEADD(day, 1, ed.easter_date)) AS easter_day,       
    CONVERT(varchar(10), DATEADD(day, 10, ed.easter_date), 120) AS radunica,
    DATENAME(weekday, DATEADD(day, 10, ed.easter_date)) AS radunica_day,    
    CONVERT(varchar(10), 
        DATEADD(day, ((4 - DATEPART(weekday, DATEFROMPARTS(launched, 11, 1)) + 7) % 7) + 22, 
        DATEFROMPARTS(launched, 11, 1)), 120) AS thanksgiving_usa,
    DATENAME(weekday, DATEADD(day, ((4 - DATEPART(weekday, DATEFROMPARTS(launched, 11, 1)) + 7) % 7) + 22, 
        DATEFROMPARTS(launched, 11, 1))) AS thanksgiving_usa_day,
    CONVERT(varchar(10), 
        DATEADD(day, ((2 - DATEPART(weekday, DATEFROMPARTS(launched, 10, 1)) + 7) % 7) + 7, 
        DATEFROMPARTS(launched, 10, 1)), 120) AS thanksgiving_canada,
    DATENAME(weekday, DATEADD(day, ((2 - DATEPART(weekday, DATEFROMPARTS(launched, 10, 1)) + 7) % 7) + 7, 
        DATEFROMPARTS(launched, 10, 1))) AS thanksgiving_canada_day
FROM (
    SELECT DISTINCT launched 
    FROM Ships 
    WHERE launched IS NOT NULL
) AS y
JOIN (
    SELECT launched AS year,
        DATEADD(day,
            (((19 * (launched % 19) + 15) % 30) +
            ((2 * (launched % 4) + 4 * (launched % 7) + 6 * ((19 * (launched % 19) + 15) % 30) + 6) % 7) + 13),
            DATEFROMPARTS(launched, 3, 21)) AS easter_date
    FROM (
        SELECT DISTINCT launched 
        FROM Ships 
        WHERE launched IS NOT NULL
    ) AS sub
) AS ed ON y.launched = ed.year
ORDER BY y.launched;










--решение правильное 1 задания

SELECT 
    launched AS year,
    CONVERT(varchar(10), DATEADD(day, 1, ed.easter_date), 120) AS easter,  
    CONVERT(varchar(10), DATEADD(day, 10, ed.easter_date), 120) AS radunica,
    CONVERT(varchar(10), 
        DATEADD(day, ((4 - DATEPART(weekday, DATEFROMPARTS(launched, 11, 1)) + 7) % 7) + 22, 
        DATEFROMPARTS(launched, 11, 1)), 120) AS thanksgiving_usa,
    CONVERT(varchar(10), 
        DATEADD(day, ((2 - DATEPART(weekday, DATEFROMPARTS(launched, 10, 1)) + 7) % 7) + 7, 
        DATEFROMPARTS(launched, 10, 1)), 120) AS thanksgiving_canada
FROM (
    SELECT DISTINCT launched 
    FROM Ships 
    WHERE launched IS NOT NULL
) AS y
JOIN (
    SELECT launched AS year,
        DATEADD(day,
            (((19 * (launched % 19) + 15) % 30) +
            ((2 * (launched % 4) + 4 * (launched % 7) + 6 * ((19 * (launched % 19) + 15) % 30) + 6) % 7) + 13),
            DATEFROMPARTS(launched, 3, 21)) AS easter_date
    FROM (
        SELECT DISTINCT launched 
        FROM Ships 
        WHERE launched IS NOT NULL
    ) AS sub
) AS ed ON y.launched = ed.year
ORDER BY y.launched;
