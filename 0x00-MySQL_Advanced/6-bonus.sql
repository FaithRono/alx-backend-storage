-- Create stored procedure AddBonus
-- This procedure adds a new correction for a student
DELIMITER //
CREATE PROCEDURE AddBonus(IN user_id INT, IN project_name VARCHAR(255), IN score INT)
BEGIN
    DECLARE project_id INT;

    -- Check if the project already exists
    SELECT id INTO project_id FROM projects WHERE name = project_name;
    IF project_id IS NULL THEN
        -- If the project does not exist, create it
        INSERT INTO projects (name) VALUES (project_name);
        -- Get the ID of the newly created project
        SET project_id = LAST_INSERT_ID();
    END IF;

    -- Insert the new correction
    INSERT INTO corrections (user_id, project_id, score) VALUES (user_id, project_id, score);
END;
//
DELIMITER ;
