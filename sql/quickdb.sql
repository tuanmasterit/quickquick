-- phpMyAdmin SQL Dump
-- version 3.1.3.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Apr 19, 2010 at 06:26 PM
-- Server version: 5.1.33
-- PHP Version: 5.2.9

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `quickdb`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin_acl_resource`
--

CREATE TABLE IF NOT EXISTS `admin_acl_resource` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `resource_id` varchar(64) NOT NULL,
  `title` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `admin_acl_resource`
--

INSERT INTO `admin_acl_resource` (`id`, `resource_id`, `title`) VALUES
(1, 'sale', 'Sale System'),
(2, 'sale/transaction', 'Sale - Transaction'),
(3, 'sale/transaction/add-order', 'Sale - Add New Order'),
(4, 'core', 'Core System');

-- --------------------------------------------------------

--
-- Table structure for table `admin_acl_role`
--

CREATE TABLE IF NOT EXISTS `admin_acl_role` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `sort_order` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `role_name` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `admin_acl_role`
--

INSERT INTO `admin_acl_role` (`id`, `sort_order`, `role_name`) VALUES
(1, 0, 'Administrator'),
(2, 0, 'Accountant'),
(3, 0, 'Saler'),
(4, 0, 'Purchaser'),
(5, 0, 'Storekeeper'),
(6, 0, 'Saler 1'),
(7, 0, 'Saler 2');

-- --------------------------------------------------------

--
-- Table structure for table `admin_acl_role_parent`
--

CREATE TABLE IF NOT EXISTS `admin_acl_role_parent` (
  `role_id` mediumint(8) unsigned NOT NULL,
  `role_parent_id` mediumint(8) unsigned NOT NULL,
  PRIMARY KEY (`role_id`),
  KEY `fk_role_id` (`role_id`),
  KEY `fk_role_parent_id` (`role_parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

--
-- Dumping data for table `admin_acl_role_parent`
--


-- --------------------------------------------------------

--
-- Table structure for table `admin_acl_rule`
--

CREATE TABLE IF NOT EXISTS `admin_acl_rule` (
  `role_id` mediumint(8) unsigned NOT NULL,
  `resource_id` varchar(128) NOT NULL,
  `permission` enum('allow','deny') NOT NULL,
  PRIMARY KEY (`role_id`,`resource_id`),
  KEY `resource` (`resource_id`),
  KEY `i_acl_rule_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `admin_acl_rule`
--

INSERT INTO `admin_acl_rule` (`role_id`, `resource_id`, `permission`) VALUES
(1, 'core', 'allow'),
(1, 'sale', 'allow'),
(3, 'sale', 'allow'),
(4, 'sale', 'allow'),
(4, 'sale/transaction', 'deny'),
(4, 'sale/transaction/add-order', 'deny');

-- --------------------------------------------------------

--
-- Table structure for table `admin_user`
--

CREATE TABLE IF NOT EXISTS `admin_user` (
  `id` mediumint(9) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` mediumint(8) unsigned DEFAULT NULL,
  `firstname` varchar(32) NOT NULL,
  `lastname` varchar(32) NOT NULL,
  `email` varchar(128) NOT NULL,
  `username` varchar(40) NOT NULL,
  `password` varchar(32) NOT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `lastlogin` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `lognum` smallint(5) unsigned NOT NULL DEFAULT '0',
  `reload_acl_flag` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `i_admin_user_role_id` (`role_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `admin_user`
--

INSERT INTO `admin_user` (`id`, `role_id`, `firstname`, `lastname`, `email`, `username`, `password`, `created`, `modified`, `lastlogin`, `lognum`, `reload_acl_flag`, `is_active`) VALUES
(1, 1, 'admin', 'admin', 'ecartcommerce@example.com', 'admin', 'e10adc3949ba59abbe56e057f20f883e', '0000-00-00 00:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 0, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `core_acl_resource`
--

CREATE TABLE IF NOT EXISTS `core_acl_resource` (
  `module_id` int(10) unsigned NOT NULL,
  `resource_id` varchar(255) NOT NULL,
  `title_key` varchar(255) NOT NULL,
  PRIMARY KEY (`resource_id`),
  KEY `fk_resource_module_id` (`module_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `core_acl_resource`
--

INSERT INTO `core_acl_resource` (`module_id`, `resource_id`, `title_key`) VALUES
(2, 'accountant', 'module-accountant'),
(1, 'core', 'module-core'),
(3, 'general', 'module-general'),
(4, 'inventory', 'module-inventory'),
(6, 'purchase', 'module-purchase'),
(5, 'sale', 'module-sale'),
(5, 'sale/transaction', 'sale-transaction');

-- --------------------------------------------------------

--
-- Table structure for table `core_acl_role`
--

CREATE TABLE IF NOT EXISTS `core_acl_role` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `sort_order` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `role_name` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `core_acl_role`
--

INSERT INTO `core_acl_role` (`id`, `sort_order`, `role_name`) VALUES
(1, 0, 'Administrator'),
(2, 0, 'Accountant'),
(3, 0, 'Saler'),
(4, 0, 'Purchaser'),
(5, 0, 'Storekeeper');

-- --------------------------------------------------------

--
-- Table structure for table `core_acl_role_parent`
--

CREATE TABLE IF NOT EXISTS `core_acl_role_parent` (
  `role_id` mediumint(8) unsigned NOT NULL,
  `role_parent_id` mediumint(8) unsigned NOT NULL,
  PRIMARY KEY (`role_id`),
  KEY `fk_acl_role_id` (`role_id`),
  KEY `fk_acl_role_parent_id` (`role_parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

--
-- Dumping data for table `core_acl_role_parent`
--


-- --------------------------------------------------------

--
-- Table structure for table `core_acl_rule`
--

CREATE TABLE IF NOT EXISTS `core_acl_rule` (
  `role_id` mediumint(8) unsigned NOT NULL,
  `resource_id` varchar(255) NOT NULL,
  `permission` enum('allow','deny') NOT NULL,
  `is_add` tinyint(1) NOT NULL DEFAULT '0',
  `is_modify` tinyint(1) NOT NULL DEFAULT '0',
  `is_change` tinyint(1) NOT NULL DEFAULT '0',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0',
  `is_view` tinyint(1) NOT NULL DEFAULT '0',
  `is_list` tinyint(1) NOT NULL DEFAULT '0',
  `is_print` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`role_id`,`resource_id`),
  KEY `fk_core_acl_resource_id` (`resource_id`),
  KEY `fk_core_acl_rule_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `core_acl_rule`
--

INSERT INTO `core_acl_rule` (`role_id`, `resource_id`, `permission`, `is_add`, `is_modify`, `is_change`, `is_delete`, `is_view`, `is_list`, `is_print`) VALUES
(1, 'accountant', 'allow', 0, 1, 1, 0, 0, 0, 0),
(1, 'core', 'allow', 1, 1, 0, 0, 1, 0, 0),
(1, 'general', 'allow', 0, 0, 0, 0, 0, 0, 0),
(1, 'inventory', 'allow', 0, 0, 0, 0, 0, 0, 0),
(1, 'purchase', 'allow', 0, 0, 0, 0, 0, 0, 0),
(1, 'sale', 'allow', 1, 1, 1, 0, 0, 0, 0),
(1, 'sale/transaction', 'allow', 1, 0, 0, 0, 0, 0, 0),
(2, 'accountant', 'allow', 1, 1, 1, 0, 0, 0, 0),
(2, 'sale', 'allow', 1, 1, 1, 0, 0, 0, 0),
(3, 'accountant', 'allow', 0, 0, 0, 0, 0, 0, 0),
(3, 'core', 'allow', 0, 1, 0, 1, 0, 0, 0),
(3, 'sale', 'allow', 1, 1, 1, 0, 0, 0, 0),
(3, 'sale/transaction', 'allow', 1, 0, 0, 0, 0, 0, 0),
(4, 'core', 'deny', 0, 0, 0, 0, 0, 0, 0),
(4, 'general', 'allow', 0, 0, 0, 0, 0, 0, 0),
(4, 'purchase', 'deny', 0, 0, 0, 0, 0, 0, 0),
(4, 'sale', 'allow', 1, 1, 1, 0, 0, 0, 0),
(5, 'accountant', 'deny', 0, 0, 0, 0, 0, 0, 0),
(5, 'core', 'allow', 1, 1, 1, 1, 0, 0, 0),
(5, 'general', 'deny', 0, 0, 0, 0, 0, 0, 0),
(5, 'inventory', 'deny', 0, 0, 0, 0, 0, 0, 0),
(5, 'purchase', 'deny', 0, 0, 0, 0, 0, 0, 0),
(5, 'sale', 'allow', 1, 1, 1, 0, 0, 0, 1),
(5, 'sale/transaction', 'deny', 0, 0, 0, 0, 0, 0, 0);

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
  `lvl` tinyint(3) unsigned NOT NULL,
  `path` varchar(255) NOT NULL,
  `title` varchar(128) NOT NULL,
  `config_type` varchar(15) NOT NULL DEFAULT '',
  `model` varchar(128) NOT NULL,
  `model_assigned_with` varchar(128) NOT NULL,
  `config_options` text,
  `description` text,
  PRIMARY KEY (`id`),
  KEY `index_path` (`path`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=24 ;

--
-- Dumping data for table `core_config_field`
--

INSERT INTO `core_config_field` (`id`, `lvl`, `path`, `title`, `config_type`, `model`, `model_assigned_with`, `config_options`, `description`) VALUES
(1, 1, 'main', 'Main', 'string', '', '', NULL, ''),
(2, 2, 'main/store', 'Store', 'string', '', '', NULL, ''),
(3, 3, 'main/store/name', 'Name', 'string', '', '', NULL, ''),
(4, 3, 'main/store/country', 'Country', 'select', 'Country', '', NULL, 'Store Country'),
(5, 3, 'main/store/zone', 'Zone', 'select', 'ZoneByCountry', 'main/store/country', NULL, 'Store zone(state,province)'),
(6, 3, 'main/store/city', 'City', 'string', '', '', NULL, ''),
(7, 3, 'main/store/taxBasis', 'Tax Basis for products', 'select', 'TaxBasis', '', NULL, 'Basis that will be used for calculating products taxes'),
(8, 3, 'main/store/language', 'Default language', 'select', 'Language', '', NULL, 'Default site language'),
(9, 3, 'main/store/currency', 'Default display currency', 'select', 'Currency', '', NULL, 'Default currency'),
(10, 3, 'main/store/zip', 'Zipcode', 'string', '', '', NULL, 'Zip code'),
(11, 3, 'main/store/owner', 'Store owner', 'string', '', '', NULL, ''),
(12, 3, 'main/store/locale', 'Default locale', 'select', 'ZendLocale', '', NULL, 'Default site locale'),
(13, 3, 'main/store/timezone', 'Timezone', 'select', 'ZendTimezone', '', NULL, 'Timezone'),
(14, 3, 'sale/main/saleRoute', 'Sale router', 'string', '', '', NULL, 'Sale url (example.com/<b>saleRoute</b>/product)'),
(15, 3, 'design/main/frontTemplateId', 'Front Template', 'select', 'Template', '', NULL, ''),
(16, 3, 'design/main/adminTemplateId', 'Admin Template', 'select', 'Template', '', NULL, ''),
(17, 3, 'design/htmlHead/titlePattern', 'Title Pattern', 'multiple', '', '', 'Page Title,Parent Page Titles,Site Name', 'Check values, which you want to see on page title'),
(18, 1, 'translation', 'Translation', 'string', '', '', NULL, ''),
(19, 2, 'translation/main', 'Main', 'string', '', '', NULL, ''),
(20, 3, 'translation/main/autodetect', 'Autodetect new words', 'bool', '', '', NULL, 'Autodetect new words (run if set TRUE: >chmod -R 0777 [root_path]/app/locale)'),
(21, 3, 'general/main/generalRoute', 'general router', 'string', '', '', NULL, 'general url'),
(22, 3, 'auth/main/authRoute', 'Authenticate router', 'string', '', '', NULL, ''),
(23, 3, 'language/main/languageRoute', 'Language router', 'string', '', '', NULL, '');

-- --------------------------------------------------------

--
-- Table structure for table `core_config_value`
--

CREATE TABLE IF NOT EXISTS `core_config_value` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `config_field_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `path` varchar(128) NOT NULL,
  `site_id` smallint(5) unsigned NOT NULL,
  `value` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `config_value_site_id` (`site_id`),
  KEY `FK_config_field_id` (`config_field_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=20 ;

--
-- Dumping data for table `core_config_value`
--

INSERT INTO `core_config_value` (`id`, `config_field_id`, `path`, `site_id`, `value`) VALUES
(1, 3, 'main/store/name', 0, 'Enter store name'),
(2, 4, 'main/store/country', 0, '223'),
(3, 5, 'main/store/zone', 0, '43'),
(4, 6, 'main/store/city', 0, ''),
(5, 7, 'main/store/taxBasis', 0, 'delivery'),
(6, 8, 'main/store/language', 0, '1'),
(7, 9, 'main/store/currency', 0, 'USD'),
(8, 10, 'main/store/zip', 0, '10001'),
(9, 11, 'main/store/owner', 0, 'minh trung phan'),
(10, 12, 'main/store/locale', 0, 'vi_VN'),
(11, 13, 'main/store/timezone', 0, 'Australia/Darwin'),
(12, 14, 'sale/main/saleRoute', 0, 'sale'),
(13, 15, 'design/main/frontTemplateId', 0, '1'),
(14, 16, 'design/main/adminTemplateId', 0, '1'),
(15, 17, 'design/htmlHead/titlePattern', 0, 'Page Title,Site Name'),
(16, 20, 'translation/main/autodetect', 0, '0'),
(17, 21, 'general/main/generalRoute', 0, 'general'),
(18, 22, 'auth/main/authRoute', 0, 'auth'),
(19, 23, 'language/main/languageRoute', 0, 'language');

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
-- Table structure for table `core_module`
--

CREATE TABLE IF NOT EXISTS `core_module` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `package` varchar(64) NOT NULL,
  `code` varchar(64) NOT NULL,
  `name` varchar(64) NOT NULL,
  `version` varchar(10) NOT NULL,
  `is_active` tinyint(1) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `core_module`
--

INSERT INTO `core_module` (`id`, `package`, `code`, `name`, `version`, `is_active`) VALUES
(1, 'Quick_Core', 'Quick_Core', 'Core', '0.1', 1),
(2, 'Quick_Accountant', 'Quick_Accountant', 'Accountant', '0.1', 1),
(3, 'Quick_General', 'Quick_General', 'General', '0.1', 1),
(4, 'Quick_Inventory', 'Quick_Inventory', 'Inventory', '0.1', 1),
(5, 'Quick_Sale', 'Quick_Sale', 'Sale', '0.1', 1),
(6, 'Quick_Purchase', 'Quick_Purchase', 'Purchase', '0.1', 1);

-- --------------------------------------------------------

--
-- Table structure for table `core_module_language`
--

CREATE TABLE IF NOT EXISTS `core_module_language` (
  `module_id` int(10) unsigned NOT NULL,
  `language_id` smallint(5) unsigned NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` text NOT NULL,
  PRIMARY KEY (`module_id`,`language_id`,`key`),
  KEY `fk_module_id` (`module_id`),
  KEY `fk_language_id` (`language_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED;

--
-- Dumping data for table `core_module_language`
--

INSERT INTO `core_module_language` (`module_id`, `language_id`, `key`, `value`) VALUES
(1, 1, 'Home', 'Home'),
(1, 1, 'module-core', 'The System Function'),
(1, 2, 'Home', 'Trang chủ'),
(1, 2, 'module-core', 'Chức năng hệ thống'),
(2, 1, 'module-accountant', 'The Accountant Function'),
(2, 2, 'module-accountant', 'Chức năng kế toán'),
(3, 1, 'module-general', 'The General Legder Function'),
(3, 2, 'module-general', 'Chức năng quản trị'),
(4, 1, 'module-inventory', 'The Inventory Function'),
(4, 2, 'module-inventory', 'Chức năng quản lí kho'),
(5, 1, 'module-sale', 'The Sale Function'),
(5, 2, 'module-sale', 'Chức năng bán hàng'),
(6, 1, 'module-purchase', 'The Purchase Function'),
(6, 2, 'module-purchase', 'Chức năng mua hàng');

-- --------------------------------------------------------

--
-- Table structure for table `core_user`
--

CREATE TABLE IF NOT EXISTS `core_user` (
  `id` mediumint(9) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` mediumint(8) unsigned DEFAULT NULL,
  `firstname` varchar(32) NOT NULL,
  `lastname` varchar(32) NOT NULL,
  `email` varchar(128) NOT NULL,
  `username` varchar(40) NOT NULL,
  `password` varchar(32) NOT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `lastlogin` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `lognum` smallint(5) unsigned NOT NULL DEFAULT '0',
  `reload_acl_flag` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `i_admin_user_role_id` (`role_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `core_user`
--

INSERT INTO `core_user` (`id`, `role_id`, `firstname`, `lastname`, `email`, `username`, `password`, `created`, `modified`, `lastlogin`, `lognum`, `reload_acl_flag`, `is_active`) VALUES
(1, 1, 'admin', 'admin', 'abc@example.com', 'admin', 'e10adc3949ba59abbe56e057f20f883e', '0000-00-00 00:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 0, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE IF NOT EXISTS `suppliers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` text COLLATE utf8_unicode_ci NOT NULL,
  `name` text COLLATE utf8_unicode_ci,
  `address` text COLLATE utf8_unicode_ci,
  `taxcode` text COLLATE utf8_unicode_ci,
  `contactperson` text COLLATE utf8_unicode_ci,
  `telephone` text COLLATE utf8_unicode_ci,
  `phone` text COLLATE utf8_unicode_ci,
  `fax` text COLLATE utf8_unicode_ci,
  `email` text COLLATE utf8_unicode_ci,
  `bankaccountno` text COLLATE utf8_unicode_ci,
  `createDate` datetime NOT NULL,
  `updateDate` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=128 ;

--
-- Dumping data for table `suppliers`
--

INSERT INTO `suppliers` (`id`, `code`, `name`, `address`, `taxcode`, `contactperson`, `telephone`, `phone`, `fax`, `email`, `bankaccountno`, `createDate`, `updateDate`) VALUES
(1, '111-001', 'CTY TNHH DOTCOM VIỆT NAM', '40-42 Phan Bội Châu, P. Bến Thành, Q1', '0305084734', 'chị Hòa -kt', '', NULL, '', '', '', '2010-03-29 11:53:17', '2010-03-29 11:53:17'),
(2, '111-002', 'Trần Phúc Hoàng', '', '', '', '', NULL, '', '', '', '2010-03-29 11:53:17', '2010-03-29 11:53:17'),
(3, '111-003', 'Chi Cục Thuế Quận Thủ Đức', '16 đường 6, P.Linh Chiểu, Q. Thủ Đức', '0301519977022', '', '', NULL, '', '', '', '2010-03-29 11:53:17', '2010-03-29 11:53:17'),
(4, '111-004', 'CÔNG TY TNHH TM ĐỒNG NAM', '67-69-71 Trương Định, Q1. TPHCM', '0300835779001', '', '', NULL, '', '', '', '2010-03-29 11:53:17', '2010-03-29 11:53:17'),
(5, '111-005', 'Vũ Thị Kim Ngân', '', '', '', '', NULL, '', '', '', '2010-03-29 11:53:17', '2010-03-29 11:53:17'),
(6, '111-006', 'Hợp Tác Xã Vận Tải Số 10', '100 Hùng Vương, P9, Q5', '0302847593', '', '', NULL, '', '', '', '2010-03-29 11:53:17', '2010-03-29 11:53:17'),
(7, '111-007', 'Cty TNHH May THIÊN ĐỨC TÂM', '197/2 Ba Đình, P8, Q8, TPHCM', '0303237720', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(8, '111-008', 'Hợp Tác Xã VTHH Và Xe Du Lịch THỦ ĐỨC', '30 Võ Văn Ngân, P. Bình Thọ, Q. Thủ Đức', '0301459132', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(9, '111-009', 'Cty CP Việt Đỉnh', 'Lầu 4, số 141, đường D3, P25, Q. Bình Thạnh', '0304397068', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(10, '111-010', 'Cty TNHH TÂN ĐÔNG DƯƠNG', '45 Trương Định,P6, Q3', '0301449173', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(11, '111-011', 'TAXI', '', '', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(12, '111-012', 'Công Ty Cổ Phần Thương Mại Dịch Vụ Phong Vũ', '125 Cách Mạng Tháng 8, P. Bến Thành, Q1, TPHCM', '0304998358', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(13, '111-013', 'Anh Tuấn ( cty  Nhanh Nhanh)', '', '', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(14, '111-014', 'Trung Đoàn TT23-QK7', '102 Phổ Quang, P2, Q.TB, TPHCM', '0301832040', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(15, '111-015', 'Anh Đời Cty Nhanh Nhanh', '', '', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(16, '111-016', 'Cty TNHH DVBV Hoàng Gia', 'km 92-QL5-Hùng Vương-HB-HP', '0200356067', 'C. Phượng', '37168506', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(17, '111-017', 'Anh Thanh', '', '', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(18, '111-018', 'Anh Hùng', '', '', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(19, '111-019', 'Anh Phước (Thủ Đức)', '', '', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(20, '111-020', 'Mr. Taro', '', '', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:55:02'),
(21, '111-021', 'Cty TNHH MTV Nhanh Nhanh', 'Số 37, Đường số 7, P. Linh Trung, Q. TĐ', '', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(22, '111-022', 'CTY Cổ Phần Hai Bốn Bảy', '57 Nguyễn Quang Bích, P13, Q. TB', '0304043037', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(23, '111-023', 'Tổng Công Ty Viễn Thông Quân Đội ( Viettel Corporation)', 'Số 1, Giang Minh, Ba Đình, Hà Nội', '0100109106', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(24, '111-024', 'CTY CP THƯƠNG MẠI NGUYỄN KIM', '63-65 Trần Hưng Đạo, Q1, TP.HCM', '0302286281', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(25, '111-025', 'Anh Sơn', '', '', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(26, '111-026', 'Nguyễn Văn Trương', 'Đường số 7, P. Linh Trung, Q TĐ', '', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(27, '111-027', 'Cty TNHH Columbia ASIA(VN)', '', '', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(28, '111-028', 'Cty Điện Thoại Đông TP (CN Thủ Đức)', '125 Hai Bà Trưng, P. Bến Nghé, Q1', '0300954529028', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(29, '111-029', 'Công Ty Cổ Phần VON', '64-64 Bis Võ Thị Sáu, P. Tân Định, Q1', '0303284985', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(30, '111-030', 'Cửa Hàng Thanh An', '87b Thủ Khoa Huân, P8, Q.TB', '0303182302', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(31, '111-031', 'Cty CP Siêu Thanh', '254 Trần Hưng Đạo Q1', '0302563707', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(32, '111-032', ' Nguyễn Xuân Hùng (HTX-VT&DL Phương Nam)', '6/6 Trần Não, P. Bình An, Q2', '0301555277', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(33, '111-033', 'Anh Hoành', '', '', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(34, '111-034', 'CỤC QUẢN LÝ XUẤT NHẬP CẢNH', '', '0301464848', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(35, '111-035', 'Kho Bạc Nhà Nước Thủ Đức ( Điểm Giao Dịch Số 61)', '', '', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(36, '111-036', 'Cửa Hàng Vật Liệu Xây Dựng ĐỨC HUỲNH', '1133 Kha Vạn Cân-KP4 P.LT, Q. Thủ Đức', '', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(37, '111-037', 'Công Ty  TNHH TM Thế Giới Hộp Mực', 'Số 4 Trương Định P6, Q3', '0304258716', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(38, '111-038', 'CTY BẢO MINH CHỢ LỚN', '26 Tôn Thất Đạm, Q1, TPHCM', '0300446973055', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(39, '111-039', 'Cty TNHH Viễn Thông FPT Miền Nam', '68 Võ Văn Tầng, P.6 Q.3, TPHCM', '0305617774', '', '197 D2, Q. Bình Thạnh, TP. HCM', NULL, '0305617774002', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(40, '111-040', 'Sách Tài Chính - Chính Trị', '44/49 Đường Số 14, P11, Q. GV', '0305845234', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(41, '111-041', 'BHXH Quận Thủ Đức', '', '', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(42, '111-042', 'CÔNG TY TNHH SÀI GÒN TAXI', '82 Đường 45, P. tân Quy, Q7', '0303651755', '', '', NULL, '', '', '', '2010-03-29 11:53:18', '2010-03-29 11:53:18'),
(43, '111-043', 'CỬA HÀNG ĐIỆN-ĐTDĐ THANH XUÂN', '75 Lê Văn Việt, kp3, p. Hiệp Phú, Q9, TPHCM', '0301722217', '', '', NULL, '', '', '', '2010-03-29 11:53:19', '2010-03-29 11:53:19'),
(44, '111-044', 'CTY TNHH DV VẬN TẢI TÂN VĨNH THỊNH', '67 Lê Thị Hồng Gấm, Q1, TPHCM', '0301464414001', '', '', NULL, '', '', '', '2010-03-29 11:53:19', '2010-03-29 11:53:19'),
(45, '111-045', 'CÔNG TY CP HẢI NINH', '82B, QL13, P. Hiệp Bình Phước, TPHCM', '0303466872', '', '', NULL, '', '', '', '2010-03-29 11:53:19', '2010-03-29 11:53:19'),
(46, '111-046', 'CTY ĐIỆN LỰC THÀNH PHỐ HCM', 'Thủ Đức', '0300951119001', '', '', NULL, '', '', '', '2010-03-29 11:53:19', '2010-03-29 11:53:19'),
(47, '111-047', 'CTY CP CẤP NƯỚC THỦ ĐỨC', 'Thủ Đức', '0304803601', '', '', NULL, '', '', '', '2010-03-29 11:53:19', '2010-03-29 11:53:19'),
(48, '111-048', 'Chi Cục Hải Quan Cửa Khẩu cảng Sài Gòn KV1(Tân cảng)', '', '', '', '', NULL, '', '', '', '2010-03-29 11:53:19', '2010-03-29 11:53:19'),
(49, '111-049', 'CN TRUNG TÂM THẮNG HƯNG', 'Ấp 8 Xã Lương Hòa, H, Bến Lức, T. Long An', '0302788066001', '', 'fax:8535638', NULL, '', '', '', '2010-03-29 11:53:19', '2010-03-29 11:53:19'),
(50, '111-050', 'TỔNG CTY  BƯU CHÍNH VIỆT NAM (VNPT)', '', '0300954529', '', 'BÁO HƯ 38355555-119', NULL, '', '', '', '2010-03-29 11:53:19', '2010-03-29 11:53:19'),
(51, '111-051', 'Cửa Hàng Vải Thúy Loan', '327 Hai Bà Trưng, P8, Q3', '0302861929', '', '', NULL, '', '', '', '2010-03-29 11:53:19', '2010-03-29 11:53:19'),
(52, '111-052', 'CÔNG TY TNHH SX-TM&DV PHÚ BÌNH HƯƠNG', '13/9A Lê Văn Thọ, P12, Q.Gò Vấp, TPHCM', '0303675298', '', '', NULL, '', '', '', '2010-03-29 11:53:19', '2010-03-29 11:53:19'),
(53, '111-053', 'CÔNG TY CỔ PHẦN ÁNH DƯƠNG VN', '306 Điện Biên Phủ, P.22, QBT', '0302035520', '', '', NULL, '', '', '', '2010-03-29 11:53:19', '2010-03-29 11:53:19'),
(54, '111-054', 'CÔNG TY CỔ PHẦN NGÔI SAO TƯƠNG LAI', '01 Hoa Sứ, P7, Q. Phú Nhuận', '0304917581', '', '', NULL, '', '', '', '2010-03-29 11:53:19', '2010-03-29 11:53:19'),
(55, '111-055', 'Tổng Cục Thuế', '', '', '', '', NULL, '', '', '', '2010-03-29 11:53:19', '2010-03-29 11:53:19'),
(56, '111-056', 'CÔNG TY TNHH SCS (VIỆT NAM) - CHI NHÁNH TP. HCM', ' 115 Nguyễn Huệ, Q. 1, TP. HCM', '0101407070001', '', '', NULL, '', '', '', '2010-03-29 11:53:19', '2010-03-29 11:53:19'),
(57, '111-057', 'CTY TNHH DRAGON LOGISTICS-ĐỒNG NAI', '101/1 KCN Amata, Biên Hòa, Đồng Nai', '0100112691003', '', '', NULL, '', '', '', '2010-03-29 11:53:19', '2010-03-29 11:53:19'),
(58, '111-058', 'Anh Quả', '', '', '', '', NULL, '', '', '', '2010-03-29 11:53:19', '2010-03-29 11:53:19'),
(59, '111-059', 'HTX VẬN TẢI SỐ 3 GÒ VẤP', '372 Nguyễn Thái Sơn, P5, Q. GV', '0301450549', '', '', NULL, '', '', '', '2010-03-29 11:53:19', '2010-03-29 11:53:19'),
(60, '111-060', 'Ngân Hàng Vietcombank', 'Thủ Đức', '', '', '', NULL, '', '', '', '2010-03-29 11:53:19', '2010-03-29 11:53:19'),
(61, '111-061', 'Thương Xá Tax', '135 Nguyễ Huệ, Q1, TPHCM', '0300100037003', '', '083 8213849', NULL, '083 8299973', '', '', '2010-03-29 11:53:19', '2010-03-29 11:53:19'),
(62, '111-062', 'Cửa Hàng Trinh', '109-111A Tôn Thất Đạm, Q1, TPHCM', '', '', '8214466/ 0913608220/ nr: 9905397', NULL, '', '', '', '2010-03-29 11:53:19', '2010-03-29 11:53:19'),
(63, '111-063', 'CÔNG TY BẢO HIỂM LIÊN HIỆP', '803, Lầu 8, Sun Wah, 115 Nguyễn Huệ, Q1, TPHCM', '0100112571001001', '', '', NULL, '', '', '', '2010-03-29 11:53:19', '2010-03-29 11:53:19'),
(64, '111-064', 'CÔNG TY TNHH SX TM TTNT ĐÔNG GIA', '53 Ngô Gia Tự, Q10, TPHCM', '0302566377', '', '38354134(chị Mai KT)', NULL, '38396726', '', '', '2010-03-29 11:53:19', '2010-03-29 11:53:19'),
(65, '111-065', 'CÔNG TY CP DU LỊCH TĨNH BÀ RỊA VŨNG TÀU', '207 Võ Thị Sáu-Phường Thắng Tam-TP Vũng Tàu', '3500101812001', '', '', NULL, '', '', '', '2010-03-29 11:53:19', '2010-03-29 11:53:19'),
(66, '111-066', 'CÔNG TY DỊCH VỤ LỮ HÀNH SÀI GÒN TOURIST', '49 Lê Thánh Tôn, Q1, TP HCM', '0300625210025001', '', '8244820/8(8298914)', NULL, '', '', '', '2010-03-29 11:53:19', '2010-03-29 11:53:19'),
(67, '111-067', 'CTY TNHH TM DƯỢC PHẨM LAN KHUÊ', '520-522-524-526 CMT8,P11, Q3', '0302971015', '', '', NULL, '', '', '', '2010-03-29 11:53:19', '2010-03-29 11:53:19'),
(68, '111-068', 'CÔNG TY CP TÌM KIẾM NHÂN TÀI VINA', '365 Lê Quang Định, P5, Q. Bình Thạnh', '0303452460', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(69, '111-069', 'CHI NHÁNH 2-CÔNG TY CP BVMT QUỐC TẾ ICARE', '240 Võ Văn Ngân, P. Bình Thọ, Q. Thủ Đức', '0303897195005', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(70, '111-070', 'Công ty tnhh tm-dv Hàm Rồng', '475 Lạc Long Quân , P5, Q11', '0302863651', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(71, '111-071', 'Công ty tnhh bảo hiểm PNT MSIG VN', 'tầng 6 sài gòn centre, số 65 Lê Lợi, p Bến Nghé, Q1', '0102973336-001', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(72, '111-072', 'Công ty VTM Việt Nam ', 'Lầu 6 phòng 6, tòa nhà Etown 2,364 Cộng hòa, p13, Q. TB', '0304239135', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(73, '111-073', 'Công ty tnhh dv&tm Đông Á ', '5/6 Nguyễn Siêu, Q1 TPHCM', '0302441963', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(74, '111-074', 'Công ty tnhh mtv xd-tm dv-qc Vương Đại Dương ', '23.26 Bình Dương 1 X. An bình H. Dĩ An Bình Dương', '3701349179', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(75, '111-075', 'Công ty tnhh Hoàng Trường Sa ', '82 Nguyễn Bá Tuyển, P12 Q. Tân bình', '0308077950', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(76, '111-076', 'Công ty xăng dầu khu vực II ', '15 Lê Duẩn Q1, TP HCM', '0300555450-001', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(77, '111-077', 'Công ty tnhh giấy Vi Tính Liên Sơn ', '34 Nguyễn Bỉnh Khiêm Q1 TPHCM', '0301452923', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(78, '111-078', 'Công ty tnhh Bí Bo ', '77G - 77H Bùi Thị Xuân, P. PNL - Q1', '0302906802', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(79, '111-079', 'Công ty tnhh tmdv Quốc tế BigC Dong Nai', 'KP1-Long Bình Tân, TP Biên Hòa Tỉnh Đồng Nai', '3600258976', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(80, '111-080', 'Công ty CP Khóa Việt Tiệp ', '20 Đường số 7, P11, Q6, TPHCM', '0100100537-002', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(81, '111-081', 'Công ty tnhh mtv Giải Pháp Trí Tuệ ', '9 Hoa huệ p.7 - Q. Phú Nhuận', '0309174805', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(82, '111-082', 'Công ty tnhh Acer Việt Nam ', 'Tòa nhà Petro Việt Nam số 1-5 Lê Duẫn, Q.1 TP.HCM', '0301883398', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(83, '111-083', 'CH TẠP HÓA VŨ THỊ THANH HẰNG', 'Chợ thủ đức A _ P. Linh Tây', '0301611901', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(84, '111-084', 'Ngân Hàng Công Thương Việt Nam', 'Chi nhánh Thủ Đức', '0100111948-110', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(85, '111-085', 'HTX  Vận Tải & Du Lịch Phước Lộc ', '616 cộng Hòa -F13- TB', '03002802384', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(86, '111-086', 'Công ty tnhh MTV QC IN ẤN Hồng Anh', '39 Bis Đặng Dung, P.Tân Định, Q1', '0309277550', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(87, '111-087', 'Co.opMart Nguyễn Kiệm', '571-573 Nguyễn Kiệm Q.Phú Nhuận', '0305778394', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(88, '111-088', 'CÔNG TY TNHH SX-TM KHANG THỊNH', '171 Hậu Giang, P5, Q6, tp HCM', '0304924980', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(89, '111-089', 'Công ty tnhh Máy Tính Xách tay Bảo Huy', '806 Trần Hưng Đạo P7-Q5', '0305247315', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(90, '111-090', 'Công ty tnhh dịch thuật chuyên nghiệp CNN ', 'số 470 nguyễn trãi  Thanh Xuân Trung_ Thanh Xuân_HN', '0101759107', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(91, '111-091', 'CÔNG TY CP TÌM KIẾM NHÂN TÀI VINA', '', '', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(92, '111-092', 'Công ty tnhh tk-tm Minh Trí Dũng ', '136/20 Lê Thánh Tôn _ P. Bến Thành. Q1', '0303266048', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(93, '111-093', 'Công ty tnhh Cetus Việt nam', '', '', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(94, '111-094', 'Công ty tnhh Sài Gòn Co.op Xa lộ Hà Nội', '', '', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(95, '111-095', 'Công ty tnhh tv-tm-dv Kỳ Long', '31 Bế Văn Đàn - P14 - Q. Tân Bình', '', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(96, '111-096', 'Cửa hàng Dũng ', 'Dĩ An Bình Dương', '3700840761', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(97, '111-097', 'CH TẠP HÓA VŨ THỊ THANH HẰNG', '', '', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(98, '112-001', 'Ngân hàng MIZUHO', '115 Nguyễn Huệ, Q1, TPHCM', '0304413344', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(99, '112-002', 'The Bank of Tokyo-Mitsubishi UFJ', '5B Tôn Đức Thắng, Q1, TPHCM', '0301224067', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(100, '112-003', 'Ngân hàng Sumitomo', '5B Tôn Đức Thắng, Q1, TPHCM', '0304198827', '', '', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(101, '112-004', 'Ngân Hàng VietCombank', 'PGD Bình Thọ - CN Thủ Đức', '0100112437-062', '', '37225602(hà), 37225601 (diệp)', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(102, '331-01', ' CÔNG TY TNHH-TM-BÌNH HƯƠNG', '51 Pasteur Q.1', '0305790722', '39141525', '(Ms. Trinh) / 0907979933 Hương', NULL, '37240512', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(103, '331-02', ' CÔNG TY CHẤN LONG', 'Số 2, Đường 36, P10, Q6', '0302718245', '', '38768195 Quyên', NULL, '', '', '', '2010-03-29 11:53:20', '2010-03-29 11:53:20'),
(104, '331-03', ' CO.OP MAX', '191 Quang Trung, Phường Hiệp Phú, Q9, TPHCM', '0305767459', '', '7307233-7307234', NULL, '', '', '', '2010-03-29 11:53:21', '2010-03-29 11:53:21'),
(105, '331-04', ' CỬA HÀNG SỐ 42', '42 Huỳnh Thúc Kháng, Phường Bến Nghé, Q1', '0302723904', '', '#VALUE!', NULL, '', '', '', '2010-03-29 11:53:21', '2010-03-29 11:53:21'),
(106, '331-05', ' CÔNG TY TNHH SX-TM-DV-XNK ĐẠI DƯƠNG', '92 Hồ Ngọc Lãm, An Lạc, Bình Tân', '0302787947', '', '08. 9801642', NULL, '', 'Chị Ngọc Anh', '', '2010-03-29 11:53:21', '2010-03-29 11:53:21'),
(107, '331-06', ' CÔNG TY CỔ PHẦN SX-TM ĐÀO TIÊN', 'Lô 2, Đường E, KCN Tân Tạo, Q.Tân Bình', '0302567645', '', '083 7552060', NULL, '', 'chị Hiền', '', '2010-03-29 11:53:21', '2010-03-29 11:53:21'),
(108, '331-07', 'CÔNG TY CỔ PHẦN ĐIỆN MÁY TPHCM', '29 Tôn Đức Thắng, Q1, HCM', '0300646919', 'Điện quang', '0650. 790132', NULL, '', '0909041946/ 0903041946', '', '2010-03-29 11:53:21', '2010-03-29 11:53:21'),
(109, '331-08', ' CÔNG TY CỔ PHẦN DIỆU THƯƠNG', ' ấp Long Đức 1, Xã Tam Phước, Huyện Long Thành, Tỉnh Đồng Nai. ', '3600257203', '', ' 0613. 511035 - 08-8582832', NULL, '', 'Chị Ngọc Anh', '', '2010-03-29 11:53:21', '2010-03-29 11:53:21'),
(110, '331-09', ' C.TY TNHH-SX-TM DƯƠNG THÀNH', ' 22/10 Lê Lăng, P. Phú Thọ Hòa, Q. Tân Phú', '0302778406', '', '8610458', NULL, '0918061023(anh Nam sale)', 'c. thắm/ c. trinh', '', '2010-03-29 11:53:21', '2010-03-29 11:53:21'),
(111, '331-10', ' CÔNG TY CP GIẤY TÂN MAI', ' Phường Thống Nhất, Biên Hòa, Đồng Nai', '3600260196', '', ' 0613. 822257', NULL, 'anh Đức, chị Hạnh PKD bấm nội bộ 336', '', 'chị Hoa cửa hàng Tân Mai (0902288103)', '2010-03-29 11:53:21', '2010-03-29 11:53:21'),
(112, '331-11', ' CÔNG TY TNHH TM CN GIẤY VĨNH THỊNH', '346 Bến Vân Đồn, P1,Q4', '0301445450-001', '', '54012999/                      0909276698 (A. UT)', NULL, '39432603', 'chị Phượng, chị Ly, Dung, Mr. Tuấn kt', '', '2010-03-29 11:53:21', '2010-03-29 11:53:21'),
(113, '331-12', 'CÔNG TY TNHH SX TM GIMIKO', ' 57 Trần Quốc Thảo,P7,Q3', '0301692805', '', '', NULL, '', '', '', '2010-03-29 11:53:21', '2010-03-29 11:53:21'),
(114, '331-13', 'CÔNG TY TNHH SX HẠ PHONG', ' Lô 114, Đường B1-KDC Tân Thới Hiệp-Q12', '0301903492', '', '5370961', NULL, '', '', '', '2010-03-29 11:53:21', '2010-03-29 11:53:21'),
(115, '331-14', 'CÔNG TY TNHH HẢO VỌNG', ' 86 Hàm Nghi, Q1', '0303374389', '', '38212270/38370044', NULL, 'chị Vân', '', '', '2010-03-29 11:53:21', '2010-03-29 11:53:21'),
(116, '331-15', 'CÔNG TY TNHH HOÀNG LINH XANH', ' 251 Hồng Lạc, P10, Q. Tân Bình', '0302884676', '', '38428585', NULL, 'chị Hồng kế toán/c. Ngân', '', '', '2010-03-29 11:53:21', '2010-03-29 11:53:21'),
(117, '331-16', ' CÔNG TY TNHH SX TM HOÀNG QUAN', '2967 Phạm Thế Hiển, P7, Q8', '0302422287', '', '2609537/ 0983760227(a NHẬT), 39800008 Chi Hương)', NULL, '', '', '', '2010-03-29 11:53:21', '2010-03-29 11:53:21'),
(118, '331-17', ' CÔNG TY TNHH TB HOÀNG THANH', '69/30 Đào Huy Tư, P17, Q. Phú Nhuận', '0302983162', '', '3.7290305', NULL, 'chị Nhung kt', '', '', '2010-03-29 11:53:21', '2010-03-29 11:53:21'),
(119, '331-18', ' DNTN NHỰA HỒNG PHÁT', '58-60-62, Đường số 8, Khu Bình Phú, P11,Q6', '0303833843', '', '083.8571556/ 8536161/ 4060108', NULL, '', '', '', '2010-03-29 11:53:21', '2010-03-29 11:53:21'),
(120, '331-19', ' CỬA HÀNG HUÂN TRINH', ' 10/29C Tân Lập, Tổ 2, KP3, P Hiệp Phú, Q9', '0302767531', '', '', NULL, '', '', '', '2010-03-29 11:53:21', '2010-03-29 11:53:21'),
(121, '331-20', 'CÔNG TY TNHH HƯNG THỊNH', ' 49 Hồ Văn Tư, Q Thủ Đức', '0301289995', '', '', NULL, '', '', '', '2010-03-29 11:53:21', '2010-03-29 11:53:21'),
(122, '331-21', 'CÔNG TY TNHH KEN DO', '211 Nam Kỳ Khởi Nghĩa,P7, Q3', '0303728398', '', '', NULL, '', '', '', '2010-03-29 11:53:21', '2010-03-29 11:53:21'),
(123, '331-22', 'CÔNG TY TNHH SX-TM KIM HOÀN VŨ', ' H31 Bis K300-Cộng Hòa-P12-Q. Tân Bình', '0301424549-001', '', '38110702 /    23 CHI BÌNH', NULL, '', '', '', '2010-03-29 11:53:21', '2010-03-29 11:53:21'),
(124, '331-23', 'CÔNG TY TNHH MAI HUY', '180 Trần Phú, Phú Hà, Phan Rang, Ninh Thuận', '4500240328', '', '0918446632( A Danh)', NULL, '', '', '', '2010-03-29 11:53:21', '2010-03-29 11:53:21'),
(125, '331-24', 'CÔNG TY TNHH TM MẪN ĐẠT', ' 98F Lê Lai, P Bến Thành, Q1', '0302225296', '', '3-9253861/3', NULL, '', 'Tiên Tiến (3.8535366) chị Thắm/ fax: 3.9507126', '', '2010-03-29 11:53:21', '2010-03-29 11:53:21'),
(126, '331-25', 'Công ty tnhh Metro Cash & Carry Việt Nam', 'An Phú-An Khánh, Q2, TPHCM', '0302249586', '', '87406677', NULL, '', '', '', '2010-03-29 11:53:21', '2010-03-29 11:53:21'),
(127, '331-26', 'CÔNG TY TNHH NAM NHẬT TIÊN', '69 Nguyễn Cữu Vân, P17, QTB', '0301895227', '', '8404487', NULL, '', '', '', '2010-03-29 11:53:21', '2010-03-29 11:53:21');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admin_acl_role_parent`
--
ALTER TABLE `admin_acl_role_parent`
  ADD CONSTRAINT `fk_role_id` FOREIGN KEY (`role_id`) REFERENCES `admin_acl_role` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_role_parent_id` FOREIGN KEY (`role_parent_id`) REFERENCES `admin_acl_role` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `admin_acl_rule`
--
ALTER TABLE `admin_acl_rule`
  ADD CONSTRAINT `fk_acl_role_id` FOREIGN KEY (`role_id`) REFERENCES `admin_acl_role` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `core_acl_resource`
--
ALTER TABLE `core_acl_resource`
  ADD CONSTRAINT `fk_resource_module_id` FOREIGN KEY (`module_id`) REFERENCES `core_module` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `core_acl_role_parent`
--
ALTER TABLE `core_acl_role_parent`
  ADD CONSTRAINT `fk_core_acl_role_id` FOREIGN KEY (`role_id`) REFERENCES `core_acl_role` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_core_acl_role_parent_id` FOREIGN KEY (`role_parent_id`) REFERENCES `core_acl_role` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `core_acl_rule`
--
ALTER TABLE `core_acl_rule`
  ADD CONSTRAINT `fk_core_acl_resource_id` FOREIGN KEY (`resource_id`) REFERENCES `core_acl_resource` (`resource_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_core_acl_rule_id` FOREIGN KEY (`role_id`) REFERENCES `core_acl_role` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `core_config_value`
--
ALTER TABLE `core_config_value`
  ADD CONSTRAINT `FK_config_field_id` FOREIGN KEY (`config_field_id`) REFERENCES `core_config_field` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `core_module_language`
--
ALTER TABLE `core_module_language`
  ADD CONSTRAINT `fk_language_id` FOREIGN KEY (`language_id`) REFERENCES `core_language` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_module_id` FOREIGN KEY (`module_id`) REFERENCES `core_module` (`id`) ON DELETE CASCADE;
