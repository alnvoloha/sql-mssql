-- Task #84 (exported from notes)
-- Source file: 1 курс/3 lesson/SQLQuery1.sql
-- Encoding normalized to UTF-8

--Задание: 84 
--Для каждой компании подсчитать количество перевезенных пассажиров (если они были в этом месяце) по декадам апреля 2003. При этом учитывать только дату вылета.
--Вывод: название компании, количество пассажиров за каждую декаду
with t1 as(
select c.name
, c.ID_comp
, p.ID_psg
, p.date
, case 
        when DAy(p.date) <= 10 THEn 1
        when day(p.date) <= 20 then 2
        else 3
  end as decada
from Company as C
    join Trip as T on C.ID_comp= T.ID_comp
    join Pass_in_trip AS P on P.trip_no=T.trip_no
where P.date between '20030401' AND '20030430'
)
select name,[1],[2],[3]
from t1
pivot ( COUNT(ID_psg) 
for decada in ([1], [2], [3])
) as t2
