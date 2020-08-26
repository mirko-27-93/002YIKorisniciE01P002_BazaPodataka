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



