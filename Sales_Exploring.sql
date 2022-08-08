select *
from sales

--  what day has the highest\less number of order
select  MAX(MONDAY_ORDERS) as MONDAY,MAX(TUESDAY_ORDERS) as TUESDAY,MAX(WEDNESDAY_ORDERS) as WEDNESDAY, MAX(THURSDAY_ORDERS) as THURSDAY,
MAX(FRIDAY_ORDERS) as FRIDAY, MAX(SATURDAY_ORDERS) as SATURDAY, MAX(SUNDAY_ORDERS) as SUNDAY
from sales
select  MIN(MONDAY_ORDERS) as MONDAY,MIN(TUESDAY_ORDERS) as TUESDAY,MIN(WEDNESDAY_ORDERS) as WEDNESDAY, MIN(THURSDAY_ORDERS) as THURSDAY,
MIN(FRIDAY_ORDERS) as FRIDAY, MIN(SATURDAY_ORDERS) as SATURDAY, MIN(SUNDAY_ORDERS) as SUNDAY
from sales

-- find the customer who has the highest revenue with his first and last order date
select CustomerID, FIRST_ORDER_DATE, LATEST_ORDER_DATE, MAX(Revenue) as revenue
from Sales
group by CustomerID, FIRST_ORDER_DATE, LATEST_ORDER_DATE
order by MAX(Revenue) desc

-- the total of orders and revenue of all customer in 2016 
select CustomerID, TOTAL_ORDERS, REVENUE, FIRST_ORDER_DATE
from sales
where FIRST_ORDER_DATE between'2016-01-01' and '2016-12-30'
order by FIRST_ORDER_DATE 

-- number of customers who have more than 50 order
select count(customerId) as MoreThan50Order
from sales
where TOTAL_ORDERS > 50

-- number of customers who have ordered in each week
select count(customerId)
from sales
where WEEK1_DAY01_DAY07_ORDERS >0
and WEEK2_DAY08_DAY15_ORDERS >0
and WEEK3_DAY16_DAY23_ORDERS >0
and WEEK4_DAY24_DAY31_ORDERS >0

-- Who are the 5 customer with the highest reveneu value with carriage revenue
select Top 5 CustomerID, revenue, carriage_revenue
from sales
order by revenue desc 

-- the order, revenue but the avearge days between orders more than 20
select CustomerID, revenue, TOTAL_ORDERS, AVGDAYSBETWEENORDERS
from sales
where AVGDAYSBETWEENORDERS > 20 
order by AVGDAYSBETWEENORDERS desc

-- which year has the most orders 
select YEAR(first_order_date) as Year, sum(TOTAL_ORDERS) as TotalOrders
from sales
group by YEAR(first_order_date)
order by sum(TOTAL_ORDERS) desc