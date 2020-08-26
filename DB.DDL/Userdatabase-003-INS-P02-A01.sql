DELIMITER $$ 
CREATE TRIGGER userinfo_AU BEFORE UPDATE ON  yi.userinfo  
FOR EACH ROW 
BEGIN 
   DECLARE exists_user_old BOOLEAN DEFAULT FALSE; 
   DECLARE exists_user_neo BOOLEAN DEFAULT FALSE; 
   
   DECLARE exists_owner_old BOOLEAN DEFAULT FALSE; 
   DECLARE exists_owner_neo BOOLEAN DEFAULT FALSE;
  
   SELECT TRUE INTO exists_user_old FROM yi.userdatabase WHERE username=CURRENT.username;
   SELECT TRUE INTO exists_user_neo FROM yi.userdatabase WHERE username=NEW.username;
   
   SELECT TRUE INTO exists_owner_old FROM mysql.user WHERE username=CURRENT.username;
   SELECT TRUE INTO exists_owner_neo FROM mysql.user WHERE username=NEW.username;

   IF exists_user_old AND exists_owner_neo THEN 
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'TARGET DATABASE USER EXISTS.';
   END IF;
END $$
DELIMITER $$ 