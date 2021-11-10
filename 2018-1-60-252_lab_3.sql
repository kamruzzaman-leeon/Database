--lab_3
--task 1
SELECT * FROM Branch where assets>1000000;
--task 2
select account_number,balance from account where branch_name='Downtown' or balance BETWEEN 600 and 750;
--task 3
select account_number from account Natural join branch where branch_city='Rye';
--task 4
select loan_number from loan natural join borrower natural join customer where amount>=1000 And customer_city='Harrison';
--task 5
select * from account ORDER by balance desc;
--task 6
select * from customer order by customer_city asc;
--task 7
(select customer_name from account natural join depositor) intersect (select customer_name from borrower natural join loan);
--task 8
(select customer_name,customer_street,customer_city from account natural join depositor natural JOIN customer) union (select customer_name,customer_street,customer_city from borrower natural join loan natural join customer); 
--task 9
(select customer_name,customer_city from borrower natural join loan natural join customer) minus (select customer_name,customer_city from account natural join depositor natural join customer);
--task 10
select sum(assets) as total_assets FROM branch;
--task 11
select DISTINCT branch_name,avg(balance) as avg_balance from account GROUP BY branch_name;
--task 12
select DISTINCT branch_city,avg(balance) as avg_balance from account natural join branch GROUP BY branch_city;
--task 13
select DISTINCT branch_name, min(amount) as lowest_balance from loan GROUP BY branch_name;
--task 14
select distinct branch_name,count(loan_number) as loan_number_each_branch from loan GROUP by branch_name;
--task 15
select customer_name,account_number, max(balance)from depositor natural join account;