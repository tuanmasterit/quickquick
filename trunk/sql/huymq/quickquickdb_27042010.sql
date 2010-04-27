-- phpMyAdmin SQL Dump
-- version 3.2.1-rc1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Apr 27, 2010 at 05:03 PM
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
  `credit_account_id` bigint(30) unsigned NOT NULL,
  `debit_account_level2_id` bigint(30) unsigned NOT NULL,
  `credit_account_level2_id` bigint(30) unsigned NOT NULL,
  `debit_account_level3_id` bigint(30) unsigned NOT NULL,
  `credit_account_level3_id` bigint(30) unsigned NOT NULL,
  `debit_account_level4_id` bigint(30) unsigned NOT NULL,
  `credit_account_level4_id` bigint(30) unsigned NOT NULL,
  `debit_account_level5_id` bigint(30) unsigned NOT NULL,
  `credit_account_level5_id` bigint(30) unsigned NOT NULL,
  `original_amount` decimal(18,4) NOT NULL,
  `currency_id` bigint(30) unsigned NOT NULL,
  `converted_amount` decimal(18,4) NOT NULL,
  PRIMARY KEY (`entry_id`,`debit_account_id`,`credit_account_id`),
  KEY `fk_accountant_detail_entries_accountant_master_entries1` (`entry_id`),
  KEY `fk_accountant_detail_entries_definition_list_accounts1` (`debit_account_id`),
  KEY `fk_accountant_detail_entries_definition_list_accounts2` (`credit_account_id`),
  KEY `fk_accountant_detail_entries_definition_list_currencies1` (`currency_id`),
  KEY `fk_accountant_detail_entries_definition_list_subject1` (`debit_account_level2_id`),
  KEY `fk_accountant_detail_entries_definition_list_subject2` (`credit_account_level2_id`)
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

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
(2, 'definition_list_execution', '', 6, 'Giao hàng - GN'),
(2, 'definition_list_execution', '', 7, 'Nhận hàng - GN'),
(2, 'definition_list_execution', '', 8, 'Danh mục - KH'),
(2, 'definition_list_execution', '', 9, 'Nhập kho - KH'),
(2, 'definition_list_execution', '', 10, 'Xuất kho - KH'),
(2, 'definition_list_execution', '', 11, 'Kiểm kho - KH'),
(2, 'definition_list_execution', '', 12, 'Danh mục - KT'),
(2, 'definition_list_execution', '', 13, 'Mua hàng - KT'),
(2, 'definition_list_execution', '', 14, 'Bán hàng - KT'),
(2, 'definition_list_execution', '', 15, 'Tồn kho - KT'),
(2, 'definition_list_execution', '', 16, 'Phải thu - KT'),
(2, 'definition_list_execution', '', 17, 'Phải trả - KT'),
(2, 'definition_list_execution', '', 18, 'Ngân quỹ - KT'),
(2, 'definition_list_execution', '', 19, 'Tài sản - KT'),
(2, 'definition_list_execution', '', 20, 'CP trả trước - KT'),
(2, 'definition_list_execution', '', 21, 'Tổng hợp - KT'),
(2, 'definition_list_execution', '', 22, 'Danh mục - BH'),
(2, 'definition_list_execution', '', 23, 'Báo giá - BH'),
(2, 'definition_list_execution', '', 24, 'Hợp đồng - BH'),
(2, 'definition_list_execution', '', 25, 'Nhu cầu - BH'),
(2, 'definition_list_execution', '', 26, 'Đơn đặt hàng - BH'),
(2, 'definition_list_execution', '', 27, 'Trả, giảm - BH'),
(2, 'definition_list_execution', '', 28, 'TL hàng - TL'),
(2, 'definition_list_execution', '', 29, 'TL đối tượng - TL'),
(2, 'definition_list_execution', '', 30, 'TL khác - TL'),
(2, 'definition_list_function', '', 1, 'Phân nhóm hàng mua'),
(2, 'definition_list_function', '', 2, 'Danh mục hàng mua'),
(2, 'definition_list_function', '', 3, 'Phân nhóm đối tượng'),
(2, 'definition_list_function', '', 4, 'DM nhà sản xuất'),
(2, 'definition_list_function', '', 5, 'DM nhà cung cấp'),
(2, 'definition_list_function', '', 6, 'Hiện trạng tồn kho'),
(2, 'definition_list_function', '', 7, 'Hiện trạng tồn quỹ'),
(2, 'definition_list_function', '', 8, 'Lịch sử mua hàng'),
(2, 'definition_list_function', '', 9, 'Kế hoạch mua hàng'),
(2, 'definition_list_function', '', 10, 'Theo dõi KH mua'),
(2, 'definition_list_function', '', 11, 'Đơn đặt hàng'),
(2, 'definition_list_function', '', 12, 'Ứng tiền mua hàng'),
(2, 'definition_list_function', '', 13, 'Trả tiền mua hàng'),
(2, 'definition_list_function', '', 14, 'Danh mục kho hàng'),
(2, 'definition_list_function', '', 15, 'Phân nhóm hàng tkho'),
(2, 'definition_list_function', '', 16, 'Nhập kho hàng mua'),
(2, 'definition_list_function', '', 17, 'Nhập kho trả lại'),
(2, 'definition_list_function', '', 18, 'Xuất kho bán hàng'),
(2, 'definition_list_function', '', 19, 'Xuất kho sử dụng'),
(2, 'definition_list_function', '', 20, 'Kiểm khu vực (tháng)'),
(2, 'definition_list_function', '', 21, 'Kiểm toàn bộ (quý)'),
(2, 'definition_list_function', '', 22, 'Hệ thống tài khoản'),
(2, 'definition_list_function', '', 23, 'Danh mục ngoại tệ'),
(2, 'definition_list_function', '', 24, 'Danh mục doanh thu'),
(2, 'definition_list_function', '', 25, 'Danh mục chi phí'),
(2, 'definition_list_function', '', 26, 'Hóa đơn mua hàng'),
(2, 'definition_list_function', '', 27, 'Công nợ phải trả'),
(2, 'definition_list_function', '', 28, 'Phân bổ chi phí'),
(2, 'definition_list_function', '', 29, 'Hóa đơn bán hàng'),
(2, 'definition_list_function', '', 30, 'Hàng bán trả lại'),
(2, 'definition_list_function', '', 31, 'Giảm giá hàng bán'),
(2, 'definition_list_function', '', 32, 'Quản lý hàng tồn kho'),
(2, 'definition_list_function', '', 33, 'Xử lý thừa thiếu kho'),
(2, 'definition_list_function', '', 34, 'Tính giá xuất kho'),
(2, 'definition_list_function', '', 35, 'Quản lý phải thu'),
(2, 'definition_list_function', '', 36, 'Phiếu thu'),
(2, 'definition_list_function', '', 37, 'Giải trừ phải thu'),
(2, 'definition_list_function', '', 38, 'Quản lý phải trả'),
(2, 'definition_list_function', '', 39, 'Phiếu chi'),
(2, 'definition_list_function', '', 40, 'Giải trừ phải trả'),
(2, 'definition_list_function', '', 41, 'Quản lý ngân quỹ'),
(2, 'definition_list_function', '', 42, 'Quản lý ngân lưu'),
(2, 'definition_list_function', '', 43, 'Khấu hao TSCĐ'),
(2, 'definition_list_function', '', 44, 'Chi phí trả trước'),
(2, 'definition_list_function', '', 45, 'Phiếu định khoản'),
(2, 'definition_list_function', '', 46, 'Phân nhóm khách hàng'),
(2, 'definition_list_function', '', 47, 'Danh mục khách hàng'),
(2, 'definition_list_function', '', 48, 'Phân nhóm hàng bán'),
(2, 'definition_list_function', '', 49, 'Danh mục hàng bán'),
(2, 'definition_list_function', '', 50, 'Báo giá định kỳ'),
(2, 'definition_list_function', '', 51, 'Báo giá theo yêu cầu'),
(2, 'definition_list_function', '', 52, 'Hợp đồng nguyên tắc'),
(2, 'definition_list_function', '', 53, 'Hợp đồng phát sinh'),
(2, 'definition_list_function', '', 54, 'Mua thường xuyên'),
(2, 'definition_list_function', '', 55, 'Đơn đặt hàng'),
(2, 'definition_list_function', '', 56, 'Xác nhận đặt hàng'),
(2, 'definition_list_function', '', 57, 'Hàng bán trả lại'),
(2, 'definition_list_function', '', 58, 'Giảm giá hàng bán'),
(2, 'definition_list_function', '', 59, 'Phân nhóm mặt hàng'),
(2, 'definition_list_function', '', 60, 'Danh mục mặt hàng'),
(2, 'definition_list_function', '', 61, 'Phân nhóm đối tượng'),
(2, 'definition_list_function', '', 62, 'Danh mục đối tượng'),
(2, 'definition_list_function', '', 63, 'Mua hàng'),
(2, 'definition_list_function', '', 66, 'Nhập xuất tồn kho'),
(2, 'definition_list_function', '', 69, 'Hạch toán kế toán'),
(2, 'definition_list_function', '', 72, 'Thiết lập hệ thống'),
(2, 'definition_list_function', '', 74, 'Ra quyết định'),
(2, 'definition_list_module', '', 1, 'Mua Hàng'),
(2, 'definition_list_module', '', 3, 'Nhập xuất tồn kho'),
(2, 'definition_list_module', '', 4, 'Hạch toán kế toán'),
(2, 'definition_list_module', '', 5, 'Bán hàng'),
(2, 'definition_list_module', '', 7, 'Thiết lập hệ thống'),
(2, 'definition_list_module', '', 8, 'Ra quyết định');

-- --------------------------------------------------------

--
-- Table structure for table `definition_detail_account`
--

CREATE TABLE IF NOT EXISTS `definition_detail_account` (
  `account_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `level` tinyint(1) unsigned NOT NULL,
  `detail_id` bigint(30) unsigned NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`account_id`,`level`,`detail_id`),
  KEY `fk_detail_account_created_user` (`created_by_userid`),
  KEY `fk_detail_account_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `definition_detail_account`
--


-- --------------------------------------------------------

--
-- Table structure for table `definition_detail_group`
--

CREATE TABLE IF NOT EXISTS `definition_detail_group` (
  `product_id` bigint(30) unsigned NOT NULL,
  `criteria_id` bigint(30) unsigned NOT NULL,
  `group_id` bigint(30) unsigned NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`product_id`,`criteria_id`),
  KEY `fk_detail_group_criteria` (`criteria_id`),
  KEY `fk_detail_group` (`group_id`),
  KEY `fk_detail_group_created_user` (`created_by_userid`),
  KEY `fk_detail_group_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `definition_detail_group`
--


-- --------------------------------------------------------

--
-- Table structure for table `definition_detail_property`
--

CREATE TABLE IF NOT EXISTS `definition_detail_property` (
  `product_id` bigint(30) unsigned NOT NULL,
  `factor_id` bigint(30) unsigned NOT NULL,
  `property_id` bigint(30) unsigned NOT NULL,
  `detail_property_text` varchar(100) NOT NULL,
  `detail_property_number` decimal(18,4) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`product_id`,`factor_id`),
  KEY `fk_detail_property_factor` (`factor_id`),
  KEY `fk_detail_property` (`property_id`),
  KEY `fk_detail_property_created_user` (`created_by_userid`),
  KEY `fk_detail_property_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `definition_detail_property`
--


-- --------------------------------------------------------

--
-- Table structure for table `definition_list_account`
--

CREATE TABLE IF NOT EXISTS `definition_list_account` (
  `account_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `account_path` varchar(51) NOT NULL,
  `account_code` varchar(10) NOT NULL,
  `account_name` varchar(100) NOT NULL,
  `account_note` varchar(100) NOT NULL,
  `inactive` bit(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`account_id`),
  KEY `fk_account_created_user` (`created_by_userid`),
  KEY `fk_account_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=215 ;

--
-- Dumping data for table `definition_list_account`
--

INSERT INTO `definition_list_account` (`account_id`, `account_path`, `account_code`, `account_name`, `account_note`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, '', '', '', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(1, '/', '111', 'Tiền mặt', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(2, '/1/', '1111', 'Tiền Việt Nam', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(3, '/1/', '1112', 'Ngoại tệ', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, '/1/', '1113', 'Vàng, bạc, kim khí quý, đá quý', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, '/', '112', 'Tiền gửi Ngân hàng', 'Chi tiết theo từng ngân hàng', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(6, '/5/', '1121', 'Tiền Việt Nam', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(7, '/5/', '1122', 'Ngoại tệ', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(8, '/5/', '1123', 'Vàng, bạc, kim khí quý, đá quý', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(9, '/', '113', 'Tiền đang chuyển', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(10, '/9/', '1131', 'Tiền Việt Nam', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(11, '/9/', '1132', 'Ngoại tệ', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(12, '/', '121', 'Đầu tư chứng khoán ngắn hạn', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(13, '/12/', '1211', 'Cổ phiếu', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(14, '/12/', '1212', 'Trái phiếu, tín phiếu, kỳ phiếu', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(15, '/', '128', 'Đầu tư ngắn hạn khác', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(16, '/15/', '1281', 'Tiền gửi có kỳ hạn', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(17, '/15/', '1288', 'Đầu tư ngắn hạn khác', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(18, '/', '129', 'Dự phòng giảm giá đầu tư ngắn hạn', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(19, '/', '131', 'Phải thu của khách hàng', 'Chi tiết theo đối tượng', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(20, '/', '133', 'Thuế GTGT được khấu trừ', '0', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(21, '/20/', '1331', 'Thuế GTGT được khấu trừ của hàng hóa, dịch vụ', '0', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(22, '/20/', '1332', 'Thuế GTGT được khấu trừ của TSCĐ', '0', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(23, '/', '136', 'Phải thu nội bộ', '0', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(24, '/23/', '1361', 'Vốn kinh doanh ở các đơn vị trực thuộc', '0', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(25, '/23/', '1368', 'Phải thu nội bộ khác', '0', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(26, '/', '138', 'Phải thu khác', '0', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(27, '/26/', '1381', 'Tài sản thiếu chờ xử lý', '0', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(28, '/26/', '1385', 'Phải thu về cổ phần hóa', '0', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(29, '/26/', '1388', 'Phải thu khác', '0', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(30, '/', '139', 'Dự phòng phải thu khó đòi', '0', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(31, '/', '141', 'Tạm ứng', 'Chi tiết theo đối tượng', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(32, '/', '142', 'Chi phí trả trước ngắn hạn', '0', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(33, '/', '144', 'Cầm cố, ký quỹ, ký cược ngắn hạn', '0', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(34, '/', '151', 'Hàng mua đang đi đường', '0', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(35, '/', '152', 'Nguyên liệu, vật liệu', 'Chi tiết theo yêu cầu quản lý', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(36, '/', '153', 'Công cụ, dụng cụ', '0', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(37, '/', '154', 'Chi phí sản xuất, kinh doanh dở dang', '0', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(38, '/', '155', 'Thành phẩm', '0', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(39, '/', '156', 'Hàng hóa', '0', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(40, '/39/', '1561', 'Giá mua hàng hóa', '0', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(41, '/39/', '1562', 'Chi phí thu mua hàng hóa', '0', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(42, '/39/', '1567', 'Hàng hóa bất động sản', '0', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(43, '/', '157', 'Hàng gửi đi bán', '0', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(44, '/', '158', 'Hàng hóa kho bảo thuế', 'Đơn vị có XNK được lập kho bảo thuế', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(45, '/', '159', 'Dự phòng giảm giá hàng tồn kho', '0', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(46, '/', '161', 'Chi sự nghiệp', '0', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(47, '/46/', '1611', 'Chi sự nghiệp năm trước', '0', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(48, '/46/', '1612', 'Chi sự nghiệp năm nay', '0', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(49, '/', '211', 'Tài sản cố định hữu hình', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(50, '/49/', '2111', 'Nhà cửa, vật kiến trúc', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(51, '/49/', '2112', 'Máy móc, thiết bị', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(52, '/49/', '2113', 'Phương tiện vận tải, truyền dẫn', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(53, '/49/', '2114', 'Thiết bị, dụng cụ quản lý', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(54, '/49/', '2115', 'Cây lâu năm, súc vật làm việc và cho sản phẩm', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(55, '/49/', '2118', 'TSCĐ khác', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(56, '/', '212', 'Tài sản cố định thuê tài chính', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(57, '/', '213', 'Tài sản cố định vô hình', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(58, '/57/', '2131', 'Quyền sử dụng đất', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(59, '/57/', '2132', 'Quyền phát hành', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(60, '/57/', '2133', 'Bản quyền, bằng sáng chế', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(61, '/57/', '2134', 'Nhãn hiệu hàng hoá', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(62, '/57/', '2135', 'Phần mềm máy vi tính', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(63, '/57/', '2136', 'Giấy phép và giấy phép nhượng quyền', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(64, '/57/', '2138', 'TSCĐ vô hình khác', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(65, '/', '214', 'Hao mòn tài sản cố định', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(66, '/65/', '2141', 'Hao mòn TSCĐ hữu hình', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(67, '/65/', '2142', 'Hao mòn TSCĐ thuê tài chính', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(68, '/65/', '2143', 'Hao mòn TSCĐ vô hình', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(69, '/65/', '2147', 'Hao mòn bất động sản đầu tư', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(70, '/', '217', 'Bất động sản đầu tư', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(71, '/', '221', 'Đầu tư vào công ty con', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(72, '/', '222', 'Vốn góp liên doanh', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(73, '/', '223', 'Đầu tư vào công ty liên kết', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(74, '/', '228', 'Đầu tư dài hạn khác', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(75, '/74/', '2281', 'Cổ phiếu', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(76, '/74/', '2282', 'Trái phiếu', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(77, '/74/', '2288', 'Đầu tư dài hạn khác', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(78, '/', '229', 'Dự phòng giảm giá đầu tư dài hạn', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(79, '/', '241', 'Xây dựng cơ bản dở dang', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(80, '/79/', '2411', 'Mua sắm TSCĐ', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(81, '/79/', '2412', 'Xây dựng cơ bản', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(82, '/79/', '2413', 'Sửa chữa lớn TSCĐ', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(83, '/', '242', 'Chi phí trả trước dài hạn', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(84, '/', '243', 'Tài sản thuế thu nhập hoãn lại', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(85, '/', '244', 'Ký quỹ, ký cược dài hạn', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(86, '/', '311', 'Vay ngắn hạn', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(87, '/', '315', 'Nợ dài hạn đến hạn trả', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(88, '/', '331', 'Phải trả cho người bán', 'Chi tiết theo đối tượng', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(89, '/', '333', 'Thuế và các khoản phải nộp Nhà nước', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(90, '/89/', '3331', 'Thuế giá trị gia tăng phải nộp', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(91, '/89/90/', '33311', 'Thuế GTGT đầu ra', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(92, '/89/90/', '33312', 'Thuế GTGT hàng nhập khẩu', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(93, '/89/', '3332', 'Thuế tiêu thụ đặc biệt', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(94, '/89/', '3333', 'Thuế xuất, nhập khẩu', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(95, '/89/', '3334', 'Thuế thu nhập doanh nghiệp', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(96, '/89/', '3335', 'Thuế thu nhập cá nhân', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(97, '/89/', '3336', 'Thuế tài nguyên', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(98, '/89/', '3337', 'Thuế nhà đất, tiền thuê đất', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(99, '/89/', '3338', 'Các loại thuế khác', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(100, '/89/', '3339', 'Phí, lệ phí và các khoản phải nộp khác', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(101, '/', '334', 'Phải trả người lao động', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(102, '/101/', '3341', 'Phải trả công nhân viên', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(103, '/101/', '3348', 'Phải trả người lao động khác', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(104, '/', '335', 'Chi phí phải trả', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(105, '/', '336', 'Phải trả nội bộ', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(106, '/', '337', 'Thanh toán theo tiến độ kế hoạch hợp đồng xây dựng', 'DN xây lắp có thanh toán theo tiến độ kế hoạch', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(107, '/', '338', 'Phải trả, phải nộp khác', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(108, '/107/', '3381', 'Tài sản thừa chờ giải quyết', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(109, '/107/', '3382', 'Kinh phí công đoàn', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(110, '/107/', '3383', 'Bảo hiểm xã hội', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(111, '/107/', '3384', 'Bảo hiểm y tế', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(112, '/107/', '3385', 'Phải trả về cổ phần hoá', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(113, '/107/', '3386', 'Nhận ký quỹ, ký cược ngắn hạn', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(114, '/107/', '3387', 'Doanh thu chưa thực hiện', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(115, '/107/', '3388', 'Phải trả, phải nộp khác', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(116, '/', '341', 'Vay dài hạn', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(117, '/', '342', 'Nợ dài hạn', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(118, '/', '343', 'Trái phiếu phát hành', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(119, '/118/', '3431', 'Mệnh giá trái phiếu', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(120, '/118/', '3432', 'Chiết khấu trái phiếu', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(121, '/118/', '3433', 'Phụ trội trái phiếu', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(122, '/', '344', 'Nhận ký quỹ, ký cược dài hạn', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(123, '/', '347', 'Thuế thu nhập hoãn lại phải trả', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(124, '/', '351', 'Quỹ dự phòng trợ cấp mất việc làm', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(125, '/', '352', 'Dự phòng phải trả', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(126, '/', '411', 'Nguồn vốn kinh doanh', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(127, '/126/', '4111', 'Vốn đầu tư của chủ sở hữu', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(128, '/126/', '4112', 'Thặng dư vốn cổ phần', 'C.ty cổ phần', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(129, '/126/', '4118', 'Vốn khác', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(130, '/', '412', 'Chênh lệch đánh giá lại tài sản', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(131, '/', '413', 'Chênh lệch tỷ giá hối đoái', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(132, '/131/', '4131', 'Chênh lệch tỷ giá hối đoái đánh giá lại cuối năm tài chính', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(133, '/131/', '4132', 'Chênh lệch tỷ giá hối đoái trong giai đoạn đầu tư XDCB', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(134, '/', '414', 'Quỹ đầu tư phát triển', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(135, '/', '415', 'Quỹ dự phòng tài chính', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(136, '/', '418', 'Các quỹ khác thuộc vốn chủ sở hữu', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(137, '/', '419', 'Cổ phiếu quỹ', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(138, '/', '421', 'Lợi nhuận chưa phân phối', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(139, '/138/', '4211', 'Lợi nhuận chưa phân phối năm trước', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(140, '/138/', '4212', 'Lợi nhuận chưa phân phối năm nay', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(141, '/', '431', 'Quỹ khen thưởng, phúc lợi', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(142, '/141/', '4311', 'Quỹ khen thưởng', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(143, '/141/', '4312', 'Quỹ phúc lợi', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(144, '/141/', '4313', 'Quỹ phúc lợi đã hình thành TSCĐ', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(145, '/', '441', 'Nguồn vốn đầu tư xây dựng cơ bản', 'Áp dụng cho DNNN', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(146, '/', '461', 'Nguồn kinh phí sự nghiệp', 'Dùng cho các công ty, TCty có nguồn kinh phí', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(147, '/146/', '4611', 'Nguồn kinh phí sự nghiệp năm trước', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(148, '/146/', '4612', 'Nguồn kinh phí sự nghiệp năm nay', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(149, '/', '466', 'Nguồn kinh phí đã hình thành TSCĐ', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(150, '/', '511', 'Doanh thu bán hàng và cung cấp dịch vụ', 'Chi tiết theo yêu cầu quản lý', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(151, '/150/', '5111', 'Doanh thu bán hàng hóa', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(152, '/150/', '5112', 'Doanh thu bán các thành phẩm', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(153, '/150/', '5113', 'Doanh thu cung cấp dịch vụ', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(154, '/150/', '5114', 'Doanh thu trợ cấp, trợ giá', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(155, '/150/', '5117', 'Doanh thu kinh doanh bất động sản đầu tư', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(156, '/', '512', 'Doanh thu bán hàng nội bộ', 'Áp dụng khi có bán hàng nội  bộ', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(157, '/156/', '5121', 'Doanh thu bán hàng hóa', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(158, '/156/', '5122', 'Doanh thu bán các thành phẩm', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(159, '/156/', '5123', 'Doanh thu cung cấp dịch vụ', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(160, '/', '515', 'Doanh thu hoạt động tài chính', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(161, '/', '521', 'Chiết khấu thương mại', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(162, '/', '531', 'Hàng bán bị trả lại', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(163, '/', '532', 'Giảm giá hàng bán', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(164, '/', '611', 'Mua hàng', 'Áp dụng phương pháp kiểm kê định kỳ', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(165, '/164/', '6111', 'Mua nguyên liệu, vật liệu', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(166, '/164/', '6112', 'Mua hàng hóa', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(167, '/', '621', 'Chi phí nguyên liệu, vật liệu trực tiếp', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(168, '/', '622', 'Chi phí nhân công trực tiếp', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(169, '/', '623', 'Chi phí sử dụng máy thi công', 'Áp dụng cho đơn vị xây lắp', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(170, '/169/', '6231', 'Chi phí nhân công', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(171, '/169/', '6232', 'Chi phí vật liệu', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(172, '/169/', '6233', 'Chi phí dụng cụ sản xuất', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(173, '/169/', '6234', 'Chi phí khấu hao máy thi công', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(174, '/169/', '6237', 'Chi phí dịch vụ mua ngoài', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(175, '/169/', '6238', 'Chi phí bằng tiền khác', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(176, '/', '627', 'Chi phí sản xuất chung', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(177, '/176/', '6271', 'Chi phí nhân viên phân xưởng', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(178, '/176/', '6272', 'Chi phí vật liệu', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(179, '/176/', '6273', 'Chi phí dụng cụ sản xuất', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(180, '/176/', '6274', 'Chi phí khấu hao TSCĐ', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(181, '/176/', '6277', 'Chi phí dịch vụ mua ngoài', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(182, '/176/', '6278', 'Chi phí bằng tiền khác', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(183, '/', '631', 'Giá thành sản xuất', 'PP.Kkê định kỳ', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(184, '/', '632', 'Giá vốn hàng bán', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(185, '/', '635', 'Chi phí tài chính', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(186, '/', '641', 'Chi phí bán hàng', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(187, '/186/', '6411', 'Chi phí nhân viên', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(188, '/186/', '6412', 'Chi phí vật liệu, bao bì', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(189, '/186/', '6413', 'Chi phí dụng cụ, đồ dùng', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(190, '/186/', '6414', 'Chi phí khấu hao TSCĐ', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(191, '/186/', '6415', 'Chi phí bảo hành', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(192, '/186/', '6417', 'Chi phí dịch vụ mua ngoài', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(193, '/186/', '6418', 'Chi phí bằng tiền khác', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(194, '/', '642', 'Chi phí quản lý doanh nghiệp', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(195, '/194/', '6421', 'Chi phí nhân viên quản lý', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(196, '/194/', '6422', 'Chi phí vật liệu quản lý', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(197, '/194/', '6423', 'Chi phí đồ dùng văn phòng', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(198, '/194/', '6424', 'Chi phí khấu hao TSCĐ', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(199, '/194/', '6425', 'Thuế, phí và lệ phí', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(200, '/194/', '6426', 'Chi phí dự phòng', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(201, '/194/', '6427', 'Chi phí dịch vụ mua ngoài', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(202, '/194/', '6428', 'Chi phí bằng tiền khác', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(203, '/', '711', 'Thu nhập khác', 'Chi tiết theo hoạt động', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(204, '/', '811', 'Chi phí khác', 'Chi tiết theo hoạt động', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(205, '/', '821', 'Chi phí thuế thu nhập doanh nghiệp', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(206, '/205/', '8211', 'Chi phí thuế TNDN hiện hành', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(207, '/205/', '8212', 'Chi phí thuế TNDN hoãn lại', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(208, '/', '911', 'Xác định kết quả kinh doanh', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(209, '/', '001', 'Tài sản thuê ngoài', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(210, '/', '002', 'Vật tư, hàng hóa nhận giữ hộ, nhận gia công', 'Chi tiết theo yêu cầu quản lý', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(211, '/', '003', 'Hàng hóa nhận bán hộ, nhận ký gửi, ký cược', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(212, '/', '004', 'Nợ khó đòi đã xử lý', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(213, '/', '007', 'Ngoại tệ các loại', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(214, '/', '008', 'Dự toán chi sự nghiệp, dự án', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_criteria`
--

CREATE TABLE IF NOT EXISTS `definition_list_criteria` (
  `criteria_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `criteria_name` varchar(100) NOT NULL,
  `inactive` bit(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`criteria_id`),
  KEY `fk_criteria_created_user` (`created_by_userid`),
  KEY `fk_criteria_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `definition_list_criteria`
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

INSERT INTO `definition_list_currency` (`currency_id`, `currency_code`, `currency_name`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, '', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

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
  `is_sales` tinyint(1) unsigned NOT NULL,
  `is_finance` tinyint(1) unsigned NOT NULL,
  `is_purchasing` tinyint(1) unsigned NOT NULL,
  `is_inventory` tinyint(1) unsigned NOT NULL,
  `inactive` bit(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`department_id`),
  KEY `fk_definition_list_department_definition_list_subject1` (`subject_id`),
  KEY `fk_department_created_user` (`created_by_userid`),
  KEY `fk_department_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `definition_list_department`
--

INSERT INTO `definition_list_department` (`department_id`, `subject_id`, `department_code`, `department_name`, `department_function`, `is_sales`, `is_finance`, `is_purchasing`, `is_inventory`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, 0, '', '', '', 0, 0, 0, 0, b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(1, 1, 'KT', 'Kế toán', '', 0, 1, 0, 0, b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(2, 1, 'KD', 'Kinh doanh', '', 1, 0, 0, 0, b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(3, 1, 'MH', 'Mua hàng', '', 0, 0, 1, 0, b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 1, 'KH', 'Kho hàng', '', 0, 0, 0, 1, b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 1, 'GN', 'Giao nhận', '', 0, 0, 0, 0, b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(6, 1, 'HC', 'Hành chính nhân sự', '', 0, 0, 0, 0, b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=31 ;

--
-- Dumping data for table `definition_list_execution`
--

INSERT INTO `definition_list_execution` (`execution_id`, `module_id`, `execution_code`, `execution_name`, `inactive`, `display_order`, `image_file`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, 0, '', '', 1, 0, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(1, 1, 'MD', 'Danh mục - MH', 0, 1, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(2, 1, 'MX', 'Xem hiện trạng - MH', 0, 2, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(3, 1, 'MK', 'Kế hoạch - MH', 0, 3, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 1, 'MP', 'Phát hành - MH', 0, 4, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 1, 'MT', 'Thanh toán - MH', 0, 5, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(6, 2, 'HG', 'Giao hàng - GN', 1, 1, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(7, 2, 'HN', 'Nhận hàng - GN', 1, 2, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(8, 3, 'KD', 'Danh mục - KH', 0, 1, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(9, 3, 'KN', 'Nhập kho - KH', 0, 2, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(10, 3, 'KX', 'Xuất kho - KH', 0, 3, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(11, 3, 'KK', 'Kiểm kho - KH', 0, 4, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(12, 4, 'TD', 'Danh mục - KT', 0, 1, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(13, 4, 'TM', 'Mua hàng - KT', 0, 2, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(14, 4, 'TB', 'Bán hàng - KT', 0, 3, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(15, 4, 'TK', 'Tồn kho - KT', 0, 4, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(16, 4, 'TT', 'Phải thu - KT', 0, 5, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(17, 4, 'TR', 'Phải trả - KT', 0, 6, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(18, 4, 'TN', 'Ngân quỹ - KT', 0, 7, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(19, 4, 'TS', 'Tài sản - KT', 0, 8, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(20, 4, 'TC', 'CP trả trước - KT', 0, 9, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(21, 4, 'TH', 'Tổng hợp - KT', 0, 10, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(22, 5, 'BD', 'Danh mục - BH', 0, 1, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(23, 5, 'BB', 'Báo giá - BH', 0, 2, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(24, 5, 'BH', 'Hợp đồng - BH', 0, 3, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(25, 5, 'BM', 'Nhu cầu - BH', 0, 4, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(26, 5, 'BN', 'Đơn đặt hàng - BH', 0, 5, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(27, 5, 'BG', 'Trả, giảm - BH', 0, 6, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(28, 7, 'LH', 'TL hàng - TL', 0, 1, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(29, 7, 'LD', 'TL đối tượng - TL', 0, 2, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(30, 7, 'LK', 'TL khác - TL', 0, 3, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_factor`
--

CREATE TABLE IF NOT EXISTS `definition_list_factor` (
  `factor_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `factor_name` varchar(100) NOT NULL,
  `inactive` bit(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`factor_id`),
  KEY `fk_factor_created_user` (`created_by_userid`),
  KEY `fk_factor_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `definition_list_factor`
--


-- --------------------------------------------------------

--
-- Table structure for table `definition_list_function`
--

CREATE TABLE IF NOT EXISTS `definition_list_function` (
  `function_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `execution_id` bigint(30) unsigned NOT NULL,
  `function_code` varchar(10) NOT NULL,
  `function_name` varchar(50) NOT NULL,
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=77 ;

--
-- Dumping data for table `definition_list_function`
--

INSERT INTO `definition_list_function` (`function_id`, `execution_id`, `function_code`, `function_name`, `function_action`, `inactive`, `display_order`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, 0, '', '', '', 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(1, 1, 'PNHM', 'Phân nhóm hàng mua', 'purchase/maintenance/product-group', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(2, 1, 'DMHM', 'Danh mục hàng mua', 'purchase/maintenance/product-catalog', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(3, 1, 'PNDM', 'Phân nhóm đối tượng', 'purchase/maintenance/object-group', 0, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 1, 'DMSX', 'DM nhà sản xuất', 'purchase/maintenance/manufacture-list', 0, 4, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 1, 'DMCC', 'DM nhà cung cấp', 'purchase/maintenance/supplier-list', 0, 5, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(6, 2, 'HTTK', 'Hiện trạng tồn kho', 'purchase/maintenance/present-inventory', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(7, 2, 'HTTQ', 'Hiện trạng tồn quỹ', 'purchase/maintenance/survival-fund', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(8, 2, 'LSMH', 'Lịch sử mua hàng', 'purchase/maintenance/purchase-history', 0, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(9, 3, 'KHMH', 'Kế hoạch mua hàng', 'purchase/transaction/buying-plan', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(10, 3, 'TDKH', 'Theo dõi KH mua', 'purchase/transaction/customer-trace', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(11, 4, 'DDHG', 'Đơn đặt hàng', 'purchase/transaction/purchase-order', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(12, 5, 'UTMH', 'Ứng tiền mua hàng', 'purchase/transaction/buying-money', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(13, 5, 'TTMH', 'Trả tiền mua hàng', 'purchase/transaction/payment-money', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(14, 8, 'DMKH', 'Danh mục kho hàng', 'inventory/maintenance/stock-catalog', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(15, 8, 'PNTK', 'Phân nhóm hàng tkho', 'inventory/maintenance/stock-group', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(16, 9, 'NKHM', 'Nhập kho hàng mua', 'inventory/transaction/input-buying-product', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(17, 9, 'NKTL', 'Nhập kho trả lại', 'inventory/transaction/input-return-product', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(18, 10, 'XKBH', 'Xuất kho bán hàng', 'inventory/transaction/output-saling-product', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(19, 10, 'XKSD', 'Xuất kho sử dụng', 'inventory/transaction/output-using-product', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(20, 11, 'KKKV', 'Kiểm khu vực (tháng)', 'inventory/maintenance/check-stock-month', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(21, 11, 'KKTB', 'Kiểm toàn bộ (quý)', 'inventory/maintenance/check-stock', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(22, 12, 'HTTK', 'Hệ thống tài khoản', 'accountant/maintenance/account-system', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(23, 12, 'DMNT', 'Danh mục ngoại tệ', 'accountant/maintenance/currency-catalog', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(24, 12, 'DMDT', 'Danh mục doanh thu', 'accountant/maintenance/revenue-catalog', 0, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(25, 12, 'DMCP', 'Danh mục chi phí', 'accountant/maintenance/expenditure-catalog', 0, 4, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(26, 13, 'HDMH', 'Hóa đơn mua hàng', 'accountant/transaction/buy-billing', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(27, 13, 'CNPR', 'Công nợ phải trả', 'accountant/transaction/owe-topay', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(28, 13, 'PBMH', 'Phân bổ chi phí', 'accountant/transaction/apportion-expenditure', 0, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(29, 14, 'HDBH', 'Hóa đơn bán hàng', 'accountant/transaction/sale-billing', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(30, 14, 'HBTL', 'Hàng bán trả lại', 'accountant/transaction/product-return', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(31, 14, 'GGHB', 'Giảm giá hàng bán', 'accountant/transaction/product-saleoff', 0, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(32, 15, 'QLTK', 'Quản lý hàng tồn kho', 'accountant/transaction/stock-manage', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(33, 15, 'XLTT', 'Xử lý thừa thiếu kho', 'accountant/transaction/stock-clean', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(34, 15, 'TGXK', 'Tính giá xuất kho', 'accountant/transaction/output-price-product', 0, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(35, 16, 'QLPT', 'Quản lý phải thu', 'accountant/transaction/obtain-manage', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(36, 16, 'PTCN', 'Phiếu thu', 'accountant/transaction/obtain-letter', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(37, 16, 'GTPT', 'Giải trừ phải thu', 'accountant/transaction/obtain-resolve', 0, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(38, 17, 'QLPR', 'Quản lý phải trả', 'accountant/transaction/payment-manage', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(39, 17, 'PCCN', 'Phiếu chi', 'accountant/transaction/payment-letter', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(40, 17, 'GTPR', 'Giải trừ phải trả', 'accountant/transaction/payment-resolve', 0, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(41, 18, 'QLNQ', 'Quản lý ngân quỹ', 'accountant/transaction/fund-manage', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(42, 18, 'QLNL', 'Quản lý ngân lưu', 'accountant/transaction/owe-manage', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(43, 19, 'KHTS', 'Khấu hao TSCĐ', 'accountant/maintenance/amortize-property', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(44, 20, 'CPTT', 'Chi phí trả trước', 'accountant/maintenance/expenditure-pay', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(45, 21, 'PHDK', 'Phiếu định khoản', 'accountant/maintenance/account-letter', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(46, 22, 'PNKH', 'Phân nhóm khách hàng', 'sale/maintenance/customer-group', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(47, 22, 'DMKH', 'Danh mục khách hàng', 'sale/maintenance/customer-list', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(48, 22, 'PNHB', 'Phân nhóm hàng bán', 'sale/maintenance/product-group', 0, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(49, 22, 'DMHB', 'Danh mục hàng bán', 'sale/maintenance/product-catalog', 0, 4, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(50, 23, 'BGDK', 'Báo giá định kỳ', 'sale/maintenance/price-announce', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(51, 23, 'BGYC', 'Báo giá theo yêu cầu', 'sale/maintenance/price-announce-request', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(52, 24, 'HDNT', 'Hợp đồng nguyên tắc', 'sale/maintenance/billing-priciple', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(53, 24, 'HDPS', 'Hợp đồng phát sinh', 'sale/maintenance/billing-originate', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(54, 25, 'MHTX', 'Mua thường xuyên', 'sale/maintenance/buy-regular', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(55, 26, 'DDHG', 'Đơn đặt hàng', 'sale/transaction/sale-order', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(56, 26, 'XNDH', 'Xác nhận đặt hàng', 'sale/transaction/order-confirm', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(57, 27, 'HBTL', 'Hàng bán trả lại', 'sale/transaction/product-return', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(58, 27, 'GGHB', 'Giảm giá hàng bán', 'sale/transaction/price-saleoff', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(59, 28, 'PNMH', 'Phân nhóm mặt hàng', 'core/maintenance/product-group', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(60, 28, 'DMMH', 'Danh mục mặt hàng', 'core/maintenance/product-catalog', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(61, 29, 'PNDT', 'Phân nhóm đối tượng', 'core/maintenance/object-group', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(62, 29, 'DMDT', 'Danh mục đối tượng', 'core/maintenance/object-catalog', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(63, 1, '', 'Purchase Module', 'purchase', 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(64, 1, '', 'Purchase Maintenance', 'purchase/maintenance', 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(65, 1, '', 'Purchase Transaction', 'purchase/transaction', 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(66, 8, '', 'Inventory Module', 'inventory', 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(67, 8, '', 'Inventory Maintenance', 'inventory/maintenance', 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(68, 8, '', 'Inventory Transaction', 'inventory/transaction', 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(69, 12, '', 'Accountant Module', 'accountant', 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(70, 12, '', 'Accountant Maintenance', 'accountant/maintenance', 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(71, 12, '', 'Accountant Transaction', 'accountant/transaction', 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(72, 28, '', 'Core Module', 'core', 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(73, 28, '', 'Core Maintenance', 'core/maintenance', 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(74, 28, '', 'Sale Module', 'sale', 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(75, 28, '', 'Sale Maintenance', 'sale/maintenance', 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(76, 28, '', 'Sale Transaction', 'sale/transaction', 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_group`
--

CREATE TABLE IF NOT EXISTS `definition_list_group` (
  `group_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `criteria_id` bigint(30) unsigned NOT NULL,
  `group_path` varchar(101) NOT NULL,
  `group_code` varchar(10) NOT NULL,
  `group_name` varchar(100) NOT NULL,
  `group_note` varchar(100) NOT NULL,
  `inactive` bit(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`group_id`),
  KEY `fk_group_criteria` (`criteria_id`),
  KEY `fk_group_created_user` (`created_by_userid`),
  KEY `fk_group_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `definition_list_group`
--


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
(0, '', '', '', 0, '', 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(1, 'MH', 'Mua hàng', 'Quick_Purchase', 6, 'purchase/', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(2, 'GN', 'Giao nhận hàng', '', 0, '', 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(3, 'KH', 'Nhập xuất tồn kho', 'Quick_Inventory', 4, 'inventory/', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 'KT', 'Hạch toán kế toán', 'Quick_Accountant', 2, 'accountant/', 0, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 'BH', 'Bán hàng', 'Quick_Sale', 5, 'sale/', 0, 4, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(6, 'HC', 'Hành chính nhân sự', 'Quick_Human', 7, '', 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(7, 'TL', 'Thiết lập hệ thống', 'Quick_Core', 1, '/', 0, 5, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(8, 'QT', 'Ra quyết định', 'Quick_General', 3, 'general/', 0, 6, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_product`
--

CREATE TABLE IF NOT EXISTS `definition_list_product` (
  `product_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `product_code` varchar(10) NOT NULL,
  `product_name` varchar(100) NOT NULL,
  `producer_id` bigint(30) unsigned NOT NULL,
  `base_unit_id` bigint(30) unsigned NOT NULL,
  `regular_unit_id` bigint(30) unsigned NOT NULL,
  `product_picture` varchar(100) NOT NULL,
  `product_model` varchar(100) NOT NULL,
  `product_description` varchar(500) NOT NULL,
  `inactive` bit(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`product_id`),
  KEY `fk_product_producer` (`producer_id`),
  KEY `fk_product_base_unit` (`base_unit_id`),
  KEY `fk_product_regular_unit` (`regular_unit_id`),
  KEY `fk_product_created_user` (`created_by_userid`),
  KEY `fk_product_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `definition_list_product`
--


-- --------------------------------------------------------

--
-- Table structure for table `definition_list_property`
--

CREATE TABLE IF NOT EXISTS `definition_list_property` (
  `property_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `factor_id` bigint(30) unsigned NOT NULL,
  `property_text` varchar(100) NOT NULL,
  `max_property_number` decimal(18,4) NOT NULL,
  `min_property_number` decimal(18,4) NOT NULL,
  `inactive` bit(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`property_id`),
  KEY `fk_property_factor` (`factor_id`),
  KEY `fk_property_created_user` (`created_by_userid`),
  KEY `fk_property_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `definition_list_property`
--


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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `definition_list_role`
--

INSERT INTO `definition_list_role` (`role_id`, `department_id`, `role_code`, `role_name`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, 0, 'VTM', 'Toàn quyền', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_staff`
--

CREATE TABLE IF NOT EXISTS `definition_list_staff` (
  `staff_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `department_id` bigint(30) unsigned NOT NULL,
  `staff_code` varchar(10) NOT NULL,
  `first_name` varchar(20) NOT NULL,
  `middle_name` varchar(60) NOT NULL,
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
  KEY `fk_staff_created_user` (`created_by_userid`),
  KEY `fk_staff_department` (`department_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `definition_list_staff`
--

INSERT INTO `definition_list_staff` (`staff_id`, `department_id`, `staff_code`, `first_name`, `middle_name`, `last_name`, `birth_date`, `id_number`, `id_issuing_office`, `id_issuing_date`, `social_number`, `resident_address`, `contact_address`, `home_phone`, `cell_phone`, `email`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, 0, 'VTM', 'Nhân viên', '', 'VTM', '1900-01-01 00:00:00', '', '', '1900-01-01 00:00:00', '', '', '', '', '', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_subject`
--

CREATE TABLE IF NOT EXISTS `definition_list_subject` (
  `subject_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `subject_code` varchar(10) NOT NULL,
  `subject_name` varchar(100) NOT NULL,
  `subject_address` varchar(100) NOT NULL,
  `subject_tax_code` varchar(20) NOT NULL,
  `is_software_user` bit(1) NOT NULL,
  `is_producer` bit(1) NOT NULL,
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `definition_list_subject`
--

INSERT INTO `definition_list_subject` (`subject_id`, `subject_code`, `subject_name`, `subject_address`, `subject_tax_code`, `is_software_user`, `is_producer`, `is_supplier`, `is_customer`, `is_government`, `is_bank`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, '', '', '', '', b'0', b'0', b'0', b'0', b'0', b'0', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(1, 'N2H', 'Công ty Nhanh Nhanh', '', '', b'1', b'0', b'1', b'1', b'0', b'0', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_unit`
--

CREATE TABLE IF NOT EXISTS `definition_list_unit` (
  `unit_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `unit_code` varchar(10) NOT NULL,
  `unit_name` varchar(100) NOT NULL,
  `inactive` bit(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`unit_id`),
  KEY `fk_unit_created_user` (`created_by_userid`),
  KEY `fk_unit_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `definition_list_unit`
--


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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `definition_list_user`
--

INSERT INTO `definition_list_user` (`user_id`, `staff_id`, `role_id`, `user_name`, `password`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, 0, 0, 'nguoi_dung', '', b'0', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_relation_account_level`
--

CREATE TABLE IF NOT EXISTS `definition_relation_account_level` (
  `account_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `level` tinyint(1) unsigned NOT NULL,
  `detail_table` varchar(40) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`account_id`,`level`),
  KEY `fk_level_account_created_user` (`created_by_userid`),
  KEY `fk_level_account_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `definition_relation_account_level`
--


-- --------------------------------------------------------

--
-- Table structure for table `definition_relation_product_unit`
--

CREATE TABLE IF NOT EXISTS `definition_relation_product_unit` (
  `product_id` bigint(30) unsigned NOT NULL,
  `unit_id` bigint(30) unsigned NOT NULL,
  `sku_number` varchar(10) NOT NULL,
  `coefficient` decimal(18,4) NOT NULL,
  `default_sales_price` decimal(18,4) NOT NULL,
  `default_purchasing_price` decimal(18,4) NOT NULL,
  `default_inventory_price` decimal(18,4) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`product_id`,`unit_id`),
  KEY `fk_relation_unit` (`unit_id`),
  KEY `fk_product_unit_created_user` (`created_by_userid`),
  KEY `fk_product_unit_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `definition_relation_product_unit`
--


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
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`role_id`,`function_id`),
  KEY `fk_definition_relation_role_function_definition_list_role1` (`role_id`),
  KEY `fk_definition_relation_role_function_definition_list_function1` (`function_id`) USING BTREE,
  KEY `fk_function_role_created_user` (`created_by_userid`),
  KEY `fk_function_role_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `definition_relation_role_function`
--

INSERT INTO `definition_relation_role_function` (`role_id`, `function_id`, `permission`, `can_list`, `can_view`, `can_add`, `can_modify`, `can_change`, `can_delete`, `can_print`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, 1, 'allow', 1, 1, 1, 1, 1, 1, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(0, 2, 'allow', 1, 1, 1, 1, 1, 1, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(0, 6, 'allow', 1, 1, 1, 1, 1, 1, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(0, 7, 'allow', 1, 1, 1, 1, 1, 1, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(0, 8, 'allow', 1, 1, 1, 1, 1, 1, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(0, 9, 'allow', 1, 1, 1, 1, 1, 1, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `accountant_detail_entry`
--
ALTER TABLE `accountant_detail_entry`
  ADD CONSTRAINT `fk_entry_credit_account` FOREIGN KEY (`credit_account_id`) REFERENCES `definition_list_account` (`account_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_entry_currency` FOREIGN KEY (`currency_id`) REFERENCES `definition_list_currency` (`currency_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_entry_debit_account` FOREIGN KEY (`debit_account_id`) REFERENCES `definition_list_account` (`account_id`) ON DELETE CASCADE ON UPDATE CASCADE,
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
-- Constraints for table `definition_detail_account`
--
ALTER TABLE `definition_detail_account`
  ADD CONSTRAINT `fk_detail_account_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_account` FOREIGN KEY (`account_id`) REFERENCES `definition_list_account` (`account_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_account_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_detail_group`
--
ALTER TABLE `definition_detail_group`
  ADD CONSTRAINT `fk_detail_group_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_group` FOREIGN KEY (`group_id`) REFERENCES `definition_list_group` (`group_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_group_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_group_criteria` FOREIGN KEY (`criteria_id`) REFERENCES `definition_list_criteria` (`criteria_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_group_product` FOREIGN KEY (`product_id`) REFERENCES `definition_list_product` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_detail_property`
--
ALTER TABLE `definition_detail_property`
  ADD CONSTRAINT `fk_detail_property_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_property` FOREIGN KEY (`property_id`) REFERENCES `definition_list_property` (`property_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_property_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_property_factor` FOREIGN KEY (`factor_id`) REFERENCES `definition_list_factor` (`factor_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_property_product` FOREIGN KEY (`product_id`) REFERENCES `definition_list_product` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_account`
--
ALTER TABLE `definition_list_account`
  ADD CONSTRAINT `fk_account_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_account_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_criteria`
--
ALTER TABLE `definition_list_criteria`
  ADD CONSTRAINT `fk_criteria_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_criteria_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

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
-- Constraints for table `definition_list_factor`
--
ALTER TABLE `definition_list_factor`
  ADD CONSTRAINT `fk_factor_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_factor_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_function`
--
ALTER TABLE `definition_list_function`
  ADD CONSTRAINT `fk_function_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_function_execution` FOREIGN KEY (`execution_id`) REFERENCES `definition_list_execution` (`execution_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_function_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_group`
--
ALTER TABLE `definition_list_group`
  ADD CONSTRAINT `fk_group_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_group_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_group_criteria` FOREIGN KEY (`criteria_id`) REFERENCES `definition_list_criteria` (`criteria_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_module`
--
ALTER TABLE `definition_list_module`
  ADD CONSTRAINT `fk_module_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_module_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_product`
--
ALTER TABLE `definition_list_product`
  ADD CONSTRAINT `fk_product_base_unit` FOREIGN KEY (`base_unit_id`) REFERENCES `definition_list_unit` (`unit_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_product_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_product_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_product_producer` FOREIGN KEY (`producer_id`) REFERENCES `definition_list_subject` (`subject_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_product_regular_unit` FOREIGN KEY (`regular_unit_id`) REFERENCES `definition_list_unit` (`unit_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_property`
--
ALTER TABLE `definition_list_property`
  ADD CONSTRAINT `fk_property_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_property_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_property_factor` FOREIGN KEY (`factor_id`) REFERENCES `definition_list_factor` (`factor_id`) ON DELETE CASCADE ON UPDATE CASCADE;

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
  ADD CONSTRAINT `fk_staff_department` FOREIGN KEY (`department_id`) REFERENCES `definition_list_department` (`department_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_staff_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_staff_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_subject`
--
ALTER TABLE `definition_list_subject`
  ADD CONSTRAINT `fk_subject_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_subject_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_unit`
--
ALTER TABLE `definition_list_unit`
  ADD CONSTRAINT `fk_unit_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_unit_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_user`
--
ALTER TABLE `definition_list_user`
  ADD CONSTRAINT `fk_user_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_role` FOREIGN KEY (`role_id`) REFERENCES `definition_list_role` (`role_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_staff` FOREIGN KEY (`staff_id`) REFERENCES `definition_list_staff` (`staff_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_relation_account_level`
--
ALTER TABLE `definition_relation_account_level`
  ADD CONSTRAINT `fk_level_account_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_level_account` FOREIGN KEY (`account_id`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_level_account_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_relation_product_unit`
--
ALTER TABLE `definition_relation_product_unit`
  ADD CONSTRAINT `fk_product_unit_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_product_unit_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_relation_product` FOREIGN KEY (`product_id`) REFERENCES `definition_list_product` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_relation_unit` FOREIGN KEY (`unit_id`) REFERENCES `definition_list_unit` (`unit_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_relation_role_function`
--
ALTER TABLE `definition_relation_role_function`
  ADD CONSTRAINT `fk_function_role_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_function_role_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_relation_function` FOREIGN KEY (`function_id`) REFERENCES `definition_list_function` (`function_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_relation_role` FOREIGN KEY (`role_id`) REFERENCES `definition_list_role` (`role_id`) ON DELETE CASCADE ON UPDATE CASCADE;
