

/*
Домашнее задание по sql №6
Махкамзода Дилёб
*/


/*
Задача №1
Для каждого клиента посчитайте сумму продаж по годам и месяцам. Итоговая таблица должна содержать следующие поля: customer_id, full_name, monthkey (в числовом формате), total.
Дополните получившуюся таблицу, посчитав для каждого клиента какой процент от общих продаж за каждый месяц он принёс. Т.е. если например в феврале 2023-го общая сумма продаж всем клиентам составила 100, а сумма продаж клиенту Х составила 15, тогда процент расчитывается как 15/100.
Дополните таблицу, посчитав для каждого клиента нарастающий итог за каждый год.
Дополните таблицу, добавив для каждого клиента скользящее среднее за 3 последних периода (2 предыдущих периода и текущий период).
Дополните таблицу, посчитав для каждого клиента разницу между суммой текущего периода и суммой предыдущего периода.

Задача №2
Верните топ 3 продаваемых альбома за каждый год. Итоговая таблица должна содержать следующие поля: год, название альбома, имя исполнителя, количество проданных треков.

Задача №3
Посчитайте количество клиентов, закреплённых за каждым сотрудником. Итоговая таблица должна содержать следующие поля: id сотрудника, полное имя, количество клиентов
К предыдущему запросу добавьте поле, показывающее какой процент от общей клиентской базы обслуживает каждый сотрудник.

Задача №4
Для каждого клиента определите дату первой и последней покупки. Посчитайте разницу в годах между первой и последней покупкой.
*/



--Задача 1.

WITH monthly_sales AS (
    SELECT 
        c.customer_id,
        c.first_name || ' ' || c.last_name as full_name,
        TO_CHAR(i.invoice_date, 'YYYYMM')::INTEGER AS monthkey,
        SUM(i.total) AS total
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    GROUP BY c.customer_id, c.first_name || ' ' || c.last_name, monthkey
)
SELECT * FROM monthly_sales;



WITH monthly_sales AS (
    SELECT 
        c.customer_id,
        c.first_name || ' ' || c.last_name as full_name,
        TO_CHAR(i.invoice_date, 'YYYYMM')::INTEGER AS monthkey,
        SUM(i.total) AS total
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    GROUP BY c.customer_id, c.first_name || ' ' || c.last_name, monthkey
), total_sales_per_month AS (
    SELECT monthkey, SUM(total) AS month_total
    FROM monthly_sales
    GROUP BY monthkey
)
SELECT 
    m.customer_id,
    m.full_name,
    m.monthkey,
    m.total,
    ROUND((m.total * 100.0 / t.month_total), 2) AS percent_of_month_total
FROM monthly_sales m
JOIN total_sales_per_month t ON m.monthkey = t.monthkey;



WITH monthly_sales AS (
    SELECT 
        c.customer_id,
        c.first_name || ' ' || c.last_name AS full_name,
        TO_CHAR(i.invoice_date, 'YYYYMM')::INTEGER AS monthkey,
        SUM(i.total) AS total
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    GROUP BY c.customer_id, c.first_name || ' ' || c.last_name, monthkey
)
SELECT 
    customer_id,
    full_name,
    monthkey,
    total,
    SUM(total) OVER (
        PARTITION BY customer_id, SUBSTRING(monthkey::TEXT FROM 1 FOR 4)::INTEGER 
        ORDER BY monthkey
    ) AS running_total
FROM monthly_sales;


SELECT 
    customer_id,
    full_name,
    monthkey,
    total,
    AVG(total) OVER (PARTITION BY customer_id ORDER BY monthkey ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg
FROM monthly_sales;



SELECT 
    customer_id,
    full_name,
    monthkey,
    total,
    total - LAG(total) OVER (PARTITION BY customer_id ORDER BY monthkey) AS period_diff
FROM monthly_sales;




--Задача 2

WITH album_sales AS (
    SELECT 
        EXTRACT(YEAR FROM i.invoice_date) AS sale_year,
        a.title AS album_title,
        ar.name AS artist_name,
        COUNT(ii.track_id) AS total_tracks_sold
    FROM album a
    JOIN track t ON a.album_id = t.album_id
    JOIN invoice_line ii ON t.track_id = ii.track_id
    JOIN invoice i ON ii.invoice_id = i.invoice_id
    JOIN artist ar ON a.artist_id = ar.artist_id
    GROUP BY sale_year, album_title, artist_name
), ranked_albums AS (
    SELECT *,
        RANK() OVER (PARTITION BY sale_year ORDER BY total_tracks_sold DESC) AS rank
    FROM album_sales
)
SELECT sale_year, album_title, artist_name, total_tracks_sold
FROM ranked_albums
WHERE rank <= 3;



--задача 3.

WITH total_clients AS (
    SELECT COUNT(*) AS total_count FROM customer
)
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name as full_name ,
    COUNT(c.customer_id) AS client_count,
    ROUND((COUNT(c.customer_id) * 100.0 / t.total_count), 2) AS percent_of_clients
FROM employee e
LEFT JOIN customer c ON e.employee_id = c.support_rep_id
JOIN total_clients t ON TRUE
GROUP BY e.employee_id, e.first_name || ' ' || e.last_name, t.total_count
ORDER BY client_count DESC;




--Задача 4.

SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name as full_name ,
    MIN(i.invoice_date) AS first_purchase,
    MAX(i.invoice_date) AS last_purchase,
    EXTRACT(YEAR FROM MAX(i.invoice_date)) - EXTRACT(YEAR FROM MIN(i.invoice_date)) AS years_active
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.customer_id, c.first_name || ' ' || c.last_name;



