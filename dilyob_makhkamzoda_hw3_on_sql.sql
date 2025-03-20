

/*
1. Создайте новую схему store и активируйте её.
2.В новой схеме создайте таблицу customers со следующими полями:
customer_id - id клиента; основной ключ таблицы
customer_name - имя клиента; не может быть больше 50 символов; не может быть пустым
email - имейл клиента; не может быть больше 260 символов
address - адрес клиента; может содержать любое количество символов
3.Заполните таблицу данными из таблицы customer датасета chinook. При этом, значения для поля customer_name должны быть составлены из полей first_name и last_name исходной таблицы. А значения для поля address должно быть составлено из полей country, state, city и address исходной таблицы. В качестве делимитера между значениями должен использовать пробел.
4.Создайте таблицу products со следующими полями:
product_id - id продукта; основной ключ таблицы
product_name - название продукта; не может содержать больше 100 символов; но может быть пустым
price -цена продукта; не может быть пустым
5.Заполните таблицу списком следующих товаров:
Ноутбук Lenovo Thinkpad; 12000
Мышь для компьютера, беспроводная; 90
Подставка для ноутбука; 300
Шнур электрический для ПК; 160
6.Создайте таблицу sales, со следующими полями:
sale_id - id продажи; основной ключ таблицы
sale_timestamp - время продажи; не может быть пустым; по умолчанию равно текущей дате и времени
customer_id - id клиента; не может быть пустым; является внешним ключём, ссылающимся на поле customer_id таблицы customers
product_id - id продукта; не может быть пустым; является внешним ключём, ссылающимся на поле product_id таблицы products
quantity - количество проданного товара; не может быть пустым; по умолчанию равно единице
7. Заполните таблицу следующими данными:
customer_id	product_id	quantity
3	4	1
56	2	3
11	2	1
31	2	1
24	2	3
27	2	1
37	3	2
35	1	2
21	1	2
31	2	2
15	1	1
29	2	1
12	2	1

8.Добавьте столбец discount в таблицу sales и установите его значение равным 0.2 для всех строк где product_id равен 1
9.Создайте представление v_usa_customers, которое возвращает список всех клиентов из США
 */

CREATE SCHEMA store;
SET search_path TO store;



CREATE TABLE store.customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    email VARCHAR(260),
    address TEXT
);



INSERT INTO store.customers (customer_id, customer_name, email, address)
SELECT 
    customer_id,
    first_name || ' ' || last_name AS customer_name,
    email,
    country || ' ' || state || ' ' || city || ' ' || address AS address
FROM public.customer;


select * from store.customers c ;



CREATE TABLE store.products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    price NUMERIC NOT NULL
);


INSERT INTO store.products (product_name, price) VALUES
('Ноутбук Lenovo Thinkpad', 12000),
('Мышь для компьютера, беспроводная', 90),
('Подставка для ноутбука', 300),
('Шнур электрический для ПК', 160);



select * from store.products;


CREATE TABLE store.sales (
    sale_id SERIAL PRIMARY KEY,
    sale_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    customer_id INT NOT NULL REFERENCES store.customers(customer_id),
    product_id INT NOT NULL REFERENCES store.products(product_id),
    quantity INT DEFAULT 1 NOT NULL
);


INSERT INTO store.sales (customer_id, product_id, quantity) VALUES
(3, 4, 1), (56, 2, 3), (11, 2, 1), (31, 2, 1),
(24, 2, 3), (27, 2, 1), (37, 3, 2), (35, 1, 2),
(21, 1, 2), (31, 2, 2), (15, 1, 1), (29, 2, 1),
(12, 2, 1);



ALTER TABLE store.sales ADD COLUMN discount NUMERIC DEFAULT 0;

UPDATE store.sales 
SET discount = 0.2 
WHERE product_id = 1;


select * from store.sales s where s.product_id = 1;


CREATE VIEW store.v_usa_customers AS
SELECT * 
FROM store.customers 
WHERE address LIKE 'United States%';







