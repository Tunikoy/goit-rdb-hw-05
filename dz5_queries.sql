-- 1. SELECT з вкладеним SELECT
USE goit_hw3;

SELECT od.*, 
       (SELECT customer_id FROM orders WHERE orders.id = od.order_id) AS customer_id
FROM order_details od;

-- 2. Вкладений запит у WHERE
SELECT * 
FROM order_details 
WHERE order_id IN (
    SELECT id FROM orders WHERE shipper_id = 3
);

-- 3. Вкладений запит у FROM з агрегацією
SELECT order_id, AVG(quantity) AS avg_quantity
FROM (
    SELECT * FROM order_details WHERE quantity > 10
) AS filtered
GROUP BY order_id;

-- 4. WITH (CTE) — тимчасова таблиця
WITH temp AS (
    SELECT * FROM order_details WHERE quantity > 10
)
SELECT order_id, AVG(quantity) AS avg_quantity
FROM temp
GROUP BY order_id;

-- 5. Функція ділення + використання
DROP FUNCTION IF EXISTS divide_values;

DELIMITER //

CREATE FUNCTION divide_values(a FLOAT, b FLOAT) RETURNS FLOAT
DETERMINISTIC
BEGIN
    RETURN a / b;
END;
//

DELIMITER ;

SELECT id, quantity, divide_values(quantity, 2) AS result
FROM order_details;
