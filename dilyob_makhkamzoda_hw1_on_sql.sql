

/*
Домашнее задание по sql №1
Махкамзода Дилёб
*/

/*
1. Создайте многострочный комментарий со следующей информацией:
~ваши имя и фамилия
~описание задачи
2. Напишите код, который вернёт из таблицы track поля name и genre_id
3. Напишите код, который вернёт из таблицы track поля name, composer, unit_price. Переименуйте поля на song, author и price соответственно. Расположите поля так, чтобы сначало следовало название произведения, далее его цена и в конце список авторов.
4. Напишите код, который вернёт из таблицы track название произведения и его длительность в минутах. Результат должен быть отсортирован по длительности произведения по убыванию.
5. Напишите код, который вернёт из таблицы track поля name и genre_id, и только первые 15 строк.
6. Напишите код, который вернёт из таблицы track все поля и все строки начиная с 50-й строки.
7. Напишите код, который вернёт из таблицы track названия всех произведений, чей объём больше 100 мегабайт (подсказка: 1mb=1048576 bytes).
8. Напишите код, который вернёт из таблицы track поля name и composer, где composer не равен "U2". Код должен вернуть записи с 10 по 20-й включительно.
*/


--Задание 2.
select
	t.name
	, t.genre_id
from
	track t;

--Задание 3.
select
	t."name" as song
	, t.unit_price as price
	, t.composer as author
from
	track t;

--Задание 3.
select 
	t."name" 
	, round(milliseconds / 60000., 2) as duration_in_min
from
	track t
order by 
	round(milliseconds / 60000., 2) desc;

--Задание 4.
select 
	t."name",
	t.genre_id
from
	track t
limit 15;


--Задание 5.
select 
	t.*
from
	track t
offset 50;



--Задание 6.
select 
	t."name"
from
	track t
where 
	t.bytes > 104857600;


--Задание 7.
select 
	t."name"
	, t.composer
from
	track t
where
	t.composer = 'U2'
limit 11
offset 9