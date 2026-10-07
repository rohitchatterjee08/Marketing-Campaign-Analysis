select * from marketing

--1Q: Which marketing campaign generated the highest customer acceptance?
SELECT 
    'Campaign 1' AS campaign,
    SUM(acceptedcmp1) AS accepted_customers
FROM marketing

UNION ALL

SELECT 
    'Campaign 2',
    SUM(acceptedcmp2)
FROM marketing

UNION ALL

SELECT 
    'Campaign 3',
    SUM(acceptedcmp3)
FROM marketing

UNION ALL

SELECT 
    'Campaign 4',
    SUM(acceptedcmp4)
FROM marketing

UNION ALL

SELECT 
    'Campaign 5',
    SUM(acceptedcmp5)
FROM marketing

UNION ALL

SELECT 
    'Latest Campaign',
    SUM(response)
FROM marketing

ORDER BY accepted_customers DESC;

--2Q: What customer characteristics are associated with campaign success?

SELECT
    response,
    COUNT(*) AS customers,
    ROUND(AVG(age)::numeric, 2) AS avg_age,
    ROUND(AVG(income)::numeric, 2) AS avg_income,
    ROUND(AVG(total_spend)::numeric, 2) AS avg_spend,
    ROUND(AVG(total_purchase)::numeric, 2) AS avg_purchases
FROM marketing
GROUP BY response
ORDER BY response DESC;

--3Q: What factors are associated with higher online purchasing activity?

SELECT
    ROUND(AVG(numwebpurchases), 2) AS avg_web_purchases,
    ROUND(AVG(numwebvisitsmonth), 2) AS avg_web_visits,
    ROUND(AVG(income)::numeric, 2) AS avg_income,
    ROUND(AVG(total_spend), 2) AS avg_total_spend,
    ROUND(AVG(response), 2) AS campaign_response_rate
FROM marketing;

--4Q: Which customer segments are most responsive to marketing campaigns?

--By Education
SELECT
    education,
    COUNT(*) AS customers,
    SUM(response) AS responses,
    ROUND(100.0 * AVG(response), 2) AS response_rate
FROM marketing
GROUP BY education
ORDER BY response_rate DESC;

--By Marital
SELECT
    marital_status,
    COUNT(*) AS customers,
    SUM(response) AS responses,
    ROUND(100.0 * AVG(response), 2) AS response_rate
FROM marketing
GROUP BY marital_status
ORDER BY response_rate DESC;

--5Q: Which products generate the highest customer spending?
SELECT
    'Wines' AS product,
    SUM(mntwines) AS total_spending
FROM marketing

UNION ALL

SELECT 'Fruits', SUM(mntfruits)
FROM marketing

UNION ALL

SELECT 'Meat', SUM(mntmeatproducts)
FROM marketing

UNION ALL

SELECT 'Fish', SUM(mntfishproducts)
FROM marketing

UNION ALL

SELECT 'Sweets', SUM(mntsweetproducts)
FROM marketing

UNION ALL

SELECT 'Gold', SUM(mntgoldprods)
FROM marketing

ORDER BY total_spending DESC;

--6Q: Which purchasing channels are performing best?

SELECT
    'Web' AS channel,
    SUM(numwebpurchases) AS total_purchases
FROM marketing

UNION ALL

SELECT
    'Catalog',
    SUM(numcatalogpurchases)
FROM marketing

UNION ALL

SELECT
    'Store',
    SUM(numstorepurchases)
FROM marketing

ORDER BY total_purchases DESC;

--7Q: Are marketing campaigns successfully driving additional purchases?

SELECT
    response,
    COUNT(*) AS customers,
    ROUND(AVG(total_purchase), 2) AS avg_purchases,
    ROUND(AVG(total_spend), 2) AS avg_spending,
    ROUND(AVG(numwebpurchases), 2) AS avg_web_purchases,
    ROUND(AVG(numstorepurchases), 2) AS avg_store_purchases
FROM marketing
GROUP BY response
ORDER BY response DESC;

--8Q: Which customers are most valuable based on spending and purchasing behavior?

SELECT
    CASE
        WHEN total_spend >= 2000 AND total_purchase >= 15
            THEN 'High Value'
        WHEN total_spend >= 1000 AND total_purchase >= 10
            THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment,
    
    COUNT(*) AS customers,
    ROUND(AVG(income):: numeric, 2) AS avg_income,
    ROUND(AVG(total_spend), 2) AS avg_spend,
    ROUND(AVG(total_purchase), 2) AS avg_purchases
FROM marketing
GROUP BY customer_segment
ORDER BY avg_spend DESC;

--9Q: Does discount-driven purchasing indicate an opportunity or dependency?

SELECT
    numdealspurchases,
    COUNT(*) AS customers,
    ROUND(AVG(total_purchase), 2) AS avg_total_purchases,
    ROUND(AVG(total_spend), 2) AS avg_spend,
    ROUND(AVG(income):: numeric, 2) AS avg_income,
    ROUND(AVG(response), 2) AS response_rate
FROM marketing
GROUP BY numdealspurchases
ORDER BY numdealspurchases DESC;

--10Q: Which countries show the strongest customer engagement?

SELECT
    country,
    COUNT(*) AS customers,
    SUM(response) AS responses,
    ROUND(100.0 * AVG(response), 2) AS response_rate,
    ROUND(AVG(total_spend), 2) AS avg_spend,
    ROUND(AVG(total_purchase), 2) AS avg_purchases
FROM marketing
GROUP BY country
ORDER BY response_rate DESC;

--11Q: Which customer characteristics should Maven consider when targeting future campaigns?

SELECT
    education,
    marital_status,
    CASE
        WHEN age < 30 THEN 'Under 30'
        WHEN age BETWEEN 30 AND 49 THEN '30-49'
        WHEN age BETWEEN 50 AND 69 THEN '50-69'
        ELSE '70+'
    END AS age_group,
    
    COUNT(*) AS customers,
    ROUND(100.0 * AVG(response), 2) AS response_rate,
    ROUND(AVG(total_spend), 2) AS avg_spend,
    ROUND(AVG(total_purchase), 2) AS avg_purchases

FROM marketing

GROUP BY
    education,
    marital_status,
    age_group

ORDER BY response_rate DESC;

--12Q: Does customer tenure affect campaign response?

SELECT
    customer_year,
    COUNT(*) AS customers,
    SUM(response) AS responses,
    ROUND(100.0 * AVG(response), 2) AS response_rate,
    ROUND(AVG(total_spend), 2) AS avg_spend
FROM marketing
GROUP BY customer_year
ORDER BY customer_year;

--13Q: Does family size influence customer spending?

SELECT
    total_childern,
    COUNT(*) AS customers,
    ROUND(AVG(total_spend), 2) AS avg_spend,
    ROUND(AVG(total_purchase), 2) AS avg_purchases,
    ROUND(100.0 * AVG(response), 2) AS response_rate
FROM marketing
GROUP BY total_childern
ORDER BY total_childern;

--14Q: Does previous campaign engagement predict future campaign response?

SELECT
    campaign_acceptance,
    COUNT(*) AS customers,
    SUM(response) AS responses,
    ROUND(100.0 * AVG(response), 2) AS response_rate,
    ROUND(AVG(total_spend), 2) AS avg_spend
FROM marketing
GROUP BY campaign_acceptance
ORDER BY campaign_acceptance;

--15Q: Does web conversion rate differ between customer segments?

--by campaign response
SELECT
    response,
    COUNT(*) AS customers,
    ROUND(AVG(web_conversion_rate):: numeric, 4) AS avg_web_conversion_rate,
    ROUND(AVG(numwebvisitsmonth), 2) AS avg_web_visits,
    ROUND(AVG(numwebpurchases), 2) AS avg_web_purchases
FROM marketing
GROUP BY response;
--by education
SELECT
    education,
    COUNT(*) AS customers,
    ROUND(AVG(web_conversion_rate):: numeric, 4) AS avg_web_conversion_rate
FROM marketing
GROUP BY education
ORDER BY avg_web_conversion_rate DESC;

--16Q: Do newer customers have different purchasing behavior?

SELECT
    customer_year,
    COUNT(*) AS customers,
    ROUND(AVG(total_spend), 2) AS avg_spend,
    ROUND(AVG(total_purchase), 2) AS avg_purchases,
    ROUND(AVG(numwebpurchases), 2) AS avg_web_purchases,
    ROUND(AVG(numstorepurchases), 2) AS avg_store_purchases
FROM marketing
GROUP BY customer_year
ORDER BY customer_year;