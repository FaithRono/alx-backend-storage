-- Create stored procedure ComputeAverageScoreForUser
-- This procedure computes and stores the average score for a student
-- Parameters:
--   - user_id: the ID of the student
DELIMITER //
CREATE PROCEDURE ComputeAverageScoreForUser(IN user_id INT) -- Declare the stored procedure with one input parameter
BEGIN
    DECLARE total_score FLOAT; -- Declare a variable to store the total score for the user
    DECLARE total_projects INT; -- Declare a variable to store the total number of projects for the user
    DECLARE avg_score FLOAT; -- Declare a variable to store the average score

    -- Compute total score for the user
    SELECT SUM(score) INTO total_score FROM corrections WHERE user_id = user_id;

    -- Compute total number of projects for the user
    SELECT COUNT(DISTINCT project_id) INTO total_projects FROM corrections WHERE user_id = user_id;

    -- Compute average score
    IF total_projects > 0 THEN -- Check if the user has projects to avoid division by zero
        SET avg_score = total_score / total_projects; -- Calculate the average score
    ELSE
        SET avg_score = 0; -- Set average score to 0 if the user has no projects
    END IF;

    -- Update the user's average score in the users table
    UPDATE users SET average_score = avg_score WHERE id = user_id;
END;
//
DELIMITER ;
