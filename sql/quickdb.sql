-- phpMyAdmin SQL Dump
-- version 3.1.3.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Apr 13, 2010 at 06:24 PM
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

INSERT INTO `admin_acl_role_parent` (`role_id`, `role_parent_id`) VALUES
(6, 3),
(7, 3);

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=23 ;

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
(22, 3, 'auth/main/authRoute', 'Sale router', 'string', '', '', NULL, '');

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=19 ;

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
(18, 22, 'auth/main/authRoute', 0, 'auth');

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `core_module`
--

INSERT INTO `core_module` (`id`, `package`, `code`, `name`, `version`, `is_active`) VALUES
(1, 'Quick_Core', 'Quick_Core', 'Core', '0.1', 1),
(2, 'Quick_Locale', 'Quick_Locale', 'Locale', '0.1', 0),
(3, 'Quick_General', 'Quick_General', 'General', '0.1', 1),
(4, 'Quick_Admin', 'Quick_Admin', 'Backend', '0.1', 0),
(5, 'Quick_Sale', 'Quick_Sale', 'Sale', '0.1', 1);

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
(1, 2, 'Home', 'Trang Chủ');

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
