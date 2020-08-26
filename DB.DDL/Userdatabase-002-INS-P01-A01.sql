DELIMITER $$ 
CREATE TRIGGER userdatabase_AD AFTER DELETE ON  yi.userdatabase  
FOR EACH ROW 
BEGIN 
	DECLARE exists_owner BOOLEAN DEFAULT FALSE; 
    DECLARE neo_username VARCHAR(45);
    SELECT TRUE INTO exists_owner FROM mysql.user WHERE username=OLD.username;
    SET neo_username=OLD.username;
    IF exists_owner THEN
		DROP USER neo_username@'localhost'; 
    END IF; 
END $$
DELIMITER $$;

DELIMITER $$
CREATE TRIGGER userdatabase_AU AFTER UPDATE ON yi.userdatabase  
FOR EACH ROW 
BEGIN 
	DECLARE exists_owner BOOLEAN DEFAULT FALSE; 
    DECLARE neo_username VARCHAR(45);
    DECLARE old_username VARCHAR(45);
    SELECT TRUE INTO exists_owner FROM mysql.user WHERE username=OLD.username;
	SET neo_username=NEW.username;
    IF exists_owner THEN 
		RENAME USER old_username@'localhost' TO neo_username@'localhost'; 
    END IF; 
END $$
DELIMITER ; 