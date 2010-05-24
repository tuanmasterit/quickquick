-- phpMyAdmin SQL Dump
-- version 3.2.0.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: May 23, 2010 at 08:19 AM
-- Server version: 5.1.37
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
-- Table structure for table `accountant_detail_correspondence`
--

CREATE TABLE IF NOT EXISTS `accountant_detail_correspondence` (
  `correspondence_id` bigint(30) unsigned NOT NULL,
  `table_id` bigint(30) unsigned NOT NULL,
  `detail_id` bigint(30) unsigned NOT NULL,
  PRIMARY KEY (`correspondence_id`,`table_id`),
  KEY `fk_detail_correspondence_table` (`table_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `accountant_detail_correspondence`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_detail_entry`
--

CREATE TABLE IF NOT EXISTS `accountant_detail_entry` (
  `entry_id` bigint(30) unsigned NOT NULL,
  `table_id` bigint(30) unsigned NOT NULL,
  `detail_id` bigint(30) unsigned NOT NULL,
  PRIMARY KEY (`entry_id`,`table_id`),
  KEY `fk_detail_entry_table` (`table_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `accountant_detail_entry`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_detail_purchase`
--

CREATE TABLE IF NOT EXISTS `accountant_detail_purchase` (
  `purchase_invoice_id` bigint(30) unsigned NOT NULL,
  `product_id` bigint(30) unsigned NOT NULL,
  `unit_id` decimal(30,0) unsigned NOT NULL,
  `quantity` decimal(18,4) NOT NULL,
  `converted_quantity` decimal(18,4) NOT NULL,
  `price` decimal(18,4) NOT NULL,
  `amount` decimal(18,4) NOT NULL,
  `converted_amount` decimal(18,4) NOT NULL,
  `import_rate_id` bigint(30) unsigned NOT NULL,
  `import_rate` tinyint(2) unsigned NOT NULL,
  `import_amount` decimal(18,4) NOT NULL,
  `vat_rate_id` bigint(30) unsigned NOT NULL,
  `vat_rate` tinyint(2) unsigned NOT NULL,
  `vat_amount` decimal(18,4) NOT NULL,
  `excise_rate_id` bigint(30) unsigned NOT NULL,
  `excise_rate` tinyint(2) unsigned NOT NULL,
  `excise_amount` decimal(18,4) NOT NULL,
  `total_amount` decimal(18,4) NOT NULL,
  `note` varchar(100) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`purchase_invoice_id`,`product_id`,`unit_id`),
  KEY `fk_detail_purchase_product` (`product_id`),
  KEY `fk_detail_purchase_import_rate` (`import_rate_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `accountant_detail_purchase`
--

INSERT INTO `accountant_detail_purchase` (`purchase_invoice_id`, `product_id`, `unit_id`, `quantity`, `converted_quantity`, `price`, `amount`, `converted_amount`, `import_rate_id`, `import_rate`, `import_amount`, `vat_rate_id`, `vat_rate`, `vat_amount`, `excise_rate_id`, `excise_rate`, `excise_amount`, `total_amount`, `note`) VALUES
(1, 1, '1', '5.0000', '5.0000', '1000.0000', '5000.1200', '5000.0000', 1, 10, '500.0000', 3, 5, '288.7500', 2, 5, '275.0000', '6063.7500', 'note'),
(1, 2, '2', '2.0000', '4.0000', '25000000.0000', '100000000.5700', '100000000.0000', 1, 10, '10000000.0000', 3, 5, '5775000.0000', 2, 5, '5500000.0000', '121275000.0000', 'note');

-- --------------------------------------------------------

--
-- Table structure for table `accountant_entry_credit`
--

CREATE TABLE IF NOT EXISTS `accountant_entry_credit` (
  `entry_type_id` bigint(30) unsigned NOT NULL,
  `account_id` bigint(30) unsigned NOT NULL,
  `default` tinyint(1) unsigned NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`entry_type_id`,`account_id`),
  KEY `fk_entry_credit_created_user` (`created_by_userid`),
  KEY `fk_entry_credit_modified_user` (`last_modified_by_userid`),
  KEY `fk_entry_credit_account` (`account_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `accountant_entry_credit`
--

INSERT INTO `accountant_entry_credit` (`entry_type_id`, `account_id`, `default`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, 89, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(1, 93, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(1, 94, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(1, 95, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(2, 93, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `accountant_entry_debit`
--

CREATE TABLE IF NOT EXISTS `accountant_entry_debit` (
  `entry_type_id` bigint(30) unsigned NOT NULL,
  `account_id` bigint(30) unsigned NOT NULL,
  `default` tinyint(1) unsigned NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`entry_type_id`,`account_id`),
  KEY `fk_entry_debit_created_user` (`created_by_userid`),
  KEY `fk_entry_debit_modified_user` (`last_modified_by_userid`),
  KEY `fk_entry_debit_account` (`account_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `accountant_entry_debit`
--

INSERT INTO `accountant_entry_debit` (`entry_type_id`, `account_id`, `default`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, 35, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(1, 40, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(1, 50, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(2, 22, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(2, 23, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `accountant_entry_type`
--

CREATE TABLE IF NOT EXISTS `accountant_entry_type` (
  `entry_type_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `entry_type_name` varchar(300) NOT NULL,
  PRIMARY KEY (`entry_type_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `accountant_entry_type`
--

INSERT INTO `accountant_entry_type` (`entry_type_id`, `entry_type_name`) VALUES
(1, 'Mua hàng nhập khẩu'),
(2, 'Thuế GTGT hàng nhập khẩu tính theo phương pháp khấu trừ thuế');

-- --------------------------------------------------------

--
-- Table structure for table `accountant_list_expense`
--

CREATE TABLE IF NOT EXISTS `accountant_list_expense` (
  `expense_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `expense_name` varchar(100) NOT NULL,
  `for_buying` tinyint(1) unsigned NOT NULL,
  `for_material` tinyint(1) unsigned NOT NULL,
  `for_wage` tinyint(1) unsigned NOT NULL,
  `for_construction_equipment` tinyint(1) unsigned NOT NULL,
  `for_tool` tinyint(1) unsigned NOT NULL,
  `for_depreciation` tinyint(1) unsigned NOT NULL,
  `for_services` tinyint(1) unsigned NOT NULL,
  `for_rest` tinyint(1) unsigned NOT NULL,
  `for_production` tinyint(1) unsigned NOT NULL,
  `for_sales` tinyint(1) unsigned NOT NULL,
  `for_guarantee` tinyint(1) unsigned NOT NULL,
  `for_management` tinyint(1) unsigned NOT NULL,
  `for_fee` tinyint(1) unsigned NOT NULL,
  `for_reserve` tinyint(1) unsigned NOT NULL,
  `production_cost` tinyint(1) unsigned NOT NULL,
  `sales_cost` tinyint(1) unsigned NOT NULL,
  `finance_cost` tinyint(1) unsigned NOT NULL,
  `inactive` tinyint(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`expense_id`),
  KEY `fk_expense_created_user` (`created_by_userid`),
  KEY `fk_expense_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=42 ;

--
-- Dumping data for table `accountant_list_expense`
--

INSERT INTO `accountant_list_expense` (`expense_id`, `expense_name`, `for_buying`, `for_material`, `for_wage`, `for_construction_equipment`, `for_tool`, `for_depreciation`, `for_services`, `for_rest`, `for_production`, `for_sales`, `for_guarantee`, `for_management`, `for_fee`, `for_reserve`, `production_cost`, `sales_cost`, `finance_cost`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, '', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(1, 'Thuế, phí và lệ phí', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(2, 'Lương nhân viên', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(3, 'Bảo hiểm xã hội', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 'Bảo hiểm y tế', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 'Bảo hiểm thất nghiệp', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(6, 'Nước uống', 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(7, 'Nước sinh hoạt', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(8, 'Điện', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(9, 'Thuê nhà', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(10, 'Thuê kho', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(11, 'Khấu hao tài sản cố định', 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(12, 'Khấu hao tài sản vô hình', 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(13, 'Phân bổ công cụ dụng cụ', 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(14, 'Phí chuyển tiền ngân hàng', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(15, 'Phí rút sec', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(16, 'Phí quản lý tài khoản', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(17, 'Phí chuyển lương', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(18, 'Lãi vay', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(19, 'Chênh lệch tỷ giá', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(20, 'Mực in', 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(21, 'Mực fax', 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(22, 'Mực máy photocopy', 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(23, 'Giấy in', 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(24, 'Văn phòng phẩm', 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(25, 'Hàng mẫu', 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(26, 'Điện thoại bàn', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(27, 'Điện thoại di động', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(28, 'Internet', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(29, 'Fax', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(30, 'Chuyển phát nhanh', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(31, 'Thuê xe', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(32, 'Thuê xe vượt định mức', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(33, 'Phí cầu đường', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(34, 'Phí đậu xe', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(35, 'Tiền xe nhân viên', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(36, 'Xăng chạy máy phát điện', 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(37, 'Bảo vệ', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(38, 'Thuê thiết bị bảo vệ', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(39, 'Bảo trì máy tính', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(40, 'Bảo trì máy lạnh', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(41, 'Catolog', 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `accountant_list_specification`
--

CREATE TABLE IF NOT EXISTS `accountant_list_specification` (
  `specification_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `specification_name` varchar(300) NOT NULL,
  `inactive` tinyint(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`specification_id`),
  KEY `fk_specification_created_user` (`created_by_userid`),
  KEY `fk_specification_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `accountant_list_specification`
--

INSERT INTO `accountant_list_specification` (`specification_id`, `specification_name`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, 'Hàng hóa nhập khẩu phục vụ trực tiếp cho an ninh, quốc phòng, nghiên cứu khoa học và giáo dục đào tạo.', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(2, 'Máy móc, thiết bị, dụng cụ nghề nghiệp tạm nhập, tái xuất hoặc tạm xuất, tái nhập để phục vụ công việc như hội nghị, hội thảo, nghiên cứu khoa học, thi đấu thể thao, biểu diễn văn hóa, biểu diễn nghệ thuật, khám chữa bệnh...', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(3, 'Hàng hóa nhập khẩu, xuất khẩu làm mẫu phục vụ cho gia công.', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 'Hàng hoá tạm nhập, tái xuất hoặc tạm xuất, tái nhập để tham dự hội chợ, triển lãm, giới thiệu sản phẩm.', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 'Máy móc, thiết bị nhập khẩu hoặc xuất khẩu để trực tiếp phục vụ gia công được thoả thuận trong hợp đồng gia công.', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `accountant_list_tax`
--

CREATE TABLE IF NOT EXISTS `accountant_list_tax` (
  `tax_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `tax_name` varchar(100) NOT NULL,
  PRIMARY KEY (`tax_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=12 ;

--
-- Dumping data for table `accountant_list_tax`
--

INSERT INTO `accountant_list_tax` (`tax_id`, `tax_name`) VALUES
(1, 'Thuế giá trị gia tăng'),
(2, 'Thuế tiêu thụ đặc biệt'),
(3, 'Thuế xuất khẩu'),
(4, 'Thuế nhập khẩu'),
(5, 'Thuế thu nhập doanh nghiệp'),
(6, 'Thuế thu nhập cá nhân'),
(7, 'Thuế tài nguyên'),
(8, 'Thuế nhà đất'),
(9, 'Tiền thuê đất'),
(10, 'Các loại thuế khác'),
(11, 'Phí, lệ phí và các khoản phải nộp khác');

-- --------------------------------------------------------

--
-- Table structure for table `accountant_list_turnover`
--

CREATE TABLE IF NOT EXISTS `accountant_list_turnover` (
  `turnover_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `turnover_name` varchar(100) NOT NULL,
  `is_normal` tinyint(1) unsigned NOT NULL,
  `is_internal` tinyint(1) unsigned NOT NULL,
  `is_financial` tinyint(1) unsigned NOT NULL,
  `is_discounted` tinyint(1) unsigned NOT NULL,
  `is_returned` tinyint(1) unsigned NOT NULL,
  `is_devalued` tinyint(1) unsigned NOT NULL,
  `from_goods` tinyint(1) unsigned NOT NULL,
  `from_products` tinyint(1) unsigned NOT NULL,
  `from_services` tinyint(1) unsigned NOT NULL,
  `from_subsidy` tinyint(1) unsigned NOT NULL,
  `from_real_estate` tinyint(1) unsigned NOT NULL,
  `from_rest` tinyint(1) unsigned NOT NULL,
  `inactive` tinyint(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`turnover_id`),
  KEY `fk_turnover_created_user` (`created_by_userid`),
  KEY `fk_turnover_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `accountant_list_turnover`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_purchase_invoice`
--

CREATE TABLE IF NOT EXISTS `accountant_purchase_invoice` (
  `purchase_invoice_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `voucher_id` bigint(30) unsigned NOT NULL COMMENT 'Quan hệ một - một với bảng accountant_transaction_voucher',
  `purchase_invoice_number` varchar(20) NOT NULL,
  `purchase_invoice_date` datetime NOT NULL,
  `supplier_id` bigint(30) unsigned NOT NULL,
  `supplier_name` varchar(100) NOT NULL,
  `supplier_address` varchar(100) NOT NULL,
  `supplier_tax_code` varchar(20) NOT NULL,
  `supplier_contact` varchar(100) NOT NULL,
  `currency_id` bigint(30) unsigned NOT NULL,
  `forex_rate` decimal(18,4) NOT NULL,
  `by_import` tinyint(1) unsigned NOT NULL,
  `description` varchar(500) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`purchase_invoice_id`),
  KEY `fk_purchase_invoice_voucher` (`voucher_id`),
  KEY `fk_purchase_invoice_supplier` (`supplier_id`),
  KEY `fk_purchase_invoice_created_user` (`created_by_userid`),
  KEY `fk_purchase_invoice_modified_user` (`last_modified_by_userid`),
  KEY `fk_purchase_invoice_currency` (`currency_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `accountant_purchase_invoice`
--

INSERT INTO `accountant_purchase_invoice` (`purchase_invoice_id`, `voucher_id`, `purchase_invoice_number`, `purchase_invoice_date`, `supplier_id`, `supplier_name`, `supplier_address`, `supplier_tax_code`, `supplier_contact`, `currency_id`, `forex_rate`, `by_import`, `description`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, 1, 'PCIN001', '2010-05-22 00:10:05', 5, 'Magx Japan', 'Tokyo', '2312312312', '', 1, '1.0000', 1, 'Description test', 0, '2010-05-22 00:11:06', 0, '2010-05-23 16:14:57');

-- --------------------------------------------------------

--
-- Table structure for table `accountant_relation_tax`
--

CREATE TABLE IF NOT EXISTS `accountant_relation_tax` (
  `product_id` bigint(30) unsigned NOT NULL,
  `tax_id` bigint(30) unsigned NOT NULL,
  `specification_id` bigint(30) unsigned NOT NULL,
  `tax_rate_id` bigint(30) unsigned NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`product_id`,`tax_id`,`specification_id`),
  KEY `fk_relation_tax_tax` (`tax_id`),
  KEY `fk_relation_tax_specification` (`specification_id`),
  KEY `fk_relation_tax_rate` (`tax_rate_id`),
  KEY `fk_realtion_created_user` (`created_by_userid`),
  KEY `fk_relation_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `accountant_relation_tax`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_tax_rate`
--

CREATE TABLE IF NOT EXISTS `accountant_tax_rate` (
  `tax_rate_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `tax_id` bigint(30) unsigned NOT NULL,
  `rate` tinyint(2) unsigned NOT NULL COMMENT '0< Thuế suất < 100',
  `inactive` tinyint(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`tax_rate_id`),
  KEY `fk_tax_rate` (`tax_id`),
  KEY `fk_tax_created_user` (`created_by_userid`),
  KEY `fk_tax_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `accountant_tax_rate`
--

INSERT INTO `accountant_tax_rate` (`tax_rate_id`, `tax_id`, `rate`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, 4, 10, 0, 0, '2010-05-22 00:31:52', 0, '2010-05-22 00:31:55'),
(2, 2, 5, 0, 0, '2010-05-22 00:34:40', 0, '2010-05-22 00:34:44'),
(3, 1, 5, 0, 0, '2010-05-20 00:03:56', 0, '2010-05-20 00:04:05');

-- --------------------------------------------------------

--
-- Table structure for table `accountant_transaction_batch`
--

CREATE TABLE IF NOT EXISTS `accountant_transaction_batch` (
  `batch_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT COMMENT 'bó bút toán',
  `voucher_id` bigint(30) unsigned NOT NULL,
  `execution_id` bigint(30) unsigned NOT NULL COMMENT 'khác với phần hành của voucher, phần hành này thể hiện nơi mà bút toán thuộc về, bắt buộc phải thuộc phân hệ kế toán',
  `batch_note` varchar(300) NOT NULL,
  PRIMARY KEY (`batch_id`),
  KEY `fk_accountant_batch_voucher` (`voucher_id`),
  KEY `fk_accountant_batch_execution` (`execution_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `accountant_transaction_batch`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_transaction_correspondence`
--

CREATE TABLE IF NOT EXISTS `accountant_transaction_correspondence` (
  `correspondence_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `entry_id` bigint(30) unsigned NOT NULL,
  `detail_account_id` bigint(30) unsigned NOT NULL COMMENT 'tài khoản bên một trong quan hệ một - nhiều',
  `debit_credit` tinyint(1) NOT NULL COMMENT 'thể hiện tài khoản bên một là bên nợ (-1) hay bên có (1)',
  `original_amount` decimal(18,4) NOT NULL,
  `currency_id` bigint(30) unsigned NOT NULL,
  `forex_rate` decimal(18,4) NOT NULL,
  `converted_amount` decimal(18,4) unsigned NOT NULL,
  PRIMARY KEY (`correspondence_id`),
  KEY `fk_accountant_correspondence_entry` (`entry_id`),
  KEY `fk_accountant_correspondence_account` (`detail_account_id`),
  KEY `fk_accountant_correspondence_currency` (`currency_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `accountant_transaction_correspondence`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_transaction_entry`
--

CREATE TABLE IF NOT EXISTS `accountant_transaction_entry` (
  `entry_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `batch_id` bigint(30) unsigned NOT NULL,
  `master_account_id` bigint(30) unsigned NOT NULL COMMENT 'tài khoản bên một trong quan hệ một - nhiều',
  `debit_credit` tinyint(1) NOT NULL COMMENT 'thể hiện tài khoản bên một là bên nợ (-1) hay bên có (1)',
  `original_amount` decimal(18,4) NOT NULL,
  `currency_id` bigint(30) unsigned NOT NULL,
  `forex_rate` decimal(18,4) NOT NULL,
  `converted_amount` decimal(18,4) NOT NULL,
  PRIMARY KEY (`entry_id`),
  KEY `fk_accountant_entry_batch` (`batch_id`),
  KEY `fk_accountant_entry_account` (`master_account_id`),
  KEY `fk_accountant_entry_currency` (`currency_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `accountant_transaction_entry`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_transaction_voucher`
--

CREATE TABLE IF NOT EXISTS `accountant_transaction_voucher` (
  `voucher_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT COMMENT 'chứng từ có thể phát sinh từ phân hệ kế toán, hay có thể từ các phân hệ khác chuyển qua',
  `execution_id` bigint(30) unsigned NOT NULL COMMENT 'phần hành nơi chứng từ phát sinh, có thể không thuộc phân hệ kế toán',
  `period_id` bigint(30) unsigned NOT NULL,
  `voucher_number` varchar(20) NOT NULL COMMENT 'số chứng từ, phát sinh từ phân hệ gốc, lưu nguyên qua đây',
  `voucher_date` datetime NOT NULL COMMENT 'ngày chứng từ, lấy giá trị từ phân hệ gốc chuyển qua',
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`voucher_id`),
  KEY `fk_accountant_voucher_execution` (`execution_id`),
  KEY `fk_accountant_voucher_created_user` (`created_by_userid`),
  KEY `fk_accountant_voucher_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `accountant_transaction_voucher`
--

INSERT INTO `accountant_transaction_voucher` (`voucher_id`, `execution_id`, `period_id`, `voucher_number`, `voucher_date`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, 13, 1, 'VC001', '2010-05-20 00:03:48', 0, '2010-05-20 00:03:56', 0, '2010-05-20 00:04:05');

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
(1, 'definition_list_execution', '', 1, 'Navigation - MH'),
(1, 'definition_list_execution', '', 2, 'View current status - MH'),
(1, 'definition_list_execution', '', 3, 'Planning - MH'),
(1, 'definition_list_execution', '', 4, 'Released order - MH'),
(1, 'definition_list_execution', '', 5, 'Payment - MH'),
(1, 'definition_list_execution', '', 6, 'Delivery - GN'),
(1, 'definition_list_execution', '', 7, 'Receiving - GN'),
(1, 'definition_list_execution', '', 8, 'Navigation - KH'),
(1, 'definition_list_execution', '', 9, 'Input stock - KH'),
(1, 'definition_list_execution', '', 10, 'Output stock - KH'),
(1, 'definition_list_execution', '', 11, 'Inventory control - KH'),
(1, 'definition_list_execution', '', 12, 'Navigation - KT'),
(1, 'definition_list_execution', '', 13, 'Purchasing - KT'),
(1, 'definition_list_execution', '', 14, 'Saling - KT'),
(1, 'definition_list_execution', '', 15, 'Inventory - KT'),
(1, 'definition_list_execution', '', 16, 'Receivables - KT'),
(1, 'definition_list_execution', '', 17, 'Payables - KT'),
(1, 'definition_list_execution', '', 18, 'Funds - KT'),
(1, 'definition_list_execution', '', 19, 'Assets - KT'),
(1, 'definition_list_execution', '', 20, 'Prepaid Expenses - KT'),
(1, 'definition_list_execution', '', 21, 'General - KT'),
(1, 'definition_list_execution', '', 22, 'Navigation - BH'),
(1, 'definition_list_execution', '', 23, 'Quotes - BH'),
(1, 'definition_list_execution', '', 24, 'Contracts - BH'),
(1, 'definition_list_execution', '', 25, 'Demand - BH'),
(1, 'definition_list_execution', '', 26, 'Orders - BH'),
(1, 'definition_list_execution', '', 27, 'Returns, reduction - BH'),
(1, 'definition_list_execution', '', 28, 'Setup product - TL'),
(1, 'definition_list_execution', '', 29, 'Setup object - TL'),
(1, 'definition_list_execution', '', 30, 'Setup other - TL'),
(1, 'definition_list_function', '', 1, 'Grouping purchase'),
(1, 'definition_list_function', '', 2, 'List purchase'),
(1, 'definition_list_function', '', 3, 'Grouping objects'),
(1, 'definition_list_function', '', 4, 'Manufacturers list'),
(1, 'definition_list_function', '', 5, 'Suppliers list'),
(1, 'definition_list_function', '', 6, 'Current status of inventory'),
(1, 'definition_list_function', '', 7, 'Current status of funds'),
(1, 'definition_list_function', '', 8, 'Purchase history'),
(1, 'definition_list_function', '', 9, 'Purchase plan'),
(1, 'definition_list_function', '', 10, 'Track customer purchases'),
(1, 'definition_list_function', '', 11, 'Orders'),
(1, 'definition_list_function', '', 12, 'Comes pre-purchase'),
(1, 'definition_list_function', '', 13, 'Paid purchasing'),
(1, 'definition_list_function', '', 14, 'Store list'),
(1, 'definition_list_function', '', 15, 'Grouping inventory'),
(1, 'definition_list_function', '', 16, 'Enter a stock purchase'),
(1, 'definition_list_function', '', 17, 'Enter a stock return'),
(1, 'definition_list_function', '', 18, 'Warehouse sales'),
(1, 'definition_list_function', '', 19, 'Warehousing use'),
(1, 'definition_list_function', '', 20, 'Test area (monthly)'),
(1, 'definition_list_function', '', 21, 'Check all (quarter)'),
(1, 'definition_list_function', '', 22, 'Account system'),
(1, 'definition_list_function', '', 23, 'List of foreign currency'),
(1, 'definition_list_function', '', 24, 'Catalog sales'),
(1, 'definition_list_function', '', 25, 'List expenses'),
(1, 'definition_list_function', '', 26, 'Purchase invoice'),
(1, 'definition_list_function', '', 27, 'Account payable'),
(1, 'definition_list_function', '', 28, 'Distribution costs'),
(1, 'definition_list_function', '', 29, 'Sale invoice'),
(1, 'definition_list_function', '', 30, 'Sales returns'),
(1, 'definition_list_function', '', 31, 'Discount sales'),
(1, 'definition_list_function', '', 32, 'Inventory management'),
(1, 'definition_list_function', '', 33, 'Handling excess inventory shortage'),
(1, 'definition_list_function', '', 34, 'Output inventory calculation'),
(1, 'definition_list_function', '', 35, 'Receivables management'),
(1, 'definition_list_function', '', 36, 'Receivable bills'),
(1, 'definition_list_function', '', 37, 'Disarmament receivable'),
(1, 'definition_list_function', '', 38, 'Payables management'),
(1, 'definition_list_function', '', 39, 'Payables bills'),
(1, 'definition_list_function', '', 40, 'Disarmament payables'),
(1, 'definition_list_function', '', 41, 'Budget management'),
(1, 'definition_list_function', '', 42, 'Cash flow management'),
(1, 'definition_list_function', '', 43, 'Depreciation of fixed assets'),
(1, 'definition_list_function', '', 44, 'Prepaid expenses'),
(1, 'definition_list_function', '', 45, 'Vote on account'),
(1, 'definition_list_function', '', 46, 'Grouping customers'),
(1, 'definition_list_function', '', 47, 'Customer list'),
(1, 'definition_list_function', '', 48, 'Sub-group sales'),
(1, 'definition_list_function', '', 49, 'Catalog sales'),
(1, 'definition_list_function', '', 50, 'Periodic report'),
(1, 'definition_list_function', '', 51, 'Quotation request'),
(1, 'definition_list_function', '', 52, 'The contract principles'),
(1, 'definition_list_function', '', 53, 'The contract arising'),
(1, 'definition_list_function', '', 54, 'Buy regular'),
(1, 'definition_list_function', '', 55, 'Orders'),
(1, 'definition_list_function', '', 56, 'Confirm order'),
(1, 'definition_list_function', '', 57, 'Sales returns'),
(1, 'definition_list_function', '', 58, 'Discount sales'),
(1, 'definition_list_function', '', 59, 'Grouping items'),
(1, 'definition_list_function', '', 60, 'List of items'),
(1, 'definition_list_function', '', 61, 'Grouping objects'),
(1, 'definition_list_function', '', 62, 'List object'),
(1, 'definition_list_function', '', 63, 'Purchasing'),
(1, 'definition_list_function', '', 66, 'Import-export inventory'),
(1, 'definition_list_function', '', 69, 'Accounting'),
(1, 'definition_list_function', '', 72, 'Set up system'),
(1, 'definition_list_function', '', 74, 'Decision'),
(1, 'definition_list_function', '', 77, 'Setting up the accounting period'),
(1, 'definition_list_function', '', 78, 'Setting up the account automatically'),
(1, 'definition_list_function', '', 79, 'Tax list'),
(1, 'definition_list_function', '', 80, 'Setting up an account to account'),
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
(2, 'definition_list_function', '', 77, 'Thiết lập kỳ kế toán'),
(2, 'definition_list_function', '', 78, 'Thiết lập định khoản tự động'),
(2, 'definition_list_function', '', 79, 'Danh mục thuế'),
(2, 'definition_list_function', '', 80, 'Thiết lập tài khoản hạch toán'),
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
  `account_id` bigint(30) unsigned NOT NULL,
  `table_id` bigint(30) unsigned NOT NULL,
  `detail_id` bigint(30) unsigned NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`account_id`,`table_id`,`detail_id`),
  KEY `fk_sub_account_table` (`table_id`) USING BTREE,
  KEY `fk_detail_account_created_user` (`created_by_userid`),
  KEY `fk_detail_account_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `definition_detail_account`
--

INSERT INTO `definition_detail_account` (`account_id`, `table_id`, `detail_id`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(6, 5, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(6, 5, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_detail_currency`
--

CREATE TABLE IF NOT EXISTS `definition_detail_currency` (
  `base_currency_id` bigint(30) unsigned NOT NULL,
  `convert_currency_id` bigint(30) unsigned NOT NULL,
  `time_point` datetime NOT NULL,
  `forex_rate` decimal(18,4) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`base_currency_id`,`convert_currency_id`,`time_point`),
  KEY `fk_detail_currency_convert` (`convert_currency_id`),
  KEY `fk_detail_currency_created_user` (`created_by_userid`),
  KEY `fk_detail_currency_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `definition_detail_currency`
--

INSERT INTO `definition_detail_currency` (`base_currency_id`, `convert_currency_id`, `time_point`, `forex_rate`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, 1, '2010-05-22 00:07:22', '1.0000', 0, '2010-05-22 00:07:33', 0, '2010-05-22 00:07:36');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `definition_detail_property`
--


-- --------------------------------------------------------

--
-- Table structure for table `definition_detail_rank`
--

CREATE TABLE IF NOT EXISTS `definition_detail_rank` (
  `subject_id` bigint(30) unsigned NOT NULL,
  `term_id` bigint(30) unsigned NOT NULL,
  `rank_id` bigint(30) unsigned NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`subject_id`,`term_id`),
  KEY `fk_detail_rank` (`rank_id`),
  KEY `fk_detail_rank_term` (`term_id`),
  KEY `fk_detail_rank_created_user` (`created_by_userid`),
  KEY `fk_detail_rank_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `definition_detail_rank`
--


-- --------------------------------------------------------

--
-- Table structure for table `definition_list_account`
--

CREATE TABLE IF NOT EXISTS `definition_list_account` (
  `account_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `account_code` varchar(10) NOT NULL,
  `account_name` varchar(100) NOT NULL,
  `account_parent_id` bigint(30) DEFAULT NULL,
  `account_note` varchar(100) NOT NULL,
  `debit_credit_balance` tinyint(1) unsigned NOT NULL COMMENT 'Tài khoản dư Nợ (1) hoặc dư Có (-1) hoặc không dư (0)',
  `inactive` tinyint(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`account_id`),
  KEY `fk_account_created_user` (`created_by_userid`),
  KEY `fk_account_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=216 ;

--
-- Dumping data for table `definition_list_account`
--

INSERT INTO `definition_list_account` (`account_id`, `account_code`, `account_name`, `account_parent_id`, `account_note`, `debit_credit_balance`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, '', 'Hệ thống tài khoản kế toán', NULL, '', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(2, '111', 'Tiền mặt', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(3, '1111', 'Tiền Việt Nam', 2, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, '1112', 'Ngoại tệ', 2, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, '1113', 'Vàng, bạc, kim khí quý, đá quý', 2, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(6, '112', 'Tiền gửi Ngân hàng', 1, 'Chi tiết theo từng ngân hàng', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(7, '1121', 'Tiền Việt Nam', 6, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(8, '1122', 'Ngoại tệ', 6, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(9, '1123', 'Vàng, bạc, kim khí quý, đá quý', 6, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(10, '113', 'Tiền đang chuyển', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(11, '1131', 'Tiền Việt Nam', 10, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(12, '1132', 'Ngoại tệ', 10, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(13, '121', 'Đầu tư chứng khoán ngắn hạn', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(14, '1211', 'Cổ phiếu', 13, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(15, '1212', 'Trái phiếu, tín phiếu, kỳ phiếu', 13, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(16, '128', 'Đầu tư ngắn hạn khác', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(17, '1281', 'Tiền gửi có kỳ hạn', 16, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(18, '1288', 'Đầu tư ngắn hạn khác', 16, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(19, '129', 'Dự phòng giảm giá đầu tư ngắn hạn', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(20, '131', 'Phải thu của khách hàng', 1, 'Chi tiết theo đối tượng', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(21, '133', 'Thuế GTGT được khấu trừ', 1, '0', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(22, '1331', 'Thuế GTGT được khấu trừ của hàng hóa, dịch vụ', 21, '0', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(23, '1332', 'Thuế GTGT được khấu trừ của TSCĐ', 21, '0', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(24, '136', 'Phải thu nội bộ', 1, '0', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(25, '1361', 'Vốn kinh doanh ở các đơn vị trực thuộc', 24, '0', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(26, '1368', 'Phải thu nội bộ khác', 24, '0', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(27, '138', 'Phải thu khác', 1, '0', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(28, '1381', 'Tài sản thiếu chờ xử lý', 27, '0', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(29, '1385', 'Phải thu về cổ phần hóa', 27, '0', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(30, '1388', 'Phải thu khác', 27, '0', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(31, '139', 'Dự phòng phải thu khó đòi', 1, '0', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(32, '141', 'Tạm ứng', 1, '1', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(33, '142', 'Chi phí trả trước ngắn hạn', 1, '0', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(34, '144', 'Cầm cố, ký quỹ, ký cược ngắn hạn', 1, '0', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(35, '151', 'Hàng mua đang đi đường', 1, '0', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(36, '152', 'Nguyên liệu, vật liệu', 1, 'Chi tiết theo yêu cầu quản lý', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(37, '153', 'Công cụ, dụng cụ', 1, '0', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(38, '154', 'Chi phí sản xuất, kinh doanh dở dang', 1, '0', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(39, '155', 'Thành phẩm', 1, '0', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(40, '156', 'Hàng hóa', 1, '0', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(41, '1561', 'Giá mua hàng hóa', 40, '0', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(42, '1562', 'Chi phí thu mua hàng hóa', 40, '0', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(43, '1567', 'Hàng hóa bất động sản', 40, '0', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(44, '157', 'Hàng gửi đi bán', 1, '0', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(45, '158', 'Hàng hóa kho bảo thuế', 1, 'Đơn vị có XNK được lập kho bảo thuế', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(46, '159', 'Dự phòng giảm giá hàng tồn kho', 1, '0', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(47, '161', 'Chi sự nghiệp', 1, '0', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(48, '1611', 'Chi sự nghiệp năm trước', 47, '0', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(49, '1612', 'Chi sự nghiệp năm nay', 47, '0', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(50, '211', 'Tài sản cố định hữu hình', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(51, '2111', 'Nhà cửa, vật kiến trúc', 50, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(52, '2112', 'Máy móc, thiết bị', 50, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(53, '2113', 'Phương tiện vận tải, truyền dẫn', 50, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(54, '2114', 'Thiết bị, dụng cụ quản lý', 50, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(55, '2115', 'Cây lâu năm, súc vật làm việc và cho sản phẩm', 50, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(56, '2118', 'TSCĐ khác', 50, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(57, '212', 'Tài sản cố định thuê tài chính', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(58, '213', 'Tài sản cố định vô hình', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(59, '2131', 'Quyền sử dụng đất', 58, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(60, '2132', 'Quyền phát hành', 58, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(61, '2133', 'Bản quyền, bằng sáng chế', 58, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(62, '2134', 'Nhãn hiệu hàng hoá', 58, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(63, '2135', 'Phần mềm máy vi tính', 58, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(64, '2136', 'Giấy phép và giấy phép nhượng quyền', 58, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(65, '2138', 'TSCĐ vô hình khác', 58, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(66, '214', 'Hao mòn tài sản cố định', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(67, '2141', 'Hao mòn TSCĐ hữu hình', 66, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(68, '2142', 'Hao mòn TSCĐ thuê tài chính', 66, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(69, '2143', 'Hao mòn TSCĐ vô hình', 66, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(70, '2147', 'Hao mòn bất động sản đầu tư', 66, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(71, '217', 'Bất động sản đầu tư', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(72, '221', 'Đầu tư vào công ty con', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(73, '222', 'Vốn góp liên doanh', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(74, '223', 'Đầu tư vào công ty liên kết', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(75, '228', 'Đầu tư dài hạn khác', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(76, '2281', 'Cổ phiếu', 75, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(77, '2282', 'Trái phiếu', 75, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(78, '2288', 'Đầu tư dài hạn khác', 75, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(79, '229', 'Dự phòng giảm giá đầu tư dài hạn', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(80, '241', 'Xây dựng cơ bản dở dang', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(81, '2411', 'Mua sắm TSCĐ', 80, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(82, '2412', 'Xây dựng cơ bản', 80, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(83, '2413', 'Sửa chữa lớn TSCĐ', 80, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(84, '242', 'Chi phí trả trước dài hạn', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(85, '243', 'Tài sản thuế thu nhập hoãn lại', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(86, '244', 'Ký quỹ, ký cược dài hạn', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(87, '311', 'Vay ngắn hạn', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(88, '315', 'Nợ dài hạn đến hạn trả', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(89, '331', 'Phải trả cho người bán', 1, 'Chi tiết theo đối tượng', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(90, '333', 'Thuế và các khoản phải nộp Nhà nước', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(91, '3331', 'Thuế giá trị gia tăng phải nộp', 90, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(92, '33311', 'Thuế GTGT đầu ra', 91, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(93, '33312', 'Thuế GTGT hàng nhập khẩu', 91, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(94, '3332', 'Thuế tiêu thụ đặc biệt', 90, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(95, '3333', 'Thuế xuất, nhập khẩu', 90, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(96, '3334', 'Thuế thu nhập doanh nghiệp', 90, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(97, '3335', 'Thuế thu nhập cá nhân', 90, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(98, '3336', 'Thuế tài nguyên', 90, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(99, '3337', 'Thuế nhà đất, tiền thuê đất', 90, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(100, '3338', 'Các loại thuế khác', 90, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(101, '3339', 'Phí, lệ phí và các khoản phải nộp khác', 90, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(102, '334', 'Phải trả người lao động', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(103, '3341', 'Phải trả công nhân viên', 102, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(104, '3348', 'Phải trả người lao động khác', 102, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(105, '335', 'Chi phí phải trả', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(106, '336', 'Phải trả nội bộ', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(107, '337', 'Thanh toán theo tiến độ kế hoạch hợp đồng xây dựng', 1, 'DN xây lắp có thanh toán theo tiến độ kế hoạch', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(108, '338', 'Phải trả, phải nộp khác', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(109, '3381', 'Tài sản thừa chờ giải quyết', 108, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(110, '3382', 'Kinh phí công đoàn', 108, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(111, '3383', 'Bảo hiểm xã hội', 108, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(112, '3384', 'Bảo hiểm y tế', 108, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(113, '3385', 'Phải trả về cổ phần hoá', 108, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(114, '3386', 'Nhận ký quỹ, ký cược ngắn hạn', 108, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(115, '3387', 'Doanh thu chưa thực hiện', 108, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(116, '3388', 'Phải trả, phải nộp khác', 108, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(117, '341', 'Vay dài hạn', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(118, '342', 'Nợ dài hạn', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(119, '343', 'Trái phiếu phát hành', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(120, '3431', 'Mệnh giá trái phiếu', 119, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(121, '3432', 'Chiết khấu trái phiếu', 119, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(122, '3433', 'Phụ trội trái phiếu', 119, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(123, '344', 'Nhận ký quỹ, ký cược dài hạn', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(124, '347', 'Thuế thu nhập hoãn lại phải trả', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(125, '351', 'Quỹ dự phòng trợ cấp mất việc làm', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(126, '352', 'Dự phòng phải trả', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(127, '411', 'Nguồn vốn kinh doanh', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(128, '4111', 'Vốn đầu tư của chủ sở hữu', 127, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(129, '4112', 'Thặng dư vốn cổ phần', 127, 'C.ty cổ phần', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(130, '4118', 'Vốn khác', 127, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(131, '412', 'Chênh lệch đánh giá lại tài sản', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(132, '413', 'Chênh lệch tỷ giá hối đoái', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(133, '4131', 'Chênh lệch tỷ giá hối đoái đánh giá lại cuối năm tài chính', 132, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(134, '4132', 'Chênh lệch tỷ giá hối đoái trong giai đoạn đầu tư XDCB', 132, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(135, '414', 'Quỹ đầu tư phát triển', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(136, '415', 'Quỹ dự phòng tài chính', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(137, '418', 'Các quỹ khác thuộc vốn chủ sở hữu', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(138, '419', 'Cổ phiếu quỹ', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(139, '421', 'Lợi nhuận chưa phân phối', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(140, '4211', 'Lợi nhuận chưa phân phối năm trước', 139, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(141, '4212', 'Lợi nhuận chưa phân phối năm nay', 139, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(142, '431', 'Quỹ khen thưởng, phúc lợi', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(143, '4311', 'Quỹ khen thưởng', 142, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(144, '4312', 'Quỹ phúc lợi', 142, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(145, '4313', 'Quỹ phúc lợi đã hình thành TSCĐ', 142, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(146, '441', 'Nguồn vốn đầu tư xây dựng cơ bản', 1, 'Áp dụng cho DNNN', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(147, '461', 'Nguồn kinh phí sự nghiệp', 1, 'Dùng cho các công ty, TCty có nguồn kinh phí', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(148, '4611', 'Nguồn kinh phí sự nghiệp năm trước', 147, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(149, '4612', 'Nguồn kinh phí sự nghiệp năm nay', 147, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(150, '466', 'Nguồn kinh phí đã hình thành TSCĐ', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(151, '511', 'Doanh thu bán hàng và cung cấp dịch vụ', 1, 'Chi tiết theo yêu cầu quản lý', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(152, '5111', 'Doanh thu bán hàng hóa', 151, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(153, '5112', 'Doanh thu bán các thành phẩm', 151, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(154, '5113', 'Doanh thu cung cấp dịch vụ', 151, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(155, '5114', 'Doanh thu trợ cấp, trợ giá', 151, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(156, '5117', 'Doanh thu kinh doanh bất động sản đầu tư', 151, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(157, '512', 'Doanh thu bán hàng nội bộ', 1, 'Áp dụng khi có bán hàng nội  bộ', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(158, '5121', 'Doanh thu bán hàng hóa', 157, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(159, '5122', 'Doanh thu bán các thành phẩm', 157, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(160, '5123', 'Doanh thu cung cấp dịch vụ', 157, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(161, '515', 'Doanh thu hoạt động tài chính', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(162, '521', 'Chiết khấu thương mại', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(163, '531', 'Hàng bán bị trả lại', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(164, '532', 'Giảm giá hàng bán', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(165, '611', 'Mua hàng', 1, 'Áp dụng phương pháp kiểm kê định kỳ', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(166, '6111', 'Mua nguyên liệu, vật liệu', 165, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(167, '6112', 'Mua hàng hóa', 165, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(168, '621', 'Chi phí nguyên liệu, vật liệu trực tiếp', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(169, '622', 'Chi phí nhân công trực tiếp', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(170, '623', 'Chi phí sử dụng máy thi công', 1, 'Áp dụng cho đơn vị xây lắp', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(171, '6231', 'Chi phí nhân công', 170, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(172, '6232', 'Chi phí vật liệu', 170, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(173, '6233', 'Chi phí dụng cụ sản xuất', 170, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(174, '6234', 'Chi phí khấu hao máy thi công', 170, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(175, '6237', 'Chi phí dịch vụ mua ngoài', 170, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(176, '6238', 'Chi phí bằng tiền khác', 170, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(177, '627', 'Chi phí sản xuất chung', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(178, '6271', 'Chi phí nhân viên phân xưởng', 177, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(179, '6272', 'Chi phí vật liệu', 177, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(180, '6273', 'Chi phí dụng cụ sản xuất', 177, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(181, '6274', 'Chi phí khấu hao TSCĐ', 177, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(182, '6277', 'Chi phí dịch vụ mua ngoài', 177, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(183, '6278', 'Chi phí bằng tiền khác', 177, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(184, '631', 'Giá thành sản xuất', 1, 'PP.Kkê định kỳ', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(185, '632', 'Giá vốn hàng bán', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(186, '635', 'Chi phí tài chính', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(187, '641', 'Chi phí bán hàng', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(188, '6411', 'Chi phí nhân viên', 187, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(189, '6412', 'Chi phí vật liệu, bao bì', 187, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(190, '6413', 'Chi phí dụng cụ, đồ dùng', 187, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(191, '6414', 'Chi phí khấu hao TSCĐ', 187, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(192, '6415', 'Chi phí bảo hành', 187, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(193, '6417', 'Chi phí dịch vụ mua ngoài', 187, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(194, '6418', 'Chi phí bằng tiền khác', 187, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(195, '642', 'Chi phí quản lý doanh nghiệp', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(196, '6421', 'Chi phí nhân viên quản lý', 195, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(197, '6422', 'Chi phí vật liệu quản lý', 195, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(198, '6423', 'Chi phí đồ dùng văn phòng', 195, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(199, '6424', 'Chi phí khấu hao TSCĐ', 195, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(200, '6425', 'Thuế, phí và lệ phí', 195, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(201, '6426', 'Chi phí dự phòng', 195, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(202, '6427', 'Chi phí dịch vụ mua ngoài', 195, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(203, '6428', 'Chi phí bằng tiền khác', 195, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(204, '711', 'Thu nhập khác', 1, 'Chi tiết theo hoạt động', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(205, '811', 'Chi phí khác', 1, 'Chi tiết theo hoạt động', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(206, '821', 'Chi phí thuế thu nhập doanh nghiệp', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(207, '8211', 'Chi phí thuế TNDN hiện hành', 206, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(208, '8212', 'Chi phí thuế TNDN hoãn lại', 206, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(209, '911', 'Xác định kết quả kinh doanh', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(210, '001', 'Tài sản thuê ngoài', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(211, '002', 'Vật tư, hàng hóa nhận giữ hộ, nhận gia công', 1, 'Chi tiết theo yêu cầu quản lý', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(212, '003', 'Hàng hóa nhận bán hộ, nhận ký gửi, ký cược', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(213, '004', 'Nợ khó đòi đã xử lý', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(214, '007', 'Ngoại tệ các loại', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(215, '008', 'Dự toán chi sự nghiệp, dự án', 1, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_account_path`
--

CREATE TABLE IF NOT EXISTS `definition_list_account_path` (
  `account_id` bigint(30) unsigned NOT NULL,
  `path` text,
  PRIMARY KEY (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `definition_list_account_path`
--

INSERT INTO `definition_list_account_path` (`account_id`, `path`) VALUES
(1, '/1/'),
(2, '/1/2/'),
(3, '/1/2/3/'),
(4, '/1/2/4/'),
(5, '/1/2/5/'),
(6, '/1/6/'),
(7, '/1/6/7/'),
(8, '/1/6/8/'),
(9, '/1/6/9/'),
(10, '/1/10/'),
(11, '/1/10/11/'),
(12, '/1/10/12/'),
(13, '/1/13/'),
(14, '/1/13/14/'),
(15, '/1/13/15/'),
(16, '/1/16/'),
(17, '/1/16/17/'),
(18, '/1/16/18/'),
(19, '/1/19/'),
(20, '/1/20/'),
(21, '/1/21/'),
(22, '/1/21/22/'),
(23, '/1/21/23/'),
(24, '/1/24/'),
(25, '/1/24/25/'),
(26, '/1/24/26/'),
(27, '/1/27/'),
(28, '/1/27/28/'),
(29, '/1/27/29/'),
(30, '/1/27/30/'),
(31, '/1/31/'),
(32, '/1/32/'),
(33, '/1/33/'),
(34, '/1/34/'),
(35, '/1/35/'),
(36, '/1/36/'),
(37, '/1/37/'),
(38, '/1/38/'),
(39, '/1/39/'),
(40, '/1/40/'),
(41, '/1/40/41/'),
(42, '/1/40/42/'),
(43, '/1/40/43/'),
(44, '/1/44/'),
(45, '/1/45/'),
(46, '/1/46/'),
(47, '/1/47/'),
(48, '/1/47/48/'),
(49, '/1/47/49/'),
(50, '/1/50/'),
(51, '/1/50/51/'),
(52, '/1/50/52/'),
(53, '/1/50/53/'),
(54, '/1/50/54/'),
(55, '/1/50/55/'),
(56, '/1/50/56/'),
(57, '/1/57/'),
(58, '/1/58/'),
(59, '/1/58/59/'),
(60, '/1/58/60/'),
(61, '/1/58/61/'),
(62, '/1/58/62/'),
(63, '/1/58/63/'),
(64, '/1/58/64/'),
(65, '/1/58/65/'),
(66, '/1/66/'),
(67, '/1/66/67/'),
(68, '/1/66/68/'),
(69, '/1/66/69/'),
(70, '/1/66/70/'),
(71, '/1/71/'),
(72, '/1/72/'),
(73, '/1/73/'),
(74, '/1/74/'),
(75, '/1/75/'),
(76, '/1/75/76/'),
(77, '/1/75/77/'),
(78, '/1/75/78/'),
(79, '/1/79/'),
(80, '/1/80/'),
(81, '/1/80/81/'),
(82, '/1/80/82/'),
(83, '/1/80/83/'),
(84, '/1/84/'),
(85, '/1/85/'),
(86, '/1/86/'),
(87, '/1/87/'),
(88, '/1/88/'),
(89, '/1/89/'),
(90, '/1/90/'),
(91, '/1/90/91/'),
(92, '/1/90/91/92/'),
(93, '/1/90/91/93/'),
(94, '/1/90/94/'),
(95, '/1/90/95/'),
(96, '/1/90/96/'),
(97, '/1/90/97/'),
(98, '/1/90/98/'),
(99, '/1/90/99/'),
(100, '/1/90/100/'),
(101, '/1/90/101/'),
(102, '/1/102/'),
(103, '/1/102/103/'),
(104, '/1/102/104/'),
(105, '/1/105/'),
(106, '/1/106/'),
(107, '/1/107/'),
(108, '/1/108/'),
(109, '/1/108/109/'),
(110, '/1/108/110/'),
(111, '/1/108/111/'),
(112, '/1/108/112/'),
(113, '/1/108/113/'),
(114, '/1/108/114/'),
(115, '/1/108/115/'),
(116, '/1/108/116/'),
(117, '/1/117/'),
(118, '/1/118/'),
(119, '/1/119/'),
(120, '/1/119/120/'),
(121, '/1/119/121/'),
(122, '/1/119/122/'),
(123, '/1/123/'),
(124, '/1/124/'),
(125, '/1/125/'),
(126, '/1/126/'),
(127, '/1/127/'),
(128, '/1/127/128/'),
(129, '/1/127/129/'),
(130, '/1/127/130/'),
(131, '/1/131/'),
(132, '/1/132/'),
(133, '/1/132/133/'),
(134, '/1/132/134/'),
(135, '/1/135/'),
(136, '/1/136/'),
(137, '/1/137/'),
(138, '/1/138/'),
(139, '/1/139/'),
(140, '/1/139/140/'),
(141, '/1/139/141/'),
(142, '/1/142/'),
(143, '/1/142/143/'),
(144, '/1/142/144/'),
(145, '/1/142/145/'),
(146, '/1/146/'),
(147, '/1/147/'),
(148, '/1/147/148/'),
(149, '/1/147/149/'),
(150, '/1/150/'),
(151, '/1/151/'),
(152, '/1/151/152/'),
(153, '/1/151/153/'),
(154, '/1/151/154/'),
(155, '/1/151/155/'),
(156, '/1/151/156/'),
(157, '/1/157/'),
(158, '/1/157/158/'),
(159, '/1/157/159/'),
(160, '/1/157/160/'),
(161, '/1/161/'),
(162, '/1/162/'),
(163, '/1/163/'),
(164, '/1/164/'),
(165, '/1/165/'),
(166, '/1/165/166/'),
(167, '/1/165/167/'),
(168, '/1/168/'),
(169, '/1/169/'),
(170, '/1/170/'),
(171, '/1/170/171/'),
(172, '/1/170/172/'),
(173, '/1/170/173/'),
(174, '/1/170/174/'),
(175, '/1/170/175/'),
(176, '/1/170/176/'),
(177, '/1/177/'),
(178, '/1/177/178/'),
(179, '/1/177/179/'),
(180, '/1/177/180/'),
(181, '/1/177/181/'),
(182, '/1/177/182/'),
(183, '/1/177/183/'),
(184, '/1/184/'),
(185, '/1/185/'),
(186, '/1/186/'),
(187, '/1/187/'),
(188, '/1/187/188/'),
(189, '/1/187/189/'),
(190, '/1/187/190/'),
(191, '/1/187/191/'),
(192, '/1/187/192/'),
(193, '/1/187/193/'),
(194, '/1/187/194/'),
(195, '/1/195/'),
(196, '/1/195/196/'),
(197, '/1/195/197/'),
(198, '/1/195/198/'),
(199, '/1/195/199/'),
(200, '/1/195/200/'),
(201, '/1/195/201/'),
(202, '/1/195/202/'),
(203, '/1/195/203/'),
(204, '/1/204/'),
(205, '/1/205/'),
(206, '/1/206/'),
(207, '/1/206/207/'),
(208, '/1/206/208/'),
(209, '/1/209/'),
(210, '/1/210/'),
(211, '/1/211/'),
(212, '/1/212/'),
(213, '/1/213/'),
(214, '/1/214/'),
(215, '/1/215/');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_criteria`
--

CREATE TABLE IF NOT EXISTS `definition_list_criteria` (
  `criteria_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `module_id` bigint(30) unsigned NOT NULL,
  `criteria_name` varchar(100) NOT NULL,
  `inactive` tinyint(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`criteria_id`),
  KEY `fk_criteria_created_user` (`created_by_userid`),
  KEY `fk_criteria_modified_user` (`last_modified_by_userid`),
  KEY `fk_criteria_module` (`module_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `definition_list_criteria`
--

INSERT INTO `definition_list_criteria` (`criteria_id`, `module_id`, `criteria_name`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, 3, 'Phân nhóm theo thời hạn lưu kho', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(2, 3, 'Phân nhóm theo điều kiện lưu kho', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(3, 1, 'Phân nhóm theo xuất xứ hàng mua', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 1, 'Phân nhóm theo điều kiện mua hàng', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_currency`
--

CREATE TABLE IF NOT EXISTS `definition_list_currency` (
  `currency_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `currency_code` char(3) NOT NULL,
  `currency_name` varchar(20) NOT NULL,
  `inactive` tinyint(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`currency_id`),
  KEY `fk_currency_created_user` (`created_by_userid`),
  KEY `fk_currency_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `definition_list_currency`
--

INSERT INTO `definition_list_currency` (`currency_id`, `currency_code`, `currency_name`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, '', '', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(1, 'VND', 'Tiền đồng Việt Nam', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(2, 'JPY', 'Tiền yên Nhật Bản', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

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
  `inactive` tinyint(1) NOT NULL,
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
(0, 0, '', '', '', 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(1, 1, 'KT', 'Kế toán', '', 0, 1, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(2, 1, 'KD', 'Kinh doanh', '', 1, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(3, 1, 'MH', 'Mua hàng', '', 0, 0, 1, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 1, 'KH', 'Kho hàng', '', 0, 0, 0, 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 1, 'GN', 'Giao nhận', '', 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(6, 1, 'HC', 'Hành chính nhân sự', '', 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

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
  `inactive` tinyint(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`factor_id`),
  KEY `fk_factor_created_user` (`created_by_userid`),
  KEY `fk_factor_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=81 ;

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
(23, 12, 'DMNT', 'Danh mục tiền tệ', 'accountant/maintenance/currency-catalog', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(24, 12, 'DMDT', 'Danh mục doanh thu', 'accountant/maintenance/revenue-catalog', 0, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(25, 12, 'DMCP', 'Danh mục chi phí', 'accountant/maintenance/expenditure-catalog', 0, 4, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(26, 13, 'HDMH', 'Hóa đơn mua hàng', 'accountant/purchase/buy-billing', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(27, 13, 'CNPR', 'Công nợ phải trả', 'accountant/purchase/owe-topay', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(28, 13, 'PBMH', 'Phân bổ chi phí', 'accountant/purchase/apportion-expenditure', 0, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(29, 14, 'HDBH', 'Hóa đơn bán hàng', 'accountant/sale/sale-billing', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(30, 14, 'HBTL', 'Hàng bán trả lại', 'accountant/sale/product-return', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(31, 14, 'GGHB', 'Giảm giá hàng bán', 'accountant/sale/product-saleoff', 0, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(32, 15, 'QLTK', 'Quản lý hàng tồn kho', 'accountant/inventory/stock-manage', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(33, 15, 'XLTT', 'Xử lý thừa thiếu kho', 'accountant/inventory/stock-clean', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(34, 15, 'TGXK', 'Tính giá xuất kho', 'accountant/inventory/output-price-product', 0, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(35, 16, 'QLPT', 'Quản lý phải thu', 'accountant/receivable/obtain-manage', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(36, 16, 'PTCN', 'Phiếu thu', 'accountant/receivable/obtain-letter', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(37, 16, 'GTPT', 'Giải trừ phải thu', 'accountant/receivable/obtain-resolve', 0, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(38, 17, 'QLPR', 'Quản lý phải trả', 'accountant/payable/payment-manage', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(39, 17, 'PCCN', 'Phiếu chi', 'accountant/payable/payment-letter', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(40, 17, 'GTPR', 'Giải trừ phải trả', 'accountant/payable/payment-resolve', 0, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(41, 18, 'QLNQ', 'Quản lý ngân quỹ', 'accountant/fund/fund-manage', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(42, 18, 'QLNL', 'Quản lý ngân lưu', 'accountant/fund/owe-manage', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(43, 19, 'KHTS', 'Khấu hao TSCĐ', 'accountant/asset/amortize-property', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(44, 20, 'CPTT', 'Chi phí trả trước', 'accountant/maintenance/expenditure-pay', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(45, 21, 'PHDK', 'Phiếu định khoản', 'accountant/general/account-letter', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
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
(76, 28, '', 'Sale Transaction', 'sale/transaction', 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(77, 12, 'LKKT', 'Thiết lập kỳ kế toán', 'accountant/maintenance/period-accounting', 0, 5, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(78, 12, 'DKTD', 'Thiết lập định khoản tự động', 'accountant/maintenance/auto-to-account', 0, 6, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(79, 12, 'DMT', 'Danh mục thuế', 'accountant/maintenance/tax-catalog', 0, 7, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(80, 12, 'TKHT', 'Thiết lập tài khoản hạch toán', 'accountant/maintenance/to-accounting', 0, 8, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_group`
--

CREATE TABLE IF NOT EXISTS `definition_list_group` (
  `group_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `criteria_id` bigint(30) unsigned NOT NULL,
  `group_parent_id` bigint(30) unsigned DEFAULT NULL,
  `group_code` varchar(10) NOT NULL,
  `group_name` varchar(100) NOT NULL,
  `group_note` varchar(100) NOT NULL,
  `inactive` tinyint(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`group_id`),
  KEY `fk_group_criteria` (`criteria_id`),
  KEY `fk_group_created_user` (`created_by_userid`),
  KEY `fk_group_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=10 ;

--
-- Dumping data for table `definition_list_group`
--

INSERT INTO `definition_list_group` (`group_id`, `criteria_id`, `group_parent_id`, `group_code`, `group_name`, `group_note`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, 1, NULL, '', '', '', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(2, 1, 1, 'VPP', 'Văn phòng phẩm', 'Không ảnh hưởng tới sức khỏe người tiêu dùng', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(3, 1, 1, 'TP', 'Thực phẩm', 'Ảnh hưởng trực tiếp đến sức khỏe người dùng', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 1, 1, 'KHC', 'Khác', 'Không xác định trước', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 1, 2, 'MHG', 'Mau hỏng', 'Chú ý thời hạn vì hàng mau hỏng', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(6, 1, 2, 'LHG', 'Lâu hỏng', 'Lâu hỏng hơn', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(7, 1, 3, 'NGH', 'Ngắn hạn', 'Thời hạn sử dụng ngắn', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(8, 1, 3, 'TRH', 'Trung hạn', 'Thời hạn sử dụng trung bình', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(9, 1, 3, 'DIH', 'Dài hạn', 'Thời hạn sử dụng dài', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_group_path`
--

CREATE TABLE IF NOT EXISTS `definition_list_group_path` (
  `group_id` bigint(30) unsigned NOT NULL,
  `path` text,
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `definition_list_group_path`
--

INSERT INTO `definition_list_group_path` (`group_id`, `path`) VALUES
(1, '/1/'),
(2, '/1/2/'),
(3, '/1/3/'),
(4, '/1/4/'),
(5, '/1/2/5/'),
(6, '/1/2/6/'),
(7, '/1/3/7/'),
(8, '/1/3/8/'),
(9, '/1/3/9/');

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
-- Table structure for table `definition_list_period`
--

CREATE TABLE IF NOT EXISTS `definition_list_period` (
  `period_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `subject_id` bigint(30) unsigned NOT NULL,
  `length` tinyint(2) unsigned NOT NULL,
  `month` tinyint(2) unsigned NOT NULL,
  `year` smallint(4) unsigned NOT NULL,
  `lock` tinyint(1) unsigned NOT NULL,
  `current` tinyint(1) unsigned NOT NULL,
  `inactive` tinyint(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`period_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `definition_list_period`
--

INSERT INTO `definition_list_period` (`period_id`, `subject_id`, `length`, `month`, `year`, `lock`, `current`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, 1, 3, 7, 2010, 0, 1, 0, 0, '2010-05-22 14:01:42', 0, '2010-05-22 14:01:42');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_product`
--

CREATE TABLE IF NOT EXISTS `definition_list_product` (
  `product_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `product_code` varchar(10) NOT NULL,
  `product_name` varchar(100) NOT NULL,
  `producer_id` bigint(30) unsigned NOT NULL,
  `product_model` varchar(100) NOT NULL,
  `product_picture` varchar(100) NOT NULL,
  `product_description` varchar(500) NOT NULL,
  `base_unit_id` bigint(30) unsigned NOT NULL,
  `regular_unit_id` bigint(30) unsigned NOT NULL,
  `inactive` tinyint(1) NOT NULL,
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `definition_list_product`
--

INSERT INTO `definition_list_product` (`product_id`, `product_code`, `product_name`, `producer_id`, `product_model`, `product_picture`, `product_description`, `base_unit_id`, `regular_unit_id`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, '111', 'máy vi tính', 0, '', '', '', 1, 1, 0, 0, '2010-05-21 23:04:42', 0, '2010-05-21 23:04:42'),
(2, '112', 'bút long', 0, '', '', '', 2, 2, 0, 0, '2010-05-21 23:04:50', 0, '2010-05-21 23:04:50'),
(3, '113', '', 0, '', '', '', 0, 0, 0, 0, '2010-05-21 23:04:54', 0, '2010-05-21 23:04:54'),
(4, '114', '', 0, '', '', '', 0, 0, 0, 0, '2010-05-21 23:04:59', 0, '2010-05-21 23:04:59'),
(5, '115', '', 0, '', '', '', 0, 0, 0, 0, '2010-05-21 23:05:03', 0, '2010-05-21 23:05:03'),
(6, '116', '', 0, '', '', '', 0, 0, 0, 0, '2010-05-21 23:05:08', 0, '2010-05-21 23:05:08'),
(7, '117', '', 0, '', '', '', 0, 0, 0, 0, '2010-05-21 23:05:47', 0, '2010-05-21 23:05:47'),
(8, '118', '', 0, '', '', '', 0, 0, 0, 0, '2010-05-21 23:05:52', 0, '2010-05-21 23:05:52');

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
  `inactive` tinyint(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`property_id`),
  KEY `fk_property_factor` (`factor_id`),
  KEY `fk_property_created_user` (`created_by_userid`),
  KEY `fk_property_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `definition_list_property`
--


-- --------------------------------------------------------

--
-- Table structure for table `definition_list_rank`
--

CREATE TABLE IF NOT EXISTS `definition_list_rank` (
  `rank_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `term_id` bigint(30) unsigned NOT NULL,
  `rank_parent_id` bigint(30) unsigned DEFAULT NULL,
  `rank_name` varchar(100) NOT NULL,
  `inactive` tinyint(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`rank_id`),
  KEY `fk_rank_term` (`term_id`),
  KEY `fk_rank_created_user` (`created_by_userid`),
  KEY `fk_rank_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `definition_list_rank`
--


-- --------------------------------------------------------

--
-- Table structure for table `definition_list_rank_path`
--

CREATE TABLE IF NOT EXISTS `definition_list_rank_path` (
  `rank_id` bigint(30) unsigned NOT NULL,
  `path` text,
  PRIMARY KEY (`rank_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `definition_list_rank_path`
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
  `inactive` tinyint(1) NOT NULL,
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
(0, 0, 'VTM', 'Toàn quyền', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

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
  `inactive` tinyint(1) NOT NULL,
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
(0, 0, 'VTM', 'Nhân viên', '', 'VTM', '1900-01-01 00:00:00', '', '', '1900-01-01 00:00:00', '', '', '', '', '', '', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

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
  `currency_id` bigint(30) unsigned NOT NULL,
  `is_software_user` tinyint(1) NOT NULL,
  `is_producer` tinyint(1) NOT NULL,
  `is_supplier` tinyint(1) NOT NULL,
  `is_customer` tinyint(1) NOT NULL,
  `is_government` tinyint(1) NOT NULL,
  `is_bank` tinyint(1) NOT NULL,
  `inactive` tinyint(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`subject_id`),
  KEY `fk_subject_modified_user` (`last_modified_by_userid`),
  KEY `fk_subject_created_user` (`created_by_userid`),
  KEY `fk_subject_currency` (`currency_id`),
  KEY `sk_subject_supplier` (`is_supplier`),
  KEY `sk_subject_user` (`is_software_user`),
  KEY `sk_subject_customer` (`is_customer`),
  KEY `sk_subject_producer` (`is_producer`),
  KEY `sk_subject_government` (`is_government`),
  KEY `sk_subject_bank` (`is_bank`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `definition_list_subject`
--

INSERT INTO `definition_list_subject` (`subject_id`, `subject_code`, `subject_name`, `subject_address`, `subject_tax_code`, `currency_id`, `is_software_user`, `is_producer`, `is_supplier`, `is_customer`, `is_government`, `is_bank`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, '', '', '', '', 0, 0, 1, 1, 1, 1, 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(1, 'N2H', 'Công ty Nhanh Nhanh', '', '', 1, 1, 0, 1, 1, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(2, 'ACB', 'Ngân hàng TMCP Á Châu', 'Nguyễn Thị Minh Khai', '0000', 1, 0, 0, 0, 0, 0, 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(3, 'VCB', 'Ngân hàng TM Ngoại thương', 'Bến Chương Dương', '1111', 1, 0, 0, 0, 0, 0, 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 'EAB', 'Ngân hàng TMCP Đông Á', 'Nguyễn Công Trứ', '2222', 1, 0, 0, 0, 0, 0, 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 'MAGX', 'Magx Japan', 'Tokyo', '2312312312', 2, 0, 0, 1, 0, 0, 0, 0, 0, '2010-05-22 00:09:37', 0, '2010-05-22 00:09:41');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_table`
--

CREATE TABLE IF NOT EXISTS `definition_list_table` (
  `table_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `table_name` varchar(50) NOT NULL,
  `column_name` varchar(50) CHARACTER SET latin1 NOT NULL,
  `description` varchar(100) NOT NULL,
  `inactive` tinyint(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`table_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=18 ;

--
-- Dumping data for table `definition_list_table`
--

INSERT INTO `definition_list_table` (`table_id`, `table_name`, `column_name`, `description`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, 'definition_list_currency', '', 'Chi tiết theo loại tiền tệ', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(2, 'definition_list_department', '', 'Chi tiết theo phòng ban', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(3, 'definition_list_product', '', 'Chi tiết theo sản phẩm', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 'definition_list_staff', '', 'Chi tiết theo nhân viên', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 'definition_list_subject', 'is_bank', 'Chi tiết theo ngân hàng', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(6, 'definition_list_subject', 'is_supplier', 'Chi tiết theo nhà cung cấp', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(7, 'definition_list_subject', 'is_customer', 'Chi tiết theo khách hàng', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(8, 'accountant_list_expense', 'for_wage', 'Chi tiết theo chi phí nhân công, nhân viên', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(9, 'accountant_list_expense', 'for_tool', 'Chi tiết theo chi phí dụng cụ, đồ dùng', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(10, 'accountant_list_expense', 'for_depreciation', 'Chi tiết theo chi phí khấu hao', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(11, 'accountant_list_expense', 'for_services', 'Chi tiết theo chi phí dịch vụ mua ngoài', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(12, 'accountant_list_expense', 'for_rest', 'Chi tiết theo chi phí khác', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(13, 'accountant_list_expense', 'for_sales', 'Chi tiết theo chi phí bán hàng', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(14, 'accountant_list_expense', 'for_management', 'Chi tiết theo chi phí quản lý', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(15, 'accountant_list_expense', 'for_fee', 'Chi tiết theo thuế, phí, lệ phí', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(16, 'accountant_list_expense', 'finance_cost', 'Chi tiết theo chi phí tài chính', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(17, 'definition_list_unit', '', 'Chi tiết theo đơn vị tính', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_term`
--

CREATE TABLE IF NOT EXISTS `definition_list_term` (
  `term_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `term_name` varchar(100) NOT NULL,
  `inactive` tinyint(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`term_id`),
  KEY `fk_term_created_user` (`created_by_userid`),
  KEY `fk_term_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `definition_list_term`
--


-- --------------------------------------------------------

--
-- Table structure for table `definition_list_unit`
--

CREATE TABLE IF NOT EXISTS `definition_list_unit` (
  `unit_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `unit_code` varchar(10) NOT NULL,
  `unit_name` varchar(100) NOT NULL,
  `inactive` tinyint(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`unit_id`),
  KEY `fk_unit_created_user` (`created_by_userid`),
  KEY `fk_unit_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `definition_list_unit`
--

INSERT INTO `definition_list_unit` (`unit_id`, `unit_code`, `unit_name`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, '', '', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(1, 'cái', 'cái', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(2, 'm', 'mét', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(3, 'kg', 'kí lô gam', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

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
  `inactive` tinyint(1) NOT NULL,
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
(0, 0, 0, 'nguoi_dung', '', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

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
  `default_purchase_price` decimal(18,4) NOT NULL,
  `default_inventory_price` decimal(18,4) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`product_id`,`unit_id`),
  KEY `fk_relation_unit` (`unit_id`),
  KEY `fk_product_unit_created_user` (`created_by_userid`),
  KEY `fk_product_unit_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `definition_relation_product_unit`
--

INSERT INTO `definition_relation_product_unit` (`product_id`, `unit_id`, `sku_number`, `coefficient`, `default_sales_price`, `default_purchase_price`, `default_inventory_price`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, 1, 'SKU1', '1.0000', '2000.0000', '1000.0000', '1500.0000', 0, '2010-05-22 00:15:54', 0, '2010-05-22 00:15:57'),
(2, 2, 'SKU2', '2.0000', '20000000.0000', '25000000.0000', '20000000.0000', 0, '2010-05-22 00:17:26', 0, '2010-05-22 00:17:30');

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

-- --------------------------------------------------------

--
-- Table structure for table `purchase_detail_order`
--

CREATE TABLE IF NOT EXISTS `purchase_detail_order` (
  `purchase_order_id` bigint(30) unsigned NOT NULL,
  `product_id` bigint(30) unsigned NOT NULL,
  `unit_id` decimal(30,0) unsigned NOT NULL,
  `quantity` decimal(18,4) NOT NULL,
  `converted_quantity` decimal(18,4) NOT NULL,
  `price` decimal(18,4) NOT NULL,
  `amount` decimal(18,4) NOT NULL,
  `converted_amount` decimal(18,4) NOT NULL,
  `note` varchar(100) NOT NULL,
  PRIMARY KEY (`purchase_order_id`,`product_id`,`unit_id`),
  KEY `fk_purchase_order_product` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `purchase_detail_order`
--


-- --------------------------------------------------------

--
-- Table structure for table `purchase_transaction_order`
--

CREATE TABLE IF NOT EXISTS `purchase_transaction_order` (
  `purchase_order_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `period_id` bigint(30) unsigned NOT NULL,
  `order_number` varchar(100) NOT NULL,
  `order_date` datetime NOT NULL,
  `delivery_date` datetime NOT NULL,
  `payment_date` datetime NOT NULL,
  `supplier_id` bigint(30) unsigned NOT NULL,
  `currency_id` bigint(30) unsigned NOT NULL,
  `forex_rate` decimal(18,4) NOT NULL,
  `description` varchar(500) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`purchase_order_id`),
  KEY `fk_purchase_order_supplier` (`supplier_id`),
  KEY `fk_purchase_order_currency` (`currency_id`),
  KEY `fk_purchase_order_created_user` (`created_by_userid`),
  KEY `fk_purchase_order_modified_user` (`last_modified_by_userid`),
  KEY `fk_purchase_order_period` (`period_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `purchase_transaction_order`
--


--
-- Constraints for dumped tables
--

--
-- Constraints for table `accountant_detail_correspondence`
--
ALTER TABLE `accountant_detail_correspondence`
  ADD CONSTRAINT `fk_detail_correspondence` FOREIGN KEY (`correspondence_id`) REFERENCES `accountant_transaction_correspondence` (`correspondence_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_correspondence_table` FOREIGN KEY (`table_id`) REFERENCES `definition_list_table` (`table_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_detail_entry`
--
ALTER TABLE `accountant_detail_entry`
  ADD CONSTRAINT `fk_detail_entry` FOREIGN KEY (`entry_id`) REFERENCES `accountant_transaction_entry` (`entry_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_entry_table` FOREIGN KEY (`table_id`) REFERENCES `definition_list_table` (`table_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_detail_purchase`
--
ALTER TABLE `accountant_detail_purchase`
  ADD CONSTRAINT `fk_detail_purchase` FOREIGN KEY (`purchase_invoice_id`) REFERENCES `accountant_purchase_invoice` (`purchase_invoice_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_purchase_import_rate` FOREIGN KEY (`import_rate_id`) REFERENCES `accountant_tax_rate` (`tax_rate_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_purchase_product` FOREIGN KEY (`product_id`) REFERENCES `definition_list_product` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_list_expense`
--
ALTER TABLE `accountant_list_expense`
  ADD CONSTRAINT `fk_expense_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_expense_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_list_specification`
--
ALTER TABLE `accountant_list_specification`
  ADD CONSTRAINT `fk_specification_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_specification_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_list_turnover`
--
ALTER TABLE `accountant_list_turnover`
  ADD CONSTRAINT `fk_turnover_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_turnover_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_purchase_invoice`
--
ALTER TABLE `accountant_purchase_invoice`
  ADD CONSTRAINT `fk_purchase_invoice_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_invoice_currency` FOREIGN KEY (`currency_id`) REFERENCES `definition_list_currency` (`currency_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_invoice_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_invoice_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `definition_list_subject` (`subject_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_invoice_voucher` FOREIGN KEY (`voucher_id`) REFERENCES `accountant_transaction_voucher` (`voucher_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_relation_tax`
--
ALTER TABLE `accountant_relation_tax`
  ADD CONSTRAINT `fk_realtion_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_relation_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_relation_tax_product` FOREIGN KEY (`product_id`) REFERENCES `definition_list_product` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_relation_tax_rate` FOREIGN KEY (`tax_rate_id`) REFERENCES `accountant_tax_rate` (`tax_rate_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_relation_tax_specification` FOREIGN KEY (`specification_id`) REFERENCES `accountant_list_specification` (`specification_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_relation_tax_tax` FOREIGN KEY (`tax_id`) REFERENCES `accountant_list_tax` (`tax_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_tax_rate`
--
ALTER TABLE `accountant_tax_rate`
  ADD CONSTRAINT `fk_tax_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tax_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tax_rate` FOREIGN KEY (`tax_id`) REFERENCES `accountant_list_tax` (`tax_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_transaction_batch`
--
ALTER TABLE `accountant_transaction_batch`
  ADD CONSTRAINT `fk_accountant_batch_execution` FOREIGN KEY (`execution_id`) REFERENCES `definition_list_execution` (`execution_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_accountant_batch_voucher` FOREIGN KEY (`voucher_id`) REFERENCES `accountant_transaction_voucher` (`voucher_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_transaction_correspondence`
--
ALTER TABLE `accountant_transaction_correspondence`
  ADD CONSTRAINT `fk_accountant_correspondence_account` FOREIGN KEY (`detail_account_id`) REFERENCES `definition_list_account` (`account_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_accountant_correspondence_currency` FOREIGN KEY (`currency_id`) REFERENCES `definition_list_currency` (`currency_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_accountant_correspondence_entry` FOREIGN KEY (`entry_id`) REFERENCES `accountant_transaction_entry` (`entry_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_transaction_entry`
--
ALTER TABLE `accountant_transaction_entry`
  ADD CONSTRAINT `fk_accountant_entry_account` FOREIGN KEY (`master_account_id`) REFERENCES `definition_list_account` (`account_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_accountant_entry_batch` FOREIGN KEY (`batch_id`) REFERENCES `accountant_transaction_batch` (`batch_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_accountant_entry_currency` FOREIGN KEY (`currency_id`) REFERENCES `definition_list_currency` (`currency_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_transaction_voucher`
--
ALTER TABLE `accountant_transaction_voucher`
  ADD CONSTRAINT `fk_accountant_voucher_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_accountant_voucher_execution` FOREIGN KEY (`execution_id`) REFERENCES `definition_list_execution` (`execution_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_accountant_voucher_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

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
  ADD CONSTRAINT `fk_detail_account` FOREIGN KEY (`account_id`) REFERENCES `definition_list_account` (`account_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_account_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_account_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_account_table` FOREIGN KEY (`table_id`) REFERENCES `definition_list_table` (`table_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_detail_currency`
--
ALTER TABLE `definition_detail_currency`
  ADD CONSTRAINT `fk_detail_currency_base` FOREIGN KEY (`base_currency_id`) REFERENCES `definition_list_currency` (`currency_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_currency_convert` FOREIGN KEY (`convert_currency_id`) REFERENCES `definition_list_currency` (`currency_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_currency_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_currency_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_detail_group`
--
ALTER TABLE `definition_detail_group`
  ADD CONSTRAINT `fk_detail_group` FOREIGN KEY (`group_id`) REFERENCES `definition_list_group` (`group_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_group_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_group_criteria` FOREIGN KEY (`criteria_id`) REFERENCES `definition_list_criteria` (`criteria_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_group_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_group_product` FOREIGN KEY (`product_id`) REFERENCES `definition_list_product` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_detail_property`
--
ALTER TABLE `definition_detail_property`
  ADD CONSTRAINT `fk_detail_property` FOREIGN KEY (`property_id`) REFERENCES `definition_list_property` (`property_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_property_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_property_factor` FOREIGN KEY (`factor_id`) REFERENCES `definition_list_factor` (`factor_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_property_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_property_product` FOREIGN KEY (`product_id`) REFERENCES `definition_list_product` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_detail_rank`
--
ALTER TABLE `definition_detail_rank`
  ADD CONSTRAINT `fk_detail_rank` FOREIGN KEY (`rank_id`) REFERENCES `definition_list_rank` (`rank_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_rank_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_rank_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_rank_subject` FOREIGN KEY (`subject_id`) REFERENCES `definition_list_subject` (`subject_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_rank_term` FOREIGN KEY (`term_id`) REFERENCES `definition_list_term` (`term_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_account`
--
ALTER TABLE `definition_list_account`
  ADD CONSTRAINT `fk_account_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_account_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_account_path`
--
ALTER TABLE `definition_list_account_path`
  ADD CONSTRAINT `definition_list_account_path_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `definition_list_account` (`account_id`);

--
-- Constraints for table `definition_list_criteria`
--
ALTER TABLE `definition_list_criteria`
  ADD CONSTRAINT `fk_criteria_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_criteria_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_criteria_module` FOREIGN KEY (`module_id`) REFERENCES `definition_list_module` (`module_id`) ON DELETE CASCADE ON UPDATE CASCADE;

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
  ADD CONSTRAINT `fk_factor_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_factor_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

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
  ADD CONSTRAINT `fk_group_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_group_criteria` FOREIGN KEY (`criteria_id`) REFERENCES `definition_list_criteria` (`criteria_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_group_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_group_path`
--
ALTER TABLE `definition_list_group_path`
  ADD CONSTRAINT `fk_group_path` FOREIGN KEY (`group_id`) REFERENCES `definition_list_group` (`group_id`) ON DELETE CASCADE ON UPDATE CASCADE;

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
  ADD CONSTRAINT `fk_property_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_property_factor` FOREIGN KEY (`factor_id`) REFERENCES `definition_list_factor` (`factor_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_property_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_rank`
--
ALTER TABLE `definition_list_rank`
  ADD CONSTRAINT `fk_rank_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_rank_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_rank_term` FOREIGN KEY (`term_id`) REFERENCES `definition_list_term` (`term_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_rank_path`
--
ALTER TABLE `definition_list_rank_path`
  ADD CONSTRAINT `fk_rank_path` FOREIGN KEY (`rank_id`) REFERENCES `definition_list_rank` (`rank_id`) ON DELETE CASCADE ON UPDATE CASCADE;

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
  ADD CONSTRAINT `fk_staff_department` FOREIGN KEY (`department_id`) REFERENCES `definition_list_department` (`department_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_staff_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_subject`
--
ALTER TABLE `definition_list_subject`
  ADD CONSTRAINT `fk_subject_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_subject_currency` FOREIGN KEY (`currency_id`) REFERENCES `definition_list_currency` (`currency_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_subject_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_term`
--
ALTER TABLE `definition_list_term`
  ADD CONSTRAINT `fk_term_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_term_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_unit`
--
ALTER TABLE `definition_list_unit`
  ADD CONSTRAINT `fk_unit_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_unit_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_user`
--
ALTER TABLE `definition_list_user`
  ADD CONSTRAINT `fk_user_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_role` FOREIGN KEY (`role_id`) REFERENCES `definition_list_role` (`role_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_staff` FOREIGN KEY (`staff_id`) REFERENCES `definition_list_staff` (`staff_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_relation_product_unit`
--
ALTER TABLE `definition_relation_product_unit`
  ADD CONSTRAINT `fk_product_unit_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_product_unit_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_relation_product` FOREIGN KEY (`product_id`) REFERENCES `definition_list_product` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_relation_unit` FOREIGN KEY (`unit_id`) REFERENCES `definition_list_unit` (`unit_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_relation_role_function`
--
ALTER TABLE `definition_relation_role_function`
  ADD CONSTRAINT `fk_function_role_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_function_role_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_relation_function` FOREIGN KEY (`function_id`) REFERENCES `definition_list_function` (`function_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_relation_role` FOREIGN KEY (`role_id`) REFERENCES `definition_list_role` (`role_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `purchase_detail_order`
--
ALTER TABLE `purchase_detail_order`
  ADD CONSTRAINT `fk_detail_purchase_order` FOREIGN KEY (`purchase_order_id`) REFERENCES `purchase_transaction_order` (`purchase_order_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_order_product` FOREIGN KEY (`product_id`) REFERENCES `definition_list_product` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `purchase_transaction_order`
--
ALTER TABLE `purchase_transaction_order`
  ADD CONSTRAINT `fk_purchase_order_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_order_currency` FOREIGN KEY (`currency_id`) REFERENCES `definition_list_currency` (`currency_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_order_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_order_period` FOREIGN KEY (`period_id`) REFERENCES `definition_list_period` (`period_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_order_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `definition_list_subject` (`subject_id`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
