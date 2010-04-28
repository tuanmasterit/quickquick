CREATE TABLE  `definition_list_account_path`(
`account_id` bigint(30) unsigned PRIMARY KEY NOT NULL,
`path` TEXT,
FOREIGN KEY(`account_id`) REFERENCES `definition_list_account`(`account_id`)
) ENGINE=INNODB DEFAULT CHARSET=UTF8;

CREATE TRIGGER `makeAccountTree` AFTER INSERT ON `definition_list_account`
FOR EACH ROW BEGIN
	DECLARE `parent_path` TEXT DEFAULT '';
	SELECT `path` INTO `parent_path` FROM `definition_list_account_path` WHERE `account_id` = NEW.`account_parent_id`;
	INSERT INTO `definition_list_account_path` VALUES(
		NEW.`account_id`,
      	CONCAT(IF(LENGTH(`parent_path`) < 2, '/', `parent_path`), NEW.`account_id`, '/')
	);
END;

CREATE TRIGGER  `updateAccountTree` BEFORE UPDATE ON `definition_list_account`
FOR EACH ROW BEGIN
	DECLARE `old_path` TEXT DEFAULT '';
	DECLARE `new_path` TEXT DEFAULT '';
	SELECT `path` INTO `old_path` FROM `definition_list_account_path` WHERE `account_id` = NEW.`account_id`;
	SELECT `path` INTO `new_path` FROM `definition_list_account_path` WHERE `account_id` = NEW.`account_parent_id`;
	UPDATE `definition_list_account_path` SET `path` =
		REPLACE(`path`, `old_path`,
			CONCAT(IF(LENGTH(`new_path`) < 2, '/', `new_path`), NEW.`account_id`, '/') )
	WHERE LEFT(`path`, LENGTH(`old_path`)) = `old_path`;
END;