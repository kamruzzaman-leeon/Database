1.
--without subqueries
select distinct customer_name,  customer_street,  customer_city 
from (customer natural join depositor) , (account natural join branch) 
where depositor.account_number=account.account_number and customer_city=branch_city;

--with subqueries
select customer_name,customer_street,customer_city
from customer natural join depositor
where (customer_city,account_number) in 
(select customer_city,account_number
 from account natural join branch
 where branch_city=customer_city
);


2.
--without subqueries
select distinct customer_name,  customer_street,  customer_city 
from (customer natural join borrower) , (loan natural join branch) 
where borrower.loan_number=loan.loan_number and customer_city=branch_city;

--with subqueries
select customer_name,customer_street,customer_city
from customer natural join borrower
where (customer_city,loan_number) in 
(select customer_city,loan_number
 from loan natural join branch
 where branch_city=customer_city
);


3.
--Without using “Having” clause:
select branch_city, average
from (select branch_city, avg(balance) as average, sum(balance) as sum
      from branch natural join account
	  group by branch_city)temp
where sum>=1000;

--Using “Having” clause:
select branch_city, avg(balance) as average
from branch natural join account
group by branch_city
having sum(balance)>=1000;


--4
--Without using “Having” clause:
select branch_city, average
from (select branch_city, avg(amount) as average
      from branch natural join loan    
	  group by branch_city)temp
where average>=1500;

--Using “Having” clause:
select branch_city, avg(amount) as average
from branch natural join loan 
group by branch_city
having avg(amount)>=1500;

--5
--Without using “All” clause:
select distinct customer_name, customer_street, customer_city 
from customer natural join depositor natural join account
where balance=(select max(balance) from account);

--Using “All” clause:
select distinct customer_name, customer_street, customer_city 
from customer natural join depositor natural join account
where balance>=all(select balance from account);


--6
--Without using “All” clause:
select distinct customer_name, customer_street, customer_city 
from customer natural join borrower natural join loan
where amount=(select min(amount) from loan);

--Using “All” clause:
select distinct customer_name, customer_street, customer_city 
from customer natural join borrower natural join loan
where amount<=all(select amount from loan);


--7
--Using “In” clause:
select distinct branch_name, branch_city
from branch natural join account
where (branch_name) in(
select branch_name
from account natural join loan);

--Using “Exists” clause:
select distinct b.branch_name, b.branch_city
from branch b,account a
where b.branch_name=a.branch_name and exists(
select distinct br.branch_name,br.branch_city
from branch br, loan ln
where br.branch_name=ln.branch_name and b.branch_name=br.branch_name and b.branch_city=br.branch_city
);


--8
--Using “Not In” clause:
select distinct customer_name, customer_city
from customer natural join depositor natural join account
where (customer_name, customer_city) not in(
select distinct customer_name, customer_city
from customer natural join loan natural join borrower);

--Using “Not Exists” clause:
select distinct c.customer_name, c.customer_city
from customer c,depositor d,account a
where c.customer_name=d.customer_name and d.account_number=a.account_number and not exists(
select distinct cus.customer_name, cus.customer_city
from customer cus,loan ln,borrower bor
where cus.customer_name=bor.customer_name and bor.loan_number=ln.loan_number and 
c.customer_name=cus.customer_name and c.customer_city=cus.customer_city);

--9
--Without using “With” clause:
select branch_name
from account
group by branch_name 
having sum(balance)>all(select avg(balance) from account);

--Using “With” clause:
with avg as (select avg(balance) as average from account), bran as(select sum(balance) as total, branch_name
	     from account 
	     group by branch_name)
select branch_name
from avg,bran
where total>average;

--10
--Without using “With” clause:
select branch_name
from loan
group by branch_name 
having sum(amount)<all(select avg(amount) from account);

--Using “With” clause:

with total_amount as (select  sum(amount) as total
		      from loan 
		      group by branch_name )
select 	branch_name
from loan
group by branch_name
having sum(amount)<(select avg(total) from total_amount);








