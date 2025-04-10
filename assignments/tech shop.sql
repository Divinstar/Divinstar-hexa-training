create database techshop
go

use techshop
go

create table customers (
    customerid int primary key identity(1,1),
    firstname nvarchar(50) not null,
    lastname nvarchar(50) not null,
    email nvarchar(100) not null unique,
    phone nvarchar(20),
    address nvarchar(255)
)
go

create table products (
    productid int primary key identity(1,1),
    productname nvarchar(100) not null,
    description nvarchar(255),
    price decimal(10,2) not null
)
go

create table orders (
    orderid int primary key identity(1,1),
    customerid int not null,
    orderdate datetime not null default getdate(),
    totalamount decimal(10,2) not null,
    foreign key (customerid) references customers(customerid)
)
go

create table orderdetails (
    orderdetailid int primary key identity(1,1),
    orderid int not null,
    productid int not null,
    quantity int not null,
    foreign key (orderid) references orders(orderid),
    foreign key (productid) references products(productid)
)
go

create table inventory (
    inventoryid int primary key identity(1,1),
    productid int not null,
    quantityinstock int not null,
    laststockupdate datetime not null default getdate(),
    foreign key (productid) references products(productid)
)
go


insert into customers (firstname, lastname, email, phone, address) values
('john', 'doe', 'john.doe@example.com', '1234567890', '123 main street'),
('jane', 'smith', 'jane.smith@example.com', '2345678901', '456 park avenue'),
('michael', 'johnson', 'michael.johnson@example.com', '3456789012', '789 elm road'),
('emily', 'davis', 'emily.davis@example.com', '4567890123', '321 oak lane'),
('david', 'wilson', 'david.wilson@example.com', '5678901234', '654 maple drive'),
('linda', 'martin', 'linda.martin@example.com', '6789012345', '987 pine street'),
('robert', 'clark', 'robert.clark@example.com', '7890123456', '135 cedar court'),
('patricia', 'lewis', 'patricia.lewis@example.com', '8901234567', '246 birch boulevard'),
('charles', 'walker', 'charles.walker@example.com', '9012345678', '369 spruce terrace'),
('barbara', 'hall', 'barbara.hall@example.com', '0123456789', '147 fir avenue')
go

insert into products (productname, description, price) values
('smartphone', 'latest model smartphone', 699.99),
('laptop', 'high performance laptop', 1299.50),
('tablet', 'lightweight tablet', 499.00),
('smartwatch', 'fitness tracking smartwatch', 199.99),
('headphones', 'wireless noise cancelling headphones', 299.99),
('gaming console', 'next gen gaming console', 499.99),
('bluetooth speaker', 'portable bluetooth speaker', 149.49),
('camera', 'dslr camera with lens kit', 899.95),
('monitor', '4k ultra hd monitor', 399.89),
('keyboard', 'mechanical gaming keyboard', 129.99)
go

insert into orders (customerid, orderdate, totalamount) values
(1, '2025-04-01', 1299.50),
(2, '2025-04-02', 499.00),
(3, '2025-04-03', 699.99),
(4, '2025-04-04', 299.99),
(5, '2025-04-05', 149.49),
(6, '2025-04-06', 399.89),
(7, '2025-04-07', 899.95),
(8, '2025-04-08', 499.99),
(9, '2025-04-09', 129.99),
(10, '2025-04-10', 199.99)
go

insert into orderdetails (orderid, productid, quantity) values
(1, 2, 1),
(2, 3, 1),
(3, 1, 1),
(4, 5, 1),
(5, 7, 1),
(6, 9, 1),
(7, 8, 1),
(8, 6, 1),
(9, 10, 1),
(10, 4, 1)
go

insert into inventory (productid, quantityinstock, laststockupdate) values
(1, 50, '2025-04-01'),
(2, 30, '2025-04-01'),
(3, 40, '2025-04-01'),
(4, 25, '2025-04-01'),
(5, 60, '2025-04-01'),
(6, 20, '2025-04-01'),
(7, 35, '2025-04-01'),
(8, 15, '2025-04-01'),
(9, 45, '2025-04-01'),
(10, 55, '2025-04-01')
go

--part 2
-- 1
select firstname, lastname, email from customers
go

-- 2
select orders.orderid, orders.orderdate, customers.firstname, customers.lastname
from orders
join customers on orders.customerid = customers.customerid
go

-- 3

insert into customers (firstname, lastname, email, phone, address) values
('alex', 'brown', 'alex.brown123@example.com', '1122334455', '500 river street')
go

-- 4
update products
set price = price * 1.10
go

-- 5
declare @orderid int = 1

delete from orderdetails where orderid = @orderid
delete from orders where orderid = @orderid
go

-- 6
insert into orders (customerid, orderdate, totalamount) values
(2, getdate(), 0)
go

-- 7
declare @customerid int = 3
declare @newemail nvarchar(100) = 'new.email@example.com'
declare @newaddress nvarchar(255) = '777 new road'

update customers
set email = @newemail, address = @newaddress
where customerid = @customerid
go

-- 8
update orders
set totalamount = isnull((
    select sum(products.price * orderdetails.quantity)
    from orderdetails
    join products on orderdetails.productid = products.productid
    where orderdetails.orderid = orders.orderid
), 0)
go

-- 9
delete from customers
where firstname like '%test%' or email like '%test%'
go


-- part 3

-- 1. write an sql query to retrieve a list of all orders along with customer information (e.g., customer name) for each order
select orders.orderid, customers.firstname, customers.lastname, customers.email, orders.orderdate, orders.totalamount
from orders
join customers on orders.customerid = customers.customerid
go

-- 2. write an sql query to find the total revenue generated by each electronic gadget product. include the product name and the total revenue
select products.productname, sum(products.price * orderdetails.quantity) as total_revenue
from products
join orderdetails on products.productid = orderdetails.productid
group by products.productname
go

-- 3. write an sql query to list all customers who have made at least one purchase. include their names and contact information
select distinct customers.firstname, customers.lastname, customers.email, customers.phone, customers.address
from customers
join orders on customers.customerid = orders.customerid
go

-- 4. write an sql query to find the most popular electronic gadget, which is the one with the highest total quantity ordered. include the product name and the total quantity ordered
select top 1 products.productname, sum(orderdetails.quantity) as total_quantity_ordered
from products
join orderdetails on products.productid = orderdetails.productid
group by products.productname
order by total_quantity_ordered desc
go

-- 5. write an sql query to retrieve a list of electronic gadgets along with their corresponding categories
select productid, productname, description
from products
go

-- 6. write an sql query to calculate the average order value for each customer. include the customer's name and their average order value
select customers.firstname, customers.lastname, avg(orders.totalamount) as average_order_value
from customers
join orders on customers.customerid = orders.customerid
group by customers.firstname, customers.lastname
go

-- 7. write an sql query to find the order with the highest total revenue. include the order id, customer information, and the total revenue
select top 1 orders.orderid, customers.firstname, customers.lastname, customers.email, orders.totalamount
from orders
join customers on orders.customerid = customers.customerid
order by orders.totalamount desc
go

-- 8. write an sql query to list electronic gadgets and the number of times each product has been ordered
select products.productname, count(orderdetails.orderdetailid) as number_of_times_ordered
from products
join orderdetails on products.productid = orderdetails.productid
group by products.productname
go

-- 9. write an sql query to find customers who have purchased a specific electronic gadget product. allow users to input the product name as a parameter
select distinct customers.firstname, customers.lastname, customers.email, customers.phone
from customers
join orders on customers.customerid = orders.customerid
join orderdetails on orders.orderid = orderdetails.orderid
join products on orderdetails.productid = products.productid
where products.productname = 'input_product_name'
go

-- 10. write an sql query to calculate the total revenue generated by all orders placed within a specific date range
select sum(totalamount) as total_revenue
from orders
where orderdate between '2025-01-01' and '2025-12-31'
go



-- part 4

-- 1. write an sql query to find out which customers have not placed any orders
select firstname, lastname, email
from customers
where customerid not in (select distinct customerid from orders)
go

-- 2. write an sql query to find the total number of products available for sale
select (select count(*) from products) as total_products
go

-- 3. write an sql query to calculate the total revenue generated by techshop
select (select sum(totalamount) from orders) as total_revenue
go

-- 4. write an sql query to calculate the average quantity ordered for products in a specific category. allow users to input the category name as a parameter
alter table products
add category varchar(50)
go

update products
set category = 'smartphones'
where productid in (1, 2)

update products
set category = 'laptops'
where productid in (3, 4)

update products
set category = 'accessories'
where productid in (5, 6)

select (select avg(od.quantity)
        from orderdetails od
        where od.productid in (select productid from products where category = 'smartphones')) as average_quantity
go


-- 5. write an sql query to calculate the total revenue generated by a specific customer. allow users to input the customer id as a parameter
select (select sum(od.quantity * p.price)
        from orderdetails od
        join products p on od.productid = p.productid
        where od.orderid in (select orderid from orders where customerid = 1)) as total_revenue
go


-- 6. write an sql query to find the customers who have placed the most orders. list their names and the number of orders they've placed
select firstname, lastname, order_count
from (
    select customerid, count(orderid) as order_count
    from orders
    group by customerid
) as order_summary
join customers on customers.customerid = order_summary.customerid
where order_count = (select max(order_count) from (select customerid, count(orderid) as order_count from orders group by customerid) as sub)
go

-- 7. write an sql query to find the most popular product category, which is the one with the highest total quantity ordered across all orders
select category, total_quantity
from (
    select products.category, sum(orderdetails.quantity) as total_quantity
    from orderdetails
    join products on orderdetails.productid = products.productid
    group by products.category
) as category_summary
where total_quantity = (select max(total_quantity) from (select products.category, sum(orderdetails.quantity) as total_quantity from orderdetails join products on orderdetails.productid = products.productid group by products.category) as sub)
go

-- 8. write an sql query to find the customer who has spent the most money (highest total revenue) on electronic gadgets. list their name and total spending
select firstname, lastname, total_spent
from (
    select customerid, sum(totalamount) as total_spent
    from orders
    group by customerid
) as spending_summary
join customers on customers.customerid = spending_summary.customerid
where total_spent = (select max(total_spent) from (select customerid, sum(totalamount) as total_spent from orders group by customerid) as sub)
go

-- 9. write an sql query to calculate the average order value (total revenue divided by the number of orders) for all customers
select (select sum(totalamount) from orders) * 1.0 / (select count(*) from orders) as average_order_value
go

-- 10. write an sql query to find the total number of orders placed by each customer and list their names along with the order count
select firstname, lastname, (select count(*) from orders where orders.customerid = customers.customerid) as total_orders
from customers
go
