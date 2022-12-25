/* Инструкция: 
Шаг 1. Изучите материалы лекционных и практических занятий по теме 7.1-7.4. 
Шаг 2. Напишите SQL запросы к базе данных "Корпорация" по заданию ниже.
Шаг 4. Опубликуйте файл расширения sql на платформу Odin.
*/
 -- Выполнил Кожедуб Надежда Сергеевна
 
-- 1. Для каждого продавца (job_id=670) вывести разность между его зарплатой и 
-- средней зарплатой продавцов в отделе c кодом 23. 
select last_name, first_name, job_id, salary, salary - (select avg(salary) from employee where department_id = 23)  as "Разность"
from employee
where job_id = 670;

-- 2. Выбрать среднюю сумму продаж, которая приходится на одного сотрудника в городе NEW YORK.

select avg(total) as 'Средняя сумма продаж' 
from employee e join DEPARTMENT d 
on d.department_id = e.department_id 
join LOCATION l on l.location_id = d.location_id 
join CUSTOMER c on c.salesperson_id = e.employee_id 
join SALES_ORDER so on so.customer_id = c.customer_id
where l.regional_group = 'NEW YORK';

-- 3. Определить, какой продукт был наиболее популярен весной 2019г (по количеству проданных экземпляров quantity).
select p.product_id, p.description, sum(i.quantity) 
from PRODUCT p 
join ITEM i on i.product_id = p.product_id 
join SALES_ORDER so on so.order_id = i.order_id 
where year(so.order_date) = 2019  and month(so.order_date) between 3 and 5
group by p.product_id
order by sum(i.quantity) desc
limit 1; 

-- 4. Выбрать товары, наиболее популярные в каждом городе (по количеству проданных экземпляров quantity).

Select t1.description, t1.st, t1.regional_group
from  (SELECT description, sum(quantity) as st, regional_group
FROM department, employee, customer, sales_order, item, location, product
WHERE department.department_id=employee.department_id
AND employee_id=salesperson_id
AND customer.customer_id= sales_order.customer_id
AND sales_order.order_id=item.order_id
and department.location_id=location.location_id
and item.product_id=product.product_id 
group by description) as t1
where st = 
(SELECT max(t2.st)
FROM (SELECT description, sum(quantity) as st, regional_group
FROM department, employee, customer, sales_order, item, location, product
WHERE department.department_id=employee.department_id
AND employee_id=salesperson_id
AND customer.customer_id= sales_order.customer_id
AND sales_order.order_id=item.order_id
and department.location_id=location.location_id
and item.product_id=product.product_id 
group by description) as t2
where t2.regional_group=t1.regional_group);
     
--  5. Выбрать данные для построения графика зависимости суммы продажи 
-- от процента представленной покупателю скидки.
select round(((p.list_price - i.actual_price)/p.list_price*100),1) as "% скидки", round (i.total,1) as "сумма продажи"
from item i
join price p on p.product_id = i.product_id
join sales_order so on i.order_id = so.order_id
where so.order_date between p.start_date and p.end_date
order by (p.list_price - i.actual_price)/p.list_price*100 desc;
