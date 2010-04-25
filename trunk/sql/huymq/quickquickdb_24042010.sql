-- phpMyAdmin SQL Dump
-- version 3.1.3.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Apr 25, 2010 at 03:02 PM
-- Server version: 5.1.33
-- PHP Version: 5.2.9

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
-- Table structure for table `core_acl_role_parent`
--

CREATE TABLE IF NOT EXISTS `core_acl_role_parent` (
  `role_id` bigint(30) unsigned NOT NULL,
  `role_parent_id` bigint(30) unsigned NOT NULL,
  PRIMARY KEY (`role_id`),
  KEY `fk_acl_role_id` (`role_id`),
  KEY `fk_acl_role_parent_id` (`role_parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

--
-- Dumping data for table `core_acl_role_parent`
--


-- --------------------------------------------------------

--
-- Table structure for table `core_cache`
--

CREATE TABLE IF NOT EXISTS `core_cache` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `is_active` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `lifetime` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `core_cache`
--

INSERT INTO `core_cache` (`id`, `name`, `is_active`, `lifetime`) VALUES
(1, 'modules', 0, 864000),
(2, 'config', 0, 864000),
(3, 'query', 0, NULL),
(4, 'locales', 0, 864000),
(5, 'order_total_methods', 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `core_config_field`
--

CREATE TABLE IF NOT EXISTS `core_config_field` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `path` varchar(255) NOT NULL,
  `title` varchar(128) NOT NULL,
  `config_type` varchar(15) NOT NULL DEFAULT '',
  `model` varchar(128) NOT NULL,
  `model_assigned_with` varchar(128) NOT NULL,
  `config_options` text,
  `description` text,
  PRIMARY KEY (`id`),
  KEY `index_path` (`path`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=31 ;

--
-- Dumping data for table `core_config_field`
--

INSERT INTO `core_config_field` (`id`, `path`, `title`, `config_type`, `model`, `model_assigned_with`, `config_options`, `description`) VALUES
(1, 'main', 'Main', 'string', '', '', NULL, ''),
(2, 'main/store', 'Store', 'string', '', '', NULL, ''),
(3, 'main/store/name', 'Name', 'string', '', '', NULL, ''),
(4, 'main/store/country', 'Country', 'select', 'Country', '', NULL, 'Store Country'),
(5, 'main/store/zone', 'Zone', 'select', 'ZoneByCountry', 'main/store/country', NULL, 'Store zone(state,province)'),
(6, 'main/store/city', 'City', 'string', '', '', NULL, ''),
(7, 'main/store/taxBasis', 'Tax Basis for products', 'select', 'TaxBasis', '', NULL, 'Basis that will be used for calculating products taxes'),
(8, 'main/store/language', 'Default language', 'select', 'Language', '', NULL, 'Default site language'),
(9, 'main/store/currency', 'Default display currency', 'select', 'Currency', '', NULL, 'Default currency'),
(10, 'main/store/zip', 'Zipcode', 'string', '', '', NULL, 'Zip code'),
(11, 'main/store/owner', 'Store owner', 'string', '', '', NULL, ''),
(12, 'main/store/locale', 'Default locale', 'select', 'ZendLocale', '', NULL, 'Default site locale'),
(13, 'main/store/timezone', 'Timezone', 'select', 'ZendTimezone', '', NULL, 'Timezone'),
(14, 'sale/main/saleRoute', 'Sale router', 'string', '', '', NULL, 'Sale url (example.com/<b>saleRoute</b>/product)'),
(15, 'design/main/frontTemplateId', 'Front Template', 'select', 'Template', '', NULL, ''),
(16, 'design/main/adminTemplateId', 'Admin Template', 'select', 'Template', '', NULL, ''),
(17, 'design/htmlHead/titlePattern', 'Title Pattern', 'multiple', '', '', 'Page Title,Parent Page Titles,Site Name', 'Check values, which you want to see on page title'),
(18, 'translation', 'Translation', 'string', '', '', NULL, ''),
(19, 'translation/main', 'Main', 'string', '', '', NULL, ''),
(20, 'translation/main/autodetect', 'Autodetect new words', 'bool', '', '', NULL, 'Autodetect new words (run if set TRUE: >chmod -R 0777 [root_path]/app/locale)'),
(21, 'general/main/generalRoute', 'general router', 'string', '', '', NULL, 'general url'),
(22, 'auth/main/authRoute', 'Authenticate router', 'string', '', '', NULL, ''),
(23, 'language/main/languageRoute', 'Language router', 'string', '', '', NULL, ''),
(24, 'accountant/main/accountantRoute', 'Accountant Route', 'string', '', '', NULL, NULL),
(25, 'inventory/main/inventoryRoute', 'Inventory Route', 'string', '', '', NULL, NULL),
(26, 'purchase/main/purchaseRoute', 'Purchase Route', 'string', '', '', NULL, NULL),
(27, 'sale/main/saleRoute', 'Sale Route', 'string', '', '', NULL, NULL),
(28, 'main/store/defaultTheme', 'Default Theme', 'string', '', '', NULL, NULL),
(29, 'main/store/companyName', 'Company Name', 'string', '', '', NULL, NULL),
(30, 'main/store/defaultDateTime', 'Default DateTime', 'string', '', '', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `core_config_value`
--

CREATE TABLE IF NOT EXISTS `core_config_value` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `config_field_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `path` varchar(128) NOT NULL,
  `value` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_config_field_id` (`config_field_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=27 ;

--
-- Dumping data for table `core_config_value`
--

INSERT INTO `core_config_value` (`id`, `config_field_id`, `path`, `value`) VALUES
(1, 3, 'main/store/name', 'Enter store name'),
(2, 4, 'main/store/country', '223'),
(3, 5, 'main/store/zone', '43'),
(4, 6, 'main/store/city', ''),
(5, 7, 'main/store/taxBasis', 'delivery'),
(6, 8, 'main/store/language', '1'),
(7, 9, 'main/store/currency', 'USD'),
(8, 10, 'main/store/zip', '10001'),
(9, 11, 'main/store/owner', 'minh trung phan'),
(10, 12, 'main/store/locale', 'vi_VN'),
(11, 13, 'main/store/timezone', 'Australia/Darwin'),
(12, 14, 'sale/main/saleRoute', 'sale'),
(13, 15, 'design/main/frontTemplateId', '1'),
(14, 16, 'design/main/adminTemplateId', '1'),
(15, 17, 'design/htmlHead/titlePattern', 'Page Title,Site Name'),
(16, 20, 'translation/main/autodetect', '0'),
(17, 21, 'general/main/generalRoute', 'general'),
(18, 22, 'auth/main/authRoute', 'auth'),
(19, 23, 'language/main/languageRoute', 'language'),
(20, 24, 'accountant/main/accountantRoute', 'accountant'),
(21, 25, 'inventory/main/inventoryRoute', 'inventory'),
(22, 26, 'purchase/main/purchaseRoute', 'purchase'),
(23, 27, 'sale/main/saleRoute', 'sale'),
(24, 28, 'main/store/defaultTheme', 'professional'),
(25, 29, 'main/store/companyName', 'Nhanh Nhanh Company'),
(26, 30, 'main/store/defaultDateTime', 'd/m/Y');

-- --------------------------------------------------------

--
-- Table structure for table `core_language`
--

CREATE TABLE IF NOT EXISTS `core_language` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(3) NOT NULL,
  `language` varchar(128) NOT NULL,
  `locale` varchar(5) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Index_code` (`code`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=3 ;

--
-- Dumping data for table `core_language`
--

INSERT INTO `core_language` (`id`, `code`, `language`, `locale`) VALUES
(1, 'en', 'English', 'en_US'),
(2, 'vi', 'Việt Nam', 'vi_VN');

-- --------------------------------------------------------

--
-- Table structure for table `core_module_language`
--

CREATE TABLE IF NOT EXISTS `core_module_language` (
  `language_id` smallint(5) unsigned NOT NULL,
  `table_name` varchar(255) NOT NULL,
  `field_name` varchar(255) NOT NULL,
  `record_id` bigint(30) unsigned NOT NULL,
  `value` text NOT NULL,
  PRIMARY KEY (`language_id`,`table_name`,`field_name`,`record_id`),
  KEY `language_id` (`language_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

--
-- Dumping data for table `core_module_language`
--

INSERT INTO `core_module_language` (`language_id`, `table_name`, `field_name`, `record_id`, `value`) VALUES
(1, 'definition_list_execution', '', 1, 'Catalog - Purchase'),
(1, 'definition_list_execution', '', 2, 'Present Condition - Purchase'),
(1, 'definition_list_execution', '', 3, 'Make A Plan - Purchase'),
(1, 'definition_list_execution', '', 4, 'Publish Order - Purchase'),
(1, 'definition_list_execution', '', 5, 'Liquidate Order - Purchase'),
(1, 'definition_list_function', '', 1, 'Product Group'),
(1, 'definition_list_function', '', 2, 'Product Catalog'),
(1, 'definition_list_function', '', 3, 'Sale Plan'),
(1, 'definition_list_function', '', 4, 'Present Condition Inventory'),
(1, 'definition_list_function', '', 5, 'Survival Fund'),
(1, 'definition_list_function', '', 6, 'Purchase History'),
(1, 'definition_list_function', '', 7, 'Purchase'),
(1, 'definition_list_module', '', 1, 'Purchase'),
(1, 'definition_list_module', '', 3, 'Inventory'),
(1, 'definition_list_module', '', 4, 'Accountant'),
(1, 'definition_list_module', '', 5, 'Sale'),
(1, 'definition_list_module', '', 7, 'System Setup'),
(1, 'definition_list_module', '', 8, 'General Legder'),
(2, 'definition_list_execution', '', 1, 'Danh mục - MH'),
(2, 'definition_list_execution', '', 2, 'Xem hiện trạng - MH'),
(2, 'definition_list_execution', '', 3, 'Kế hoạch - MH'),
(2, 'definition_list_execution', '', 4, 'Phát hành - MH'),
(2, 'definition_list_execution', '', 5, 'Thanh toán - MH'),
(2, 'definition_list_function', '', 1, 'Phân nhóm hàng mua'),
(2, 'definition_list_function', '', 2, 'Danh mục mặt hàng'),
(2, 'definition_list_function', '', 3, 'Kế hoạch bán hàng'),
(2, 'definition_list_function', '', 4, 'Hiện trạng tồn kho'),
(2, 'definition_list_function', '', 5, 'Hiện trạng tồn quỹ'),
(2, 'definition_list_function', '', 6, 'Lịch sử mua hàng'),
(2, 'definition_list_function', '', 7, 'Mua Hàng'),
(2, 'definition_list_module', '', 1, 'Mua Hàng'),
(2, 'definition_list_module', '', 3, 'Nhập xuất tồn kho'),
(2, 'definition_list_module', '', 4, 'Hạch toán kế toán'),
(2, 'definition_list_module', '', 5, 'Bán hàng'),
(2, 'definition_list_module', '', 7, 'Thiết lập hệ thống'),
(2, 'definition_list_module', '', 8, 'Ra quyết định');

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
(1, 1, '', '', '', '\0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(2, 2, 'KT', 'Kế toán', '', '\0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(3, 2, 'KD', 'Kinh doanh', '', '\0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(4, 2, 'MH', 'Mua hàng', '', '\0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(5, 2, 'KH', 'Kho hàng', '', '\0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(6, 2, 'GN', 'Giao nhận', '', '\0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(7, 2, 'HC', 'Hành chính nhân sự', '', '\0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_execution`
--

CREATE TABLE IF NOT EXISTS `definition_list_execution` (
  `execution_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `module_id` bigint(30) unsigned NOT NULL,
  `execution_code` char(2) NOT NULL,
  `execution_name` varchar(20) NOT NULL,
  `inactive` tinyint(1) NOT NULL,
  `display_order` smallint(6) NOT NULL,
  `image_file` varchar(50) NOT NULL,
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

INSERT INTO `definition_list_execution` (`execution_id`, `module_id`, `execution_code`, `execution_name`, `inactive`, `display_order`, `image_file`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, 1, 'MD', 'Danh mục - MH', 0, 1, 'transactions.gif', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(2, 1, 'MX', 'Xem hiện trạng - MH', 0, 2, 'transactions.gif', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(3, 1, 'MK', 'Kế hoạch - MH', 0, 3, 'transactions.gif', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(4, 1, 'MP', 'Phát hành - MH', 0, 4, 'transactions.gif', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(5, 1, 'MT', 'Thanh toán - MH', 0, 5, 'transactions.gif', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_function`
--

CREATE TABLE IF NOT EXISTS `definition_list_function` (
  `function_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `execution_id` bigint(30) unsigned NOT NULL,
  `function_code` varchar(10) NOT NULL,
  `function_name` varchar(20) NOT NULL,
  `function_action` varchar(50) NOT NULL,
  `inactive` tinyint(1) NOT NULL,
  `display_order` smallint(6) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`function_id`),
  KEY `fk_definition_list_function_definition_list_execution1` (`execution_id`),
  KEY `fk_function_modified_user` (`last_modified_by_userid`),
  KEY `fk_function_created_user` (`created_by_userid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `definition_list_function`
--

INSERT INTO `definition_list_function` (`function_id`, `execution_id`, `function_code`, `function_name`, `function_action`, `inactive`, `display_order`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, 1, 'PNHM', 'Phân nhóm hàng mua', 'purchase/maintenance/product-group', 0, 1, 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(2, 1, 'DMMH', 'Danh mục mặt hàng', 'purchase/maintenance/product-catalog', 0, 2, 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(3, 1, 'KHBH', 'Kế hoạch bán hàng', 'purchase/maintenance/sale-plan', 0, 3, 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(4, 1, 'HTTK', 'Hiện trạng tồn kho', 'purchase/maintenance/present-inventory', 0, 4, 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(5, 1, 'HTTQ', 'Hiện trạng tồn quỹ', 'purchase/maintenance/survival-fund', 0, 5, 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(6, 1, 'LSMH', 'Lịch sử mua hàng', 'purchase/maintenance/purchase-history', 0, 6, 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(7, 1, '', 'Purchase Module', 'purchase', 1, 0, 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(8, 1, '', 'Purchase Maintenance', 'purchase/maintenance', 1, 0, 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_module`
--

CREATE TABLE IF NOT EXISTS `definition_list_module` (
  `module_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `module_code` char(2) NOT NULL,
  `module_name` varchar(20) NOT NULL,
  `package` varchar(64) NOT NULL,
  `load_route_order` tinyint(1) NOT NULL,
  `module_action` varchar(50) NOT NULL,
  `inactive` tinyint(1) NOT NULL,
  `display_order` smallint(6) NOT NULL,
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

INSERT INTO `definition_list_module` (`module_id`, `module_code`, `module_name`, `package`, `load_route_order`, `module_action`, `inactive`, `display_order`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, 'MH', 'Mua hàng', 'Quick_Purchase', 6, 'purchase/', 0, 1, 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(2, 'GN', 'Giao nhận hàng', '', 0, '', 1, 0, 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(3, 'KH', 'Nhập xuất tồn kho', 'Quick_Inventory', 4, 'inventory/', 0, 2, 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(4, 'KT', 'Hạch toán kế toán', 'Quick_Accountant', 2, 'accountant/', 0, 3, 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(5, 'BH', 'Bán hàng', 'Quick_Sale', 5, 'sale/', 0, 4, 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(6, 'HC', 'Hành chính nhân sự', 'Quick_Human', 7, '', 1, 0, 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(7, 'TL', 'Thiết lập hệ thống', 'Quick_Core', 1, '/', 0, 5, 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(8, 'QT', 'Ra quyết định', 'Quick_General', 3, 'general/', 0, 6, 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_role`
--

CREATE TABLE IF NOT EXISTS `definition_list_role` (
  `role_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `department_id` bigint(30) unsigned NOT NULL,
  `role_code` varchar(10) NOT NULL,
  `role_name` varchar(20) NOT NULL,
  `inactive` tinyint(1) NOT NULL,
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
(1, 1, '', '', 1, 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(2, 1, 'VTM', 'Administrator', 0, 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00');

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
(1, '', '', '', '', '1900-01-01 00:00:00', '', '', '1900-01-01 00:00:00', '', '', '', '', '', '', '\0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(2, 'VTM', 'Nhân viên', '', 'VTM', '1900-01-01 00:00:00', '', '', '1900-01-01 00:00:00', '', '', '', '', '', '', '\0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00');

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
(1, '', '', '', '', '\0', '\0', '\0', '\0', '\0', '\0', '\0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(2, 'N2H', 'Công ty Nhanh Nhanh', '', '', '', '\0', '', '', '\0', '\0', '\0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00');

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
(1, 1, 1, '', '', '\0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00'),
(2, 2, 2, 'nguoi_dung', '', '\0', 1, '1900-01-01 00:00:00', 1, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_relation_role_function`
--

CREATE TABLE IF NOT EXISTS `definition_relation_role_function` (
  `role_id` bigint(30) unsigned NOT NULL,
  `function_id` bigint(30) unsigned NOT NULL,
  `permission` enum('allow','deny') NOT NULL,
  `can_list` tinyint(1) NOT NULL,
  `can_view` tinyint(1) NOT NULL,
  `can_add` tinyint(1) NOT NULL,
  `can_modify` tinyint(1) NOT NULL,
  `can_change` tinyint(1) NOT NULL,
  `can_delete` tinyint(1) NOT NULL,
  `can_print` tinyint(1) NOT NULL,
  PRIMARY KEY (`role_id`,`function_id`),
  KEY `fk_definition_relation_role_function_definition_list_role1` (`role_id`),
  KEY `fk_definition_relation_role_function_definition_list_function1` (`function_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `definition_relation_role_function`
--

INSERT INTO `definition_relation_role_function` (`role_id`, `function_id`, `permission`, `can_list`, `can_view`, `can_add`, `can_modify`, `can_change`, `can_delete`, `can_print`) VALUES
(2, 1, 'allow', 1, 1, 1, 1, 1, 1, 1),
(2, 2, 'deny', 1, 1, 1, 1, 1, 1, 1),
(2, 3, 'allow', 1, 1, 1, 1, 1, 1, 1),
(2, 4, 'allow', 1, 1, 1, 1, 1, 1, 1),
(2, 5, 'allow', 1, 1, 1, 1, 1, 1, 1),
(2, 6, 'allow', 1, 1, 1, 1, 1, 1, 1),
(2, 7, 'allow', 0, 0, 0, 0, 0, 0, 0),
(2, 8, 'allow', 0, 0, 0, 0, 0, 0, 0);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `accountant_detail_entry`
--
ALTER TABLE `accountant_detail_entry`
  ADD CONSTRAINT `fk_entry_credit_account` FOREIGN KEY (`credit_account_id`) REFERENCES `definition_list_account` (`account_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_entry_credit_subject` FOREIGN KEY (`credit_subject_id`) REFERENCES `definition_list_subject` (`subject_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_entry_currency` FOREIGN KEY (`currency_id`) REFERENCES `definition_list_currency` (`currency_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_entry_debit_account` FOREIGN KEY (`debit_account_id`) REFERENCES `definition_list_account` (`account_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_entry_debit_subject` FOREIGN KEY (`debit_subject_id`) REFERENCES `definition_list_subject` (`subject_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_master_detail_entry` FOREIGN KEY (`entry_id`) REFERENCES `accountant_master_entry` (`entry_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_master_entry`
--
ALTER TABLE `accountant_master_entry`
  ADD CONSTRAINT `fk_entry_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_entry_execution` FOREIGN KEY (`execution_id`) REFERENCES `definition_list_execution` (`execution_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_entry_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_entry_module` FOREIGN KEY (`module_id`) REFERENCES `definition_list_module` (`module_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `core_acl_role_parent`
--
ALTER TABLE `core_acl_role_parent`
  ADD CONSTRAINT `fk_core_acl_role_id` FOREIGN KEY (`role_id`) REFERENCES `definition_list_role` (`role_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_core_acl_role_parent_id` FOREIGN KEY (`role_parent_id`) REFERENCES `definition_list_role` (`role_id`) ON DELETE CASCADE;

--
-- Constraints for table `core_config_value`
--
ALTER TABLE `core_config_value`
  ADD CONSTRAINT `FK_config_field_id` FOREIGN KEY (`config_field_id`) REFERENCES `core_config_field` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `core_module_language`
--
ALTER TABLE `core_module_language`
  ADD CONSTRAINT `fk_module_language_id` FOREIGN KEY (`language_id`) REFERENCES `core_language` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `definition_list_account`
--
ALTER TABLE `definition_list_account`
  ADD CONSTRAINT `fk_account_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_account_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_currency`
--
ALTER TABLE `definition_list_currency`
  ADD CONSTRAINT `fk_currency_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_currency_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_department`
--
ALTER TABLE `definition_list_department`
  ADD CONSTRAINT `fk_department_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_department_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_department_subject` FOREIGN KEY (`subject_id`) REFERENCES `definition_list_subject` (`subject_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_execution`
--
ALTER TABLE `definition_list_execution`
  ADD CONSTRAINT `fk_execution_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_execution_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
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
