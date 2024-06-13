-- Create trigger to reset valid_email only when email has been changed
-- Change the delimiter to allow for the creation of a trigger
DELIMITER //
-- Create a trigger named reset_valid_email to activate before an update operation on the users table
CREATE TRIGGER reset_valid_email BEFORE UPDATE ON users
-- Define the trigger to execute for each row affected by the update operation
FOR EACH ROW
BEGIN
    -- Check if the email value is being changed
    IF OLD.email != NEW.email THEN
        -- If the email is being changed, set the valid_email attribute of the new row to 0
        SET NEW.valid_email = 0;
    END IF;
END;
//
-- Reset the delimiter back to ;
DELIMITER ;
