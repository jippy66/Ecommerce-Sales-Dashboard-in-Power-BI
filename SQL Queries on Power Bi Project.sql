
use power_bi
select * from ecommerce_data;

------ set sql_safe_updates=0;

*HANDLING DATE COLUMNS*

 update ecommerce_data set ship_date = date_format(str_to_date(ship_date,"%d-%m-%Y"),"%Y-%m-%d")
      
 alter table ecommerce_data modify column ship_date date;

update ecommerce_data set order_date = date_format(str_to_date(order_date,"%d-%m-%Y"),"%Y-%m-%d")
      
 alter table ecommerce_data modify column order_date date;
 
 
--- describe ecommerce_data;   

>>>>>>>>>>>>>>>>>>>>>>
*STORED POCEDURES*

Delimiter $$
CREATE PROCEDURE procedure_5( IN city varchar(30))
Begin

SELECT * FROM ecommerce_data
WHERE customer_city LIKE city;
end $$
Delimiter;

CALL PROCEDURE_5('Henderson');

>>>>>>>>>>>>>>>>>>>>>>>>>>

Delimiter //

CREATE PROCEDURE Orders_Weekday_Proc1( IN 
profit_per_order float,
customer_region varchar(30))

Begin

SELECT  DAYNAME(order_date) AS Week_day ,sum(sales_per_order) FROM ecommerce_data
WHERE profit_per_order >= profit_per_order 
AND customer_region = customer_region
group by Week_day;
end //

call Orders_Weekday_Proc1(10000,"South");

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--- Analyze
For the analysis part, we will string out the most important components of our data to answer our business objectives.

...................
1. What are the total sales and total profits of each year?
The years were grouped by order of date, so we could observe data for the years.

SELECT year(order_date) AS year, 
SUM(sales_per_order) AS total_sales,
SUM(profit_per_order) AS total_profit
FROM ecommerce_data
GROUP BY year
ORDER BY year ASC;


""" Total sales and Total profits for each year
The data above shows how the profits over the years have steadily increased with each year being more
 profitable than the other despite having a fall in sales in 2022, our financial performance"''
.....................

2. What are the total profits and total sales per quarter?

This is done to see the periods where our company has been the most impactful. So that in the future,
we can tailor our operations where we see fit like maximizing our resources like advertisement, customer service 
and our overall presence during those times of the year. This is solved with the code below;

SELECT 
  year(order_date) AS year, 
  CASE 
    WHEN month(order_date) IN (1,2,3) THEN 'Q1'
    WHEN month(order_date) IN (4,5,6) THEN 'Q2'
    WHEN month(order_date) IN (7,8,9) THEN 'Q3'
    ELSE 'Q4'
  END AS quarter,
  SUM(sales_per_order) AS total_sales,
  SUM(profit_per_order) AS total_profit
FROM ecommerce_data
GROUP BY year, quarter
ORDER BY year, quarter;

'''The total sales and total profits for each year per quarter
Now this table will aid us in knowing what quarters were the most profitable. 
This can help to pave the way for investment and marketing strategies.'''

.....................
3. What region generates the highest sales and profits?

SELECT customer_region, SUM(sales_per_order) AS total_sales, SUM(profit_per_order) AS total_profits
FROM ecommerce_data
GROUP BY customer_region
ORDER BY total_profits DESC;

Total Profits and Sales by Region

'''We can observe above that the West region is the one with the most sales and brings us in the highest profits.
The East region is pretty good looking for our company too. Those 2 regions are definitely areas of interest 
if we want to maximize our profits and expand our business. Concerning the South region, we do not gain a lot of 
revenue but still the profits are there. It is the Central region that is quite alarming as we generate way more 
revenue than the South region but do not make at least the same profits over there. 

The Central region should be on our watchlist as we could start to think on how we could maybe put our resources in
the other regions instead.

Let’s observe each regions profit margins for further analysis with the following code:'''

SELECT customer_region, ROUND((SUM(profit_per_order) / SUM(sales_per_order)) * 100, 2) as profit_margin
FROM ecommerce_data
GROUP BY customer_region
ORDER BY profit_margin DESC

'''Profit margins by region
Profit margins are a measure of a company’s profitability and are expressed as the percentage of revenue
that the company keeps as profit. So we can see that the West and East are really good.
West region in revenue has a good profit margin of 11.66% which is great. However the Central region is still
not convincing. Let’s move on and try to pinpoint the data in each region.'''

...............
4. What state and city brings in the highest sales and profits ?

*States*

Firstly, Let’s discover what states are the top 10 highest and lowest and then we will move on to the cities.
For the states, it can be found with the following code:

SELECT customer_state, SUM(sales_per_order) as Total_Sales, SUM(profit_per_order) as Total_Profits, 
ROUND((SUM(profit_per_order) / SUM(sales_per_order)) * 100, 2) as profit_margin
FROM ecommerce_data
GROUP BY customer_state
ORDER BY Total_Profits DESC
LIMIT 10;
select * from ecommerce_data;

'''Top 10 State’s total sales and profits with their profit margins
The decision was to include profit margins to see this under a different lens. 
The data shows the top 10 most profitable states. Besides we can see the total sales and profit margins.
Profit margins are important and it allows us to mostly think long-term as an investor to see potential big markets.
In terms of profits, California, New York and Texas are our most profitable markets and most present ones especially in terms of sales.
Which, are so high that it would take so much for the profit margins to be higher. 
However the profits are great and the total sales show that we have the best part of our business share at 
those points so we need to boost our resources and customer service in those top states.'''

Let’s observe our bottom 10 States:

SELECT customer_state, SUM(sales_per_order) as Total_Sales, SUM(profit_per_order) as Total_Profits, 
ROUND((SUM(profit_per_order) / SUM(sales_per_order)) * 100, 2) as profit_margin
FROM ecommerce_data
GROUP BY customer_state
ORDER BY Total_Profits ASC
LIMIT 10;

'''Bottom 10 State’s total sales and profits
Our least profitable markets are listed above. The top 3 are Wyoming, Vermont and West Virginia. '''

*Cities*

The top cities are found with the code below:

SELECT customer_city, SUM(sales_per_order) as Total_Sales, SUM(profit_per_order) as Total_Profits, 
ROUND((SUM(profit_per_order) / SUM(sales_per_order)) * 100, 2) as profit_margin
FROM ecommerce_data
GROUP BY customer_city
ORDER BY Total_Profits DESC
LIMIT 10;

Top 10 Cities’ total sales and profits with their profit margins
The top 3 cities that we should focus on are New York City, Los Angeles and Philadelphia.

The bottom 10 cities are:

SELECT customer_city, SUM(sales_per_order) as Total_Sales, SUM(profit_per_order) as Total_Profits, 
ROUND((SUM(profit_per_order) / SUM(sales_per_order)) * 100, 2) as profit_margin
FROM ecommerce_data
GROUP BY customer_city
ORDER BY Total_Profits ASC
LIMIT 10;

'''Bottom 10 Cities’ total sales and profits with their profit margins
The bottom 3 are Font Collins, Cambridge and Manchester.'''

................
5. The relationship between discount and sales and the total discount per category

First, let’s observe the correlation between discount and average sales to understand how impactful one is to the other.

SELECT order_item_discount, AVG(sales_per_order) AS Avg_Sales
FROM ecommerce_data
GROUP BY order_item_discount
ORDER BY order_item_discount;

select * from ecommerce_data;


'''Discount vs Avg Sales
Seems that for each discount point, the average sales seem to vary a lot.'''

Let’s observe the total discount per product category:

SELECT category_name, SUM(order_item_discount) AS total_discount
FROM ecommerce_data
GROUP BY category_name
ORDER BY total_discount DESC;

'''Most discounted Categories
So Office supplies are the most discounted items followed by Furniture and Technology. 
We will later dive in into how much profit and sales each generate. 
Before that, let’s zoom in the category section to see exactly what type of products are the most discounted.'''

SELECT category_name,  SUM(order_item_discount) AS total_discount
FROM ecommerce_data
GROUP BY category_name
ORDER BY total_discount DESC;

................
6. What category generates the highest sales and profits in each region and state ?

First, let’s observe the total sales and total profits of each category with their profit margins:

SELECT category_name, SUM(sales_per_order) AS total_sales, SUM(profit_per_order) AS total_profit,
 ROUND(SUM(profit_per_order)/SUM(sales_per_order)*100, 2) AS profit_margin
FROM ecommerce_data
GROUP BY category_name
ORDER BY total_profit DESC;

Categories with their total sales, total profits and profit margins

SELECT customer_region, category_name, SUM(sales_per_order) AS total_sales, SUM(profit_per_order) AS total_profit
FROM ecommerce_data
GROUP BY customer_region, category_name
ORDER BY total_profit DESC;

'''Highest total sales and profits per Category in each region
These our are best categories in terms of total profits in each region. The West is in our top 3 two times with
Office Supplies and Technology and the East with Technology. Among the total profits, the only one
 that fails to break even is the Central Region with Furniture where we operate at a loss when selling it there.'''

Now let’s see the highest total sales and total profits per Category in each state:

SELECT customer_state, category_name, SUM(sales_per_order) AS total_sales, SUM(profit_per_order) AS total_profit
FROM ecommerce_data
GROUP BY customer_state, category_name
ORDER BY total_profit DESC;

'''Top Highest total sales and profits per Category in each state
The table above shows the most performing categories in each of our states. 
Technology in New York and Washington and Office Supplies in California. '''


SELECT customer_state, category_name, SUM(sales_per_order) AS total_sales, SUM(profit_per_order) AS total_profit
FROM ecommerce_data
GROUP BY customer_state, category_name
ORDER BY total_profit ASC;

Top Lowest total sales and profits per Category in each state

..........
7. What Products generates the highest sales and profits in each region and state ?

--- Let’s observe the total sales and total profits of each Products with their profit margins:

SELECT product_name, SUM(sales_per_order) AS total_sales, SUM(profit_per_order) AS total_profit, 
ROUND(SUM(profit_per_order)/SUM(sales_per_order)*100, 2) AS profit_margin
FROM ecommerce_data
GROUP BY product_name
ORDER BY total_profit DESC;

Products with their total sales, total profits and profit margins

--- Now let’s see the highest total sales and total profits per Products in each region:

SELECT customer_region, product_name, SUM(sales_per_order) AS total_sales, SUM(profit_per_order) AS total_profit
FROM ecommerce_data
GROUP BY customer_region, product_name
ORDER BY total_profit DESC;

Top 15 Products with the highest total sales and total profits in each region

--- Now let’s see the highest total sales and total profits per Products in each state:

SELECT customer_state, product_name, SUM(sales_per_order) AS total_sales, SUM(profit_per_order) AS total_profit
FROM ecommerce_data
GROUP BY customer_state, product_name
ORDER BY total_profit DESC;

Top 15 Highest total sales and profits per Products in each state

--- Let’s see the lowest sales and profits. Still in order for biggest lost in profits.

SELECT customer_state, product_name, SUM(sales_per_order) AS total_sales, SUM(profit_per_order) AS total_profit
FROM ecommerce_data
GROUP BY customer_state, product_name
ORDER BY total_profit ASC;

Top 15 Highest total sales and profits per Products in each state

................
8. What are the names of the products that are the most and least profitable to us?

Let’s verify this information:

SELECT product_name, SUM(sales_per_order) AS total_sales, SUM(profit_per_order) AS total_profit
FROM ecommerce_data
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 15;

Top 15 most profitable products

SELECT product_name, SUM(sales_per_order) AS total_sales, SUM(profit_per_order) AS total_profit
FROM ecommerce_data
GROUP BY product_name
ORDER BY total_profit ASC
LIMIT 15;

Top 15 less profitable productS

.............
9. What segment makes the most of our profits and sales ?

This can be verified with the help of the following query:

SELECT customer_segment, SUM(sales_per_order) AS total_sales, SUM(profit_per_order) AS total_profit
FROM ecommerce_data
GROUP BY customer_segment
ORDER BY total_profit DESC;

Goods Segment ordered by total profits
The consumer segment brings in the most profit followed by Corporate and then Home office. Let’s move on.

.................
10. How many customers do we have (unique customer IDs) in total and how much per region and state?

This can be solved with the following:

SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM ecommerce_data;
select * from ecommerce_data;

Total number of customers
We’ve had 41649 customers. Regionally, we had the following:

SELECT customer_region, COUNT(DISTINCT customer_id) AS total_customers
FROM ecommerce_data
GROUP BY customer_region
ORDER BY total_customers DESC;

Total customers per region


'''Top 15 states with the most customers
We have the most customers in California, New York and Texas. The areas where we have the least that passed by there are:'''

SELECT customer_state, COUNT(DISTINCT customer_id) AS total_customers
FROM ecommerce_data
GROUP BY customer_state
ORDER BY total_customers DESC;

Top 15 states with the least customers

.....................
11. Customer rewards program

'''Let’s say we want to build a loyalty and rewards program in the future. 
What customers spent the most with us? That is generated the most sales.
It is always important to cater for our best customers and see how we can provide 
more value to them as it its cheaper to keep a current customer than it is to acquire a new one. 
We will also check the total profits just fo further analysis. We can find out what we are looking for with the following query:'''

SELECT customer_id, 
SUM(sales_per_order) AS total_sales,
SUM(profit_per_order) AS total_profit
FROM ecommerce_data
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 15;

Top 15 customers that generated the most sales compared to total profits.

........................
12. Average shipping time per class and in total

'''Finally, the average shipping time regardless of the shipping mode that is chosen is found with the following function:'''

SELECT ROUND(AVG(ship_date - order_date),1) AS avg_shipping_time
FROM ecommerce_data
select * from ecommerce_data;

'''Average shipping time
The shipping time in each shipping mode is:'''

SELECT shipping_type,ROUND(AVG(ship_date - order_date),1) AS avg_shipping_time
FROM ecommerce_data
GROUP BY shipping_type
ORDER BY avg_shipping_time DESC

Average shipping time by shipping mode
Here we have all the information we need to transition to our POWER BI dashboard.

>>>>>>>>>>>>>>>>>

select * from ecommerce_data;

SELECT
    category_name,
	GROUP_CONCAT(distinct customer_segment ORDER BY (profit_per_order + sales_per_order) ) AS protoc
FROM
    ecommerce_data
GROUP BY
    category_name
ORDER BY
    category_name ASC;


SELECT
    category_name,
	GROUP_CONCAT(distinct customer_segment ORDER BY total_traffic ) AS protoc from 
    
(SELECT
    category_name,customer_segment,
sum(profit_per_order + sales_per_order) AS total_traffic
FROM
    ecommerce_data
GROUP BY
    category_name,customer_segment)X
group by category_name
ORDER BY category_name ASC;
    
SELECT
    customer_segment,sum(profit_per_order + sales_per_order) AS total_tr
	
FROM
    ecommerce_data
GROUP BY
    customer_segment
ORDER BY
    total_tr desc;
select customer_segment,sum(total_tr) c from (    
SELECT
    customer_segment,(profit_per_order + sales_per_order) AS total_tr
	
FROM
    ecommerce_data
)x
GROUP BY  customer_segment
ORDER By  c desc;

 
SELECT
    customer_segment,count(*)
	
FROM
    ecommerce_data
GROUP BY  customer_segment
ORDER By (profit_per_order + sales_per_order)  desc;
