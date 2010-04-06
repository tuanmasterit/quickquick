-- phpMyAdmin SQL Dump
-- version 3.2.0.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Apr 06, 2010 at 09:31 AM
-- Server version: 5.1.37
-- PHP Version: 5.3.0

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=21 ;

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
(14, 3, 'catalog/main/catalogRoute', 'Catalog router', 'string', '', '', NULL, 'Catalog url (example.com/<b>catalogRoute</b>/product)'),
(15, 3, 'design/main/frontTemplateId', 'Front Template', 'select', 'Template', '', NULL, ''),
(16, 3, 'design/main/adminTemplateId', 'Admin Template', 'select', 'Template', '', NULL, ''),
(17, 3, 'design/htmlHead/titlePattern', 'Title Pattern', 'multiple', '', '', 'Page Title,Parent Page Titles,Site Name', 'Check values, which you want to see on page title'),
(18, 1, 'translation', 'Translation', 'string', '', '', NULL, ''),
(19, 2, 'translation/main', 'Main', 'string', '', '', NULL, ''),
(20, 3, 'translation/main/autodetect', 'Autodetect new words', 'bool', '', '', NULL, 'Autodetect new words (run if set TRUE: >chmod -R 0777 [root_path]/app/locale)');

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=17 ;

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
(10, 12, 'main/store/locale', 0, 'en_US'),
(11, 13, 'main/store/timezone', 0, 'Australia/Darwin'),
(12, 14, 'catalog/main/catalogRoute', 0, 'store'),
(13, 15, 'design/main/frontTemplateId', 0, '1'),
(14, 16, 'design/main/adminTemplateId', 0, '1'),
(15, 17, 'design/htmlHead/titlePattern', 0, 'Page Title,Site Name'),
(16, 20, 'translation/main/autodetect', 0, '0');

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
(2, 'Quick_Locale', 'Quick_Locale', 'Locale', '0.1', 1),
(3, 'Quick_Account', 'Quick_Account', 'Account', '0.1', 1),
(4, 'Quick_Admin', 'Quick_Admin', 'Backend', '0.1', 1),
(5, 'Quick_Catalog', 'Quick_Catalog', 'Catalog', '0.1', 1);

-- --------------------------------------------------------

--
-- Table structure for table `core_page`
--

CREATE TABLE IF NOT EXISTS `core_page` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `module_name` varchar(64) NOT NULL,
  `controller_name` varchar(64) NOT NULL,
  `action_name` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `i_page_1` (`module_name`,`controller_name`,`action_name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=22 ;

--
-- Dumping data for table `core_page`
--

INSERT INTO `core_page` (`id`, `module_name`, `controller_name`, `action_name`) VALUES
(1, '*', '*', '*'),
(3, 'account', '*', '*'),
(9, 'account', 'address-book', '*'),
(4, 'account', 'auth', '*'),
(5, 'account', 'forgot', '*'),
(6, 'account', 'info', '*'),
(7, 'account', 'tag', '*'),
(8, 'account', 'wishlist', '*'),
(10, 'catalog', '*', '*'),
(11, 'catalog', 'index', '*'),
(12, 'catalog', 'index', 'product'),
(13, 'catalog', 'index', 'view'),
(14, 'catalog', 'product-compare', '*'),
(15, 'catalog', 'product-compare', 'index'),
(16, 'checkout', '*', '*'),
(17, 'checkout', 'cart', '*'),
(18, 'checkout', 'cart', 'index'),
(21, 'checkout', 'index', 'success'),
(19, 'checkout', 'onepage', '*'),
(20, 'checkout', 'wizard', '*'),
(2, 'core', 'index', 'index');

-- --------------------------------------------------------

--
-- Table structure for table `core_site`
--

CREATE TABLE IF NOT EXISTS `core_site` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `base` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `secure` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `i_base_url` (`base`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=2 ;

--
-- Dumping data for table `core_site`
--

INSERT INTO `core_site` (`id`, `base`, `name`, `secure`) VALUES
(1, 'http://localhost/quick', 'Main ERP', 'http://localhost/quick');

-- --------------------------------------------------------

--
-- Table structure for table `core_template`
--

CREATE TABLE IF NOT EXISTS `core_template` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `default_layout` varchar(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `core_template`
--

INSERT INTO `core_template` (`id`, `name`, `is_active`, `default_layout`) VALUES
(1, 'default', 1, '_3rows');

-- --------------------------------------------------------

--
-- Table structure for table `core_template_layout_page`
--

CREATE TABLE IF NOT EXISTS `core_template_layout_page` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `template_id` mediumint(8) unsigned NOT NULL,
  `page_id` mediumint(8) unsigned NOT NULL,
  `layout` varchar(64) NOT NULL,
  `priority` smallint(5) unsigned NOT NULL DEFAULT '100',
  PRIMARY KEY (`id`),
  KEY `FK_template_layout_to_page_template_id` (`template_id`),
  KEY `FK_template_layout_to_page_page_id` (`page_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `core_template_layout_page`
--


-- --------------------------------------------------------

--
-- Table structure for table `locale_language`
--

CREATE TABLE IF NOT EXISTS `locale_language` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(3) NOT NULL,
  `language` varchar(128) NOT NULL,
  `locale` varchar(5) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Index_code` (`code`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=5 ;

--
-- Dumping data for table `locale_language`
--

INSERT INTO `locale_language` (`id`, `code`, `language`, `locale`) VALUES
(1, 'en', 'English', 'en_US'),
(2, 'en', 'English', 'en_US'),
(3, 'en', 'English', 'en_US'),
(4, 'en', 'English', 'en_US');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `core_config_value`
--
ALTER TABLE `core_config_value`
  ADD CONSTRAINT `FK_config_field_id` FOREIGN KEY (`config_field_id`) REFERENCES `core_config_field` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `core_template_layout_page`
--
ALTER TABLE `core_template_layout_page`
  ADD CONSTRAINT `FK_template_layout_to_page_page_id` FOREIGN KEY (`page_id`) REFERENCES `core_page` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_template_layout_to_page_template_id` FOREIGN KEY (`template_id`) REFERENCES `core_template` (`id`) ON DELETE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
