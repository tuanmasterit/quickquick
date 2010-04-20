SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `definition_list_module`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `definition_list_module` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `definition_list_module` (
  `module_id` VARCHAR(30) NOT NULL ,
  `module_code` CHAR(2) NOT NULL ,
  `module_name` VARCHAR(20) NOT NULL ,
  `inactive` BIT NOT NULL ,
  `created_by_userid` VARCHAR(30) NOT NULL ,
  `date_entered` DATETIME NOT NULL ,
  `last_modified_by_userid` VARCHAR(30) NOT NULL ,
  `date_last_modified` DATETIME NOT NULL ,
  PRIMARY KEY (`module_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `definition_list_execution`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `definition_list_execution` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `definition_list_execution` (
  `execution_id` VARCHAR(30) NOT NULL ,
  `module_id` VARCHAR(30) NOT NULL ,
  `execution_code` CHAR(2) NOT NULL ,
  `execution_name` VARCHAR(20) NOT NULL ,
  `inactive` BIT NOT NULL ,
  `created_by_userid` VARCHAR(30) NOT NULL ,
  `date_entered` DATETIME NOT NULL ,
  `last_modified_by_userid` VARCHAR(30) NOT NULL ,
  `date_last_modified` DATETIME NOT NULL ,
  PRIMARY KEY (`execution_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

SHOW WARNINGS;
CREATE INDEX `fk_definition_list_executions_definition_list_modules` ON `definition_list_execution` (`module_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `accountant_master_entry`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `accountant_master_entry` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `accountant_master_entry` (
  `entry_id` VARCHAR(30) NOT NULL ,
  `module_id` VARCHAR(30) NOT NULL ,
  `execution_id` VARCHAR(30) NOT NULL ,
  `voucher_number` VARCHAR(20) NOT NULL ,
  `voucher_date` DATETIME NOT NULL ,
  `created_by_userid` VARCHAR(30) NOT NULL ,
  `date_entered` DATETIME NOT NULL ,
  `last_modified_by_userid` VARCHAR(30) NOT NULL ,
  `date_last_modified` DATETIME NOT NULL ,
  PRIMARY KEY (`entry_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

SHOW WARNINGS;
CREATE INDEX `fk_accountant_master_entries_definition_list_modules1` ON `accountant_master_entry` (`module_id` ASC) ;

SHOW WARNINGS;
CREATE INDEX `fk_accountant_master_entries_definition_list_executions1` ON `accountant_master_entry` (`execution_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `definition_list_account`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `definition_list_account` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `definition_list_account` (
  `account_id` VARCHAR(30) NOT NULL ,
  `account_code` VARCHAR(10) NOT NULL ,
  `account_name` VARCHAR(20) NOT NULL ,
  `account_note` VARCHAR(100) NOT NULL ,
  `inactive` BIT NOT NULL ,
  `created_by_userid` VARCHAR(30) NOT NULL ,
  `date_entered` DATETIME NOT NULL ,
  `last_modified_by_userid` VARCHAR(30) NOT NULL ,
  `date_last_modified` DATETIME NOT NULL ,
  PRIMARY KEY (`account_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `definition_list_currency`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `definition_list_currency` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `definition_list_currency` (
  `currency_id` VARCHAR(30) NOT NULL ,
  `currency_code` CHAR(3) NOT NULL ,
  `currency_name` VARCHAR(20) NOT NULL ,
  `inactive` BIT NOT NULL ,
  `created_by_userid` VARCHAR(30) NOT NULL ,
  `date_entered` DATETIME NOT NULL ,
  `last_modified_by_userid` VARCHAR(30) NOT NULL ,
  `date_last_modified` DATETIME NOT NULL ,
  PRIMARY KEY (`currency_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `definition_list_subject`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `definition_list_subject` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `definition_list_subject` (
  `subject_id` VARCHAR(30) NOT NULL ,
  `subject_code` CHAR(3) NOT NULL ,
  `subject_name` VARCHAR(20) NOT NULL ,
  `is_software_user` BIT NOT NULL ,
  `is_manufacturer` BIT NOT NULL ,
  `is_supplier` BIT NOT NULL ,
  `is_customer` BIT NOT NULL ,
  `is_government` BIT NOT NULL ,
  `is_bank` BIT NOT NULL ,
  `inactive` BIT NOT NULL ,
  `created_by_userid` VARCHAR(30) NOT NULL ,
  `date_entered` DATETIME NOT NULL ,
  `last_modified_by_userid` VARCHAR(30) NOT NULL ,
  `date_last_modified` DATETIME NOT NULL ,
  PRIMARY KEY (`subject_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `accountant_detail_entry`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `accountant_detail_entry` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `accountant_detail_entry` (
  `entry_id` VARCHAR(30) NOT NULL ,
  `debit_account_id` VARCHAR(30) NOT NULL ,
  `debit_subject_id` VARCHAR(30) NOT NULL ,
  `credit_account_id` VARCHAR(30) NOT NULL ,
  `credit_subject_id` VARCHAR(30) NOT NULL ,
  `original_amount` DECIMAL(18,4) NOT NULL ,
  `currency_id` VARCHAR(30) NOT NULL ,
  `converted_amount` DECIMAL(18,8) NOT NULL ,
  PRIMARY KEY (`entry_id`, `debit_account_id`, `credit_account_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

SHOW WARNINGS;
CREATE INDEX `fk_accountant_detail_entries_accountant_master_entries1` ON `accountant_detail_entry` (`entry_id` ASC) ;

SHOW WARNINGS;
CREATE INDEX `fk_accountant_detail_entries_definition_list_accounts1` ON `accountant_detail_entry` (`debit_account_id` ASC) ;

SHOW WARNINGS;
CREATE INDEX `fk_accountant_detail_entries_definition_list_accounts2` ON `accountant_detail_entry` (`credit_account_id` ASC) ;

SHOW WARNINGS;
CREATE INDEX `fk_accountant_detail_entries_definition_list_currencies1` ON `accountant_detail_entry` (`currency_id` ASC) ;

SHOW WARNINGS;
CREATE INDEX `fk_accountant_detail_entries_definition_list_subject1` ON `accountant_detail_entry` (`debit_subject_id` ASC) ;

SHOW WARNINGS;
CREATE INDEX `fk_accountant_detail_entries_definition_list_subject2` ON `accountant_detail_entry` (`credit_subject_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `definition_list_function`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `definition_list_function` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `definition_list_function` (
  `function_id` VARCHAR(30) NOT NULL ,
  `execution_id` VARCHAR(30) NOT NULL ,
  `function_code` VARCHAR(10) NOT NULL ,
  `function_name` VARCHAR(20) NOT NULL ,
  `form_name` VARCHAR(20) NOT NULL ,
  `inactive` BIT NOT NULL ,
  `created_by_userid` VARCHAR(30) NOT NULL ,
  `date_entered` DATETIME NOT NULL ,
  `last_modified_by_userid` VARCHAR(30) NOT NULL ,
  `date_last_modified` DATETIME NOT NULL ,
  PRIMARY KEY (`function_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

SHOW WARNINGS;
CREATE INDEX `fk_definition_list_function_definition_list_execution1` ON `definition_list_function` (`execution_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `definition_list_staff`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `definition_list_staff` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `definition_list_staff` (
  `staff_id` VARCHAR(30) NOT NULL ,
  `staff_code` VARCHAR(10) NOT NULL ,
  `first_name` VARCHAR(20) NOT NULL ,
  `middle_name` VARCHAR(20) NOT NULL ,
  `last_name` VARCHAR(20) NOT NULL ,
  `birth_date` DATETIME NOT NULL ,
  `id_number` VARCHAR(15) NOT NULL ,
  `id_issuing_office` VARCHAR(50) NOT NULL ,
  `id_issuing_date` DATETIME NOT NULL ,
  `social_number` VARCHAR(15) NOT NULL ,
  `resident_address` VARCHAR(50) NOT NULL ,
  `contact_address` VARCHAR(50) NOT NULL ,
  `home_phone` VARCHAR(20) NOT NULL ,
  `cell_phone` VARCHAR(20) NOT NULL ,
  `Email` VARCHAR(20) NOT NULL ,
  `inactive` BIT NOT NULL ,
  `created_by_userid` VARCHAR(30) NOT NULL ,
  `date_entered` DATETIME NOT NULL ,
  `last_modified_by_userid` VARCHAR(30) NOT NULL ,
  `date_last_modified` DATETIME NOT NULL ,
  PRIMARY KEY (`staff_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `definition_list_department`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `definition_list_department` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `definition_list_department` (
  `department_id` VARCHAR(30) NOT NULL ,
  `subject_id` VARCHAR(30) NOT NULL ,
  `department_code` VARCHAR(10) NOT NULL ,
  `department_name` VARCHAR(20) NOT NULL ,
  `inactive` BIT NOT NULL ,
  `created_by_userid` VARCHAR(30) NOT NULL ,
  `date_entered` DATETIME NOT NULL ,
  `last_modified_by_userid` VARCHAR(30) NOT NULL ,
  `date_last_modified` DATETIME NOT NULL ,
  PRIMARY KEY (`department_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

SHOW WARNINGS;
CREATE INDEX `fk_definition_list_department_definition_list_subject1` ON `definition_list_department` (`subject_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `definition_list_role`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `definition_list_role` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `definition_list_role` (
  `role_id` VARCHAR(30) NOT NULL ,
  `department_id` VARCHAR(30) NOT NULL ,
  `role_code` VARCHAR(10) NOT NULL ,
  `role_name` VARCHAR(20) NOT NULL ,
  `inactive` BIT NOT NULL ,
  `created_by_userid` VARCHAR(30) NOT NULL ,
  `date_entered` DATETIME NOT NULL ,
  `last_modified_by_userid` VARCHAR(30) NOT NULL ,
  `date_last_modified` DATETIME NOT NULL ,
  PRIMARY KEY (`role_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

SHOW WARNINGS;
CREATE INDEX `fk_definition_list_role_definition_list_department1` ON `definition_list_role` (`department_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `definition_list_user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `definition_list_user` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `definition_list_user` (
  `user_id` VARCHAR(30) NOT NULL ,
  `staff_id` VARCHAR(30) NOT NULL ,
  `role_id` VARCHAR(30) NOT NULL ,
  `user_name` VARCHAR(20) NOT NULL ,
  `password` VARCHAR(20) NOT NULL ,
  `inactive` BIT NOT NULL ,
  `created_by_userid` VARCHAR(30) NOT NULL ,
  `date_entered` DATETIME NOT NULL ,
  `last_modified_by_userid` VARCHAR(30) NOT NULL ,
  `date_last_modified` DATETIME NOT NULL ,
  PRIMARY KEY (`user_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

SHOW WARNINGS;
CREATE INDEX `fk_definition_list_user_definition_list_staff1` ON `definition_list_user` (`staff_id` ASC) ;

SHOW WARNINGS;
CREATE INDEX `fk_definition_list_user_definition_list_role1` ON `definition_list_user` (`role_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `definition_relation_role_function`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `definition_relation_role_function` ;

SHOW WARNINGS;
CREATE  TABLE IF NOT EXISTS `definition_relation_role_function` (
  `role_id` VARCHAR(30) NOT NULL ,
  `function_id` VARCHAR(30) NOT NULL ,
  `can_list` BIT NOT NULL ,
  `can_view` BIT NOT NULL ,
  `can_add` BIT NOT NULL ,
  `can_modify` BIT NOT NULL ,
  `can_change` BIT NOT NULL ,
  `can_delete` BIT NOT NULL ,
  `can_print` BIT NOT NULL ,
  PRIMARY KEY (`role_id`, `function_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

SHOW WARNINGS;
CREATE INDEX `fk_definition_relation_role_function_definition_list_role1` ON `definition_relation_role_function` (`role_id` ASC) ;

SHOW WARNINGS;
CREATE INDEX `fk_definition_relation_role_function_definition_list_function1` ON `definition_relation_role_function` (`function_id` ASC) ;

SHOW WARNINGS;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
