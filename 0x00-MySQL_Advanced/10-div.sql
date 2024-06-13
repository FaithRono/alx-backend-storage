-- Task 10: Safe divide - creates a function SafeDiv that divides
-- (and returns) the first by the second number
-- or returns 0 if the second number is equal to 0
DELIMITER |
DROP FUNCTION IF EXISTS SafeDiv; -- Drop the function if it already exists
CREATE FUNCTION SafeDiv (a INT, b INT) -- Create the SafeDiv function with two integer parameters
RETURNS FLOAT -- Specify that the function returns a float value
BEGIN
    DECLARE result FLOAT; -- Declare a variable to store the result of the division
    IF b = 0 THEN -- Check if the second number is equal to 0
        SET result = 0; -- Set the result to 0 if the second number is 0
    ELSE
        SET result = a / b; -- Calculate the division result if the second number is not 0
    END IF;
    RETURN result; -- Return the result of the division
END;
|  -- End of the function definition

