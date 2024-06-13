-- Task 12: Average weighted score
-- Creates a stored procedure ComputeAverageWeightedScoreForUser
-- that computes and stores the average weighted score for a student.
-- user_id: a users.id value (you can assume user_id is linked to an existing users)

-- Drop the procedure if it already exists to avoid conflicts
DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUser;

-- Change the delimiter to $$ to allow for multiple statements in the procedure
DELIMITER $$

-- Create the stored procedure ComputeAverageWeightedScoreForUser
CREATE PROCEDURE ComputeAverageWeightedScoreForUser(user_id INT)
BEGIN
    -- Declare a variable to hold the weighted average score
    DECLARE w_avg_score FLOAT;
    
    -- Calculate the weighted average score for the user
    SET w_avg_score = (
        SELECT SUM(score * weight) / SUM(weight)
        FROM users AS U
        JOIN corrections AS C ON U.id = C.user_id
        JOIN projects AS P ON C.project_id = P.id
        WHERE U.id = user_id
    );
    
    -- Update the user's average score in the users table
    UPDATE users SET average_score = w_avg_score WHERE id = user_id;
END $$

-- Reset the delimiter back to ;
DELIMITER ;

