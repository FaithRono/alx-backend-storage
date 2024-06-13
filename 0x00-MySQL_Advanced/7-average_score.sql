-- Task 7: Average score - creates a stored procedure ComputeOverallScoreForUser
-- that computes and store the overall score for a student.

-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS ComputeAverageScoreForUser;

-- Change the delimiter to handle the procedure definition
DELIMITER $$

-- Create the stored procedure ComputeAverageScoreForUser
CREATE PROCEDURE ComputeAverageScoreForUser(
    IN user_id INT)
BEGIN
    -- Declare a variable to store the average score
    DECLARE avg_score FLOAT;

    -- Calculate the average score for the specified user
    SET avg_score = (SELECT AVG(score) FROM corrections AS C WHERE C.user_id=user_id);

    -- Update the users table with the calculated average score for the specified user
    UPDATE users SET average_score = avg_score WHERE id=user_id;
END
$$

-- Restore the default delimiter
DELIMITER ;

