create table customers (
    customer_id int primary key,
    name varchar(100),
    email varchar(100),
    password varchar(100)
);

create table products (
    product_id int primary key,
    name varchar(100),
    price decimal(10,2),
    description varchar(255),
    stockquantity int
);
select * from products;

create table cart (
    cart_id int primary key,
    customer_id int foreign key references customers(customer_id),
    product_id int foreign key references products(product_id),
    quantity int
);

create table orders (
    order_id int primary key,
    customer_id int foreign key references customers(customer_id),
    order_date date,
    total_price decimal(10,2),
    shipping_address varchar(255)
);
select * from orders;

create table order_items (
    order_item_id int primary key,
    order_id int foreign key references orders(order_id),
    product_id int foreign key references products(product_id),
    quantity int,
    itemamount decimal(10,2)
);
alter table customers add address varchar(255);


-- insert values

insert into products (product_id, name, price, description, stockquantity) values
(1, 'laptop', 800.00, 'high-performance laptop', 10),
(2, 'smartphone', 600.00, 'latest smartphone', 15),
(3, 'tablet', 300.00, 'portable tablet', 20),
(4, 'headphones', 150.00, 'noise-canceling', 30),
(5, 'tv', 900.00, '4k smart tv', 5),
(6, 'coffee maker', 50.00, 'automatic coffee maker', 25),
(7, 'refrigerator', 700.00, 'energy-efficient', 10),
(8, 'microwave oven', 80.00, 'countertop microwave', 15),
(9, 'blender', 70.00, 'high-speed blender', 20),
(10, 'vacuum cleaner', 120.00, 'bagless vacuum cleaner', 10);


insert into orders (order_id, customer_id, order_date, total_price, shipping_address) values
(1, 1, '2023-01-05', 1200.00, '123 main st, city'),
(2, 2, '2023-02-10', 900.00, '456 elm st, town'),
(3, 3, '2023-03-15', 300.00, '789 oak st, village'),
(4, 4, '2023-04-20', 150.00, '101 pine st, suburb'),
(5, 5, '2023-05-25', 1800.00, '234 cedar st, district'),
(6, 6, '2023-06-30', 400.00, '567 birch st, county'),
(7, 7, '2023-07-05', 700.00, '890 maple st, state'),
(8, 8, '2023-08-10', 160.00, '321 redwood st, country'),
(9, 9, '2023-09-15', 140.00, '432 spruce st, province'),
(10, 10, '2023-10-20', 1400.00, '765 fir st, territory');

insert into customers (customer_id, name, email, password, address) values
(1, 'john doe', 'johndoe@example.com', 'pass123!', '123 main st, city'),
(2, 'jane smith', 'janesmith@example.com', 'letmein456', '456 elm st, town'),
(3, 'robert johnson', 'robert@example.com', 'r0bsecure', '789 oak st, village'),
(4, 'sarah brown', 'sarah@example.com', 's4r@hrocks', '101 pine st, suburb'),
(5, 'david lee', 'david@example.com', 'david1234', '234 cedar st, district'),
(6, 'laura hall', 'laura@example.com', 'laur@19	89', '567 birch st, county'),
(7, 'michael davis', 'michael@example.com', 'm!kepass', '890 maple st, state'),
(8, 'emma wilson', 'emma@example.com', 'emma2023', '321 redwood st, country'),
(9, 'william taylor', 'william@example.com', 'wtaylor$', '432 spruce st, province'),
(10, 'olivia adams', 'olivia@example.com', 'liv3itup', '765 fir st, territory');

insert into order_items (order_item_id, order_id, product_id, quantity, itemamount) values
(1, 1, 1, 2, 1600.00),
(2, 1, 3, 1, 300.00),
(3, 2, 2, 3, 1800.00),
(4, 3, 5, 2, 1800.00),
(5, 4, 4, 4, 600.00),
(6, 4, 6, 1, 50.00),
(7, 5, 1, 1, 800.00),
(8, 5, 10, 2, 1200.00),
(9, 6, 2, 2, 240.00),
(10, 6, 9, 3, 210.00);


insert into cart (cart_id, customer_id, product_id, quantity) values
(1, 1, 1, 2),
(2, 1, 3, 1),
(3, 2, 2, 3),
(4, 3, 4, 4),
(5, 3, 5, 2),
(6, 4, 6, 1),
(7, 5, 1, 1),
(8, 6, 10, 2),
(9, 6, 9, 3),
(10, 7, 7, 2);


-- questions

--1. update fridge price 
update products set price = 800 where name = 'refrigerator';
 

-- 2. remove cart irems from a customer
delete from cart where customer_id = 2;
select * from cart;


--3.	get products below 100 usd
select * from products where price < 100;

--4 products with stock quanityt > 5
select * from products where stockquantity > 5;


--5. orders with tot amt between 500 and 1000
select * from orders where total_price between 500 and 1000;

--6. prod name end with letter r
select * from products where name like '%r';


--7. retrieve customer 5 cart 
select * from cart where customer_id = 5;


--8. customers who places order in 2023
select distinct c.* from customers c join orders o on c.customer_id = o.customer_id where year(order_date) = 2023;


--9.minimun stock quan for each prod category
-- no columm names category given 

-- 10. tot amount spent by each customer
select customer_id, sum(total_price) as total_spent from orders group by customer_id;


--11. avg order amt for each customer
select customer_id, avg(total_price) as average_order from orders group by customer_id;


--12.no of orders placed by each cutomer
select customer_id, count(*) as order_count from orders group by customer_id;


--13. max order amt for each cust
select customer_id, max(total_price) as max_order from orders group by customer_id;


--14. Get customers who placed orders totaling over $1000
select customer_id from orders group by customer_id having sum(total_price) > 1000;


--15. sub query to find items not in cart
select * from products where product_id not in (select product_id from cart);


--16. customers who havent placed orders
select * from customers where customer_id not in (select customer_id from orders);
--since all customers hav order the output will be empty , so deelet one row to get an ouptut
delete from orders where customer_id = 10;


--17. percentage of totoal rev for a product
select product_id, 
       sum(itemamount) * 100.0 / (select sum(itemamount) from order_items) as revenue_percentage 
from order_items 
group by product_id;


--18. prod with low stock
select * from products where stockquantity < (select avg(stockquantity) from products);


-- 19. customers who placed high value orders
select distinct customer_id from orders where total_price > 1000;







	