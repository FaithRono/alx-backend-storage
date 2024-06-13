-- 2-fans.sql
-- Calculate the number of fans for each country origin of bands
-- and rank them by the number of fans in descending order.

SELECT origin, COUNT(*) as nb_fans
FROM bands
GROUP BY origin
ORDER BY nb_fans DESC;
