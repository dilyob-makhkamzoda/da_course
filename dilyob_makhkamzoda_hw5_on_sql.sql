

/*
Домашнее задание по sql №5
Махкамзода Дилёб
*/


/*
Задача №1.
Посчитайте количество клиентов, закреплённых за каждым сотрудником (подсказка: в таблице customer есть поле support_rep_id, которое хранит employee_id сотрудника, за которым закреплён клиент). Итоговая таблица должна содержать следующие поля: id сотрудника, полное имя, количество клиентов.
Добавьте к получившейся таблице поле, показывающее какой процент от общей клиентской базы обслуживает каждый сотрудник.

Задача №2
Верните список альбомов, треки из которых вообще не продавались. Итоговая таблица должна содержать следующие поля: название альбома, имя исполнителя.

Задача №3
Выведите список сотрудников у которых нет подчинённых.

Задача №4
Верните список треков, которые продавались как в США так и в Канаде. Итоговая таблица должна содержать следующие поля: id трека, название трека.

Задача №5
Верните список треков, которые продавались в Канаде, но не продавались в США. Итоговая таблица должна содержать следующие поля: id трека, название трека.
*/




--задача 1.

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
GROUP BY e.employee_id, e.first_name || e.last_name, t.total_count
ORDER BY client_count DESC;



--Задача 2.

SELECT 
    a.title AS album_title,
    ar.name AS artist_name
FROM album a
JOIN artist ar ON a.artist_id = ar.artist_id
WHERE NOT EXISTS (
    SELECT 1 FROM invoice_line ii
    JOIN track t ON ii.track_id = t.track_id
    WHERE t.album_id = a.album_id
);



--Задача 3.

SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name as full_name
FROM employee e
WHERE NOT EXISTS (
    SELECT 1 FROM employee sub
    WHERE sub.reports_to = e.employee_id
);



--задача 4.

SELECT DISTINCT
    t.track_id,
    t.name AS track_name
FROM invoice_line ii
JOIN invoice i ON ii.invoice_id = i.invoice_id
JOIN track t ON ii.track_id = t.track_id
WHERE i.billing_country = 'USA'
AND t.track_id IN (
    SELECT ii2.track_id
    FROM invoice_line ii2
    JOIN invoice i2 ON ii2.invoice_id = i2.invoice_id
    WHERE i2.billing_country = 'Canada'
);



--Задача 5.

SELECT DISTINCT
    t.track_id,
    t.name AS track_name
FROM invoice_line ii
JOIN invoice i ON ii.invoice_id = i.invoice_id
JOIN track t ON ii.track_id = t.track_id
WHERE i.billing_country = 'Canada'
AND t.track_id NOT IN (
    SELECT ii2.track_id
    FROM invoice_line ii2
    JOIN invoice i2 ON ii2.invoice_id = i2.invoice_id
    WHERE i2.billing_country = 'USA'
);



