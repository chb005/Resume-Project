create database if not exists swiggydata;

use swiggydata;
create table if not exists restaurant(
r_id int(3) unique not null,
r_name varchar(50),
cuisine varchar(25),
rating double(3,2)
)

select * from restaurant;
drop table food;
create table if not exists food(
f_id int(3) unique not null,
f_name varchar(50),
type varchar(50) 
)
select * from food;

select * from menu;
insert into data1 values(8,'rajesh','raj234@gmail.com','4er45r');

select * from orders;
select * from order_details;
____________________________________________________
/* Case Study questions and Solutions*/
_____________________________________________

/*1.Find customers who have never ordered*/

select name from data1 where user_id not in (select user_id from orders);

/*2.Average Price/dish */
select m.f_id as id,f.f_name as food_name,avg(price) as food_price
from food f join menu m on
f.f_id=m.f_id 
group by 1;

/*3.Find top restautant in terms of number of orders for a given month */

select * from orders order by date;
select * from order_details;
select * from restaurant;
select * from menu;

create table first3 select r.r_name,count(*) as months 
from orders o join restaurant r
on o.r_id=r.r_id
where monthname(date) like 'June'
group by o.r_id
order by months desc limit 1;

/*4.restaurants with monthly sales > x for a particular month */

select * from orders;
select * from restaurant;

create table first4 select o.r_id,r.r_name,sum(amount) as revenue
from orders o join restaurant r
on o.r_id=r.r_id
where monthname(date) like 'June'
group by 1
having sum(amount)>200
order by 2 desc;

/*5.Show all orders with order details for a particular customer in a particular date range*/
select * from data1;
select * from orders;
select * from restaurant;
select * from order_details;
select * from menu;
select * from food;

create table first5 select d.name,o.order_id,r.r_name,f.f_name,o.date
from orders o join data1 d on
o.user_id=d.user_id
join restaurant r on
o.r_id=r.r_id
join order_details od
on o.order_id=od.order_id 
join food f on od.f_id=f.f_id
where d.user_id=(select user_id from data1 where name like 'Ankit')
and (date between '2022-06-10' and '2022-07-10');

/*6.Find the restaurant with max repeat customers*/

select * from orders order by r_id;
select * from restaurant;
select * from order_details;	

create table first6 select r.r_id,r.r_name,count(*) as loyal_customer
from
(
select r_id,user_id,count(*) as visit from
orders group by r_id,user_id 
having visit>1
order by r_id
) t
join restaurant r
on r.r_id=t.r_id
group by r_id
order by loyal_customer desc limit 1;

/*7.Month over month revenue growth of a restaurant/swiggy*/
select * from orders;

create table first7 select months,((rev-prev_rev)/prev_rev)*100 as groth_percentage from(
with chb as
(
select monthname(date) as months,
sum(amount) as rev 
from orders
group  by months
order by month(date)
)
select months,rev,lag(rev,1) over (order by rev) as prev_rev from chb 
)t;

/*8.Customer -> favorite food*/
select * from data1;
select * from orders;
select * from food;
select * from order_details;

create table first8  with temp as
(
select o.user_id,od.f_id,count(*) as food_freq from orders o
join order_details od
on o.order_id=od.order_id
group by o.user_id,od.f_id
)

select d.name,f.f_name,t1.food_freq from temp t1 
join data1 d
on d.user_id=t1.user_id
join food f
on f.f_id=t1.f_id
where t1.food_freq=(select max(food_freq) from temp t2 
where t1.user_id=t2.user_id);

