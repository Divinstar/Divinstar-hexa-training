--task 1.1: create the database named "couriermanagementsystem"
create database couriermanagementsystem;
use couriermanagementsystem;

--task 1.2: database design - courier management system
create table users (
    userid int primary key,
    name varchar(255),
    email varchar(255) unique,
    password varchar(255),
    contactnumber varchar(20),
    address text
);

create table couriers (
    courierid int primary key,
    sendername varchar(255),
    senderaddress text,
    receivername varchar(255),
    receiveraddress text,
    weight decimal(5, 2),
    status varchar(50),
    trackingnumber varchar(20) unique,
    deliverydate date
);

create table courierservices (
    serviceid int primary key,
    servicename varchar(100),
    cost decimal(8, 2)
);

create table employees (
    employeeid int primary key,
    name varchar(255),
    email varchar(255) unique,
    contactnumber varchar(20),
    role varchar(50),
    salary decimal(10, 2)
);

create table locations (
    locationid int primary key,
    locationname varchar(100),
    address text
);

create table payments (
    paymentid int primary key,
    courierid int,
    locationid int,
    amount decimal(10, 2),
    paymentdate date,
    foreign key (courierid) references couriers(courierid),
    foreign key (locationid) references locations(locationid)
);

insert into users (userid, name, email, password, contactnumber, address) values
(1, 'alice johnson', 'alice@example.com', 'alice123', '9876543210', '123 maple street'),
(2, 'bob smith', 'bob@example.com', 'bobpass', '9876501234', '456 oak avenue'),
(3, 'charlie brown', 'charlie@example.com', 'charliepw', '9123456789', '789 pine road');

insert into couriers (courierid, sendername, senderaddress, receivername, receiveraddress, weight, status, trackingnumber, deliverydate) values
(101, 'alice johnson', '123 maple street', 'eve watson', '999 river road', 2.5, 'delivered', 'trk001', '2025-04-09'),
(102, 'bob smith', '456 oak avenue', 'sam green', '888 ocean drive', 1.2, 'in transit', 'trk002', null),
(103, 'charlie brown', '789 pine road', 'tom lane', '777 mountain blvd', 3.4, 'pending', 'trk003', null);

insert into courierservices (serviceid, servicename, cost) values
(1, 'standard delivery', 50.00),
(2, 'express delivery', 100.00),
(3, 'overnight delivery', 150.00);

insert into employees (employeeid, name, email, contactnumber, role, salary) values
(1, 'john doe', 'john.doe@example.com', '9998887777', 'delivery executive', 30000.00),
(2, 'jane smith', 'jane.smith@example.com', '8887776666', 'admin', 45000.00),
(3, 'mark lee', 'mark.lee@example.com', '7776665555', 'delivery executive', 32000.00);

insert into locations (locationid, locationname, address) values
(1, 'central hub', '11 main st, metro city'),
(2, 'north branch', '22 hill st, north town'),
(3, 'south depot', '33 lake rd, south ville');

insert into payments (paymentid, courierid, locationid, amount, paymentdate) values
(1, 101, 1, 120.00, '2025-04-09'),
(2, 102, 2, 90.00, '2025-04-10'),
(3, 103, 3, 130.00, '2025-04-10');

--task 2: sql queries (select + where)
select * from users;

select * from couriers
where sendername = 'bob smith';

select * from couriers;

select * from couriers
where courierid = 101;

select * from couriers
where trackingnumber = 'trk001';

select * from couriers
where status != 'delivered';

select * from couriers
where deliverydate = cast(getdate() as date);

select * from couriers
where status = 'pending';

select sendername, count(*) as totalpackages
from couriers
group by sendername;

alter table couriers
add pickupdate date;

update couriers
set pickupdate = '2025-04-07'
where courierid = 101;

update couriers
set pickupdate = '2025-04-09'
where courierid = 102;

update couriers
set pickupdate = '2025-04-08'
where courierid = 103;

select 
    sendername,
    avg(datediff(day, pickupdate, deliverydate)) as avgdeliverydays
from couriers
where deliverydate is not null and pickupdate is not null
group by sendername;

select * from couriers
where weight between 1.0 and 3.0;

select * from employees
where name like '%john%';

select c.*
from couriers c
join payments p on c.courierid = p.courierid
where p.amount > 50;

--task 3: groupby, aggregate functions, having, order by, where
create table employeecourier (
    assignmentid int primary key identity(1,1),
    employeeid int,
    courierid int,
    assignmentdate date,
    foreign key (employeeid) references employees(employeeid),
    foreign key (courierid) references couriers(courierid)
);

insert into employeecourier (employeeid, courierid, assignmentdate)
values
(1, 101, '2025-04-07'),
(2, 102, '2025-04-08'),
(1, 103, '2025-04-09');

select e.name, count(ec.courierid) as totalcouriershandled
from employees e
join employeecourier ec on e.employeeid = ec.employeeid
group by e.name;

select l.locationname, sum(p.amount) as totalrevenue
from payments p
join locations l on p.locationid = l.locationid
group by l.locationname;

select l.locationname, count(p.courierid) as totalcouriers
from payments p
join locations l on p.locationid = l.locationid
group by l.locationname;

select top 1 
    courierid, 
    datediff(day, pickupdate, deliverydate) as deliverydays
from couriers
where deliverydate is not null and pickupdate is not null
order by deliverydays desc;

select l.locationname, sum(p.amount) as totalpayments
from payments p
join locations l on p.locationid = l.locationid
group by l.locationname
having sum(p.amount) < 200;

select l.locationname, sum(p.amount) as totalpayments
from payments p
join locations l on p.locationid = l.locationid
group by l.locationname;

select c.courierid, p.amount
from payments p
join couriers c on p.courierid = c.courierid
where p.locationid = 2
group by c.courierid, p.amount
having sum(p.amount) > 1000;

select c.courierid, sum(p.amount) as totalamount
from payments p
join couriers c on p.courierid = c.courierid
where p.paymentdate > '2025-04-01'
group by c.courierid
having sum(p.amount) > 1000;

select l.locationname, sum(p.amount) as totalreceived
from payments p
join locations l on p.locationid = l.locationid
where p.paymentdate < '2025-05-01'
group by l.locationname
having sum(p.amount) > 5000;

--task 4: joins (inner join, full outer join, cross join, left/right outer join)
select p.paymentid, p.amount, p.paymentdate, c.trackingnumber, c.sendername, c.receivername
from payments p
join couriers c on p.courierid = c.courierid;

select p.paymentid, p.amount, p.paymentdate, l.locationname, l.address
from payments p
join locations l on p.locationid = l.locationid;

select p.paymentid, p.amount, p.paymentdate, 
       c.trackingnumber, c.sendername, c.receivername,
       l.locationname
from payments p
join couriers c on p.courierid = c.courierid
join locations l on p.locationid = l.locationid;

select p.paymentid, p.amount, p.paymentdate, c.trackingnumber, c.sendername, c.receivername
from payments p
join couriers c on p.courierid = c.courierid;

select c.courierid, c.trackingnumber, sum(p.amount) as totalpaid
from payments p
join couriers c on p.courierid = c.courierid
group by c.courierid, c.trackingnumber;

select * from payments
where paymentdate = '2025-04-08';

select p.paymentid, p.amount, c.courierid, c.trackingnumber, c.status
from payments p
join couriers c on p.courierid = c.courierid;

select p.paymentid, p.amount, p.paymentdate, l.locationname
from payments p
join locations l on p.locationid = l.locationid;

select c.courierid, c.trackingnumber, sum(p.amount) as totalpayments
from payments p
join couriers c on p.courierid = c.courierid
group by c.courierid, c.trackingnumber;

select * from payments
where paymentdate between '2025-04-01' and '2025-04-10';

select u.userid, u.name as username, c.courierid, c.trackingnumber
from users u
left join couriers c on u.name = c.sendername;

select u.userid, u.name as username, c.courierid, c.trackingnumber
from users u
right join couriers c on u.name = c.sendername;

select e.name, p.amount, p.paymentdate
from employees e
left join employeecourier ec on e.employeeid = ec.employeeid
left join payments p on ec.courierid = p.courierid;

select u.name as username, cs.servicename
from users u
cross join courierservices cs;

select e.name as employeename, l.locationname
from employees e
cross join locations l;

select c.courierid, c.sendername, u.email
from couriers c
left join users u on c.sendername = u.name;

select c.courierid, c.receivername, u.email
from couriers c
left join users u on c.receivername = u.name;

select e.name, count(ec.courierid) as totalassigned
from employees e
left join employeecourier ec on e.employeeid = ec.employeeid
group by e.name;

select l.locationname, sum(p.amount) as totalamount
from payments p
join locations l on p.locationid = l.locationid
group by l.locationname;

select sendername, count(*) as totalsent
from couriers
group by sendername
having count(*) > 1;

select role, string_agg(name, ', ') as employees
from employees
group by role
having count(*) > 1;

select 
    cast(c.senderaddress as nvarchar(max)) as senderaddress,
    sum(p.amount) as totalpaid
from couriers c
join payments p on c.courierid = p.courierid
group by cast(c.senderaddress as nvarchar(max));

select 
    cast(senderaddress as nvarchar(max)) as senderaddress,
    count(*) as totalcouriers
from couriers
group by cast(senderaddress as nvarchar(max))
having count(*) > 1;

select e.name, count(ec.courierid) as deliveredcount
from employees e
join employeecourier ec on e.employeeid = ec.employeeid
join couriers c on ec.courierid = c.courierid
where c.status = 'delivered'
group by e.name;
