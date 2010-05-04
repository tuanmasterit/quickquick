--
-- Triggers `definition_list_account`
--
DROP TRIGGER IF EXISTS `quickquickdb`.`makeAccountTree`;
DELIMITER //
CREATE TRIGGER `quickquickdb`.`makeAccountTree` AFTER INSERT ON `quickquickdb`.`definition_list_account`
 FOR EACH ROW BEGIN
 DECLARE `parent_path` TEXT DEFAULT '';
 SELECT `path` INTO `parent_path` FROM `definition_list_account_path` WHERE `account_id` = NEW.`account_parent_id`;
 INSERT INTO `definition_list_account_path` VALUES(
  NEW.`account_id`,
       CONCAT(IF(LENGTH(`parent_path`) < 2, '/', `parent_path`), NEW.`account_id`, '/')
 );
END
//
DELIMITER ;
DROP TRIGGER IF EXISTS `quickquickdb`.`updateAccountTree`;
DELIMITER //
CREATE TRIGGER `quickquickdb`.`updateAccountTree` BEFORE UPDATE ON `quickquickdb`.`definition_list_account`
 FOR EACH ROW BEGIN
 DECLARE `old_path` TEXT DEFAULT '';
 DECLARE `new_path` TEXT DEFAULT '';
 SELECT `path` INTO `old_path` FROM `definition_list_account_path` WHERE `account_id` = NEW.`account_id`;
 SELECT `path` INTO `new_path` FROM `definition_list_account_path` WHERE `account_id` = NEW.`account_parent_id`;
 UPDATE `definition_list_account_path` SET `path` =
  REPLACE(`path`, `old_path`,
   CONCAT(IF(LENGTH(`new_path`) < 2, '/', `new_path`), NEW.`account_id`, '/') )
 WHERE LEFT(`path`, LENGTH(`old_path`)) = `old_path`;
END
//
DELIMITER ;

--
-- Triggers `definition_list_group`
--
DROP TRIGGER IF EXISTS `quickquickdb`.`makeGroupTree`;
DELIMITER //
CREATE TRIGGER `quickquickdb`.`makeGroupTree` AFTER INSERT ON `quickquickdb`.`definition_list_group`
 FOR EACH ROW BEGIN
 DECLARE `parent_path` TEXT DEFAULT '';
 SELECT `path` INTO `parent_path` FROM `definition_list_group_path` WHERE `group_id` = NEW.`group_parent_id`;
 INSERT INTO `definition_list_group_path` VALUES(
  NEW.`group_id`,
       CONCAT(IF(LENGTH(`parent_path`) < 2, '/', `parent_path`), NEW.`group_id`, '/')
 );
END
//
DELIMITER ;
DROP TRIGGER IF EXISTS `quickquickdb`.`updateGroupTree`;
DELIMITER //
CREATE TRIGGER `quickquickdb`.`updateGroupTree` BEFORE UPDATE ON `quickquickdb`.`definition_list_group`
 FOR EACH ROW BEGIN
 DECLARE `old_path` TEXT DEFAULT '';
 DECLARE `new_path` TEXT DEFAULT '';
 SELECT `path` INTO `old_path` FROM `definition_list_group_path` WHERE `group_id` = NEW.`group_id`;
 SELECT `path` INTO `new_path` FROM `definition_list_group_path` WHERE `group_id` = NEW.`group_parent_id`;
 UPDATE `definition_list_group_path` SET `path` =
  REPLACE(`path`, `old_path`,
   CONCAT(IF(LENGTH(`new_path`) < 2, '/', `new_path`), NEW.`group_id`, '/') )
 WHERE LEFT(`path`, LENGTH(`old_path`)) = `old_path`;
END
//
DELIMITER ;