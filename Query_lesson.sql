USE sql_store;

SELECT 
	last_name, 
    first_name, 
    points, 
    (points * 10) + 100 AS 'discount factor'
FROM customers;
-- WHERE customer_id = 1
-- ORDER BY first_name

SELECT DISTINCT state
FROM customers;

SELECT 
	name, 
	unit_price,
    unit_price*1.1 AS new_price
FROM products;

SELECT *
FROM customers
WHERE points > 3000;

SELECT *
FROM customers
WHERE state = 'VA';

SELECT *
FROM customers
WHERE state <> 'VA';

SELECT *
FROM customers
WHERE birth_date > '1990-01-23';

SELECT *
FROM orders
WHERE order_date > '2018-12-31' AND order_date < '2020-01-01';


SELECT *
FROM customers
WHERE birth_date > '1990-01-01' OR 
	(points > 1000 AND state = 'VA');

SELECT *
FROM customers
WHERE NOT (birth_date > '1990-01-01' OR points > 1000);

SELECT *
FROM order_items
WHERE order_id = 6 AND (quantity * unit_price > 30);

SELECT *
FROM customers
WHERE state IN ('VA', 'FL', 'GA');


SELECT *
FROM customers
WHERE state NOT IN ('VA', 'FL', 'GA');

SELECT *
FROM products
WHERE quantity_in_stock IN (49,38,72);

SELECT *
FROM customers
WHERE points BETWEEN 1000 AND 3000;

SELECT *
FROM customers
WHERE birth_date BETWEEN '1990-01-01' AND '2000-01-01';

SELECT *
FROM customers
WHERE last_name LIKE 'b%';


SELECT *
FROM customers
WHERE last_name LIKE '%b%';


SELECT *
FROM customers
WHERE last_name LIKE '_____y';


SELECT *
FROM customers
WHERE last_name LIKE 'b____y';


SELECT *
FROM customers
WHERE address LIKE '%trail%' OR 
	address LIKE '%avenue%';


SELECT *
FROM customers
WHERE phone LIKE '%9';


SELECT *
FROM customers
WHERE last_name LIKE '%field%';


SELECT *
FROM customers
WHERE last_name REGEXP '[a-h]e';
-- WHERE last_name REGEXP '[gim]e';
-- WHERE last_name REGEXP 'field$|mac|rose';
-- WHERE last_name REGEXP '^field|mac|rose';
-- WHERE last_name REGEXP 'field|mac|rose';
-- WHERE last_name REGEXP 'field|mac';
-- WHERE last_name REGEXP 'field$';
-- WHERE last_name REGEXP '^field';
-- WHERE last_name REGEXP 'field';
-- ^ begining $ end | pipeOR [] set [-] ranged set

SELECT *
FROM customers
WHERE first_name IN ('ELKA', 'AMBUR');


SELECT *
FROM customers
WHERE last_name REGEXP 'EY$|ON$';

SELECT *
FROM customers
WHERE last_name REGEXP '^MY|SE';


SELECT *
FROM customers
WHERE last_name REGEXP 'B[RU]';
-- WHERE last_name REGEXP 'BR|BU';
-- WHERE last_name REGEXP 'BR|BU';


SELECT *
FROM customers
WHERE phone IS NULL;


	SELECT *
	FROM customers
	WHERE phone IS NOT NULL;
    
    SELECT *
    FROM orders
    WHERE shipper_id IS NULL;
    
    SELECT *
    FROM customers
    ORDER BY first_name DESC;
    
    SELECT *
    FROM customers
    ORDER BY state ASC, first_name DESC;
    
    SELECT first_name, last_name
    FROM customers
    ORDER BY birth_date;
    
    SELECT first_name, last_name, 10 AS points
    FROM customers
    ORDER BY points, first_name DESC;
    
    SELECT first_name, last_name, 10 AS points
    FROM customers
    ORDER BY 1,2;
    -- avoid using numbers in order by
    
    SELECT *
    FROM order_items
    WHERE order_id = 2
    ORDER BY quantity * unit_price DESC;
    
     
    SELECT *, quantity * unit_price AS total_price
    FROM order_items
    WHERE order_id = 2
    ORDER BY total_price DESC;
    
    SELECT *
    FROM customers
    LIMIT 5;
        
    SELECT *
    FROM customers
    LIMIT 3,3;
    
    SELECT *
    FROM customers
    ORDER BY points DESC
    LIMIT 3;
    
    SELECT order_id, orders.customer_id, first_name, last_name
    FROM orders
    JOIN customers
		ON orders.customer_id = customers.customer_id;
	
    
    SELECT order_id, o.customer_id, first_name, last_name
    FROM orders o
    JOIN customers c
 		ON o.customer_id = c.customer_id;
        
	SELECT order_id, p.product_id, name, quantity, oi.unit_price
    FROM order_items oi
    JOIN products p
		ON oi.product_id = p.product_id;
        
	
	SELECT order_id, p.product_id, name, quantity, oi.unit_price
    FROM order_items oi
    JOIN sql_inventory.products p
		ON oi.product_id = p.product_id;
    
    SELECT 
		order_id,
        order_date,
        first_name,
        last_name,
        name
    FROM orders o
    JOIN order_statuses os ON o.status = os.order_status_id
    JOIN customers c ON o.customer_id = c. customer_id;
    
    USE sql_hr;

SELECT
	e.employee_id,
    e.first_name,
    er.first_name AS manager
FROM employees e
JOIN employees er
	ON e.reports_to = er.employee_id;

USE sql_invoicing;

SELECT
	p.date,
	p.payment_id,
    p.amount,
    c.name AS customer,
    pm.name AS payment_method
FROM payments p 
JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id
JOIN clients c 
		ON p.client_id = c.client_id;
        
USE sql_store;

SELECT *
FROM order_items oi
JOIN order_item_notes oin
	ON oi.order_id = oin.order_id AND 
		oi.product_id = oin.product_id;
    
SELECT
	c.customer_id,
    c.first_name,
    o.order_id,
    sh.name AS shipper
FROM customers c
LEFT JOIN orders o
	ON c.customer_id = o.customer_id
LEFT JOIN shippers sh
	ON o.shipper_id = sh.shipper_id;
    
SELECT
	p.product_id,
    p.name AS product,
    oi.order_id
FROM order_items oi
RIGHT JOIN products p
	ON oi.product_id = p.product_id;

SELECT
	o.order_date,
    o.order_id,
    c.first_name,
    sh.name AS shipper,
    os.name AS status
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id
JOIN order_statuses os
	ON o.status = os.order_status_id
LEFT JOIN shippers sh
	ON o.shipper_id = sh.shipper_id;
    
SELECT
	o.order_date,
    o.order_id,
    c.first_name,
    sh.name AS shipper
FROM orders o
JOIN customers c
	-- ON o.customer_id = c.customer_id
    USING (customer_id)
LEFT JOIN shippers sh
	-- ON o.shipper_id = sh.shipper_id;
    USING (shipper_id);
    
SELECT *
FROM order_items oi
JOIN order_item_notes oin
	-- ON oi.order_id = oin.order_id
    -- AND oi.product_id = oin.product_id;
	USING (order_id, product_id);

USE sql_invoicing;

SELECT
	p.date,
    c.name AS client,
    p.amount,
    pm.name
FROM payments p
JOIN clients c 
	USING (client_id)
JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id;

USE sql_store;

SELECT *
FROM orders o
NATURAL JOIN customers c;
-- not recommended as it gives db control

SELECT
	c.first_name,
    p.name AS product
FROM customers c
CROSS JOIN products p
ORDER BY c.first_name;
 
SELECT
	c.first_name,
    p.name AS product
FROM customers c, products p;
-- better to use explicit syntax of cross join as above

SELECT
	sh.name AS shipper,
    p.name AS product
FROM shippers sh
CROSS JOIN products p
ORDER BY sh.name;


SELECT
	sh.name AS shipper,
    p.name AS product
FROM shippers sh, products p
ORDER BY sh.name;


SELECT
	order_id,
    order_date,
    'ACTIVE' AS status
FROM orders
WHERE order_date >= '2019-01-01'
UNION
SELECT
	order_id,
    order_date,
    'ARCHIVE' AS status
FROM orders
WHERE order_date < '2019-01-01';

SELECT
	customer_id,
    first_name,
    points,
    'BRONZE' AS type
FROM customers
WHERE points<2000
UNION
SELECT
	customer_id,
    first_name,
    points,
    'SILVER' AS type
FROM customers
-- WHERE points>=2000 AND points<3000
	WHERE points BETWEEN 2000 AND 3000
UNION
SELECT
	customer_id,
    first_name,
    points,
    'GOLD' AS type
FROM customers
WHERE points>3000
ORDER BY first_name;

INSERT INTO customers
VALUES (
	DEFAULT,
    'John',
    'Smith',
    '1990-01-01',
    DEFAULT,
    'address',
    'city',
    'CA',
    DEFAULT);

INSERT INTO customers (
	first_name,
    last_name,
    birth_date,
    address,
    city,
    state)
VALUES (
	'Peter',
    'Pan',
    '1991-01-01',
    'address',
    'city',
    'VA');
    
    SELECT *
    FROM customers;

INSERT INTO shippers (name)
VALUES ('Shipper1'),
		('Shipper2'),
        ('Shipper3');

SELECT *
FROM shippers;

SELECT *
FROM products;

INSERT INTO products (name, quantity_in_stock, unit_price)
VALUES ('Apple Pie', 34, 0.80),
		('Lemmon Tart', 12, 1.05),
        ('Blueberry Cheesecake', 5, 1.25);
        
INSERT INTO orders (customer_id, order_date, status)
VALUES (1, '2019-01-02', 1);

SELECT LAST_INSERT_ID();

INSERT INTO order_items
VALUES (LAST_INSERT_ID(), 1, 1, 3.35),
		(LAST_INSERT_ID(), 3, 2, 4),
        (LAST_INSERT_ID(), 4, 3, 11.05);

SELECT *
FROM orders o
RIGHT JOIN order_items oi
USING (order_id);

CREATE TABLE orders_archived AS
SELECT *
FROM orders;

INSERT INTO orders_archived
SELECT *
FROM orders
WHERE order_date > '2015-01-01';

USE sql_invoicing;

CREATE TABLE invoices_archived AS
SELECT
	i.invoice_id,
    number,
    c.name AS customer,
    invoice_total,
    payment_total,
    invoice_date,
    due_date,
    payment_date
FROM invoices i
JOIN clients c
	USING (client_id)
WHERE payment_total > 0.00;

UPDATE invoices
SET payment_total = 1, payment_date = '2019-10-01'
WHERE invoice_id = 1;

SELECT *
FROM invoices;


UPDATE invoices
SET payment_total = DEFAULT, payment_date = NULL
WHERE invoice_id = 1;


UPDATE invoices
SET payment_total = .5 * invoice_total, payment_date = due_date
WHERE invoice_id = 3;

UPDATE invoices
SET payment_total = .5 * invoice_total, payment_date = due_date
WHERE client_id = 3;


UPDATE invoices
SET payment_total = .25 * invoice_total, payment_date = due_date
WHERE client_id IN (4,5);

USE sql_store;

UPDATE customers
SET points = points+50
WHERE birth_date < '1990-01-01';

USE sql_invoicing;

UPDATE invoices
SET payment_total = .25 * invoice_total, payment_date = due_date
WHERE client_id = 
			(SELECT client_id
			FROM clients
			WHERE name = 'MyWorks');
            

UPDATE invoices
SET payment_total = .25 * invoice_total, payment_date = due_date
WHERE client_id IN
			(SELECT client_id
			FROM clients
			WHERE state IN ('CA','OR'));            

USE sql_store;

SELECT *
FROM orders;

UPDATE orders
SET comments = 'tasty food'
WHERE customer_id IN
		(SELECT customer_id
        FROM customers
        WHERE points>3000);

USE sql_invoicing;
        
DELETE FROM invoices_archived
WHERE customer IN
	(SELECT name
    FROM clients 
    WHERE name = 'MyWorks');
    
SELECT
	MAX(invoice_total) AS highest,
    MIN(invoice_total) AS lowest,
    AVG(invoice_total) AS mean,
    SUM(invoice_total * 1.1) AS total,
    COUNT(invoice_total) AS count_invoices,
    COUNT(payment_date) AS count_payments,
    COUNT(*) AS total_records
FROM invoices
WHERE invoice_date > '2019-07-01';
-- COUNT function will include duplicates by default but leave out null values (unless we run count(*) to include null)
-- COUNT (DISTINCT customer_id) AS total_records

SELECT
	'First half of 2019' AS date_range,
	SUM(invoice_total) AS total_sales,
    SUM(payment_total) AS total_payments,
    SUM(invoice_total - payment_total) AS what_we_expect
FROM invoices
WHERE invoice_date BETWEEN '2019-01-01' AND '2019-06-30'
UNION
SELECT
	'Second half of 2019' AS date_range,
	SUM(invoice_total) AS total_sales,
    SUM(payment_total) AS total_payments,
    SUM(invoice_total - payment_total) AS what_we_expect
FROM invoices
WHERE invoice_date BETWEEN '2019-07-01' AND '2019-12-31'
UNION
SELECT
	'Total' AS date_range,
	SUM(invoice_total) AS total_sales,
    SUM(payment_total) AS total_payments,
    SUM(invoice_total - payment_total) AS what_we_expect
FROM invoices;

SELECT
	 client_id,
     SUM(invoice_total) AS total_sales
FROM invoices
WHERE invoice_date >= '2019-01-01'
GROUP BY client_id
ORDER BY total_sales DESC;

SELECT 
	state,
    city,
    SUM(invoice_total) AS total_sales
FROM invoices
JOIN clients USING (client_id)
GROUP BY state, city;

SELECT
	date,
    name AS payment_method,
    SUM(amount) AS total_payments
FROM payments p
JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id
GROUP BY date, payment_method
ORDER BY date;


SELECT
	 client_id,
     SUM(invoice_total) AS total_sales,
     COUNT(*) AS number_of_invoices
FROM invoices
-- WHERE total_sales > 500
-- using WHERE before GROUP_BY wont work for total sales as the grouping hasn't been completed yet
-- instead of that we need to use HAVING which acts as filter after groub_by
-- WHERE works before GROUP BY for any column whereas HAVING works after GROUP BY for only SELECT ed colums
GROUP BY client_id
HAVING total_sales > 500 AND number_of_invoices > 5;

--
USE sql_store;

SELECT
	order_id,
    SUM(quantity * unit_price) AS invoice_total
FROM order_items
GROUP BY order_id;

SELECT
	order_id,
	customer_id,
    first_name AS customer,
    state,
    invoice_total
FROM orders
JOIN customers
	USING (customer_id)
JOIN 
	(SELECT
		order_id,
		SUM(quantity * unit_price) AS invoice_total
	FROM order_items
	GROUP BY order_id) AS orderTotal
	USING (order_id) 
GROUP BY customer_id
HAVING state = 'VA';
-- this won't calculate for all customers

-- One possible solution---------------------------
CREATE TABLE order_values
SELECT
	order_id,
    customer_id,
    first_name as customer_name,
    state,
    SUM(quantity * unit_price) AS invoice_total
FROM order_items
JOIN orders
	USING (order_id)
JOIN customers
	USING (customer_id)
GROUP BY order_id;

SELECT
	customer_name,
    SUM(invoice_total) AS spend,
    state
FROM order_values
GROUP BY customer_name
HAVING spend >= 100 AND state = 'VA';

-- -----------------------------

-- simpler solution --
SELECT
	c.customer_id,
    c.first_name,
    c.last_name,
    SUM(oi.quantity * oi.unit_price) AS total_spend
FROM
	customers c
JOIN orders o
	USING (customer_id)
JOIN order_items oi
	USING (order_id)
WHERE state = 'VA'
GROUP BY
	c.customer_id,
    c.first_name,
    c.last_name
HAVING total_spend > 100;

USE sql_invoicing;

SELECT
	 client_id,
     SUM(invoice_total) AS total_sales
FROM invoices
GROUP BY client_id WITH ROLLUP;

SELECT 
	state,
    city,
    SUM(invoice_total) AS total_sales
FROM invoices
JOIN clients USING (client_id)
GROUP BY state, city WITH ROLLUP;
-- ROLLUP totals on each value in each column individually used in GROUP BY

SELECT
	pm.name AS payment_method,
    sum(p.amount) AS total
FROM payments p
JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id
GROUP BY pm.name WITH ROLLUP;

USE sql_store;
-- testing WHERE with sub-query instead of join. Not successful

SELECT
	c.customer_id,
    c.first_name,
    c.last_name
FROM customers c
WHERE state = 'VA' AND customer_id = (
										SELECT customer_id
                                        FROM orders
                                        WHERE order_id = (
														SELECT 
															order_id
                                                            -- SUM(quantity*unit_price) AS total
                                                        FROM order_items
                                                        GROUP BY order_id
                                                        -- HAVING total>100
                                        )
)						
GROUP BY
	c.customer_id,
    c.first_name,
    c.last_name;

SELECT *
FROM products
WHERE unit_price >(
					SELECT unit_price
                    FROM products
                    WHERE product_id = 3
);

USE sql_hr;

SELECT *
FROM employees
WHERE salary > (
		SELECT
			AVG(salary) AS average
		FROM employees
);

USE sql_store;

SELECT *
FROM products
WHERE product_id NOT IN (
	SELECT DISTINCT product_id
    FROM order_items
);

USE sql_invoicing;

SELECT *
FROM clients
WHERE client_id NOT IN (
	SELECT DISTINCT client_id
    FROM invoices
);

SELECT *
FROM clients
LEFT JOIN invoices
	USING (client_id)
WHERE invoice_id IS NULL;

USE sql_store;

SELECT
	customer_id,
	first_name,
    last_name
FROM customers
WHERE customer_id IN (
	SELECT customer_id
    FROM orders
    WHERE order_id IN (
		SELECT order_id
        FROM order_items
        WHERE product_id = 3
));

SELECT
	DISTINCT customer_id,
	first_name,
    last_name
FROM customers
JOIN orders USING (customer_id)
JOIN order_items USING (order_id)
WHERE product_id = 3; 

USE sql_invoicing;

SELECT *
FROM invoices
WHERE invoice_total > (
	SELECT MAX(invoice_total)
    FROM invoices
    WHERE client_id = 3
);

SELECT *
FROM invoices
WHERE invoice_total > ALL (
	SELECT invoice_total
    FROM invoices
    WHERE client_id = 3
);

SELECT *
FROM invoices
WHERE invoice_total > ANY (
	SELECT invoice_total
    FROM invoices
    WHERE client_id = 3
);

SELECT *
FROM invoices
WHERE invoice_total > SOME (
	SELECT invoice_total
    FROM invoices
    WHERE client_id = 3
);

SELECT 
		client_id,
		COUNT(invoice_id) AS number_of_invoices
	FROM invoices
	GROUP BY client_id
	HAVING number_of_invoices > 1;
    
SELECT
	c.client_id,
    c.name
FROM clients c
WHERE c.client_id IN (
	SELECT client_id
	FROM invoices
	GROUP BY client_id
	HAVING COUNT(invoice_id) > 1
);

SELECT
	c.client_id,
    c.name
FROM clients c
WHERE c.client_id = ANY (
	SELECT client_id
	FROM invoices
	GROUP BY client_id
	HAVING COUNT(invoice_id) > 1
);

SELECT
	c.client_id,
    c.name,
    COUNT(invoice_id) AS number_of_invoices
FROM clients c
JOIN invoices i USING (client_id)
GROUP BY c.client_id
HAVING number_of_invoices > 1;

USE sql_hr;

SELECT
	office_id,
	AVG(salary) as office_average_salary
FROM employees
GROUP BY office_id;

SELECT *
FROM employees e
WHERE salary > (
		SELECT
			AVG(salary)
		FROM employees
        WHERE office_id = e.office_id
);
-- correlated subquery

USE sql_invoicing;


SELECT *
FROM invoices i
WHERE invoice_total > (
	SELECT AVG(invoice_total)
	FROM invoices
	WHERE client_id = i.client_id
    );

SELECT DISTINCT client_id, name
FROM clients
LEFT JOIN invoices USING (client_id)
WHERE invoice_id IS NOT NULL;

SELECT *
FROM clients
WHERE client_id IN (
	SELECT client_id
    FROM invoices
    );
    
-- the above query can take time if there are lots of entires in the invoices table
-- this can be improved by using the EXISTS operator

SELECT *
FROM clients c
WHERE EXISTS (
	SELECT client_id
    FROM invoices
    WHERE client_id = c.client_id
);

USE sql_store;

-- select all products that have not been ordered
SELECT *
FROM products p
WHERE NOT EXISTS (
	SELECT product_id
    FROM order_items
    WHERE product_id = p.product_id
);

USE sql_invoicing;
SELECT
	invoice_id,
    invoice_total,
    AVG(invoice_total) AS invoice_average,
    AVG(invoice_total) - invoice_total AS difference
FROM invoices;

-- the above query only returns one row.. why?
-- the right query is below and uses sub-queries in the SELECT clause

SELECT
	invoice_id,
    invoice_total,
    (SELECT AVG(invoice_total) FROM invoices) AS invoice_average,
    invoice_total - (SELECT invoice_average) AS difference
FROM invoices;

SELECT
	c.client_id,
    name,
    (SELECT SUM(invoice_total) FROM invoices WHERE client_id = c.client_id) AS total_sales,
    (SELECT AVG(invoice_total) FROM invoices) AS invoice_average,
    (SELECT total_sales) - (SELECT invoice_average) AS difference
FROM clients c;

-- subqueries can be used inthe the FROM clause also but it is better to covert it into views and using them imstead
-- subqueries should be given an alias

SELECT *
FROM (
	SELECT
		c.client_id,
		name,
		(SELECT SUM(invoice_total) FROM invoices WHERE client_id = c.client_id) AS total_sales,
		(SELECT AVG(invoice_total) FROM invoices) AS invoice_average,
		(SELECT total_sales) - (SELECT invoice_average) AS difference
	FROM clients c
) AS client_sale_summary
WHERE total_sales IS NOT NULL;

SELECT LTRIM(" ass"); 
SELECT RTRIM("ass  ");
SELECT TRIM(" ass  ");
SELECT LEFT("kindergarden", 4);
SELECT LEFT("kindergarden", 4);
SELECT SUBSTRING("kindergarden",3,4);
SELECT LOCATE("nder","kindergarden");
SELECT REPLACE("kindergarden", "garden", "tree");
 
 USE sql_store;
 
SELECT CONCAT(first_name,' ',last_name) AS full_name
FROM customers;

-- extract fucntions used specially in mysql
SELECT CURDATE();
SELECT CURTIME();
SELECT NOW();
SELECT HOUR(NOW());
SELECT MINUTE(NOW());
SELECT SECOND(NOW());
SELECT DAY(NOW());
SELECT MONTH(NOW());
SELECT WEEK(NOW());
SELECT YEAR(NOW());
SELECT DAYOFWEEK(NOW());
SELECT DAYNAME(NOW());
SELECT MONTHNAME(NOW());

-- for portability in different sql systems, best to use extract
SELECT EXTRACT(YEAR FROM NOW()); 

SELECT *
FROM orders
WHERE YEAR(order_date)>=YEAR(curdate())-1;

SELECT DATE_FORMAT(NOW(), '%y'); 
-- 2 digit
SELECT DATE_FORMAT(NOW(), '%Y');
-- 4 digit
SELECT DATE_FORMAT(NOW(), '%d %m %y');
-- look for mysql date format strings on google to get other formating options

SELECT TIME_FORMAT(NOW(), '%H:%i&p');
-- H hour i minutes p PM/AM

SELECT DATE_ADD(NOW(), INTERVAL 1 DAY);
SELECT DATE_ADD(NOW(), INTERVAL 1 YEAR);
SELECT DATE_ADD(NOW(), INTERVAL -1 DAY);
SELECT DATE_SUB(NOW(), INTERVAL 1 DAY);
SELECT DATEDIFF('2019-01-05', '2019-01-01');
-- only give difference in days and not time - write as (higher - lower) for +ve else -ve
SELECT DATEDIFF('2019-01-05 11:00', '2019-01-01 10:00');
SELECT time_to_sec('9:00') - time_to_sec('12:00')
-- to find difference in times in seconds, time_to_sec give seconds elapsed since midnight

USE sql_store;

SELECT 
	order_id,
    IFNULL(shipper_id , 'Not assigned') AS shipper
FROM orders;
-- exchange null value with the argument

SELECT 
	order_id,
COALESCE(shipper_id , comments, 'Not assigned') AS shipper
FROM orders;
-- exchange null value with first non-null value from the list of colums supplied else use argument

SELECT
	CONCAT(first_name, ' ', last_name) AS name,
    IFNULL(phone, 'unknown') AS phone
FROM customers;

SELECT
	order_id,
    IF(YEAR(order_date)>=YEAR(now())-1, 'Active', 'Archived')
FROM orders;

SELECT
	p.product_id,
    name,
    (SELECT COUNT(product_id) FROM order_items WHERE product_id = p.product_id) AS NumberofOrders,
    IF((SELECT NumberofOrders)>1, 'Many Times', 'Once') AS frequency
FROM products p;
-- can use count(*) instead of product_id also

SELECT
		DISTINCT product_id,
        name,
        COUNT(*) AS orders,
        IF(COUNT(*)>1, 'Many Times', 'Once') AS frequency
FROM order_items
JOIN products
	USING (product_id)
GROUP BY product_id, name;

SELECT
	order_id,
    CASE
		WHEN YEAR(order_date) = YEAR(NOW())-1 THEN 'Active'
        WHEN YEAR(order_date) = YEAR(NOW())-2 THEN 'LY'
        WHEN YEAR(order_date) = YEAR(NOW())-3 THEN 'Archived'
	END AS category
FROM orders;

SELECT
	CONCAT(first_name,' ',last_name) AS full_name,
    points,
    CASE
		WHEN points<2000 THEN 'Bronze'
        WHEN points BETWEEN 2000 AND 3000 THEN 'Silver'
        WHEN points>3000 THEN 'Gold'
	END AS medal
FROM customers
ORDER BY medal ASC;

-- alternatively as each when statement works as an ifelse block, this can be simplified as below
SELECT
	CONCAT(first_name,' ',last_name) AS full_name,
    points,
    CASE
		WHEN points<2000 THEN 'Bronze'
        WHEN points <= 3000 THEN 'Silver'
        ELSE 'Gold'
	END AS medal
FROM customers
ORDER BY medal ASC;

-- using create or replace allows us to alter the view without having to drop it and then recreating it
CREATE OR REPLACE VIEW clients_balance AS
SELECT
	client_id,
    name,
    SUM(invoice_total-payment_total) AS Balance
FROM invoices
JOIN clients
	USING (client_id)
GROUP BY client_id, name;
-- one should save the view query as a sql file and upload it in source control
-- if that is not done, to update a view you will need to click the spanner icon on the view and make changes there

-- updatable views are those which have been created without using DISTINCT, AGGREGATE, GROUP BY or HAVING or UNION statements
CREATE OR REPLACE VIEW invoices_with_balance AS
SELECT
	invoice_id,
    number,
    client_id,
    invoice_total,
    payment_total,
    invoice_total-payment_total AS balance,
    invoice_date,
    due_date,
    payment_date
FROM invoices
WHERE (invoice_total-payment_total>0);

-- these can then be updated like normal sql tables
DELETE FROM invoices_with_balance
WHERE invoice_id = 1;

UPDATE invoices_with_balance
SET due_date = DATE_ADD(due_date, INTERVAL 1 DAY) 
WHERE invoice_id = 2;

UPDATE invoices_with_balance
SET payment_total = invoice_total 
WHERE invoice_id = 3;
-- this deleted the record with invoice no. 2 because of the balance>0 condition on the view creation sql statement
-- to avoid this add WITH CHECK OPTION so that mysql checks with you before deleting or inserting a new record into the view

CREATE OR REPLACE VIEW invoices_with_balance AS
SELECT
	invoice_id,
    number,
    client_id,
    invoice_total,
    payment_total,
    invoice_total-payment_total AS balance,
    invoice_date,
    due_date,
    payment_date
FROM invoices
WHERE (invoice_total-payment_total>0)
WITH CHECK OPTION;

-- benefits of views: simplify queries, reduces impact of changes to underlying tables, restricts access to data

-- create procedures to avoid using sql queries in backend code

DELIMITER $$
	CREATE PROCEDURE get_clients()
	BEGIN
		SELECT * FROM clients;
	END$$
DELIMITER ;

call get_clients();

DELIMITER $$
	CREATE PROCEDURE get_inovoices_with_balance()
	BEGIN
		SELECT 
			invoice_id,
            invoice_total-payment_total AS balance
		FROM invoices
        WHERE (invoice_total-payment_total)>0;
	END$$
DELIMITER ;

-- good standard practise to store each new procedure in a new sql file and then save it with a version control software like git
DROP PROCEDURE IF EXISTS get_inovoices_with_balance;
DELIMITER $$
	CREATE PROCEDURE get_inovoices_with_balance()
	BEGIN
		SELECT *
		FROM invoices_with_balance
        WHERE balance>0;
	END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS get_clients_with_state;

DELIMITER $$
	CREATE PROCEDURE get_clients_with_state
    (
		state CHAR(2)
    )
	BEGIN
		SELECT *
        FROM clients c
        WHERE c.state = state;
	END$$
DELIMITER ;

CALL get_clients_with_state('CA');
CALL get_clients_with_state();

DELIMITER $$
	CREATE PROCEDURE get_invoices_with_client
    (
		client_id INT(11)
    )
    BEGIN
		SELECT *
        FROM invoices i
        WHERE i.client_id = client_id;
	END$$
DELIMITER ;

CALL get_invoices_with_client('5');

-- to make sure that the procedure returns a value even when a NULL parameter is returned define a default value for it like this
DELIMITER $$
	CREATE PROCEDURE get_clients_with_state
    (
		state CHAR(2)
    )
	BEGIN
		IF state IS NULL THEN 
			SET state = 'CA';
		END IF;
        -- remember that we need to end an if statement if outside the select clause
		SELECT *
        FROM clients c
        WHERE c.state = state;
	END$$
DELIMITER ;

-- alternatively we can also make the procedure to return all values if no value is passed in the parameter
DELIMITER $$
	CREATE PROCEDURE get_clients_with_state
    (
		state CHAR(2)
    )
	BEGIN
		IF state IS NULL THEN 
			SELECT *
			FROM clients c;
		ELSE
			SELECT *
			FROM clients c
			WHERE c.state = state;
		END IF;
	END$$
DELIMITER ;

-- this can be written more simply as below
DELIMITER $$
	CREATE PROCEDURE get_clients_with_state
    (
		state CHAR(2)
    )
	BEGIN
		SELECT *
		FROM clients c
		WHERE c.state = IFNULL(state,c.state);
	END$$
DELIMITER ;

DELIMITER $$
	CREATE PROCEDURE get_payments
    (
		client_id INT(11),
        payment_method_id TINYINT(11)
    )
	BEGIN
		SELECT *
		FROM payments p
		WHERE 
			p.client_id = IFNULL(client_id,p.client_id) AND 
            payment_method = IFNULL(payment_method_id,payment_method);
	END$$
DELIMITER ;

-- parameters vs arguments.. parameters are placeholders in definitions of funcitons and procdures, 
-- where as arguments are values passed when fucntions or procedures are called

-- parameter validation needed especially during updation
DELIMITER $$
CREATE PROCEDURE make_payment
(
	invoice_id INT(11),
    payment_amount DECIMAL(9,2),
    payment_date DATE
)
BEGIN
	IF payment_amount<=0 THEN
		SIGNAL SQLSTATE '22003' 
			SET MESSAGE_TEXT = 'Invalid value for payment amount';
	END IF;
    
    UPDATE invoices i
    SET
		i.payment_total = payment_amount,
        i.payment_date = payment_date
	WHERE
		i.invoice_id = invoice_id;
END$$
DELIMITER ;

-- output variables used to send data to the calling procedure
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `unpaid_invoices_total`(
	client_id INT(11),
    OUT invoice_total DECIMAL(9,2),
    OUT	invoices_count INT(2)
)
BEGIN
	SELECT COUNT(*), SUM(invoice_total)
    INTO invoices_count, invoice_total
    FROM invoices i
    WHERE i.client_id = client_id AND
		payment_total = 0;
END$$
DELIMITER ;

-- to call a procedure with output paramenters the following verbose queries are required

set @invoice_total = 0;
set @invoices_count = 0;
call sql_invoicing.unpaid_invoices_total(3, @invoice_total, @invoices_count);
select @invoice_total, @invoices_count;


-- these are called user or session variables and they stay in memory till mysql is restarted eg. set @xyz = 1
-- there are also other tupes of variables called local variables that survive only during procedure call

DELIMITER $$
CREATE PROCEDURE `get_risk_factor`()
BEGIN
	DECLARE risk_factor DECIMAL(9,2) DEFAULT 0;
    DECLARE invoice_total DECIMAL(9,2);
    DECLARE invoice_count INT;
    
	SELECT COUNT(*), SUM(invoice_total)
    INTO invoice_count, invoice_total
    FROM invoices
    WHERE payment_total = 0;
    
    SET risk_factor = invoice_total / inovoice_count*5;
    SELECT risk_factor;
END$$
DELIMITER ;

-- in sql you can also define your own custom functions as follows
DELIMITER $$
CREATE FUNCTION `get_risk_factor_for_client`
(
	client_id INT
)
RETURNS INTEGER
-- DETERMINISTIC if it returns same output for specific input, 
-- but in this case for ssame client id, values can be different at different instances
-- MODIFIES SQL DATA if you insert or update rows or columns
READS SQL DATA
BEGIN
	DECLARE risk_factor DECIMAL(9,2) DEFAULT 0;
    DECLARE invoice_total DECIMAL(9,2);
    DECLARE invoice_count INT;
    
	SELECT COUNT(*), SUM(invoice_total)
    INTO invoice_count, invoice_total
    FROM invoices i
    WHERE i.client_id = client_id;
    
    SET risk_factor = invoice_total/invoice_count*5;
    RETURN IFNULL(risk_factor,0);
END$$
DELIMITER ;

SELECT *, get_risk_factor_for_client(client_id) AS risk_factor
FROM invoices;

-- standard practise to define funtion in new sql file and save it in source control
DROP FUNCTION IF EXISTS get_risk_for_client;
 
 
 USE sql_invoicing;
 
 -- convention for naming triggers tablename_after/before_insert/delete
 DELIMITER $$
 DROP TRIGGER IF EXISTS payments_after_insert;
 CREATE TRIGGER payments_after_insert
 AFTER INSERT ON payments
 FOR EACH ROW
 BEGIN
	UPDATE invoices
    SET payment_total = payment_total + NEW.amount
    WHERE invoice_id = New.invoice_id;
 END $$
 DELIMITER ;
 
 INSERT INTO payments (
 payment_id,
 client_id,
 invoice_id,
 date,
 amount,
 payment_method)
 VALUES (
 DEFAULT,
 5,
 3,
 '2020-03-25',
 102,
 2);

DELIMITER $$
DROP TRIGGER IF EXISTS payments_after_delete;
CREATE TRIGGER payments_after_delete
AFTER DELETE ON payments
FOR EACH ROW
BEGIN
	UPDATE invoices
    SET payment_total = payment_total - OLD.amount
    WHERE invoice_id = OLD.invoice_id;
END $$
DELIMITER ;

DELETE
FROM payments
WHERE payment_id IN (11,12);
 
SHOW TRIGGERS LIKE '%payments';

DROP TRIGGER IF EXISTS payments_after_insert;

-- using triggers for auditing
CREATE TABLE payments_audit
(
	client_id			INT 
    ,date				DATE
    ,amount				DECIMAL(9,2)
    ,action_type			VARCHAR(50)
    ,action_date			DATE
);

DELIMITER $$
 DROP TRIGGER IF EXISTS payments_after_insert;
 CREATE TRIGGER payments_after_insert
 AFTER INSERT ON payments
 FOR EACH ROW
 BEGIN
	UPDATE invoices
    SET payment_total = payment_total + NEW.amount
    WHERE invoice_id = New.invoice_id;
    
    INSERT INTO payments_audit
    VALUES (
    NEW.client_id 
    , NEW.date
    , NEW.amount
    , 'Insert'
    , NOW());
 END $$
 DELIMITER ;
 
DELIMITER $$
DROP TRIGGER IF EXISTS payments_after_delete;
CREATE TRIGGER payments_after_delete
AFTER DELETE ON payments
FOR EACH ROW
BEGIN
	UPDATE invoices
    SET payment_total = payment_total - OLD.amount
    WHERE invoice_id = OLD.invoice_id;
    
   INSERT INTO payments_audit
    VALUES (
    OLD.client_id 
    , OLD.date
    , OLD.amount
    , 'Delete'
    , NOW()); 
END $$
DELIMITER ;

SHOW VARIABLES LIKE 'event%';

-- to set event scheduler off or on
SET GLOBAL event_scheduler = OFF; 

DELIMITER $$
CREATE EVENT yearly_delete_stale_audit_rows
ON SCHEDULE
-- AT '2019-01-01'
EVERY 1 YEAR STARTS '2019-01-01' ENDS '2022-01-01'
DO
BEGIN
	DELETE FROM payments_audit
    WHERE action_date = NOW() - INTERVAL 1 YEAR;
END $$
DELIMITER ;

SHOW EVENTS;
SHOW EVENTS LIKE '%yearly';
DROP EVENT IF EXISTS yearly_delete_stale_audit_rows;
-- ALTER EVENT; can be used in place to the original create event statement to make changes to the event but also to enable/disable specific events
ALTER EVENT yearly_delete_stale_audit_rows ENABLE;

USE sql_store;

-- transaction ensures all statements before commit are executed as a block
-- transaction is ACID : 
	-- Atomic - executed as a block or not
    -- Consistent - data always remains consistent
    -- Isolated - transactions are protected from eachother if they try to act on same data
    -- Durable - once transactions are committed the change is permanent and cannot be impacted by a power failure

START TRANSACTION;
INSERT INTO orders (customer_id, order_date, status)
VALUES(1,'2019-01-01',1);

INSERT INTO order_items
VALUES(LAST_INSERT_ID(),1,1,1);
COMMIT;

-- used instead of commit to manually rollback last transaction
-- ROLLBACK; 

-- whenever we run an insert, delete or update statement mysql wraps it into insert and commit statements
-- and this is controlled by system variables like auto_commit

SHOW VARIABLES LIKE '%commit';

-- concurrency of transactions
-- if a transaction modifies a row or a column, it locks any other transaction from making changes to it
-- test by opening another instance of the this database and executed below queries line by line
USE sql_store;

START TRANSACTION;
UPDATE customers
SET points = points + 10
WHERE customer_id = 1;
COMMIT;	

-- concurrency problems that can occur: 
	-- LOST UPDATES: one transaction commits before another modifying a field in the same row commits and hence those details are lost
    -- DIRTY READS: reads a field that is not yet committed and takes action
    -- NON-REPEATING: if we read the same data twice in a transaction but before we read it the second time it has been modifed by another transaction
    -- PHANTOM READS: when we miss one or more rows in our data because another transaction is modifying the eligible data and we are not aware

-- are handled by diffrent isolation levels:
	-- READ UNCOMMITTED: no protection from concurrency problems
    -- READ COMMITTED: Prevents dirty reads, but cannot avoid errors occuring when one transaciton has multiple reads inside
    -- REPEATABLE READS: Prevents lost updates, dirty reads and non-repeating reads
    -- SERIALIZABLE Prevents all because it makes transaction wait until all other transactions that can modify the same data have been executed
					-- transaction waits for most recent update of data
					-- but puts load or slowsdown the system if there are lot of concurrent transactions happening at once
	-- lower isolation allows more concurrency but at the cost of more errors
    -- higher isoloation level reduces concurrency but it requires more resources in the form of logs and cpu memory for scheduling transactions
    -- default level is repeatable reads
    
    SHOW VARIABLES LIKE 'transaction_isolation';
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    -- suggested to use session keyword to effect the transaction isolation only to your connection instance with the database
    SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    -- global will change the transaction level for all other connection instance to that database
    SET GLOBAL TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    
    -- see videos on isolation levels and deadlocks
    
    -- Data Types
    -- STRINGS
    -- VARCHAR(50) short strings
    -- VARCHAR (255) medium strings
    -- VARCHAR (65,535) max ie. 64KB
    -- MEDIUMTEXT (16MB)
    -- LONGTEXT (4GB)
    -- TINYTEXT (255) 255 bytes
    -- TEXT 64KB
    -- ENGLISH language = 1 byte, European and Middle Easter = 2 bytes, Asian languages = 3 bytes
    
    -- INTEGERS
    -- TINYINT	 			1b [-127,128]
    -- UNSIGNED	 TINYINT	1b [0,255]
    -- SMALLINT	 			2b [-32k, 32k]
    -- MEDIUMINT 			3b [-8M, 8M]
    -- INT					4b
    -- BIGING				8b
    
    -- ZEROFILL 
    -- INT(4) -> 0004
    
    -- RATIONALS
    -- DECIMAL(p,s) = precision (total digits), scale(max after scale) and P<=65 and D<=30
    -- DEC, NUMERIC, FIXED
    -- float and double store no.s in binary exponential expression, so they can store large no.s but precison is lost
    -- FLOAT 4b
    -- DOUBLE 8b
    
    -- TRUE / FALSE => 1/0, and hence booleans are actaully tinyint
    -- BOOL 
    -- BOOLEAN
    
    -- ENUM - a set to stores limited string values... advised to make a looktable of sizes (S,M,L) instead of a enum data type
    -- SET - stores multiple string values
    
    -- DATE
    -- TIME
    -- DATETIME 8b
    -- TIMESTAMP 4b and can only store values till 2038
    -- YEAR
    
    -- BLOBS for storing binary data like pics... but better not to store in sql db, which is for structured relational data vs binaray data
    -- thats wastes db space, makes it slow to read and write, also additional code is needed
    -- TINYBLOB 255b
    -- BLOB 64kb
    -- MEDIUMBLOB 16MB
    -- LONGBLOB 4GB
	
    -- JSON OBJECT
     
    USE sql_store;
    
    UPDATE products
    SET properties = NULL;
    
    -- 1st way of creating a json object 
    UPDATE products
    SET properties = '
    {
		"dimensions": [1,2,3],
        "weight": 10,
        "manufacturer": {"name": "sony"}
    }'
    WHERE product_id = 1;
    
-- 2nd way of creating a json object 
    UPDATE products
    SET properties = JSON_OBJECT(
		'weight',10,
        'dimensions', JSON_ARRAY(1,2,3),
        'manufacturer', JSON_OBJECT('name', 'sony')
        )
    WHERE product_id = 2;

    SELECT *
    FROM products;
    
    -- 1 way to extract a specific value from JSON object key
    SELECT product_id, JSON_EXTRACT(properties, '$.weight')
    FROM products
    WHERE product_id = 1;
    
    -- popular way to achieve the same result for values
    SELECT product_id, properties -> '$.weight' AS weight
    FROM products
    WHERE product_id = 1;
    
     -- popular way to achieve the same result for values from arrays (dimension stores array type) 
    SELECT product_id, properties -> '$.dimensions[0]' AS all_dimensions
    FROM products
    WHERE product_id = 1;
    
    -- popular way to achieve the same result for values from objects (manufacturer is a nested json object)
    SELECT product_id, properties -> '$.manufacturer.name' AS manfac_name
    FROM products
    WHERE product_id = 1;
    
    -- above gives string value in double quotes, to get value without quotes use ->> instead of ->
	SELECT product_id, properties ->> '$.manufacturer.name' AS manfac_name
    FROM products
    WHERE product_id = 1;
    
    -- so, then the expression can be used in where clause
    SELECT product_id, properties ->> '$.manufacturer.name' AS manfac_name
    FROM products
    WHERE properties ->> '$.manufacturer.name' = 'sony';
    
    -- updating a JSON object to set or add key value pairs
    UPDATE products
    SET properties = JSON_SET(
    properties,
    '$.weight', 20,
    '$.age', 12
    )
    WHERE product_id = 1; 
    
    SELECT product_id, properties
    FROM products
    WHERE properties ->> '$.manufacturer.name' = 'sony';
    
    -- updating a JSON object to remove key value pairs
    UPDATE products
    SET properties = JSON_REMOVE(
    properties,
    '$.age'
    )
    WHERE product_id = 1; 
    