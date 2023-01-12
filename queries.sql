-- - Название компании заказчика (`company_name` из табл. `customers`) 
-- и ФИО сотрудника, работающего над заказом этой компании 
-- (см таблицу `employees`), когда и заказчик и сотрудник 
-- зарегистрированы в городе `London`, а доставку заказа ведет 
-- компания `United Package` (`company_name` в табл `shippers`)

SELECT cus.company_name
     , e.first_name || ' ' || e.last_name as employee_name
FROM customers AS cus
JOIN orders AS o USING (customer_id)
JOIN employees  AS e USING (employee_id)
JOIN shippers AS sh ON o.ship_via = sh.shipper_id
WHERE cus.city = 'London' 
AND e.city = 'London'
AND sh.company_name = 'United Package';

-- Наименование продукта, количество товара (`product_name` и 
-- `units_in_stock` в табл `products`), имя поставщика и его 
-- телефон (`contact_name` и `phone` в табл `suppliers`) для таких 
-- продуктов, которые не сняты с продажи (поле `discontinued`) и 
-- которых меньше `25` и которые в категориях `Dairy Products` и 
-- `Condiments`. Отсортировать результат по возрастанию количества 
-- оставшегося товара.

SELECT pr.product_name, pr.units_in_stock, s.contact_name, s.phone
FROM products AS pr
JOIN suppliers AS s USING (supplier_id)
JOIN categories AS cat USING (category_id)
WHERE pr.discontinued <> 1
AND pr.units_in_stock < 25
AND cat.category_name IN ('Dairy Products', 'Condiments')
ORDER BY pr.units_in_stock;

-- Список компаний заказчиков (company_name из табл customers), 
-- не сделавших ни одного заказа

SELECT cus.company_name
FROM customers AS cus
WHERE NOT EXISTS (
	SELECT 1
	FROM orders AS o
	WHERE o.customer_id = cus.customer_id
)


-- ЗАДАНИЕ 2

-- уникальные названия продуктов, которых заказано ровно 10 единиц 
-- (количество заказанных единиц см в колонке quantity табл 
-- order_details)

SELECT DISTINCT pr.product_name
FROM products AS pr
WHERE pr.product_id = ANY (
    SELECT o_d.product_id
	FROM order_details AS o_d
	WHERE o_d.quantity = 10
);

