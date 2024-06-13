-- Task: Create a view named need_meeting that lists all students
-- that have a score under 80 (strict) and either have no last_meeting date
-- or have a last_meeting date that is more than 1 month ago

-- Drop the view if it already exists to avoid conflicts
DROP VIEW IF EXISTS need_meeting;

-- Create the view named need_meeting
CREATE VIEW need_meeting
AS
    -- Select the name of the students that meet the criteria
    SELECT name
    FROM students
    -- Filter the students based on their score and last_meeting date
    WHERE score < 80 -- Students with a score less than 80
        AND (last_meeting IS NULL -- Students with no last_meeting date
            OR last_meeting < DATE_SUB(NOW(), INTERVAL 1 MONTH)); -- Students with a last_meeting date more than 1 month ago

