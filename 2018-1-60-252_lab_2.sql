/*lab_2 2018-1-60-252 kamruzzaman leeon */

--lab_task#01 
create table account 
(	account_no char(5) primary key,
	balance numeric not null ,
	check(balance>0)
);
create table customer
(	customer_no char(5) primary key,
	customer_name varchar2(20) not null,
	customer_city varchar2(10)
);
create table depositor
(	account_no char(5),
	customer_no char(5),
	constraint depositor primary key(account_no,customer_no)
);
--lab_task#02
desc customer;
alter table customer ADD date_of_birth date;

alter table customer DROP column date_of_birth;

alter table depositor RENAME column account_no to a_no ;
alter table depositor RENAME column customer_no to c_no; 

alter table Depositor ADD constraint depositor_fk1 FOREIGN KEY (a_no) REFERENCES account(account_no);
alter table Depositor ADD constraint depositor_fk2 FOREIGN KEY (c_no) REFERENCES customer(customer_no);

--lab_task#03

insert into account values('A-101',12000);
insert into account values('A-102',6000);
insert into account values('A-103',2500);

insert into customer values('C-101','alice','dhaka');
insert into customer values('C-102','annie','dhaka');
insert into customer values('C-103','bob','chittahong');
insert into customer values('C-104','charlie','khulna');

insert into depositor values('A-101','C-101');
insert into depositor values('A-103','C-102');
insert into depositor values('A-103','C-104');
insert into depositor values('A-102','C-103');

--lab_task#04

select account_no from account where balance>5000;

select customer_no,customer_name from customer where customer_city='dhaka';

select customer_no,customer_name from customer where customer_city !='dhaka';

select customer_name,customer_city from customer,depositor,account where balance>5000 AND account_no=a_no AND customer_no=c_no AND customer_city!='dhaka';
