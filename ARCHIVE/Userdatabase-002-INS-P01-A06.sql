DROP PROCEDURE IF EXISTS yi.userdatabase_AD_PROC; 
DELIMITER ZZ
CREATE DEFINER=`root`@`localhost` PROCEDURE yi.userdatabase_AD_PROC(IN old_username VARCHAR(200))
BEGIN
	SET @`txt` = CONCAT("DROP USER '", old_username, "'@'localhost'");
	PREPARE `stmt` FROM @`txt`;
	EXECUTE `stmt`;
	DEALLOCATE PREPARE `stmt`;
	FLUSH PRIVILEGES;
END ZZ
DELIMITER ;

DROP PROCEDURE IF EXISTS yi.userdatabase_AU_PROC; 
DELIMITER ZZ
CREATE DEFINER=`root`@`localhost` PROCEDURE yi.userdatabase_AU_PROC(IN old_username VARCHAR(200), IN neo_username VARCHAR(200))
BEGIN
	SET @`txt` = CONCAT("RENAME USER '",old_username, "'@'localhost' TO '", neo_username, "'@'localhost'");
	PREPARE `stmt` FROM @`txt`;
	EXECUTE `stmt`;
	DEALLOCATE PREPARE `stmt`;
	FLUSH PRIVILEGES;
END ZZ
DELIMITER ;

DROP TRIGGER IF EXISTS yi.userdatabase_AD; 
DELIMITER $$ 
CREATE DEFINER=`root`@`localhost` TRIGGER yi.userdatabase_AD AFTER DELETE ON  yi.userdatabase  
FOR EACH ROW 
BEGIN 
	DECLARE exists_owner BOOLEAN DEFAULT FALSE; 
    DECLARE neo_username VARCHAR(200);
    SELECT TRUE INTO exists_owner FROM mysql.user WHERE user=OLD.username;
    SET neo_username=OLD.username;
    IF exists_owner THEN
		CALL yi.userdatabase_AD_PROC(neo_username);
    END IF; 
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS yi.userdatabase_AU; 
DELIMITER $$
CREATE DEFINER=`root`@`localhost` TRIGGER yi.userdatabase_AU AFTER UPDATE ON yi.userdatabase  
FOR EACH ROW 
BEGIN 
	DECLARE exists_owner BOOLEAN DEFAULT FALSE; 
    DECLARE neo_username VARCHAR(200);
    DECLARE old_username VARCHAR(200);
    SELECT TRUE INTO exists_owner FROM mysql.user WHERE user=OLD.username;
	SET neo_username=NEW.username;
    IF exists_owner THEN 
			CALL yi.userdatabase_AU_PROC(old_username, neo_username);
    END IF; 
END $$
DELIMITER ; 

DROP PROCEDURE IF EXISTS yi.userdatabase_AI_PROC; 
DELIMITER %%
CREATE DEFINER=`root`@`localhost` PROCEDURE yi.userdatabase_AI_PROC(IN neo_username VARCHAR(200),IN neo_password VARCHAR(45))
BEGIN
	SET @`txt` = CONCAT("CREATE USER '", neo_username, "'@'localhost' IDENTIFIED BY '",neo_password,"'");
    PREPARE `stmt` FROM @`txt`;
	EXECUTE `stmt`;
	DEALLOCATE PREPARE `stmt`;
	FLUSH PRIVILEGES;
END %%
DELIMITER ;


DROP PROCEDURE IF EXISTS yi.userdatabase_AU_PROC_Password; 
DELIMITER ZZ
CREATE DEFINER=`root`@`localhost` PROCEDURE yi.userdatabase_AU_PROC_Password(IN old_username VARCHAR(200), IN neo_password VARCHAR(200))
BEGIN
	SET @`txt` = CONCAT("ALTER USER '",old_username, "'@'localhost' IDENTIFIED BY '",neo_password,"'");
    PREPARE `stmt` FROM @`txt`;
	EXECUTE `stmt`;
	DEALLOCATE PREPARE `stmt`;
	FLUSH PRIVILEGES;
END ZZ
DELIMITER ;


SELECT * FROM MYSQL.USER; 
CALL yi.userdatabase_AI_PROC('marko1', 'marko123');
CALL yi.userdatabase_AI_PROC('marko2', 'marko123');
SELECT * FROM MYSQL.USER; 
CALL yi.userdatabase_AU_PROC('marko1', 'marko3');
CALL yi.userdatabase_AU_PROC('marko2', 'marko4');
SELECT * FROM MYSQL.USER; 
CALL yi.userdatabase_AU_PROC_Password('marko3', 'Marko456');
SELECT * FROM MYSQL.USER; 
CALL yi.userdatabase_AD_PROC('marko3'); 
CALL yi.userdatabase_AD_PROC('marko4'); 
SELECT * FROM MYSQL.USER; 

DROP TRIGGER IF EXISTS yi.userdatabase_AD; 
DROP TRIGGER IF EXISTS yi.userdatabase_AU; 

