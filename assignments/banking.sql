CREATE DATABASE HMBANK;
use HMBank;

go

create table customers (
    customerid int primary key identity(1,1),
    firstname varchar(50),
    lastname varchar(50),
    dob date,
    email varchar(100),
    phonenumber varchar(20),
    address varchar(200)
);

create table accounts (
    accountid int primary key identity(1,1),
    customerid int,
    accounttype varchar(50),
    balance decimal(18,2),
    foreign key (customerid) references customers(customerid)
);

CREATE TABLE transactions (
    transactionid INT PRIMARY KEY IDENTITY(1,1),
    accountid INT NOT NULL,
    transaction_type NVARCHAR(50) NOT NULL,
    amount DECIMAL(18,2) NOT NULL,
    transactiondate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (accountid) REFERENCES accounts(accountid)
);


INSERT INTO transactions (accountid, transaction_type, amount)
VALUES 
(1, 'deposit', 5000.00),
(2, 'withdrawal', 2000.00),
(3, 'deposit', 1500.00),
(4, 'withdrawal', 800.00),
(5, 'deposit', 1200.00);
drop table transactions;

INSERT INTO transactions (accountid, transaction_type, amount)
VALUES 
(1, 'deposit', 5000.00),
(2, 'withdrawal', 2000.00),
(3, 'deposit', 1500.00),
(4, 'withdrawal', 800.00),
(5, 'deposit', 1200.00);


GO

insert into customers (firstname, lastname, dob, email, phonenumber, address) values
('john', 'doe', '1990-05-14', 'john.doe@example.com', '1234567890', 'new york'),
('jane', 'smith', '1985-11-23', 'jane.smith@example.com', '2345678901', 'los angeles'),
('alice', 'johnson', '1992-07-02', 'alice.johnson@example.com', '3456789012', 'chicago'),
('bob', 'williams', '1988-02-17', 'bob.williams@example.com', '4567890123', 'houston'),
('charlie', 'brown', '1995-09-30', 'charlie.brown@example.com', '5678901234', 'phoenix'),
('david', 'miller', '1980-01-01', 'david.miller@example.com', '6789012345', 'philadelphia'),
('emma', 'davis', '1993-04-19', 'emma.davis@example.com', '7890123456', 'san antonio'),
('frank', 'garcia', '1987-08-25', 'frank.garcia@example.com', '8901234567', 'dallas'),
('grace', 'martinez', '1991-12-10', 'grace.martinez@example.com', '9012345678', 'san jose'),
('henry', 'rodriguez', '1989-06-05', 'henry.rodriguez@example.com', '0123456789', 'austin');

insert into accounts (customerid, accounttype, balance) values
(1, 'savings', 2500.00),
(2, 'current', 1500.00),
(3, 'savings', 3200.00),
(4, 'current', 500.00),
(5, 'savings', 0.00),
(6, 'current', 7500.00),
(7, 'zero_balance', 0.00),
(8, 'savings', 2100.00),
(9, 'current', 9800.00),
(10, 'savings', 3400.00);

INSERT INTO accounts (customerid, accounttype, balance)
VALUES (1, 'savings', 1000.00),
       (1, 'current', 5000.00),
       (2, 'savings', 800.00);


insert into Transactions (AccountID, Transaction_Type, Amount) VALUES
(1, 'deposit', 500.00),
(2, 'withdrawal', 200.00),
(3, 'deposit', 700.00),
(4, 'withdrawal', 100.00),
(5, 'deposit', 0.00),
(6, 'deposit', 1000.00),
(7, 'withdrawal', 0.00),
(8, 'deposit', 250.00),
(9, 'withdrawal', 300.00),
(10, 'deposit', 400.00);

select * from customers;

select * from accounts;

select * from transactions;

select name from sys.tables;

select firstname, lastname, accounttype, email
from customers
join accounts on customers.customerid = accounts.customerid;

--List all transactions corresponding to customers
select customers.firstname, customers.lastname, transactions.transactiontype, transactions.amount, transactions.transactiondate
from customers
join accounts on customers.customerid = accounts.customerid
join transactions on accounts.accountid = transactions.accountid;

--Increase balance 
update accounts
set balance = balance + 500
where accountid = 1;
--Combine first and last names 
select firstname + ' ' + lastname as fullname
from customers;
--Remove accounts with balance = 0 

delete from accounts
where balance = 0 and accounttype = 'savings';

--Find customers living in a specific city
select *
from customers
where address = 'new york';

--Get account balance for a specific account
select balance
from accounts
where accountid = 2;

--List all current accounts with balance greater than 1000
select *
from accounts
where accounttype = 'current' and balance > 1000;


--Retrieve all transactions for a specific account	

select *
from transactions
where accountid = 3;


--3rd set

-- 1. write a SQL query to Find the average account balance for all customers.   
select avg(balance) from accounts;

-- 2. Write a SQL query to Retrieve the top 10 highest account balances. 
select * from accounts order by balance desc;

-- 3. Write a SQL query to Calculate Total Deposits for All Customers in specific date. 
SELECT SUM(amount) AS TotalDeposits
FROM transactions
WHERE transaction_type = 'deposit' 
AND CAST(transactiondate AS DATE) = '2025-04-09';

SELECT * FROM transactions;


-- 4.  Write a SQL query to Find the Oldest and Newest Customers. 
select * from customers order by dob asc;  
select * from customers order by dob desc; 

-- 5. Write a SQL query to Retrieve transaction details along with the account type. 
select transactions.*, accounts.accounttype 
from transactions, accounts 
where transactions.accountid = accounts.accountid;

-- 6. Write a SQL query to Get a list of customers along with their account details.
select customers.*, accounts.accounttype, accounts.balance 
from customers, accounts 
where customers.customerid = accounts.customerid;

-- 7. Write a SQL query to Retrieve transaction details along with customer information for a 
specific account. 
select transactions.*, customers.firstname, customers.lastname 
from transactions, accounts, customers 
where transactions.accountid = accounts.accountid 
and accounts.customerid = customers.customerid 
and accounts.accountid = 1;  

-- 8. Write a SQL query to Identify customers who have more than one account.
select customerid, count(accountid) 
from accounts 
group by customerid 
having count(accountid) > 1;

-- 9. Write a SQL query to Calculate the difference in transaction amounts between deposits and 
--withdrawals.
select (select sum(amount) from transactions where transaction_type = 'deposit') - 
       (select sum(amount) from transactions where transaction_type = 'withdrawal') 
as difference;

-- 10. Write a SQL query to Calculate the average daily balance for each account over a specified 
--period. 

select accountid, avg(balance) 
from accounts 
group by accountid;

-- 11.  Calculate the total balance for each account type.
select accounttype, sum(balance) 
from accounts 
group by accounttype;

-- 12.  Identify accounts with the highest number of transactions order by descending order.
select accountid, count(transactionid) as transaction_count 
from transactions 
group by accountid 
order by transaction_count desc;

-- 13.  List customers with high aggregate account balances, along with their account types. 
select customers.firstname, customers.lastname, accounts.accounttype, accounts.balance 
from customers, accounts 
where customers.customerid = accounts.customerid 
and accounts.balance > 5000; -- (set any limit)

-- 14.  Identify and list duplicate transactions based on transaction amount, date, and account.
select amount, transaction_date, accountid, count(*) 
from transactions 
group by amount, transaction_date, accountid 
having count(*) > 1;



--4th set q

-- 1. Retrieve the customer(s) with the highest account balance. 
select firstname, lastname, balance
from customers
join accounts on customers.customerid = accounts.customerid
where balance = (select max(balance) from accounts);

-- 2. Calculate the average account balance for customers who have more than one account.
select avg(balance) as average_balance
from accounts
where customerid in (
    select customerid
    from accounts
    group by customerid
    having count(accountid) > 1
);

-- 3.Retrieve accounts with transactions whose amounts exceed the average transaction amount.
select distinct accounts.accountid, accounts.customerid, accounts.accounttype, accounts.balance
from accounts
join transactions on accounts.accountid = transactions.accountid
where transactions.amount > (select avg(amount) from transactions);

-- 4. Identify customers who have no recorded transactions. 
select firstname, lastname
from customers
where customerid not in (
    select distinct accounts.customerid
    from accounts
    join transactions on accounts.accountid = transactions.accountid	
);


-- 5.  accounts with no recorded transactions
select sum(balance) as total_balance
from accounts
where accountid not in (select distinct accountid from transactions);

-- 6. retrieve transactions for accounts with the lowest balance
select transactions.*
from transactions
where accountid in (
    select accountid
    from accounts
    where balance = (select min(balance) from accounts)
);

-- 7. Identify customers who have accounts of multiple types. 
select customerid
from accounts
group by customerid
having count(distinct accounttype) > 1;
select * from accounts;


-- 8. Calculate the percentage of each account type out of the total number of accounts.
select accounttype,
    cast(count(*) * 100.0 / (select count(*) from accounts) as decimal(5,2)) as percentage
from accounts
group by accounttype;

-- 9. Retrieve all transactions for a customer with a given customer_id. 
select transactions.*
from transactions
join accounts on transactions.accountid = accounts.accountid
where accounts.customerid = 1;

-- 10. Calculate the total balance for each account type, including a subquery within the SELECT 

select accounttype,
    (select sum(balance) from accounts a2 where a2.accounttype = a1.accounttype) as total_balance
from accounts a1
group by accounttype;

--grant and revoke
create login bank_employee with password = 'password';
drop login bank_employee;

create user bank_employee for login bank_employee;
grant select,insert,update on accounts to bank_employee;
revoke insert on transactions to bank_employee;
-- grant and revoke ends
