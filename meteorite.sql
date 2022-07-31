-- Queries for my meteorite landing dashboard

--#1
SELECT * FROM Meteorite..Meteorite_Landings


--#2 
SELECT name, [mass (g)], [mass (g)]*0.00220462 AS [mass (lb)], year, reclat, reclong 
FROM Meteorite..Meteorite_Landings
WHERE [mass (g)] IS NOT NULL 
AND year IS NOT NULL 
AND reclat IS NOT NULL 
AND reclong IS NOT NULL
AND GeoLocation != '(0.0, 0.0)'
ORDER BY year


--#3
SELECT year, COUNT(*) AS count
FROM Meteorite..Meteorite_Landings
WHERE year IS NOT NULL AND year <= 2022
GROUP BY year
ORDER BY year


--#4
select (case when year <= 1499 then 'Before 1500s'
             when year >= 1500 and year <= 1599 then '1500s'
			 when year >= 1600 and year <= 1699 then '1600s'
			 when year >= 1700 and year <= 1799 then '1700s'
             when year >= 1801 and year <= 1899 then '1800s'
			 when year >= 1900 and year <= 1999 then '1900s'
			 when year >= 2000 then '2000s'
             else 'other'
        end) as range, count(*) as TotalMeteorites
from Meteorite..Meteorite_Landings
WHERE year IS NOT NULL AND year <= 2022 
group by (case when year <= 1499 then 'Before 1500s'
             when year >= 1500 and year <= 1599 then '1500s'
			 when year >= 1600 and year <= 1699 then '1600s'
			 when year >= 1700 and year <= 1799 then '1700s'
             when year >= 1801 and year <= 1899 then '1800s'
			 when year >= 1900 and year <= 1999 then '1900s'
			 when year >= 2000 then '2000s'
             else 'other'
          end)