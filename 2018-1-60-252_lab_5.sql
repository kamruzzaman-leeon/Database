create table customer ( Customer_name varchar(15), Customer_street varchar(15), Customer_city varchar(15) );
insert into customer values('Adams','Spring','Pittsfield');
insert into customer values('Brooks','Senator','Brooklyn'); 
insert into customer values('Curry','North','Rye'); 
insert into customer values('Glenn','Sand Hill','Woodside'); 
insert into customer values('Green','Walnut','Stamford'); 
insert into customer values('Hayes','Main','Harrison'); 
insert into customer values('Johnson','Alma','Palo Alto'); 
insert into customer values('Jones','Main','Harrison'); 
insert into customer values('Smith','Main','Rye'); 
insert into customer values('Turner','Putnam','Stamford'); 
insert into customer values('Williams','Nassau','Princeton');

create table branch ( Branch_name varchar(12), Branch_city varchar(12), Assets int );
insert into branch values('Downtown','Brooklyn',900000); 
insert into branch values('Redwood','Palo Alto',2100000);
insert into branch values('Perryridge','Horseneck',1700000); 
insert into branch values('Mianus','Horseneck',400200); 
insert into branch values('Round Hill','Horseneck',8000000); 
insert into branch values('Pownal','Bennington',400000); 
insert into branch values('North Town','Rye',3700000); 
insert into branch values('Brighton','Brooklyn',7000000);

create table account ( Account_number varchar(15), Branch_name varchar(12), Balance int );
insert into account values('A-101','Downtown',500); 
insert into account values('A-215','Mianus',700); 
insert into account values('A-102','Perryridge',400); 
insert into account values('A-305','Round Hill',350); 
insert into account values('A-201','Perryridge',900); 
insert into account values('A-222','Redwood',700); 
insert into account values('A-217','Brighton',750);

create table depositor ( Customer_name varchar(15), Account_number varchar(15) );
insert into depositor values('Johnson','A-101'); 
insert into depositor values('Smith','A-215'); 
insert into depositor values('Hayes','A-102'); 
insert into depositor values('Turner','A-305'); 
insert into depositor values('Johnson','A-201'); 
insert into depositor values('Jones','A-217'); 
insert into depositor values('Lindsay','A-222');

create table loan( Loan_number varchar(12), Branch_name varchar(12), Amount int );
insert into loan values('L-17','Downtown',1000); 
insert into loan values('L-23','Redwood',2000);
 insert into loan values('L-15','Perryridge',1500);
 insert into loan values('L-14','Downtown',1500);
insert into loan values('L-93','Mianus',500); 
insert into loan values('L-11','Round Hill',900); 
insert into loan values('L-16','Perryridge',1300);

create table borrower( Customer_name varchar(15), Loan_number varchar(12) );
insert into borrower values('Jones','L-17');
 insert into borrower values('Smith','L-23'); 
 insert into borrower values('Hayes','L-15'); 
 insert into borrower values('Jackson','L-14');
 insert into borrower values('Curry','L-93');
 insert into borrower values('Smith','L-11'); 
 insert into borrower values('Williams','L-17');
 insert into borrower values('Adams','L-16');


--task1
select Customer_name,Customer_city 
from customer natural join borrower;
--task2
select Customer_name,Customer_city 
from borrower natural join loan left natural join customer
where Branch_name='Perryridge';
--task3
select Account_number,Balance 
from account 
where Balance BETWEEN 700 AND 900;
--task4
select Customer_name,Customer_street
from customer 
where Customer_street like '%Hill';
--task5
(select Customer_name
from depositor natural join account natural join customer
where Branch_name='Perryridge')
intersect
(select Customer_name
from borrower natural join loan natural join customer
where Branch_name='Perryridge');
--task6
(select Customer_name
from depositor natural join account natural join customer
where Branch_name='Perryridge')
minus
(select Customer_name
from borrower natural join loan natural join customer
where Branch_name='Perryridge');
--task7
select distinct Customer_name,Customer_city
from customer natural join borrower;
--task8
select c.customer_name
from customer c,account a,depositor d
where c.customer_name=d.customer_name and d.account_number=a.account_number
and a.branch_name in (select a.branch_name
from customer c,account a,depositor d
where c.customer_name=d.customer_name and d.account_number=a.account_number and
c.customer_name='Hayes');
--task9
select branch_name,assets
from branch
where assets > some (
select assets
from branch
where branch_city='Brooklyn');
--task10
select branch_name,assets
from branch
where assets > all (
select assets
from branch
where branch_city='Brooklyn');
--task11
(select Customer_name
from depositor natural join account left natural join customer
where Branch_name='Perryridge'
)
union
(select Customer_name
from borrower natural join loan left natural join customer
where Branch_name='Perryridge'
)
Order by Customer_name;
--task12
select Loan_number,Branch_name,Amount
from loan
order by Amount Desc,loan_number Asc;

--task13
select b.branch_name,avg(balance)
from branch b,account a
where b.branch_name=a.branch_name
group by b.branch_name;
--task14
select b.branch_name,count(a.account_number)
from branch b,account a
where b.branch_name=a.branch_name
group by b.branch_name
having count(a.account_number)>=1;
--task15
select avg(balance)
from account;
--task16
select b.branch_name,avg(a.balance)
from branch b,account a
where b.branch_name=a.branch_name
group by b.branch_name
having avg(a.balance)>700;
--task17
select b.branch_name,avg(a.balance)
from branch b,account a
where b.branch_name=a.branch_name
group by b.branch_name
having avg(a.balance)>700;
--task18
select count(customer_name)
from customer;
--task19
select b.customer_name
from loan l,borrower b
where l.loan_number=b.loan_number
and l.branch_name='Downtown';
--task20
select b.customer_name
from loan l,borrower b
where l.loan_number=b.loan_number
and l.amount>=1500 and l.amount<=2500;
--task21
select distinct c.customer_name
from loan l,borrower b,customer c
where l.loan_number=b.loan_number and c.customer_name=b.customer_name
and c.customer_city='Rye';
--task22
select l.branch_name,count(b.customer_name)
from loan l,borrower b
where l.loan_number=b.loan_number
group by l.branch_name;
--task23
with avg(branch_n,avg_am) as
(select branch_name,avg(amount)
from loan
group by branch_name),
lar_avg(bran,am)as
((select distinct a.branch_n,a.avg_am
from avg a)
minus
(select a.branch_n,a.avg_am
from avg a,avg v
where a.avg_am<v.avg_am))
select avg.branch_n,avg.avg_am
from avg,lar_avg
where avg.branch_n=lar_avg.bran and avg.avg_am=lar_avg.am;
--task24
with xyz (loan_num,am) as
((select distinct l.loan_number,l.amount
from loan l)
minus
(select l.loan_number,l.amount
from loan l,loan i
where l.amount<i.amount))
select b.customer_name,xyz.loan_num,xyz.am
from borrower b,xyz
where xyz.loan_num=b.loan_number;
--task25
select customer_name
from customer
where customer_name like 'G%';