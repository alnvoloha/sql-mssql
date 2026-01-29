-- Task #97 (exported from notes)
-- Source file: 1 курс/1 lesson/WHERE.sql
-- Encoding normalized to UTF-8

--Задание: 97 (qwrqwr: 2013-02-15)
--Отобрать из таблицы Laptop те строки, для которых выполняется следующее условие:
--значения из столбцов speed, ram, price, screen возможно расположить таким образом, что каждое последующее значение будет превосходить предыдущее в 2 раза или более.
--Замечание: все известные характеристики ноутбуков больше нуля.
--Вывод: code, speed, ram, price, screen.

SELECT code, speed, ram, price, screen
FROM Laptop
WHERE (speed >=2*ram OR ram >= 2*speed) 
       AND (speed >=2*price OR price >=2*speed)
       AND (speed >=2*screen OR screen >=2*speed)
       AND (ram >=2*price OR price >=2*ram)
       AND (ram >=2*screen OR screen >=2*ram)
       AND (price >=2*screen OR screen >=2*price)






       SELECT DISTINCT model, type
FROM Product
Where model '[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]'  OR model '[a , b, c, d, e, f, h, g, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z,]'
