-- Task 2: Best band ever! - ranks country origins of bands, ordered by the number of (non-unique) fans

-- Select distinct origin and sum of fans for each origin
SELECT DISTINCT `origin`, SUM(`fans`) as `nb_fans`
    -- From the metal_bands table
    FROM `metal_bands`
    -- Group the results by origin
    GROUP BY `origin`
    -- Order the results by the total number of fans in descending order
    ORDER BY `nb_fans` DESC;

