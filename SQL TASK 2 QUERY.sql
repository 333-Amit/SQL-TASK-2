

create table customers 
(customer_id serial primary key,customer_name varchar,city varchar,
 phone_number bigint,emai varchar,registration_date date ); 


create table orders 
(order_id serial primary key,customer_id int references customers(customer_id),
 order_date date,order_amount int,delivery_city varchar,payment_mode varchar); 


create table products 
( product_id serial primary key,product_name varchar,category varchar,price int,stock_quantity int,
 supplier_name varchar,supplier_city varchar,supply_date date);


create table order_items 
( order_item_id serial primary key,order_id int references orders(order_id),
 product_id int references products(product_id),quantity int,total_price int ); -- success 4 , data import 3



     /*   1. JOINS   */
	 
/*    que.1  Retrieve the customer_name, city, and order_date for each customer who
             placed an order in 2023 by joining the customers and orders tables.                 
*/

select c.customer_name, c.city,o.order_date from customers c
join orders o on c.customer_id = o.customer_id 
where extract(year from o.order_date) = 2023           -- success. 19 rows



/*    que.2  Get a list of all products (with product_name, category, and total_price)
             ordered by customers living in Mumbai, by joining the customers, orders,
             order_items, and products tables.                                                    
*/

select p.product_name, p.category, oi.total_price from customers c
join orders o on  c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id
join products p on p.product_id = oi.product_id 
where c.city = 'Mumbai';                                -- success 3 rows




/*    que.3  Find all orders where customers paid using 'Credit Card' and display the
             customer_name, order_date, and total_price by joining the customers,
             orders, and order_items tables.                                                                
*/                                                                                                  

select c.customer_name,o.order_date,oi.total_price from customers c
join orders o on  c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id
where o.payment_mode = 'Credit Card';                      -- success. 10 rows



/*    que.4  Display the product_name, category, and the total_price for all products
             ordered in the first half of 2023 (January - June) by joining the orders
			 order_items, and products tables.                                                    
*/

select p.product_name,p.category, oi.total_price from orders o
join order_items oi on o.order_id = oi.order_id
join products p on p.product_id = oi.product_id
where extract(year from order_date) = 2023 and extract(month from order_date) between 01 and 06  -- success.   14 rows


/*    que.5  Show the total number of products ordered by each customer, displaying
             customer_name and total products ordered, using joins between
             customers, orders, and order_items.                                                                    
*/

select c.customer_name, sum(oi.quantity) as "Total Products Ordered" from customers c
join orders o on  c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id
group by c.customer_id -- or c.customer_name                          -- success.  28 customers    

   
  
   
   /*    2. DISTINCT    */


/*    que.1  Get a distinct list of cities where customers are located
*/

select distinct(city) from customers;  -- success.  40 cities


/*    que.2  Retrieve distinct supplier_name from the products table 
*/

select distinct(supplier_name) from products;  -- success. 20 suppliers


/*    que.3  Find distinct payment methods used in the orders table.
*/

select distinct(payment_mode) from orders;  -- success.  5 payment modes


/*    que.4  List all distinct product categories that have been ordered.
*/

select distinct(category) from products;  -- success.  4 categories.
 

/*    que.5  Find distinct cities from which suppliers supply products by querying the products table.
*/

select distinct(supplier_city) from products;  -- success. 10 supplier cities


    
	
	/*   3. ORDER BY   */
   

/*    que.1  List all customers sorted by customer_name in ascending order.
*/

select * from customers
order by customer_name asc; -- success.  


/*    que.2  Display all orders sorted by total_price in descending order.
*/

select * from order_items 
order by total_price desc; -- success 


/*    que.3  Retrieve a list of products sorted by price in ascending order and then by category in descending order.
*/

select product_name,price,category from products
order by price asc , category desc; -- success  20 rows 



/*    que.4  Sort all orders by order_date in descending order and display the order_id,customer_id, and order_date.
*/

select order_id,customer_id,order_date from orders
order by order_date desc; -- success


/*    que.5  Get the list of cities where orders were placed, sorted in alphabetical order,
             and display the total number of orders placed in each city.
*/

select o.delivery_city, count(o.order_id) as "total no. of orderes" from customers c
join orders o on  c.customer_id = o.customer_id
group by o.delivery_city
order by o.delivery_city asc;  -- success  39 cities

 


/*   4. LIMIT AND OFFSET   */   
	 

/*    que.1  Retrieve the first 10 rows from the customers table ordered by customer_name.
*/

select * from customers
order by customer_name asc
limit 10; -- success


/*    que.2  Display the top 5 most expensive products (sorted by price in descending order).
*/

select  product_name,price from products
order by price desc
limit 5;  -- success


/*    que.3  Get the orders for the 11th to 20th customers (using OFFSET and LIMIT), sorted by customer_id.
*/ 

select * from orders
order by customer_id asc
limit 10 offset 10;  -- succes.


/*    que.4  List the first 5 orders placed in 2023, displaying order_id, order_date, and customer_id.
*/

select order_id,order_date,customer_id from orders 
where extract(year from order_date) = 2023
order  by order_date asc
limit 5;                             -- success


/*    que.5  Fetch the next 10 distinct cities where orders were placed, using LIMIT and OFFSET.
*/

select distinct(delivery_city) from orders     
limit 10 offset 10;            -- success



     /*   5. AGGREGATE FUNCTIONS   */    


/*     que.1  Calculate the total number of orders placed by all customers.
*/

select count(o.order_id) from orders o
join customers c on  c.customer_id = o.customer_id  -- success  40 orders. 
     

/*     que.2  Find the total revenue generated from orders paid via 'UPI' from the orders table.
*/

select sum(order_amount) as "Total Revenue"  from orders
where payment_mode = 'UPI';    -- SUCCESS 21,100


/*     que.3  Get the average price of all products in the products table.
*/

select round(avg(price),2) as "Average Price" from products -- success. 17012



/*     que.4  Find the maximum and minimum total price of orders placed in 2023
*/


select extract( year from o.order_date) as year , 
max(oi.total_price) as "Max. Price of order" ,
min(oi.total_price) as "Min. Price of order" from orders o
join order_items oi on o.order_id = oi.order_id
group by year having extract( year from o.order_date) = 2023    -- success....max = 55,000  min = 1,500 
 


/*    que.5  Calculate the total quantity of products ordered for each product_id using the order_items table
*/

select product_id, sum(quantity) from order_items
group by product_id
order by product_id asc; -- success
    




/*   6. SET OPERATIONS   */
	 
	 
/*     que.1  Get the list of customers who have placed orders in both 2022 and 2023 (use INTERSECT). 
                
*/

select c.customer_name from customers c
join orders o on c.customer_id = o.customer_id 
where extract(year from order_date) = 2022

INTERSECT

select c.customer_name from customers c
join orders o on c.customer_id = o.customer_id 
where extract(year from order_date) = 2023;    -- success.  1 CUSTOMER RAJESH SHARMA



/*     que.2  Find the products that were ordered in 2022 but not in 2023 (use EXCEPT). 
*/

select product_name from products 
where product_id in(select product_id from orders o
join order_items oi on o.order_id = oi.order_id
where extract(year from o.order_date) = 2022)

EXCEPT 

select product_name from products 
where product_id in( select product_id from orders o
join order_items oi on o.order_id = oi.order_id
where extract(year from o.order_date) = 2023)  -- success .. 6 products


/*    que.3  Display the list of supplier_city from the products table that do not match
             any customer_city in the customers table (use EXCEPT).  
*/

select supplier_city from products p

EXCEPT

select city from customers c



/*    que.4  Show a combined list of supplier_city from products and city from customers (use UNION).
*/                   

select supplier_city from products p

UNION 

select city from customers c   -- 40  CITIES



/*    que.5  Find the list of product_name from the products table that were ordered in
             2023 (use INTERSECT with the orders and order_items tables).
*/

select product_name from products 
where product_id in
( select product_id from products  
 
 INTERSECT 

 select product_id from order_items join orders o using(order_id)
 where extract(year from order_date) = 2023                -- 13 products
)







     /*   7. SUB QUERIES   */  

/*    que.1  Find the names of customers who placed orders with a total price greater
             than the average total price of all orders.
*/

select customer_name from customers where  customer_id in
(
select o.customer_id from orders o join order_items oi on o.order_id = oi.order_id
group by customer_id having sum(total_price) > (select round(avg(total_price),2) from order_items)
)                  --- 13 customer names



/*    que.2  Get a list of products that have been ordered more than once by any customer.  
*/

select product_name from products 
where product_id in( select product_id from order_items group by product_id having count(*) > 1)  -- 10 product names


/*    que.3  Retrieve the product names that were ordered by customers from Pune using a subquery.
*/
   
select product_name from products 
where product_id in (
select product_id from order_items oi 
join orders o  using(order_id)
join customers c using (customer_id)
where c.city = 'Pune' )             -- Microwave Oven
                     


/*    que.4  Find the top 3 most expensive orders using a subquery.
*/

select order_id ,order_amount from orders
where order_amount in(select order_amount from orders group by order_amount order by order_amount desc limit 3 )
order by order_amount desc   -- 4000 , 3500 , 3400



/*    que.5  Get the customer names who placed orders for a product that costs more than ₹30,000 using a subquery.
*/

select c.customer_name, p.price from customers c
join orders o on  c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id
join products p on p.product_id = oi.product_id
where p.price > (select total_price from order_items group by total_price having  total_price = 30000 ) -- success 8 names







