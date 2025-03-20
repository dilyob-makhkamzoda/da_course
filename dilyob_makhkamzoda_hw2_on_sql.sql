
/*
Домашнее задание по sql №2
Махкамзода Дилёб
*/


/*
1. Напишите код, который из таблицы invoice вернёт дату самой первой и самой последней покупки.
2. Напишите код, который вернёт размер среднего чека для покупок из США.
3. Напишите код, который вернёт список городов в которых имеется более одного клиента.
4. Из таблицы customer вытащите список телефонных номеров, не содержащих скобок;
5. Измените текст 'lorem ipsum' так чтобы только первая буква первого слова была в верхнем регистре а всё остальное в нижнем;
6. Из таблицы track вытащите список названий песен, которые содежат слово 'run';
7. Вытащите список клиентов с почтовым ящиком в 'gmail';
8. Из таблицы track найдите произведение с самым длинным названием.
9. Посчитайте общую сумму продаж за 2021 год, в разбивке по месяцам. Итоговая таблица должна содержать следующие поля: month_id, sales_sum
10. К предыдущему запросу (вопрос №6) добавьте также поле с названием месяца (для этого функции to_char в качестве второго аргумента нужно передать слово 'month'). Итоговая таблица должна содержать следующие поля: month_id, month_name, sales_sum. Результат должен быть отсортирован по номеру месяца.
11. Вытащите список 3 самых возрастных сотрудников компании. Итоговая таблица должна содержать следующие поля: full_name (имя и фамилия), birth_date, age_now (возраст в годах в числовом формате)
12. Посчитайте каков будет средний возраст сотрудников через 3 года и 4 месяца.
13. Посчитайте сумму продаж в разбивке по годам и странам. Оставьте только те строки где сумма продажи больше 20. Результат отсортируйте по году продажи (по возрастанию) и сумме продажи (по убыванию). 
*/



--задание 1.
select 
	min(i.invoice_date)min_date,
	max(i.invoice_date)max_date
from
	invoice i;


--Задание 2.
select
	avg(i.total)
from
	invoice i 
where 
	i.billing_country  = 'USA';


--Задание 3.
select
	c.city
	, count(c.customer_id)
from
	customer c
group by 
	c.city
having 
	count(c.customer_id) > 1;


--Задание 4.
select 
	*
from
	customer c
where
	c.phone not like '%(%' or c.phone not like '%)%';


--Задание 5.
SELECT UPPER(LEFT('lorem ipsum', 1)) || LOWER(SUBSTRING('lorem ipsum', 2))



--Задание 6.
select 
	t."name"
from
	track t
where
	lower(t.name) like '%run%';


--Задание 7.
select 
	c.first_name
	, c.last_name
	, c.email
from
	customer c
where 
	lower(c.email) like '%gmail%';



--задание 8.
select
	t."name"
from
	track t
where
 length(t.name) = (select 
						max(length(t."name")) max_len
					from
						track t);

--задание 9.
select 
	extract(month from i.invoice_date)month_id 
	, sum(i.total)sales_sum
from
	invoice i
where
	extract(year from i.invoice_date) = 2021
group by
	month_id
order by 
	month_id;

--Задание 10
select 
	t."name"
	--, to_char(t.)
from
	track t
where
	lower(t.name) like '%run%';


--Задание 11.
select
	e.first_name || e.last_name as full_name
	, e.birth_date
	, extract(year from age(birth_date)) as age
from 
	employee e
order by birth_date asc
limit 3;


--Задание 12.
select 
    round(avg(extract(year from age(birth_date + interval '3 years 4 months'))), 2) as avg_age_after_3_years_4_months
FROM 
	employee;



--Задание 13.
select 
	b.*
from
	(select 
	    extract(year from i.invoice_date) as sale_year
	    , i.billing_country
	    , SUM(total) as sum_sales
	from 
		invoice i
	group by 
	    extract(year from i.invoice_date),
	    billing_country
	order by 
	    sale_year asc,
	    sum_sales desc
	) b
where
	b.sum_sales > 20;
