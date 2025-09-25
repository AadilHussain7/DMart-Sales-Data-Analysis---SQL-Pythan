select * from walmart
select count(*) from walmart
select "Branch"
from walmart
group by payment_method
 
select min(quantity) from walmart




 --Q1 What are the different payment methods, and how many 
 --transactions and items were sold with each method? 
 
 select payment_method,count(payment_method), sum(quantity::int) as total_item_solde
 from walmart
 group by payment_method
 order by 3  desc
 
 --Q2  Which category received the highest average rating in each branch? 
select "Branch",category,round(avg(rating::numeric),2) as avg_rating
from walmart
group by 1,2
order by 1,3 desc

 
  --Q3 What is the busiest day of the week for each branch based on transaction volume? 
  
 
SELECT "Branch",
       busiest_day,
       txn_count
FROM (
  SELECT "Branch",
         to_char(("date")::date, 'Day') AS busiest_day,   -- returns Monday, Tuesday, ...
         COUNT(*) AS txn_count,
         RANK() OVER (PARTITION BY "Branch" ORDER BY COUNT(*) DESC) AS rnk
  FROM walmart
  GROUP BY "Branch", busiest_day
) t
WHERE rnk = 1
ORDER BY "Branch", busiest_day;

-- Q4 How many items were sold through each payment method?

 SELECT payment_method, count(*) as no_payment, sum(quantity::numeric) as total_qt_sold
FROM walmart
group by 1
 
 
 --Q5 What are the average, minimum, and maximum ratings for each category in each city?

select category,city, min(rating)as min_ratings,
 max(rating) as max_ratings ,
 round (avg(rating::numeric),3) avg_ratings
 from walmart
 group by 1,2
 
 
  --Q6 What is the total profit for each category, ranked from highest to lowest? 
  
  select category, 
  sum(total ::numeric) as total_revenu,
  sum(total::numeric * profit_margin ::numeric) as profit
 from walmart
 group by 1
  
  
  
  --Q7 What is the most frequently used payment method in each branch?
  	
	select  "Branch",payment_method, count(*) as total_tran ,
	rank()over(partition by "Branch"order by count(*) desc ) as rank
	from walmart
	group by 1,2
	
	
--Q09 How many transactions occur in each shift (Morning, Afternoon, Evening) 
--across branches? 

	select  "Branch",
	case
	when extract (hour from(time::time)) < 12 then 'morning'
	when extract (hour from(time::time)) between 12 and 17 then 'afternoon'
	else 'evening'
	end day_time,
	count(*)
	from walmart
  group by 1,2
  order by 1,3 desc
  
  
 --Q9 Which branches experienced the largest decrease in 
 --revenue compared to the previous year
 
 --rdr == last_rev-cr_rev/ls_rev*100
 
 WITH yearly_revenue AS (
    SELECT "Branch",
           EXTRACT(YEAR FROM TO_DATE("date", 'FMMM/FMDD/YYYY'))::int AS year,
           SUM("total"::numeric) AS revenue
    FROM walmart
    GROUP BY "Branch", year
),
yearly_diff AS (
    SELECT "Branch",
           year,
           revenue,
           revenue - LAG(revenue) OVER (PARTITION BY "Branch" ORDER BY year) AS diff
    FROM yearly_revenue
)
SELECT "Branch", year, revenue, diff
FROM yearly_diff
WHERE diff < 0
ORDER BY diff ASC;

  
  
  
  
  
  
 
 
 
 
 
 
 
 