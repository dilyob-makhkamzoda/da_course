

/*
Домашнее задание по sql №1
Махкамзода Дилёб
*/


/*
1.По каждому сотруднику компании предоставьте следующую информацию: id сотрудника, полное имя, позиция (title), id менеджера (reports_to), полное имя менеджера и через запятую его позиция. 
2.Вытащите список чеков, сумма которых была больше среднего чека за 2023 год. Итоговая таблица должна содержать следующие поля: invoice_id, invoice_date, monthkey (цифровой код состоящий из года и месяца), customer_id, total 
3.Дополните предыдущую информацию email-ом клиента. 
4.Отфильтруйте результирующий запрос, чтобы в нём не было клиентов имеющих почтовый ящик в домене gmail. 
5.Посчитайте какой процент от общей выручки за 2024 год принёс каждый чек. 
6.Посчитайте какой процент от общей выручки за 2024 год принёс каждый клиент компании.
*/


--Задание 1.
SELECT 
    e.employee_id,
    e.first_name || e.last_name as full_name,
    e.title,
    e.reports_to AS manager_id,
    e.first_name || e.last_name || ', ' || m.title AS manager_info
FROM employee e
LEFT JOIN employee m 
ON e.reports_to = m.employee_id;


--Задание 2.


WITH avg_invoice_2023 AS (
    SELECT AVG(total) AS avg_total
    FROM invoice 
    WHERE EXTRACT(YEAR FROM invoice_date) = 2023
)
SELECT 
    i.invoice_id,
    i.invoice_date,
    TO_CHAR(invoice_date, 'YYYYMM')::INTEGER AS monthkey,
    i.customer_id,
    i.total
FROM invoice i
JOIN avg_invoice_2023 a ON i.total > a.avg_total
WHERE EXTRACT(YEAR FROM i.invoice_date) = 2023;


--Задание 3.

WITH avg_invoice_2023 AS (
    SELECT AVG(total) AS avg_total
    FROM invoice
    WHERE EXTRACT(YEAR FROM invoice_date) = 2023
)
SELECT 
    i.invoice_id,
    i.invoice_date,
    TO_CHAR(i.invoice_date, 'YYYYMM')::INTEGER AS monthkey,
    i.customer_id,
    c.email,
    i.total
FROM invoice i
JOIN customer c ON i.customer_id = c.customer_id
JOIN avg_invoice_2023 a ON i.total > a.avg_total
WHERE EXTRACT(YEAR FROM i.invoice_date) = 2023;



--Задание 4.
WITH avg_invoice_2023 AS (
    SELECT AVG(total) AS avg_total
    FROM invoice
    WHERE EXTRACT(YEAR FROM invoice_date) = 2023
)
SELECT 
    i.invoice_id,
    i.invoice_date,
    TO_CHAR(i.invoice_date, 'YYYYMM')::INTEGER AS monthkey,
    i.customer_id,
    c.email,
    i.total
FROM invoice i
JOIN customer c ON i.customer_id = c.customer_id
JOIN avg_invoice_2023 a ON i.total > a.avg_total
WHERE EXTRACT(YEAR FROM i.invoice_date) = 2023
AND c.email NOT LIKE '%@gmail.com';



--Задание 5.

WITH total_revenue_2024 AS (
    SELECT SUM(total) AS total_sum
    FROM invoice
    WHERE EXTRACT(YEAR FROM invoice_date) = 2024
)
SELECT 
    i.invoice_id,
    i.invoice_date,
    i.customer_id,
    i.total,
    ROUND((i.total / t.total_sum) * 100, 2) AS percent_of_revenue
FROM invoice i
JOIN total_revenue_2024 t ON TRUE
WHERE EXTRACT(YEAR FROM i.invoice_date) = 2024
ORDER BY percent_of_revenue DESC;



--Задание 6.

WITH total_revenue_2024 AS (
    SELECT SUM(total) AS total_sum
    FROM invoice
    WHERE EXTRACT(YEAR FROM invoice_date) = 2024
),
customer_revenue AS (
    SELECT 
        customer_id,
        SUM(total) AS customer_total
    FROM invoice
    WHERE EXTRACT(YEAR FROM invoice_date) = 2024
    GROUP BY customer_id
)
SELECT 
    c.customer_id,
    c.customer_total,
    ROUND((c.customer_total / t.total_sum) * 100, 2) AS percent_of_revenue
FROM customer_revenue c
JOIN total_revenue_2024 t ON TRUE
ORDER BY percent_of_revenue DESC;



