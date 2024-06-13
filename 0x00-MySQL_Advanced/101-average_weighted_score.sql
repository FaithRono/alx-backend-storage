-- Task 13 - Average weighted score for all!
-- Computes and stores the average weighted score for all students.

-- Drop the procedure if it already exists to avoid conflicts
DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUsers;

-- Change the delimiter to $$ to allow for multiple statements in the procedure
DELIMITER $$

-- Create the stored procedure ComputeAverageWeightedScoreForUsers
CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
    -- Update the average_score for all users
    UPDATE users AS U,
        -- Subquery to calculate the weighted average score for each user
        (SELECT U.id, SUM(score * weight) / SUM(weight) AS w_avg
        FROM users AS U
        JOIN corrections AS C ON U.id = C.user_id
        JOIN projects AS P ON C.project_id = P.id
        GROUP BY U.id) AS WA
    SET U.average_score = WA.w_avg
    WHERE U.id = WA.id;
END $$

-- Reset the delimiter back to ;
DELIMITER ;

