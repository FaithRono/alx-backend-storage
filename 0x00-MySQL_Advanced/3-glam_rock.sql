-- A SQL script that lists all bands with Glam rock as their main style, ranked by their longevity

-- Select the band_name and calculate the lifespan as the difference between the split year (or 2022 if NULL) and the formed year
SELECT band_name, (IFNULL(split, '2022') - formed) AS lifespan
    -- From the metal_bands table
    FROM metal_bands
    -- Filter to only include bands with 'Glam rock' in their style
    WHERE style LIKE '%Glam rock%'
    -- Order the results by lifespan in descending order (longest lifespan first)
    ORDER BY lifespan DESC;

