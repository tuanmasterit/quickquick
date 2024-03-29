-- phpMyAdmin SQL Dump
-- version 3.2.1-rc1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Apr 21, 2010 at 03:20 PM
-- Server version: 5.1.36
-- PHP Version: 5.3.0

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `quickquickdb`
--

-- --------------------------------------------------------

--
-- Table structure for table `accountant_detail_entry`
--

CREATE TABLE IF NOT EXISTS `accountant_detail_entry` (
  `entry_id` bigint(30) unsigned NOT NULL,
  `debit_account_id` bigint(30) unsigned NOT NULL,
  `debit_subject_id` bigint(30) unsigned NOT NULL,
  `credit_account_id` bigint(30) unsigned NOT NULL,
  `credit_subject_id` bigint(30) unsigned NOT NULL,
  `original_amount` decimal(18,4) NOT NULL,
  `currency_id` bigint(30) unsigned NOT NULL,
  `converted_amount` decimal(18,8) NOT NULL,
  PRIMARY KEY (`entry_id`,`debit_account_id`,`credit_account_id`),
  KEY `fk_accountant_detail_entries_accountant_master_entries1` (`entry_id`),
  KEY `fk_accountant_detail_entries_definition_list_accounts1` (`debit_account_id`),
  KEY `fk_accountant_detail_entries_definition_list_accounts2` (`credit_account_id`),
  KEY `fk_accountant_detail_entries_definition_list_currencies1` (`currency_id`),
  KEY `fk_accountant_detail_entries_definition_list_subject1` (`debit_subject_id`),
  KEY `fk_accountant_detail_entries_definition_list_subject2` (`credit_subject_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `accountant_detail_entry`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_master_entry`
--

CREATE TABLE IF NOT EXISTS `accountant_master_entry` (
  `entry_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `module_id` bigint(30) unsigned NOT NULL,
  `execution_id` bigint(30) unsigned NOT NULL,
  `voucher_number` varchar(20) NOT NULL,
  `voucher_date` datetime NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`entry_id`),
  KEY `fk_accountant_master_entries_definition_list_modules1` (`module_id`),
  KEY `fk_accountant_master_entries_definition_list_executions1` (`execution_id`),
  KEY `fk_entry_created_user` (`created_by_userid`),
  KEY `fk_entry_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `accountant_master_entry`
--


-- --------------------------------------------------------

--
-- Table structure for table `definition_list_account`
--

CREATE TABLE IF NOT EXISTS `definition_list_account` (
  `account_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `account_code` varchar(10) NOT NULL,
  `account_name` varchar(20) NOT NULL,
  `account_note` varchar(100) NOT NULL,
  `inactive` bit(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`account_id`),
  KEY `fk_account_created_user` (`created_by_userid`),
  KEY `fk_account_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `definition_list_account`
--


-- --------------------------------------------------------

--
-- Table structure for table `definition_list_currency`
--

CREATE TABLE IF NOT EXISTS `definition_list_currency` (
  `currency_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `currency_code` char(3) NOT NULL,
  `currency_name` varchar(20) NOT NULL,
  `inactive` bit(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`currency_id`),
  KEY `fk_currency_created_user` (`created_by_userid`),
  KEY `fk_currency_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `definition_list_currency`
--


-- --------------------------------------------------------

--
-- Table structure for table `definition_list_department`
--

CREATE TABLE IF NOT EXISTS `definition_list_department` (
  `department_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `subject_id` bigint(30) unsigned NOT NULL,
  `department_code` varchar(10) NOT NULL,
  `department_name` varchar(20) NOT NULL,
  `department_function` varchar(100) NOT NULL,
  `inactive` bit(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`department_id`),
  KEY `fk_definition_list_department_definition_list_subject1` (`subject_id`),
  KEY `fk_department_created_user` (`created_by_userid`),
  KEY `fk_department_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `definition_list_department`
--

INSERT INTO `definition_list_department` (`department_id`, `subject_id`, `department_code`, `department_name`, `department_function`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, 1, '', '', '', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(2, 2, 'KT', 'Kế toán', '', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(3, 2, 'KD', 'Kinh doanh', '', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(4, 2, 'MH', 'Mua hàng', '', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(5, 2, 'KH', 'Kho hàng', '', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(6, 2, 'GN', 'Giao nhận', '', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(7, 2, 'HC', 'Hành chính nhân sự', '', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_execution`
--

CREATE TABLE IF NOT EXISTS `definition_list_execution` (
  `execution_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `module_id` bigint(30) unsigned NOT NULL,
  `execution_code` char(2) NOT NULL,
  `execution_name` varchar(20) NOT NULL,
  `inactive` bit(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`execution_id`),
  KEY `fk_definition_list_executions_definition_list_modules` (`module_id`),
  KEY `fk_execution_created_user` (`created_by_userid`),
  KEY `fk_execution_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `definition_list_execution`
--

INSERT INTO `definition_list_execution` (`execution_id`, `module_id`, `execution_code`, `execution_name`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, 1, 'MD', 'Danh mục - MH', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(2, 1, 'MX', 'Xem hiện trạng - MH', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(3, 1, 'MK', 'Kế hoạch - MH', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(4, 1, 'MP', 'Phát hành - MH', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(5, 1, 'MT', 'Thanh toán - MH', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_function`
--

CREATE TABLE IF NOT EXISTS `definition_list_function` (
  `function_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `execution_id` bigint(30) unsigned NOT NULL,
  `function_code` varchar(10) NOT NULL,
  `function_name` varchar(20) NOT NULL,
  `form_name` varchar(20) NOT NULL,
  `inactive` bit(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`function_id`),
  KEY `fk_definition_list_function_definition_list_execution1` (`execution_id`),
  KEY `fk_function_modified_user` (`last_modified_by_userid`),
  KEY `fk_function_created_user` (`created_by_userid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `definition_list_function`
--

INSERT INTO `definition_list_function` (`function_id`, `execution_id`, `function_code`, `function_name`, `form_name`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, 1, 'PNHM', 'Phân nhóm hàng mua', '', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(2, 1, 'DMMH', 'Danh mục mặt hàng', '', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(3, 1, 'KHBH', 'Kế hoạch bán hàng', '', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(4, 1, 'HTTK', 'Hiện trạng tồn kho', '', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(5, 1, 'HTTQ', 'Hiện trạng tồn quỹ', '', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(6, 1, 'LSMH', 'Lịch sử mua hàng', '', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_module`
--

CREATE TABLE IF NOT EXISTS `definition_list_module` (
  `module_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `module_code` char(2) NOT NULL,
  `module_name` varchar(20) NOT NULL,
  `inactive` bit(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`module_id`),
  KEY `fk_module_modified_user` (`last_modified_by_userid`),
  KEY `fk_module_created_user` (`created_by_userid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `definition_list_module`
--

INSERT INTO `definition_list_module` (`module_id`, `module_code`, `module_name`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, 'MH', 'Mua hàng', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(2, 'GN', 'Giao nhận hàng', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(3, 'KH', 'Nhập xuất tồn kho', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(4, 'KT', 'Hạch toán kế toán', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(5, 'BH', 'Bán hàng', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(6, 'HC', 'Hành chính nhân sự', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(7, 'TL', 'Thiết lập hệ thống', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(8, 'QT', 'Ra quyết định', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_role`
--

CREATE TABLE IF NOT EXISTS `definition_list_role` (
  `role_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `department_id` bigint(30) unsigned NOT NULL,
  `role_code` varchar(10) NOT NULL,
  `role_name` varchar(20) NOT NULL,
  `inactive` bit(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`role_id`),
  KEY `fk_definition_list_role_definition_list_department1` (`department_id`),
  KEY `fk_role_modified_user` (`last_modified_by_userid`),
  KEY `fk_role_created_user` (`created_by_userid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `definition_list_role`
--

INSERT INTO `definition_list_role` (`role_id`, `department_id`, `role_code`, `role_name`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, 1, '', '', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(2, 1, 'VTM', 'Toàn quyền', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_staff`
--

CREATE TABLE IF NOT EXISTS `definition_list_staff` (
  `staff_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `staff_code` varchar(10) NOT NULL,
  `first_name` varchar(20) NOT NULL,
  `middle_name` varchar(20) NOT NULL,
  `last_name` varchar(20) NOT NULL,
  `birth_date` datetime NOT NULL,
  `id_number` varchar(15) NOT NULL,
  `id_issuing_office` varchar(50) NOT NULL,
  `id_issuing_date` datetime NOT NULL,
  `social_number` varchar(15) NOT NULL,
  `resident_address` varchar(50) NOT NULL,
  `contact_address` varchar(50) NOT NULL,
  `home_phone` varchar(20) NOT NULL,
  `cell_phone` varchar(20) NOT NULL,
  `email` varchar(20) NOT NULL,
  `inactive` bit(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`staff_id`),
  KEY `fk_staff_modified_user` (`last_modified_by_userid`),
  KEY `fk_staff_created_user` (`created_by_userid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `definition_list_staff`
--

INSERT INTO `definition_list_staff` (`staff_id`, `staff_code`, `first_name`, `middle_name`, `last_name`, `birth_date`, `id_number`, `id_issuing_office`, `id_issuing_date`, `social_number`, `resident_address`, `contact_address`, `home_phone`, `cell_phone`, `email`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, '', '', '', '', '1900-01-01 00:00:00', '', '', '1900-01-01 00:00:00', '', '', '', '', '', '', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(2, 'VTM', 'Nhân viên', '', 'VTM', '1900-01-01 00:00:00', '', '', '1900-01-01 00:00:00', '', '', '', '', '', '', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_subject`
--

CREATE TABLE IF NOT EXISTS `definition_list_subject` (
  `subject_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `subject_code` char(3) NOT NULL,
  `subject_name` varchar(100) NOT NULL,
  `subject_address` varchar(100) NOT NULL,
  `subject_tax_code` varchar(20) NOT NULL,
  `is_software_user` bit(1) NOT NULL,
  `is_manufacturer` bit(1) NOT NULL,
  `is_supplier` bit(1) NOT NULL,
  `is_customer` bit(1) NOT NULL,
  `is_government` bit(1) NOT NULL,
  `is_bank` bit(1) NOT NULL,
  `inactive` bit(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`subject_id`),
  KEY `fk_subject_modified_user` (`last_modified_by_userid`),
  KEY `fk_subject_created_user` (`created_by_userid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `definition_list_subject`
--

INSERT INTO `definition_list_subject` (`subject_id`, `subject_code`, `subject_name`, `subject_address`, `subject_tax_code`, `is_software_user`, `is_manufacturer`, `is_supplier`, `is_customer`, `is_government`, `is_bank`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, '', '', '', '', b'0', b'0', b'0', b'0', b'0', b'0', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(2, 'N2H', 'Công ty Nhanh Nhanh', '', '', b'1', b'0', b'1', b'1', b'0', b'0', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_user`
--

CREATE TABLE IF NOT EXISTS `definition_list_user` (
  `user_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `staff_id` bigint(30) unsigned NOT NULL,
  `role_id` bigint(30) unsigned NOT NULL,
  `user_name` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL,
  `inactive` bit(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`user_id`),
  KEY `fk_definition_list_user_definition_list_staff1` (`staff_id`),
  KEY `fk_definition_list_user_definition_list_role1` (`role_id`),
  KEY `fk_user_modified_user` (`last_modified_by_userid`),
  KEY `fk_user_created_user` (`created_by_userid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `definition_list_user`
--

INSERT INTO `definition_list_user` (`user_id`, `staff_id`, `role_id`, `user_name`, `password`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, 1, 1, '', '', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(2, 2, 2, 'nguoi_dung', '', b'0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_relation_role_function`
--

CREATE TABLE IF NOT EXISTS `definition_relation_role_function` (
  `role_id` bigint(30) unsigned NOT NULL,
  `function_id` bigint(30) unsigned NOT NULL,
  `can_list` bit(1) NOT NULL,
  `can_view` bit(1) NOT NULL,
  `can_add` bit(1) NOT NULL,
  `can_modify` bit(1) NOT NULL,
  `can_change` bit(1) NOT NULL,
  `can_delete` bit(1) NOT NULL,
  `can_print` bit(1) NOT NULL,
  PRIMARY KEY (`role_id`,`function_id`),
  KEY `fk_definition_relation_role_function_definition_list_role1` (`role_id`),
  KEY `fk_definition_relation_role_function_definition_list_function1` (`function_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `definition_relation_role_function`
--

INSERT INTO `definition_relation_role_function` (`role_id`, `function_id`, `can_list`, `can_view`, `can_add`, `can_modify`, `can_change`, `can_delete`, `can_print`) VALUES
(2, 1, b'1', b'1', b'1', b'1', b'1', b'1', b'1'),
(2, 2, b'1', b'1', b'1', b'1', b'1', b'1', b'1'),
(2, 3, b'1', b'1', b'1', b'1', b'1', b'1', b'1'),
(2, 4, b'1', b'1', b'1', b'1', b'1', b'1', b'1'),
(2, 5, b'1', b'1', b'1', b'1', b'1', b'1', b'1'),
(2, 6, b'1', b'1', b'1', b'1', b'1', b'1', b'1');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `accountant_detail_entry`
--
ALTER TABLE `accountant_detail_entry`
  ADD CONSTRAINT `fk_entry_currency` FOREIGN KEY (`currency_id`) REFERENCES `definition_list_currency` (`currency_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_entry_credit_account` FOREIGN KEY (`credit_account_id`) REFERENCES `definition_list_account` (`account_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_entry_credit_subject` FOREIGN KEY (`credit_subject_id`) REFERENCES `definition_list_subject` (`subject_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_entry_debit_account` FOREIGN KEY (`debit_account_id`) REFERENCES `definition_list_account` (`account_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_entry_debit_subject` FOREIGN KEY (`debit_subject_id`) REFERENCES `definition_list_subject` (`subject_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_master_detail_entry` FOREIGN KEY (`entry_id`) REFERENCES `accountant_master_entry` (`entry_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_master_entry`
--
ALTER TABLE `accountant_master_entry`
  ADD CONSTRAINT `fk_entry_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_entry_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_entry_execution` FOREIGN KEY (`execution_id`) REFERENCES `definition_list_execution` (`execution_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_entry_module` FOREIGN KEY (`module_id`) REFERENCES `definition_list_module` (`module_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_account`
--
ALTER TABLE `definition_list_account`
  ADD CONSTRAINT `fk_account_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_account_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_currency`
--
ALTER TABLE `definition_list_currency`
  ADD CONSTRAINT `fk_currency_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_currency_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_department`
--
ALTER TABLE `definition_list_department`
  ADD CONSTRAINT `fk_department_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_department_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_department_subject` FOREIGN KEY (`subject_id`) REFERENCES `definition_list_subject` (`subject_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_execution`
--
ALTER TABLE `definition_list_execution`
  ADD CONSTRAINT `fk_execution_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_execution_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_execution_module` FOREIGN KEY (`module_id`) REFERENCES `definition_list_module` (`module_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_function`
--
ALTER TABLE `definition_list_function`
  ADD CONSTRAINT `fk_function_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_function_execution` FOREIGN KEY (`execution_id`) REFERENCES `definition_list_execution` (`execution_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_function_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_module`
--
ALTER TABLE `definition_list_module`
  ADD CONSTRAINT `fk_module_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_module_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_role`
--
ALTER TABLE `definition_list_role`
  ADD CONSTRAINT `fk_role_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_role_department` FOREIGN KEY (`department_id`) REFERENCES `definition_list_department` (`department_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_role_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_staff`
--
ALTER TABLE `definition_list_staff`
  ADD CONSTRAINT `fk_staff_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_staff_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_subject`
--
ALTER TABLE `definition_list_subject`
  ADD CONSTRAINT `fk_subject_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_subject_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_user`
--
ALTER TABLE `definition_list_user`
  ADD CONSTRAINT `fk_user_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_role` FOREIGN KEY (`role_id`) REFERENCES `definition_list_role` (`role_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_staff` FOREIGN KEY (`staff_id`) REFERENCES `definition_list_staff` (`staff_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_relation_role_function`
--
ALTER TABLE `definition_relation_role_function`
  ADD CONSTRAINT `fk_relation_function` FOREIGN KEY (`function_id`) REFERENCES `definition_list_function` (`function_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_relation_role` FOREIGN KEY (`role_id`) REFERENCES `definition_list_role` (`role_id`) ON DELETE CASCADE ON UPDATE CASCADE;
