-- phpMyAdmin SQL Dump
-- version 3.2.0.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Sep 14, 2010 at 12:12 PM
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
-- Table structure for table `accountant_account_balance`
--

DROP TABLE IF EXISTS `accountant_account_balance`;
CREATE TABLE IF NOT EXISTS `accountant_account_balance` (
  `period_id` bigint(30) unsigned NOT NULL,
  `account_id` bigint(30) unsigned NOT NULL,
  `currency_id` bigint(30) unsigned NOT NULL,
  `debit_credit` tinyint(1) NOT NULL COMMENT 'thể hiện số dư của tài khoản là bên nợ (-1) hay bên có (1)',
  `original_amount` decimal(18,4) NOT NULL,
  `converted_amount` decimal(18,4) NOT NULL,
  PRIMARY KEY (`period_id`,`account_id`,`currency_id`),
  KEY `fk_account_balance_account` (`account_id`),
  KEY `fk_account_balance_currency` (`currency_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `accountant_account_balance`
--

INSERT INTO `accountant_account_balance` (`period_id`, `account_id`, `currency_id`, `debit_credit`, `original_amount`, `converted_amount`) VALUES
(1, 3, 1, 1, '358359.0000', '358359.0000'),
(1, 3, 3, 1, '2981877.0000', '5665565.0000'),
(1, 21, 1, -1, '976507.0000', '976507.0000'),
(1, 21, 3, -1, '284400.0000', '540360.0000'),
(1, 22, 1, -1, '434374.0000', '434374.0000'),
(1, 25, 1, -1, '1147511.0000', '1147511.0000'),
(1, 25, 3, -1, '841508.0000', '1598866.0000'),
(1, 26, 3, -1, '841508.0000', '1598866.0000'),
(1, 32, 1, -1, '-196995.0000', '-196995.0000'),
(1, 34, 3, -1, '-196995.0000', '-196995.0000'),
(1, 44, 1, 1, '-110121.0000', '-110121.0000'),
(1, 44, 3, 1, '-1925230.0000', '-3657936.0000'),
(1, 47, 1, 1, '2750276.0000', '2750276.0000'),
(1, 47, 3, 1, '-1056647.0000', '-2007629.0000'),
(1, 49, 1, 1, '-1056647.0000', '-2007629.0000'),
(1, 50, 1, 1, '-2124019.0000', '-2124019.0000'),
(1, 50, 3, 1, '-1125908.0000', '-2139226.0000'),
(1, 51, 3, 1, '-1125908.0000', '-2139226.0000'),
(1, 59, 3, 1, '-1125908.0000', '-2139226.0000'),
(1, 65, 1, -1, '1148236.0000', '1148236.0000'),
(1, 87, 1, 1, '-206845.0000', '-206845.0000'),
(1, 88, 1, 1, '941391.0000', '941391.0000'),
(1, 89, 1, 1, '941391.0000', '941391.0000'),
(1, 93, 1, 1, '941391.0000', '941391.0000');

-- --------------------------------------------------------

--
-- Table structure for table `accountant_assets_depreciation`
--

DROP TABLE IF EXISTS `accountant_assets_depreciation`;
CREATE TABLE IF NOT EXISTS `accountant_assets_depreciation` (
  `assets_voucher_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `depreciation_date` datetime NOT NULL,
  `voucher_id` bigint(30) unsigned NOT NULL COMMENT 'Quan h? m?t - m?t v?i b?ng accountant_transaction_voucher',
  `depreciation_note` varchar(100) NOT NULL,
  `depreciation_amount` decimal(18,4) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`assets_voucher_id`,`depreciation_date`),
  KEY `fk_depreciation_voucher` (`voucher_id`),
  KEY `fk_depreciation_created_user` (`created_by_userid`),
  KEY `fk_depreciation_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `accountant_assets_depreciation`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_assets_voucher`
--

DROP TABLE IF EXISTS `accountant_assets_voucher`;
CREATE TABLE IF NOT EXISTS `accountant_assets_voucher` (
  `assets_voucher_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `voucher_id` bigint(30) unsigned NOT NULL COMMENT 'Quan h? m?t - m?t v?i b?ng accountant_transaction_voucher',
  `assets_code` varchar(10) NOT NULL,
  `assets_name` varchar(100) NOT NULL,
  `assets_description` varchar(500) NOT NULL DEFAULT '',
  `purchase_date` datetime NOT NULL,
  `supplier_id` bigint(30) unsigned NOT NULL,
  `gross_cost` decimal(18,0) NOT NULL,
  `currency_id` bigint(30) unsigned NOT NULL,
  `forex_rate` decimal(18,4) NOT NULL,
  `converted_gross_cost` decimal(18,4) NOT NULL,
  `net_book_value` decimal(18,0) NOT NULL,
  `estimated_useful_lifetime` tinyint(3) unsigned NOT NULL,
  `depreciation_periods` tinyint(2) unsigned NOT NULL,
  `is_locked` tinyint(1) unsigned NOT NULL COMMENT 'Dùng để xác định tình trạng cho phép chỉnh sửa hay không của Phiếu định khoản tài sản cố định',
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`assets_voucher_id`),
  KEY `fk_assets_voucher` (`voucher_id`),
  KEY `fk_assets_supplier` (`supplier_id`),
  KEY `fk_assets_currency` (`currency_id`),
  KEY `fk_assets_created_user` (`created_by_userid`),
  KEY `fk_assets_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `accountant_assets_voucher`
--

INSERT INTO `accountant_assets_voucher` (`assets_voucher_id`, `voucher_id`, `assets_code`, `assets_name`, `assets_description`, `purchase_date`, `supplier_id`, `gross_cost`, `currency_id`, `forex_rate`, `converted_gross_cost`, `net_book_value`, `estimated_useful_lifetime`, `depreciation_periods`, `is_locked`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, 0, '', '', '', '1900-01-01 00:00:00', 0, '0', 0, '0.0000', '0.0000', '0', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `accountant_auto_batch`
--

DROP TABLE IF EXISTS `accountant_auto_batch`;
CREATE TABLE IF NOT EXISTS `accountant_auto_batch` (
  `auto_batch_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT COMMENT 'bó bút toán',
  `is_closing_batch` tinyint(1) unsigned NOT NULL,
  `batch_order` tinyint(3) unsigned NOT NULL,
  `execution_id` bigint(30) unsigned NOT NULL COMMENT 'khác với phần hành của voucher, phần hành này thể hiện nơi mà bút toán thuộc về, bắt buộc phải thuộc phân hệ kế toán',
  `batch_note` varchar(300) NOT NULL,
  PRIMARY KEY (`auto_batch_id`),
  KEY `fk_auto_bath_execution` (`execution_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `accountant_auto_batch`
--

INSERT INTO `accountant_auto_batch` (`auto_batch_id`, `is_closing_batch`, `batch_order`, `execution_id`, `batch_note`) VALUES
(8, 1, 1, 13, 'Kết chuyển 1');

-- --------------------------------------------------------

--
-- Table structure for table `accountant_auto_correspondence`
--

DROP TABLE IF EXISTS `accountant_auto_correspondence`;
CREATE TABLE IF NOT EXISTS `accountant_auto_correspondence` (
  `auto_correspondence_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `auto_entry_id` bigint(30) unsigned NOT NULL,
  `detail_account_id` bigint(30) unsigned NOT NULL COMMENT 'tài khoản bên một trong quan hệ một - nhiều',
  `debit_credit` tinyint(1) NOT NULL COMMENT 'thể hiện tài khoản bên một là bên nợ (-1) hay bên có (1)',
  `original_amount` decimal(18,4) NOT NULL,
  PRIMARY KEY (`auto_correspondence_id`),
  KEY `fk_auto_correspondence_entry` (`auto_entry_id`),
  KEY `fk_auto_correspondence_account` (`detail_account_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=33 ;

--
-- Dumping data for table `accountant_auto_correspondence`
--

INSERT INTO `accountant_auto_correspondence` (`auto_correspondence_id`, `auto_entry_id`, `detail_account_id`, `debit_credit`, `original_amount`) VALUES
(32, 21, 21, 1, '0.0000');

-- --------------------------------------------------------

--
-- Table structure for table `accountant_auto_entry`
--

DROP TABLE IF EXISTS `accountant_auto_entry`;
CREATE TABLE IF NOT EXISTS `accountant_auto_entry` (
  `auto_entry_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `auto_batch_id` bigint(30) unsigned NOT NULL,
  `master_account_id` bigint(30) unsigned NOT NULL COMMENT 'tài khoản bên một trong quan hệ một - nhiều',
  `debit_credit` tinyint(1) NOT NULL COMMENT 'thể hiện tài khoản bên một là bên nợ (-1) hay bên có (1)',
  `original_amount` decimal(18,4) NOT NULL,
  `currency_id` bigint(30) unsigned NOT NULL,
  PRIMARY KEY (`auto_entry_id`),
  KEY `fk_auto_entry_batch` (`auto_batch_id`),
  KEY `fk_auto_entry_account` (`master_account_id`),
  KEY `fk_auto_entry_currency` (`currency_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=22 ;

--
-- Dumping data for table `accountant_auto_entry`
--

INSERT INTO `accountant_auto_entry` (`auto_entry_id`, `auto_batch_id`, `master_account_id`, `debit_credit`, `original_amount`, `currency_id`) VALUES
(21, 8, 50, -1, '0.0000', 1);

-- --------------------------------------------------------

--
-- Table structure for table `accountant_bank_account`
--

DROP TABLE IF EXISTS `accountant_bank_account`;
CREATE TABLE IF NOT EXISTS `accountant_bank_account` (
  `bank_account_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `bank_id` bigint(30) unsigned NOT NULL,
  `bank_account_number` varchar(100) NOT NULL,
  `bank_account_value_date` datetime NOT NULL,
  `currency_id` bigint(30) unsigned NOT NULL,
  `bank_account_period` tinyint(2) unsigned NOT NULL,
  `interest_per_annual` decimal(5,2) unsigned NOT NULL,
  `inactive` tinyint(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`bank_account_id`),
  KEY `fk_bank_account_bank` (`bank_id`),
  KEY `fk_bank_account_currency` (`currency_id`),
  KEY `fk_bank_account_created_user` (`created_by_userid`),
  KEY `fk_bank_account_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `accountant_bank_account`
--

INSERT INTO `accountant_bank_account` (`bank_account_id`, `bank_id`, `bank_account_number`, `bank_account_value_date`, `currency_id`, `bank_account_period`, `interest_per_annual`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, 0, '', '0000-00-00 00:00:00', 0, 0, '0.00', 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(1, 2, 'TKNH2', '2010-08-05 10:54:42', 1, 0, '0.00', 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(2, 3, 'TKNH3', '2010-08-05 10:55:08', 3, 0, '0.00', 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `accountant_cash_voucher`
--

DROP TABLE IF EXISTS `accountant_cash_voucher`;
CREATE TABLE IF NOT EXISTS `accountant_cash_voucher` (
  `cash_voucher_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Mã chứng từ',
  `voucher_type_id` bigint(30) unsigned NOT NULL COMMENT 'Mã loại chứng từ',
  `voucher_id` bigint(30) unsigned NOT NULL COMMENT 'Quan hệ một - một với bảng accountant_transaction_voucher',
  `cash_voucher_number` varchar(30) NOT NULL COMMENT 'Số chứng từ',
  `cash_voucher_date` datetime NOT NULL COMMENT 'Ngày chứng từ',
  `subject_id` bigint(30) unsigned NOT NULL COMMENT 'Mã đơn vị',
  `subject_name` varchar(100) NOT NULL COMMENT 'Tên đơn vị',
  `subject_address` varchar(100) NOT NULL COMMENT 'Địa chỉ đơn vị',
  `subject_contact` varchar(100) NOT NULL COMMENT 'Người nộp tiền trong trường hợp thu, người nhận tiền trong trường hợp chi',
  `staff_id` bigint(30) unsigned NOT NULL COMMENT 'Nhân viên',
  `department_id` bigint(30) unsigned NOT NULL COMMENT 'Bộ phận',
  `debit_credit_account_id` bigint(30) NOT NULL,
  `in_bank_id` bigint(30) unsigned NOT NULL COMMENT 'Ngân hàng thu',
  `in_bank_account_id` bigint(30) unsigned NOT NULL COMMENT 'Tài khoản ngân hàng thu',
  `out_bank_id` bigint(30) unsigned NOT NULL COMMENT 'Ngân hàng chi',
  `out_bank_account_id` bigint(30) unsigned NOT NULL COMMENT 'Tài khoản ngân hàng chi',
  `turnover_id` bigint(30) NOT NULL,
  `expense_id` bigint(30) unsigned NOT NULL COMMENT 'Loại chi phí',
  `amount` decimal(18,4) NOT NULL COMMENT 'tổng nguyên tệ của chi tiết',
  `currency_id` bigint(30) unsigned NOT NULL COMMENT 'loại tiền tệ',
  `forex_rate` decimal(18,4) NOT NULL COMMENT 'tỷ giá qui đổi',
  `converted_amount` decimal(18,4) NOT NULL COMMENT 'Thành tiền qui đổi',
  `in_out` tinyint(1) unsigned NOT NULL COMMENT 'Phiếu thu 1, phiếu chi 2, chuyển khoản 3',
  `description` varchar(500) NOT NULL COMMENT 'Lý do thu tiền',
  `is_locked` tinyint(1) unsigned NOT NULL COMMENT 'Dùng để xác định tình trạng cho phép chỉnh sửa hay không của Phiếu định khoản tiền',
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`cash_voucher_id`),
  KEY `fk_cash_voucher` (`voucher_id`),
  KEY `fk_cash_subject` (`subject_id`),
  KEY `fk_cash_currency` (`currency_id`),
  KEY `fk_cash_created_user` (`created_by_userid`),
  KEY `fk_cash_modified_user` (`last_modified_by_userid`),
  KEY `fk_cash_in_bank` (`in_bank_id`),
  KEY `fk_cash_in_bank_account` (`in_bank_account_id`),
  KEY `fk_cash_out_bank` (`out_bank_id`),
  KEY `fk_cash_out_bank_account` (`out_bank_account_id`),
  KEY `fk_cash_staff` (`staff_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `accountant_cash_voucher`
--

INSERT INTO `accountant_cash_voucher` (`cash_voucher_id`, `voucher_type_id`, `voucher_id`, `cash_voucher_number`, `cash_voucher_date`, `subject_id`, `subject_name`, `subject_address`, `subject_contact`, `staff_id`, `department_id`, `debit_credit_account_id`, `in_bank_id`, `in_bank_account_id`, `out_bank_id`, `out_bank_account_id`, `turnover_id`, `expense_id`, `amount`, `currency_id`, `forex_rate`, `converted_amount`, `in_out`, `description`, `is_locked`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, 0, 0, '', '0000-00-00 00:00:00', 0, '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '0.0000', 0, '0.0000', '0.0000', 0, '', 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(2, 0, 0, 'CVN0001', '2010-08-04 14:48:04', 3, 'Công ty Nhanh Nhanh', 'Thu Duc', 'chị ngân', 3, 1, 0, 0, 0, 1, 1, 0, 0, '5000950.5500', 3, '1.4700', '254000558.0000', 2, '', 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(3, 0, 0, 'CVN0002', '2010-08-18 14:35:10', 10, 'Hợp Tác Xã Vận Tải Số 10', '100 Hùng Vương, P9, Q5', '', 4, 0, 0, 0, 0, 3, 2, 0, 0, '9578000.0000', 3, '1.6900', '16186820.0000', 2, '', 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `accountant_detail_correspondence`
--

DROP TABLE IF EXISTS `accountant_detail_correspondence`;
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

DROP TABLE IF EXISTS `accountant_detail_entry`;
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
-- Table structure for table `accountant_detail_inventory`
--

DROP TABLE IF EXISTS `accountant_detail_inventory`;
CREATE TABLE IF NOT EXISTS `accountant_detail_inventory` (
  `inventory_voucher_id` bigint(30) unsigned NOT NULL,
  `product_id` bigint(30) unsigned NOT NULL,
  `unit_id` bigint(30) unsigned NOT NULL,
  `in_voucher_id` bigint(30) unsigned NOT NULL,
  `quantity` decimal(18,4) NOT NULL,
  `converted_quantity` decimal(18,4) NOT NULL,
  `price` decimal(18,4) NOT NULL,
  `amount` decimal(18,4) NOT NULL,
  `converted_amount` decimal(18,4) NOT NULL,
  `note` varchar(100) NOT NULL,
  PRIMARY KEY (`inventory_voucher_id`,`product_id`,`unit_id`),
  KEY `fk_detail_inventory_product` (`product_id`),
  KEY `fk_detail_inventory_unit` (`unit_id`),
  KEY `fk_detail_inventory_in` (`in_voucher_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `accountant_detail_inventory`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_detail_purchase`
--

DROP TABLE IF EXISTS `accountant_detail_purchase`;
CREATE TABLE IF NOT EXISTS `accountant_detail_purchase` (
  `purchase_invoice_id` bigint(30) unsigned NOT NULL,
  `product_id` bigint(30) unsigned NOT NULL,
  `service_id` bigint(30) unsigned NOT NULL,
  `unit_id` bigint(30) unsigned NOT NULL,
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
  `note` varchar(100) NOT NULL,
  `purchase_specificity_id` bigint(30) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`purchase_invoice_id`,`product_id`,`service_id`,`unit_id`),
  KEY `fk_detail_purchase_import_rate` (`import_rate_id`),
  KEY `fk_detail_purchase_product` (`product_id`),
  KEY `fk_detail_purchase_unit` (`unit_id`),
  KEY `fk_detail_purchase_vat_rate` (`vat_rate_id`),
  KEY `fk_detail_purchase_excise_rate` (`excise_rate_id`),
  KEY `fk_detail_purchase_specificity` (`purchase_specificity_id`),
  KEY `fk_detail_purchase_service` (`service_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `accountant_detail_purchase`
--

INSERT INTO `accountant_detail_purchase` (`purchase_invoice_id`, `product_id`, `service_id`, `unit_id`, `quantity`, `converted_quantity`, `price`, `amount`, `converted_amount`, `import_rate_id`, `import_rate`, `import_amount`, `vat_rate_id`, `vat_rate`, `vat_amount`, `excise_rate_id`, `excise_rate`, `excise_amount`, `total_amount`, `note`, `purchase_specificity_id`) VALUES
(3, 1, 0, 3, '23.0000', '92.0000', '23700.0000', '545100.0000', '545100.0000', 0, 0, '0.0000', 6, 10, '54510.0000', 0, 0, '0.0000', '599610.0000', '', 0),
(4, 1, 0, 3, '12.0000', '48.0000', '23700.0000', '284400.0000', '284400.0000', 0, 0, '0.0000', 6, 10, '28440.0000', 0, 0, '0.0000', '312840.0000', '', 0),
(5, 1, 0, 3, '12.0000', '48.0000', '23700.0000', '284400.0000', '284400.0000', 0, 0, '0.0000', 6, 10, '28440.0000', 0, 0, '0.0000', '312840.0000', '', 0),
(6, 1, 0, 3, '12.0000', '48.0000', '23700.0000', '284400.0000', '284400.0000', 0, 0, '0.0000', 6, 10, '28440.0000', 0, 0, '0.0000', '312840.0000', '', 0),
(7, 1, 0, 3, '12.0000', '48.0000', '23700.0000', '284400.0000', '284400.0000', 0, 0, '0.0000', 6, 10, '28440.0000', 0, 0, '0.0000', '312840.0000', '', 0),
(8, 1, 0, 3, '12.0000', '48.0000', '23700.0000', '284400.0000', '284400.0000', 0, 0, '0.0000', 6, 10, '28440.0000', 0, 0, '0.0000', '312840.0000', '', 0),
(9, 1, 0, 3, '12.0000', '48.0000', '23700.0000', '284400.0000', '284400.0000', 0, 0, '0.0000', 6, 10, '28440.0000', 0, 0, '0.0000', '312840.0000', '', 0),
(10, 1, 0, 3, '12.0000', '48.0000', '23700.0000', '284400.0000', '284400.0000', 0, 0, '0.0000', 6, 10, '28440.0000', 0, 0, '0.0000', '312840.0000', '', 0),
(11, 1, 0, 3, '12.0000', '48.0000', '23700.0000', '284400.0000', '284400.0000', 0, 0, '0.0000', 6, 10, '28440.0000', 0, 0, '0.0000', '312840.0000', '', 0),
(12, 1, 0, 3, '12.0000', '48.0000', '23700.0000', '284400.0000', '284400.0000', 0, 0, '0.0000', 6, 10, '28440.0000', 0, 0, '0.0000', '312840.0000', '', 0),
(13, 1, 0, 3, '12.0000', '48.0000', '23700.0000', '284400.0000', '284400.0000', 0, 0, '0.0000', 6, 10, '28440.0000', 0, 0, '0.0000', '312840.0000', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `accountant_detail_sales`
--

DROP TABLE IF EXISTS `accountant_detail_sales`;
CREATE TABLE IF NOT EXISTS `accountant_detail_sales` (
  `sales_invoice_id` bigint(30) unsigned NOT NULL,
  `product_id` bigint(30) unsigned NOT NULL,
  `service_id` bigint(30) unsigned NOT NULL,
  `unit_id` bigint(30) unsigned NOT NULL,
  `debit_account_id` bigint(30) unsigned NOT NULL,
  `credit_account_id` bigint(30) unsigned NOT NULL,
  `quantity` decimal(18,4) NOT NULL,
  `converted_quantity` decimal(18,4) NOT NULL,
  `price` decimal(18,4) NOT NULL,
  `amount` decimal(18,4) NOT NULL,
  `converted_amount` decimal(18,4) NOT NULL,
  `export_rate_id` bigint(30) unsigned NOT NULL,
  `export_rate` tinyint(2) unsigned NOT NULL,
  `export_amount` decimal(18,4) NOT NULL,
  `vat_rate_id` bigint(30) unsigned NOT NULL,
  `vat_rate` tinyint(2) unsigned NOT NULL,
  `vat_amount` decimal(18,4) NOT NULL,
  `excise_rate_id` bigint(30) unsigned NOT NULL,
  `excise_rate` tinyint(2) unsigned NOT NULL,
  `excise_amount` decimal(18,4) NOT NULL,
  `total_amount` decimal(18,4) NOT NULL,
  `note` varchar(100) NOT NULL,
  PRIMARY KEY (`sales_invoice_id`,`product_id`,`service_id`,`unit_id`,`debit_account_id`,`credit_account_id`),
  KEY `fk_detail_sales_unit` (`unit_id`),
  KEY `fk_detail_sales_export_rate` (`export_rate_id`),
  KEY `fk_detail_sales_product` (`product_id`),
  KEY `fk_detail_sales_service` (`service_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `accountant_detail_sales`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_entry_credit`
--

DROP TABLE IF EXISTS `accountant_entry_credit`;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `accountant_entry_credit`
--

INSERT INTO `accountant_entry_credit` (`entry_type_id`, `account_id`, `default`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, 50, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(2, 93, 1, 0, '1900-01-01 00:00:00', 0, '2010-06-08 16:35:37'),
(3, 44, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(4, 3, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 4, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 5, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 7, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 8, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 9, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 14, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 15, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 32, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 36, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 37, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 81, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 82, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 83, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 87, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 88, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 89, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 102, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 103, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 104, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 108, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 117, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 118, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 120, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 128, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 129, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 133, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 134, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 33, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 84, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(7, 67, 1, 1, '2010-07-23 14:02:52', 1, '2010-07-23 14:10:29'),
(7, 68, 0, 1, '2010-07-23 14:11:11', 1, '2010-07-23 14:11:11'),
(8, 8, 0, 0, '2010-07-02 17:18:56', 0, '2010-07-02 17:18:56'),
(8, 12, 0, 0, '2010-07-02 17:18:53', 0, '2010-07-02 17:18:53'),
(9, 3, 1, 1, '2010-07-22 08:36:03', 1, '2010-07-22 08:36:43'),
(9, 5, 0, 1, '2010-07-22 08:42:25', 1, '2010-07-22 08:42:25'),
(16, 6, 1, 1, '2010-07-23 11:11:06', 1, '2010-07-23 11:11:15'),
(19, 42, 1, 0, '2010-06-29 16:41:33', 0, '2010-06-29 16:41:37'),
(19, 98, 0, 0, '2010-06-29 16:41:16', 1, '2010-08-16 08:46:57'),
(19, 193, 0, 0, '2010-06-29 16:41:28', 1, '2010-08-16 08:46:57'),
(20, 12, 0, 0, '2010-06-29 16:42:22', 0, '2010-06-29 16:42:22'),
(20, 95, 1, 0, '2010-06-29 16:42:36', 0, '2010-06-29 16:42:39'),
(21, 12, 0, 0, '2010-06-29 16:45:38', 1, '2010-08-16 08:47:16'),
(21, 23, 1, 0, '2010-06-29 16:45:36', 0, '2010-06-29 16:45:44'),
(21, 110, 0, 0, '2010-06-29 16:45:33', 1, '2010-08-16 08:47:16'),
(22, 47, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(23, 32, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(24, 87, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(25, 50, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(26, 51, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(27, 52, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(28, 53, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(29, 54, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(30, 55, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(31, 56, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(32, 57, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(33, 58, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(34, 59, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(36, 7, 0, 1, '2010-07-28 13:19:58', 1, '2010-07-28 13:21:49'),
(36, 11, 1, 1, '2010-07-28 13:19:01', 1, '2010-07-28 13:21:49'),
(38, 61, 1, 1, '2010-07-28 13:16:48', 1, '2010-07-28 13:17:33'),
(39, 88, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(40, 89, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(41, 90, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(42, 10, 1, 1, '2010-08-04 17:20:44', 1, '2010-08-04 17:20:44'),
(42, 49, 0, 1, '2010-08-06 09:05:54', 1, '2010-08-06 09:05:54'),
(42, 110, 0, 1, '2010-08-06 09:05:54', 1, '2010-08-06 09:05:54'),
(43, 18, 1, 1, '2010-08-04 17:21:05', 1, '2010-08-04 17:21:05'),
(44, 2, 1, 1, '2010-08-04 17:21:26', 1, '2010-08-04 17:21:26'),
(45, 76, 1, 1, '2010-08-23 13:11:59', 1, '2010-08-23 13:11:59'),
(46, 135, 1, 1, '2010-08-23 13:12:26', 1, '2010-08-23 13:12:26'),
(47, 29, 1, 1, '2010-08-23 13:12:13', 1, '2010-08-23 13:12:13'),
(48, 95, 1, 1, '2010-08-23 13:12:48', 1, '2010-08-23 13:12:48'),
(49, 155, 1, 1, '2010-08-23 13:13:11', 1, '2010-08-23 13:13:11'),
(50, 62, 1, 1, '2010-08-23 13:12:59', 1, '2010-08-23 13:12:59'),
(51, 161, 1, 1, '2010-08-23 13:13:23', 1, '2010-08-23 13:13:23');

-- --------------------------------------------------------

--
-- Table structure for table `accountant_entry_debit`
--

DROP TABLE IF EXISTS `accountant_entry_debit`;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `accountant_entry_debit`
--

INSERT INTO `accountant_entry_debit` (`entry_type_id`, `account_id`, `default`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, 21, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(2, 22, 1, 0, '1900-01-01 00:00:00', 0, '2010-06-08 16:35:37'),
(2, 23, 0, 0, '1900-01-01 00:00:00', 0, '2010-06-08 16:35:37'),
(3, 3, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(4, 3, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 4, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 5, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 7, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 8, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 9, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 22, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 23, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 33, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 51, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 52, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 53, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 54, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 55, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 56, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 59, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 60, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 61, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 62, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 63, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 64, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 65, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 71, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 84, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 81, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 82, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 83, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 171, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 172, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 173, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 174, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 175, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 176, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 178, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 179, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 180, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 181, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 182, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 183, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 185, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 186, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 188, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 189, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 190, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 191, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 192, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 193, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 194, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 196, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 197, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 198, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 199, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 200, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 201, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 202, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 203, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(7, 181, 1, 1, '2010-07-23 14:03:34', 1, '2010-07-23 14:10:29'),
(7, 191, 1, 1, '2010-07-23 14:03:44', 1, '2010-07-23 14:10:29'),
(7, 199, 1, 1, '2010-07-23 14:03:56', 1, '2010-07-23 14:10:29'),
(8, 6, 0, 0, '2010-07-02 17:18:51', 0, '2010-07-02 17:18:51'),
(9, 5, 1, 1, '2010-07-22 08:36:08', 1, '2010-07-22 08:36:43'),
(9, 20, 0, 1, '2010-07-22 08:40:54', 1, '2010-07-22 08:40:54'),
(9, 104, 1, 1, '2010-07-22 08:36:40', 1, '2010-07-22 08:36:43'),
(16, 8, 1, 1, '2010-07-23 11:11:09', 1, '2010-07-23 11:11:15'),
(16, 18, 1, 1, '2010-07-23 11:11:11', 1, '2010-07-23 11:11:15'),
(19, 3, 1, 0, '2010-06-29 16:41:12', 0, '2010-06-29 16:41:37'),
(20, 8, 0, 0, '2010-06-29 16:42:27', 1, '2010-08-16 08:47:07'),
(20, 22, 0, 0, '2010-06-29 16:42:32', 1, '2010-08-16 08:47:07'),
(20, 157, 1, 0, '2010-06-29 16:42:25', 0, '2010-06-29 16:42:39'),
(21, 119, 0, 0, '2010-06-29 16:45:41', 0, '2010-06-29 16:45:41'),
(21, 126, 1, 0, '2010-06-29 16:45:30', 0, '2010-06-29 16:45:44'),
(22, 44, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(23, 49, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(24, 65, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(25, 25, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(26, 26, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(27, 27, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(28, 28, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(29, 29, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(30, 30, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(31, 31, 0, 0, '0000-00-00 00:00:00', 1, '2010-07-28 13:22:55'),
(31, 52, 1, 1, '2010-07-28 13:22:49', 1, '2010-07-28 13:22:55'),
(32, 32, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(33, 33, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(34, 34, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(36, 54, 1, 1, '2010-07-28 13:20:03', 1, '2010-07-28 13:21:48'),
(36, 113, 0, 1, '2010-07-28 13:19:08', 1, '2010-07-28 13:21:48'),
(38, 26, 1, 1, '2010-07-28 13:16:58', 1, '2010-07-28 13:17:20'),
(39, 65, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(40, 47, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(41, 70, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(42, 20, 0, 1, '2010-08-06 09:05:29', 1, '2010-08-06 09:05:29'),
(42, 28, 1, 1, '2010-08-04 17:20:44', 1, '2010-08-04 17:20:44'),
(42, 102, 0, 1, '2010-08-06 09:05:54', 1, '2010-08-06 09:05:54'),
(42, 142, 0, 1, '2010-08-06 09:05:54', 1, '2010-08-06 09:05:54'),
(43, 82, 1, 1, '2010-08-04 17:21:05', 1, '2010-08-04 17:21:05'),
(44, 34, 1, 1, '2010-08-04 17:21:26', 1, '2010-08-04 17:21:26'),
(45, 63, 1, 1, '2010-08-23 13:11:59', 1, '2010-08-23 13:11:59'),
(46, 82, 1, 1, '2010-08-23 13:12:26', 1, '2010-08-23 13:12:26'),
(47, 138, 1, 1, '2010-08-23 13:12:13', 1, '2010-08-23 13:12:13'),
(48, 111, 1, 1, '2010-08-23 13:12:48', 1, '2010-08-23 13:12:48'),
(49, 75, 1, 1, '2010-08-23 13:13:11', 1, '2010-08-23 13:13:11'),
(50, 89, 1, 1, '2010-08-23 13:12:59', 1, '2010-08-23 13:12:59'),
(51, 72, 1, 1, '2010-08-23 13:13:23', 1, '2010-08-23 13:13:23');

-- --------------------------------------------------------

--
-- Table structure for table `accountant_entry_type`
--

DROP TABLE IF EXISTS `accountant_entry_type`;
CREATE TABLE IF NOT EXISTS `accountant_entry_type` (
  `entry_type_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `entry_type_name` varchar(300) NOT NULL,
  PRIMARY KEY (`entry_type_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=52 ;

--
-- Dumping data for table `accountant_entry_type`
--

INSERT INTO `accountant_entry_type` (`entry_type_id`, `entry_type_name`) VALUES
(1, 'Mua nguyên liệu, vật liệu trong nước'),
(2, 'Thuế GTGT hàng nhập khẩu tính theo phương pháp khấu trừ thuế'),
(3, 'Mua công cụ, dụng cụ trong nước'),
(4, 'Chi phí trả trước phát sinh'),
(5, 'Phân bổ chi phí trả trước'),
(6, 'Hình thành tài sản cố định'),
(7, 'Khấu hao tài sản cố định'),
(8, 'Thu tiền mặt'),
(9, 'Chi tiền mặt'),
(10, 'Thu tài khoản'),
(11, 'Chi tài khoản'),
(12, 'Chuyển khoản'),
(13, 'Tăng phải trả'),
(14, 'Giảm phải trả'),
(15, 'Cấn trừ phải trả'),
(16, 'Tăng phải thu'),
(17, 'Giảm phải thu'),
(18, 'Cấn trừ phải thu'),
(19, 'Nhập kho'),
(20, 'Xuất kho'),
(21, 'Vận chuyển nội bộ'),
(22, 'Thuế giá trị gia tăng được khấu trừ, mua hàng trong nước'),
(23, 'Thuế nhập khẩu'),
(24, 'Thuế tiêu thụ đặc biệt, mua hàng nhập khẩu'),
(25, 'Mua hàng hóa trong nước'),
(26, 'Mua tài sản cố định hữu hình trong nước'),
(27, 'Mua tài sản cố định vô hình trong nước'),
(28, 'Mua bất động sản đầu tư trong nước'),
(29, 'Mua hàng trong nước, theo phương pháp kiểm kê định kỳ'),
(30, 'Mua hàng trong nước, dùng ngay cho chi phí nguyên liệu, vật liệu trực tiếp'),
(31, 'Mua hàng trong nước, dùng ngay cho chi phí sử dụng máy thi công'),
(32, 'Mua hàng trong nước, dùng ngay cho chi phí sản xuất chung'),
(33, 'Mua hàng trong nước, dùng ngay cho chi phí bán hàng'),
(34, 'Mua hàng trong nước, dùng ngay cho chi phí quản lý doanh nghiệp'),
(35, 'Mua hàng trong nước, thuộc xây dựng cơ bản dở dang'),
(36, 'Mua hàng trong nước, thuộc chi phí trả trước ngắn hạn'),
(37, 'Mua hàng trong nước, thuộc chi phí trả trước dài hạn'),
(38, 'Mua hàng trong nước, giao bán ngay'),
(39, 'Nhập khẩu nguyên liệu, vật liệu'),
(40, 'Nhập khẩu hàng hóa'),
(41, 'Nhập khẩu tài sản cố định hữu hình'),
(42, 'Chi phí mua hàng từ hóa đơn dịch vụ'),
(43, 'Chi phí mua hàng từ phiếu chi tiền'),
(44, 'Chi phí mua hàng chưa có chứng từ'),
(45, 'Bán hàng trong nước'),
(46, 'Xuất khẩu hàng'),
(47, 'Bán dịch vụ trong nước'),
(48, 'Xuất khẩu dịch vụ'),
(49, 'Tiền thuế xuất khẩu'),
(50, 'Tiền thuế giá trị gia tăng đầu ra'),
(51, 'Thuế tiêu thụ đặc biệt, bán hàng - dịch vụ');

-- --------------------------------------------------------

--
-- Table structure for table `accountant_inventory_purchase`
--

DROP TABLE IF EXISTS `accountant_inventory_purchase`;
CREATE TABLE IF NOT EXISTS `accountant_inventory_purchase` (
  `inventory_voucher_id` bigint(30) unsigned NOT NULL,
  `purchase_invoice_id` bigint(30) unsigned NOT NULL,
  `source_document` tinyint(1) unsigned NOT NULL COMMENT '0: hóa đơn mua hàng kế thừa phiếu nhập kho; 1: phiếu nhập kho kế thừa hóa đơn mua hàng',
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`inventory_voucher_id`,`purchase_invoice_id`),
  KEY `fk_inventory_purchase_purchase` (`purchase_invoice_id`),
  KEY `fk_inventory_purchase_created_user` (`created_by_userid`),
  KEY `fk_inventory_purchase_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `accountant_inventory_purchase`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_inventory_sales`
--

DROP TABLE IF EXISTS `accountant_inventory_sales`;
CREATE TABLE IF NOT EXISTS `accountant_inventory_sales` (
  `inventory_voucher_id` bigint(30) unsigned NOT NULL,
  `sales_invoice_id` bigint(30) unsigned NOT NULL,
  `source_document` tinyint(1) unsigned NOT NULL COMMENT '0: hóa đơn bán hàng kế thừa phiếu xuất kho; 1: phiếu xuất kho kế thừa hóa đơn bán hàng',
  `batch_id` bigint(30) unsigned NOT NULL COMMENT 'bó bút toán',
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`inventory_voucher_id`,`sales_invoice_id`),
  KEY `fk_inventory_sales_created_user` (`created_by_userid`),
  KEY `fk_inventory_sales_modified_user` (`last_modified_by_userid`),
  KEY `fk_inventory_sales_sales` (`sales_invoice_id`),
  KEY `fk_inventory_sales_batch` (`batch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `accountant_inventory_sales`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_inventory_voucher`
--

DROP TABLE IF EXISTS `accountant_inventory_voucher`;
CREATE TABLE IF NOT EXISTS `accountant_inventory_voucher` (
  `inventory_voucher_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `voucher_type_id` bigint(30) unsigned NOT NULL,
  `voucher_id` bigint(30) unsigned NOT NULL COMMENT 'Quan hệ một - một với bảng accountant_transaction_voucher',
  `inventory_voucher_number` varchar(30) NOT NULL,
  `inventory_voucher_date` datetime NOT NULL,
  `subject_id` bigint(30) unsigned NOT NULL,
  `subject_contact` varchar(100) NOT NULL,
  `department_id` bigint(30) unsigned NOT NULL,
  `in_warehouse_id` bigint(30) unsigned NOT NULL,
  `out_warehouse_id` bigint(30) unsigned NOT NULL,
  `debit_account_id` bigint(30) NOT NULL,
  `credit_account_id` bigint(30) NOT NULL,
  `currency_id` bigint(30) unsigned NOT NULL,
  `forex_rate` decimal(18,4) NOT NULL,
  `in_out` tinyint(1) unsigned NOT NULL,
  `description` varchar(500) NOT NULL,
  `to_accountant` tinyint(1) unsigned NOT NULL,
  `is_locked` tinyint(1) unsigned NOT NULL COMMENT 'Dùng để xác định tình trạng cho phép chỉnh sửa hay không của Phiếu định khoản hàng tồn kho',
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`inventory_voucher_id`),
  KEY `fk_inventory_voucher_created_user` (`created_by_userid`),
  KEY `fk_inventory_voucher_currency` (`currency_id`),
  KEY `fk_inventory_voucher_modified_user` (`last_modified_by_userid`),
  KEY `fk_inventory_voucher_subject` (`subject_id`),
  KEY `fk_inventory_voucher_transaction_voucher` (`voucher_id`),
  KEY `fk_inventory_voucher_department` (`department_id`),
  KEY `fk_inventory_voucher_in_warehouse` (`in_warehouse_id`),
  KEY `fk_inventory_voucher_out_warehouse` (`out_warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `accountant_inventory_voucher`
--

INSERT INTO `accountant_inventory_voucher` (`inventory_voucher_id`, `voucher_type_id`, `voucher_id`, `inventory_voucher_number`, `inventory_voucher_date`, `subject_id`, `subject_contact`, `department_id`, `in_warehouse_id`, `out_warehouse_id`, `debit_account_id`, `credit_account_id`, `currency_id`, `forex_rate`, `in_out`, `description`, `to_accountant`, `is_locked`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, 0, 0, '', '1900-01-01 00:00:00', 0, '', 0, 0, 0, 0, 0, 0, '0.0000', 0, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `accountant_invoice_detail`
--

DROP TABLE IF EXISTS `accountant_invoice_detail`;
CREATE TABLE IF NOT EXISTS `accountant_invoice_detail` (
  `cash_voucher_id` bigint(30) unsigned NOT NULL,
  `serial_number` varchar(20) NOT NULL COMMENT 'số seri',
  `invoice_number` varchar(20) NOT NULL COMMENT 'số hóa đơn',
  `invoice_date` datetime NOT NULL COMMENT 'ngày hóa đơn',
  `subject_id` bigint(30) unsigned NOT NULL COMMENT 'mã đối tượng',
  `subject_name` varchar(300) NOT NULL COMMENT 'tên đối tượng',
  `subject_address` varchar(500) NOT NULL COMMENT 'địa chỉ đối tượng',
  `subject_tax_code` varchar(20) NOT NULL COMMENT 'mã số thuế',
  `product_name` varchar(300) NOT NULL COMMENT 'mặt hàng',
  `quantity` decimal(18,4) NOT NULL COMMENT 'số lượng',
  `price` decimal(18,4) NOT NULL COMMENT 'đơn giá',
  `amount` decimal(18,4) NOT NULL COMMENT 'thành tiền',
  `currency_id` bigint(30) NOT NULL COMMENT 'loại tiền tệ',
  `forex_rate` decimal(18,4) NOT NULL COMMENT 'tỷ giá quy đổi',
  `converted_amount` decimal(18,4) NOT NULL COMMENT 'thành tiền quy đổi',
  `vat_rate` tinyint(2) unsigned NOT NULL COMMENT 'vat %',
  `vat_amount` decimal(18,4) NOT NULL COMMENT 'tien thue',
  `note_invoice` text NOT NULL COMMENT 'diễn giải chứng từ',
  `department_id` bigint(30) unsigned NOT NULL COMMENT 'bộ phận',
  `expense_id` bigint(30) unsigned NOT NULL COMMENT 'laoi chi phí',
  `debit_credit_account_id_amount` bigint(30) unsigned NOT NULL COMMENT 'tài khoản nợ',
  `note_debit_credit_account_amount` text COMMENT 'diễn giải bút toán nợ',
  `debit_credit_account_id_vat` bigint(30) unsigned NOT NULL COMMENT 'tài khoản có',
  `note_debit_credit_account_vat` text COMMENT 'diễn giải bút toán có',
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`cash_voucher_id`),
  KEY `fk_invoice_detail_created_user` (`created_by_userid`),
  KEY `fk_invoice_detail_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `accountant_invoice_detail`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_list_expense`
--

DROP TABLE IF EXISTS `accountant_list_expense`;
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=48 ;

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
(41, 'Catolog', 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(42, 'Lệ phí hải quan', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, '2010-07-23 13:30:43', 1, '2010-07-23 13:30:43'),
(43, 'Chi phí vận chuyển ( hàng nhập khẩu )', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, '2010-07-23 13:31:15', 1, '2010-07-23 13:31:15'),
(44, 'Chi phí vận chuyển ( hàng nhập khẩu ) nước ngoài vào VN', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, '2010-07-23 13:32:15', 1, '2010-07-23 13:32:15'),
(45, 'Phí CFS', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, '2010-07-23 13:32:51', 1, '2010-07-23 13:32:51'),
(46, 'Phí Bill tàu', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, '2010-07-23 13:33:02', 1, '2010-07-23 13:33:02'),
(47, 'Phí dịch vụ nhận hàng', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, '2010-07-23 13:33:18', 1, '2010-07-23 13:33:18');

-- --------------------------------------------------------

--
-- Table structure for table `accountant_list_revenue`
--

DROP TABLE IF EXISTS `accountant_list_revenue`;
CREATE TABLE IF NOT EXISTS `accountant_list_revenue` (
  `revenue_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `revenue_name` varchar(100) NOT NULL,
  `from_sales` tinyint(1) unsigned NOT NULL,
  `from_capital_paid` tinyint(1) unsigned NOT NULL,
  `from_asset_sold` tinyint(1) unsigned NOT NULL,
  `from_subsidy` tinyint(1) unsigned NOT NULL,
  `from_internal` tinyint(1) unsigned NOT NULL,
  `from_financial_activity` tinyint(1) unsigned NOT NULL,
  `inactive` tinyint(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`revenue_id`),
  KEY `fk_revenue_created_user` (`created_by_userid`),
  KEY `fk_revenue_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `accountant_list_revenue`
--

INSERT INTO `accountant_list_revenue` (`revenue_id`, `revenue_name`, `from_sales`, `from_capital_paid`, `from_asset_sold`, `from_subsidy`, `from_internal`, `from_financial_activity`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, '', 1, 1, 1, 1, 1, 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `accountant_list_specification`
--

DROP TABLE IF EXISTS `accountant_list_specification`;
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `accountant_list_specification`
--

INSERT INTO `accountant_list_specification` (`specification_id`, `specification_name`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, 'Hàng hóa nhập khẩu phục vụ trực tiếp cho an ninh, quốc phòng, nghiên cứu khoa học và giáo dục đào tạo.', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(2, 'Máy móc, thiết bị, dụng cụ nghề nghiệp tạm nhập, tái xuất hoặc tạm xuất, tái nhập để phục vụ công việc như hội nghị, hội thảo, nghiên cứu khoa học, thi đấu thể thao, biểu diễn văn hóa, biểu diễn nghệ thuật, khám chữa bệnh...', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(3, 'Hàng hóa nhập khẩu, xuất khẩu làm mẫu phục vụ cho gia công.', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 'Hàng hoá tạm nhập, tái xuất hoặc tạm xuất, tái nhập để tham dự hội chợ, triển lãm, giới thiệu sản phẩm.', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 'Máy móc, thiết bị nhập khẩu hoặc xuất khẩu để trực tiếp phục vụ gia công được thoả thuận trong hợp đồng gia công.', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(6, 'Thông thường', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `accountant_list_tax`
--

DROP TABLE IF EXISTS `accountant_list_tax`;
CREATE TABLE IF NOT EXISTS `accountant_list_tax` (
  `tax_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `tax_name` varchar(100) NOT NULL,
  PRIMARY KEY (`tax_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=12 ;

--
-- Dumping data for table `accountant_list_tax`
--

INSERT INTO `accountant_list_tax` (`tax_id`, `tax_name`) VALUES
(0, ''),
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

DROP TABLE IF EXISTS `accountant_list_turnover`;
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `accountant_list_turnover`
--

INSERT INTO `accountant_list_turnover` (`turnover_id`, `turnover_name`, `is_normal`, `is_internal`, `is_financial`, `is_discounted`, `is_returned`, `is_devalued`, `from_goods`, `from_products`, `from_services`, `from_subsidy`, `from_real_estate`, `from_rest`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(1, 'Doang thu bán hàng xuất khẩu', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, '2010-07-23 13:49:08', 1, '2010-07-23 13:49:08'),
(2, 'Doanh thu bán hàng', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, '2010-07-23 13:50:05', 1, '2010-07-23 13:50:05'),
(3, 'Doanh thu máy, thiết bị', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, '2010-07-23 13:50:36', 1, '2010-07-23 13:50:36'),
(4, 'Doanh thu tư vấn', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, '2010-07-23 13:51:44', 1, '2010-07-23 13:51:44'),
(5, 'Doanh thu quảng cáo', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, '2010-07-23 13:51:54', 1, '2010-07-23 13:51:54');

-- --------------------------------------------------------

--
-- Table structure for table `accountant_payable_cash`
--

DROP TABLE IF EXISTS `accountant_payable_cash`;
CREATE TABLE IF NOT EXISTS `accountant_payable_cash` (
  `payable_voucher_id` bigint(30) unsigned NOT NULL,
  `cash_voucher_id` bigint(30) unsigned NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`payable_voucher_id`,`cash_voucher_id`),
  KEY `fk_payable_cash_modified_user` (`last_modified_by_userid`),
  KEY `fk_relation_payable_cash_voucher` (`cash_voucher_id`),
  KEY `fk_payable_cash_created_user` (`created_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `accountant_payable_cash`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_payable_mapping`
--

DROP TABLE IF EXISTS `accountant_payable_mapping`;
CREATE TABLE IF NOT EXISTS `accountant_payable_mapping` (
  `inc_payable_voucher_id` bigint(30) unsigned NOT NULL,
  `dec_payable_voucher_id` bigint(30) unsigned NOT NULL,
  `amount` decimal(18,4) NOT NULL,
  `currency_id` bigint(30) unsigned NOT NULL,
  `forex_rate` decimal(18,4) NOT NULL,
  `converted_amount` decimal(18,4) NOT NULL,
  `uneven_amount` decimal(18,4) NOT NULL,
  `inactive` tinyint(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`inc_payable_voucher_id`,`dec_payable_voucher_id`),
  KEY `fk_dec_payable_voucher` (`dec_payable_voucher_id`),
  KEY `fk_payable_mapping_currency` (`currency_id`),
  KEY `fk_payable_mapping_created_user` (`created_by_userid`),
  KEY `fk_payable_mapping_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `accountant_payable_mapping`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_payable_type`
--

DROP TABLE IF EXISTS `accountant_payable_type`;
CREATE TABLE IF NOT EXISTS `accountant_payable_type` (
  `payable_type_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `payable_type_name` varchar(100) NOT NULL,
  `short_long` tinyint(1) unsigned NOT NULL,
  `to_supplier` tinyint(1) unsigned NOT NULL,
  `to_government` tinyint(1) unsigned NOT NULL,
  `to_bank` tinyint(1) unsigned NOT NULL,
  `to_staff` tinyint(1) unsigned NOT NULL,
  `is_expense` tinyint(1) unsigned NOT NULL,
  `is_inside` tinyint(1) unsigned NOT NULL,
  `is_unknown` tinyint(1) unsigned NOT NULL,
  `is_union_cost` tinyint(1) unsigned NOT NULL,
  `is_social_insurance` tinyint(1) unsigned NOT NULL,
  `is_health_insurance` tinyint(1) unsigned NOT NULL,
  `inactive` tinyint(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`payable_type_id`),
  KEY `fk_payable_type_created_user` (`created_by_userid`),
  KEY `fk_payable_type_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `accountant_payable_type`
--

INSERT INTO `accountant_payable_type` (`payable_type_id`, `payable_type_name`, `short_long`, `to_supplier`, `to_government`, `to_bank`, `to_staff`, `is_expense`, `is_inside`, `is_unknown`, `is_union_cost`, `is_social_insurance`, `is_health_insurance`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, 'Trả nhà cung cấp', 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 1, '2010-07-23 14:16:01');

-- --------------------------------------------------------

--
-- Table structure for table `accountant_payable_voucher`
--

DROP TABLE IF EXISTS `accountant_payable_voucher`;
CREATE TABLE IF NOT EXISTS `accountant_payable_voucher` (
  `payable_voucher_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `voucher_id` bigint(30) unsigned NOT NULL COMMENT 'Quan hệ một - một với bảng accountant_transaction_voucher',
  `payable_voucher_number` varchar(20) NOT NULL,
  `payable_voucher_date` datetime NOT NULL,
  `payable_type_id` bigint(30) unsigned NOT NULL,
  `inc_dec` tinyint(1) unsigned NOT NULL,
  `inc_subject_id` bigint(30) unsigned NOT NULL,
  `dec_subject_id` bigint(30) unsigned NOT NULL,
  `inc_staff_id` bigint(30) unsigned NOT NULL,
  `dec_staff_id` bigint(30) unsigned NOT NULL,
  `tax_id` bigint(30) unsigned NOT NULL,
  `discount_date` datetime NOT NULL,
  `discount_rate` decimal(18,4) unsigned NOT NULL,
  `due_date` datetime NOT NULL,
  `due_rate` decimal(18,4) unsigned NOT NULL,
  `amount` decimal(18,4) NOT NULL,
  `currency_id` bigint(30) unsigned NOT NULL,
  `forex_rate` decimal(18,4) NOT NULL,
  `converted_amount` decimal(18,4) NOT NULL,
  `description` varchar(500) NOT NULL,
  `is_locked` tinyint(1) unsigned NOT NULL COMMENT 'Dùng để xác định tình trạng cho phép chỉnh sửa hay không của Phiếu định khoản phải trả',
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`payable_voucher_id`),
  KEY `fk_payable_voucher` (`voucher_id`),
  KEY `fk_payable_type` (`payable_type_id`),
  KEY `fk_payable_inc_subject` (`inc_subject_id`),
  KEY `fk_payable_dec_subject` (`dec_subject_id`),
  KEY `fk_payable_inc_staff` (`inc_staff_id`),
  KEY `fk_payable_dec_staff` (`dec_staff_id`),
  KEY `fk_payable_tax` (`tax_id`),
  KEY `fk_payable_currency` (`currency_id`),
  KEY `fk_payable_created_user` (`created_by_userid`),
  KEY `fk_payable_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=12 ;

--
-- Dumping data for table `accountant_payable_voucher`
--

INSERT INTO `accountant_payable_voucher` (`payable_voucher_id`, `voucher_id`, `payable_voucher_number`, `payable_voucher_date`, `payable_type_id`, `inc_dec`, `inc_subject_id`, `dec_subject_id`, `inc_staff_id`, `dec_staff_id`, `tax_id`, `discount_date`, `discount_rate`, `due_date`, `due_rate`, `amount`, `currency_id`, `forex_rate`, `converted_amount`, `description`, `is_locked`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, 84, 'sadfsd', '2010-09-14 01:52:24', 0, 1, 12, 0, 0, 0, 0, '0000-00-00 00:00:00', '0.0000', '0000-00-00 00:00:00', '0.0000', '599610.0000', 1, '1.0000', '599610.0000', 'fds', 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(2, 85, 'adsfasd', '2010-09-14 02:02:44', 0, 1, 7, 0, 0, 0, 0, '0000-00-00 00:00:00', '0.0000', '0000-00-00 00:00:00', '0.0000', '312840.0000', 1, '1.0000', '312840.0000', '', 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(3, 86, 'adsfasd', '2010-09-14 02:03:00', 0, 1, 7, 0, 0, 0, 0, '0000-00-00 00:00:00', '0.0000', '0000-00-00 00:00:00', '0.0000', '312840.0000', 1, '1.0000', '312840.0000', '', 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(4, 87, 'adsfasd', '2010-09-14 02:04:36', 0, 1, 7, 0, 0, 0, 0, '0000-00-00 00:00:00', '0.0000', '0000-00-00 00:00:00', '0.0000', '312840.0000', 1, '1.0000', '312840.0000', '', 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(5, 88, 'adsfasd', '2010-09-14 02:05:44', 0, 1, 7, 0, 0, 0, 0, '0000-00-00 00:00:00', '0.0000', '0000-00-00 00:00:00', '0.0000', '312840.0000', 1, '1.0000', '312840.0000', '', 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(6, 89, 'adsfasd', '2010-09-14 02:06:29', 0, 1, 7, 0, 0, 0, 0, '0000-00-00 00:00:00', '0.0000', '0000-00-00 00:00:00', '0.0000', '312840.0000', 1, '1.0000', '312840.0000', '', 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(7, 90, 'adsfasd', '2010-09-14 02:07:50', 0, 1, 7, 0, 0, 0, 0, '0000-00-00 00:00:00', '0.0000', '0000-00-00 00:00:00', '0.0000', '312840.0000', 1, '1.0000', '312840.0000', '', 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(8, 91, 'adsfasd', '2010-09-14 02:08:32', 0, 1, 7, 0, 0, 0, 0, '0000-00-00 00:00:00', '0.0000', '0000-00-00 00:00:00', '0.0000', '312840.0000', 1, '1.0000', '312840.0000', '', 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(9, 92, 'adsfasd', '2010-09-14 02:08:53', 0, 1, 7, 0, 0, 0, 0, '0000-00-00 00:00:00', '0.0000', '0000-00-00 00:00:00', '0.0000', '312840.0000', 1, '1.0000', '312840.0000', '', 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(10, 93, 'adsfasd', '2010-09-14 02:10:21', 0, 1, 7, 0, 0, 0, 0, '0000-00-00 00:00:00', '0.0000', '0000-00-00 00:00:00', '0.0000', '312840.0000', 1, '1.0000', '312840.0000', '', 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(11, 94, 'adsfasd', '2010-09-14 02:11:04', 0, 1, 7, 0, 0, 0, 0, '0000-00-00 00:00:00', '0.0000', '0000-00-00 00:00:00', '0.0000', '312840.0000', 1, '1.0000', '312840.0000', '', 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `accountant_prepaid_allocation`
--

DROP TABLE IF EXISTS `accountant_prepaid_allocation`;
CREATE TABLE IF NOT EXISTS `accountant_prepaid_allocation` (
  `prepaid_expense_id` bigint(30) unsigned NOT NULL,
  `allocation_date` datetime NOT NULL,
  `voucher_id` bigint(30) unsigned NOT NULL COMMENT 'Quan hệ một - một với bảng accountant_transaction_voucher',
  `allocation_note` varchar(100) NOT NULL,
  `amount` decimal(18,4) NOT NULL,
  `currency_id` bigint(30) unsigned NOT NULL,
  `forex_rate` decimal(18,4) NOT NULL,
  `converted_amount` decimal(18,4) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`prepaid_expense_id`,`allocation_date`),
  KEY `fk_prepaid_allocation_created_user` (`created_by_userid`),
  KEY `fk_prepaid_allocation_currency` (`currency_id`),
  KEY `fk_prepaid_allocation_modified_user` (`last_modified_by_userid`),
  KEY `fk_prepaid_allocation_voucher` (`voucher_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `accountant_prepaid_allocation`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_prepaid_expense`
--

DROP TABLE IF EXISTS `accountant_prepaid_expense`;
CREATE TABLE IF NOT EXISTS `accountant_prepaid_expense` (
  `prepaid_expense_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `voucher_id` bigint(30) unsigned NOT NULL COMMENT 'Quan h? m?t - m?t v?i b?ng accountant_transaction_voucher',
  `prepaid_expense_code` varchar(10) NOT NULL,
  `prepaid_expense_name` varchar(100) NOT NULL,
  `prepaid_expense_date` datetime NOT NULL,
  `prepaid_expense_description` varchar(500) NOT NULL,
  `supplier_id` bigint(30) unsigned NOT NULL,
  `expense_id` bigint(30) unsigned NOT NULL,
  `assets_id` bigint(30) unsigned NOT NULL,
  `tool_id` bigint(30) unsigned NOT NULL,
  `amount` decimal(18,4) NOT NULL,
  `currency_id` bigint(30) unsigned NOT NULL,
  `forex_rate` decimal(18,4) NOT NULL,
  `converted_amount` decimal(18,4) NOT NULL,
  `allocation_periods` tinyint(2) unsigned NOT NULL,
  `is_locked` tinyint(1) unsigned NOT NULL COMMENT 'Dùng để xác định tình trạng cho phép chỉnh sửa hay không của Phiếu định khoản chi phí trả trước',
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`prepaid_expense_id`),
  KEY `fk_prepaid_voucher` (`voucher_id`),
  KEY `fk_prepaid_supplier` (`supplier_id`),
  KEY `fk_prepaid_expense` (`expense_id`),
  KEY `fk_prepaid_currency` (`currency_id`),
  KEY `fk_prepaid_created_user` (`created_by_userid`),
  KEY `fk_prepaid_modified_user` (`last_modified_by_userid`),
  KEY `fk_prepaid_assets` (`assets_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `accountant_prepaid_expense`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_purchase_cost`
--

DROP TABLE IF EXISTS `accountant_purchase_cost`;
CREATE TABLE IF NOT EXISTS `accountant_purchase_cost` (
  `purchase_invoice_id` bigint(30) unsigned NOT NULL,
  `product_id` bigint(30) unsigned NOT NULL,
  `service_id` bigint(30) unsigned NOT NULL,
  `unit_id` bigint(30) unsigned NOT NULL,
  `cost_invoice_id` bigint(30) unsigned NOT NULL,
  `cash_voucher_id` bigint(30) unsigned NOT NULL,
  `no_document_description` varchar(100) NOT NULL,
  `amount` decimal(18,4) NOT NULL,
  `currency_id` bigint(30) unsigned NOT NULL,
  `forex_rate` decimal(18,4) NOT NULL,
  `converted_amount` decimal(18,4) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`purchase_invoice_id`,`product_id`,`service_id`,`unit_id`,`cost_invoice_id`,`cash_voucher_id`,`no_document_description`),
  KEY `fk_purchase_cost_product` (`product_id`),
  KEY `fk_purchase_cost_service` (`service_id`),
  KEY `fk_purchase_cost_unit` (`unit_id`),
  KEY `fk_purchase_cost_cost_invoice` (`cost_invoice_id`),
  KEY `fk_purchase_cost_cash` (`cash_voucher_id`),
  KEY `fk_purchase_cost_currency` (`currency_id`),
  KEY `fk_purchase_cost_created_user` (`created_by_userid`),
  KEY `fk_purchase_cost_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `accountant_purchase_cost`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_purchase_invoice`
--

DROP TABLE IF EXISTS `accountant_purchase_invoice`;
CREATE TABLE IF NOT EXISTS `accountant_purchase_invoice` (
  `purchase_invoice_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `voucher_id` bigint(30) unsigned NOT NULL COMMENT 'Quan hệ một - một với bảng accountant_transaction_voucher',
  `purchase_serial_number` varchar(10) NOT NULL,
  `purchase_invoice_number` varchar(20) NOT NULL,
  `purchase_invoice_date` datetime NOT NULL,
  `supplier_id` bigint(30) unsigned NOT NULL,
  `supplier_name` varchar(100) NOT NULL,
  `supplier_address` varchar(100) NOT NULL,
  `supplier_tax_code` varchar(20) NOT NULL,
  `supplier_contact` varchar(100) NOT NULL,
  `credit_account_id_amount` bigint(30) NOT NULL,
  `debit_account_id_amount` bigint(30) NOT NULL,
  `credit_account_id_vat` bigint(30) NOT NULL,
  `debit_account_id_vat` bigint(30) NOT NULL,
  `credit_amount_id_import` bigint(30) NOT NULL,
  `debit_account_id_import` bigint(30) NOT NULL,
  `credit_account_id_excise` bigint(30) NOT NULL,
  `debit_account_id_excise` bigint(30) NOT NULL,
  `currency_id` bigint(30) unsigned NOT NULL,
  `forex_rate` decimal(18,4) NOT NULL,
  `by_import` tinyint(1) unsigned NOT NULL,
  `for_service` tinyint(1) unsigned NOT NULL,
  `description` varchar(500) NOT NULL,
  `is_locked` tinyint(1) unsigned NOT NULL COMMENT 'Dùng để xác định tình trạng cho phép chỉnh sửa hay không của Hóa đơn mua hàng',
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=14 ;

--
-- Dumping data for table `accountant_purchase_invoice`
--

INSERT INTO `accountant_purchase_invoice` (`purchase_invoice_id`, `voucher_id`, `purchase_serial_number`, `purchase_invoice_number`, `purchase_invoice_date`, `supplier_id`, `supplier_name`, `supplier_address`, `supplier_tax_code`, `supplier_contact`, `credit_account_id_amount`, `debit_account_id_amount`, `credit_account_id_vat`, `debit_account_id_vat`, `credit_amount_id_import`, `debit_account_id_import`, `credit_account_id_excise`, `debit_account_id_excise`, `currency_id`, `forex_rate`, `by_import`, `for_service`, `description`, `is_locked`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, 0, '', '', '0000-00-00 00:00:00', 0, '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '0.0000', 0, 0, '', 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(3, 84, 'fasdf', 'sadfsd', '2010-09-14 01:52:24', 12, 'Hợp Tác Xã VTHH Và Xe Du Lịch THỦ ĐỨC', '30 Võ Văn Ngân, P. Bình Thọ, Q. Thủ Đức', '0301459132', 'fsad', 9, 24, 24, 36, 0, 0, 0, 0, 1, '1.0000', 0, 0, 'fds', 0, 1, '2010-09-15 01:52:24', 1, '2010-09-15 01:52:24'),
(4, 85, 'fasdf', 'adsfasd', '2010-09-14 02:02:44', 7, 'Chi Cục Thuế Quận Thủ Đức', '16 đường 6, P.Linh Chiểu, Q. Thủ Đức', '0301519977022', '', 214, 12, 21, 24, 0, 0, 0, 0, 1, '1.0000', 0, 0, '', 0, 1, '2010-09-15 02:02:44', 1, '2010-09-15 02:02:44'),
(5, 86, 'fasdf', 'adsfasd', '2010-09-14 02:03:00', 7, 'Chi Cục Thuế Quận Thủ Đức', '16 đường 6, P.Linh Chiểu, Q. Thủ Đức', '0301519977022', '', 214, 12, 21, 24, 0, 0, 0, 0, 1, '1.0000', 0, 0, '', 0, 1, '2010-09-15 02:03:00', 1, '2010-09-15 02:03:00'),
(6, 87, 'fasdf', 'adsfasd', '2010-09-14 02:04:36', 7, 'Chi Cục Thuế Quận Thủ Đức', '16 đường 6, P.Linh Chiểu, Q. Thủ Đức', '0301519977022', '', 214, 12, 21, 24, 0, 0, 0, 0, 1, '1.0000', 0, 0, '', 0, 1, '2010-09-15 02:04:36', 1, '2010-09-15 02:04:36'),
(7, 88, 'fasdf', 'adsfasd', '2010-09-14 02:05:44', 7, 'Chi Cục Thuế Quận Thủ Đức', '16 đường 6, P.Linh Chiểu, Q. Thủ Đức', '0301519977022', '', 214, 12, 21, 24, 0, 0, 0, 0, 1, '1.0000', 0, 0, '', 0, 1, '2010-09-15 02:05:44', 1, '2010-09-15 02:05:44'),
(8, 89, 'fasdf', 'adsfasd', '2010-09-14 02:06:29', 7, 'Chi Cục Thuế Quận Thủ Đức', '16 đường 6, P.Linh Chiểu, Q. Thủ Đức', '0301519977022', '', 214, 12, 21, 24, 0, 0, 0, 0, 1, '1.0000', 0, 0, '', 0, 1, '2010-09-15 02:06:29', 1, '2010-09-15 02:06:29'),
(9, 90, 'fasdf', 'adsfasd', '2010-09-14 02:07:50', 7, 'Chi Cục Thuế Quận Thủ Đức', '16 đường 6, P.Linh Chiểu, Q. Thủ Đức', '0301519977022', '', 214, 12, 21, 24, 0, 0, 0, 0, 1, '1.0000', 0, 0, '', 0, 1, '2010-09-15 02:07:50', 1, '2010-09-15 02:07:50'),
(10, 91, 'fasdf', 'adsfasd', '2010-09-14 02:08:32', 7, 'Chi Cục Thuế Quận Thủ Đức', '16 đường 6, P.Linh Chiểu, Q. Thủ Đức', '0301519977022', '', 214, 12, 21, 24, 0, 0, 0, 0, 1, '1.0000', 0, 0, '', 0, 1, '2010-09-15 02:08:32', 1, '2010-09-15 02:08:32'),
(11, 92, 'fasdf', 'adsfasd', '2010-09-14 02:08:53', 7, 'Chi Cục Thuế Quận Thủ Đức', '16 đường 6, P.Linh Chiểu, Q. Thủ Đức', '0301519977022', '', 214, 12, 21, 24, 0, 0, 0, 0, 1, '1.0000', 0, 0, '', 0, 1, '2010-09-15 02:08:53', 1, '2010-09-15 02:08:53'),
(12, 93, 'fasdf', 'adsfasd', '2010-09-14 02:10:21', 7, 'Chi Cục Thuế Quận Thủ Đức', '16 đường 6, P.Linh Chiểu, Q. Thủ Đức', '0301519977022', '', 214, 12, 21, 24, 0, 0, 0, 0, 1, '1.0000', 0, 0, '', 0, 1, '2010-09-15 02:10:21', 1, '2010-09-15 02:10:21'),
(13, 94, 'fasdf', 'adsfasd', '2010-09-14 02:11:04', 7, 'Chi Cục Thuế Quận Thủ Đức', '16 đường 6, P.Linh Chiểu, Q. Thủ Đức', '0301519977022', '', 214, 12, 21, 24, 0, 0, 0, 0, 1, '1.0000', 0, 0, '', 0, 1, '2010-09-15 02:11:04', 1, '2010-09-15 02:11:04');

-- --------------------------------------------------------

--
-- Table structure for table `accountant_purchase_payable`
--

DROP TABLE IF EXISTS `accountant_purchase_payable`;
CREATE TABLE IF NOT EXISTS `accountant_purchase_payable` (
  `payable_voucher_id` bigint(30) unsigned NOT NULL,
  `purchase_invoice_id` bigint(30) unsigned NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`payable_voucher_id`,`purchase_invoice_id`),
  KEY `fk_purchase_payable_modified_user` (`last_modified_by_userid`),
  KEY `fk_purchase_payable_created_user` (`created_by_userid`),
  KEY `fk_purchase_payable_purchase` (`purchase_invoice_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `accountant_purchase_payable`
--

INSERT INTO `accountant_purchase_payable` (`payable_voucher_id`, `purchase_invoice_id`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, 3, 1, '2010-09-15 01:52:24', 1, '2010-09-15 01:52:24'),
(2, 4, 1, '2010-09-15 02:02:44', 1, '2010-09-15 02:02:44'),
(3, 5, 1, '2010-09-15 02:03:00', 1, '2010-09-15 02:03:00'),
(4, 6, 1, '2010-09-15 02:04:36', 1, '2010-09-15 02:04:36'),
(5, 7, 1, '2010-09-15 02:05:44', 1, '2010-09-15 02:05:44'),
(6, 8, 1, '2010-09-15 02:06:29', 1, '2010-09-15 02:06:29'),
(7, 9, 1, '2010-09-15 02:07:50', 1, '2010-09-15 02:07:50'),
(8, 10, 1, '2010-09-15 02:08:32', 1, '2010-09-15 02:08:32'),
(9, 11, 1, '2010-09-15 02:08:53', 1, '2010-09-15 02:08:53'),
(10, 12, 1, '2010-09-15 02:10:21', 1, '2010-09-15 02:10:21'),
(11, 13, 1, '2010-09-15 02:11:04', 1, '2010-09-15 02:11:04');

-- --------------------------------------------------------

--
-- Table structure for table `accountant_purchase_receivable`
--

DROP TABLE IF EXISTS `accountant_purchase_receivable`;
CREATE TABLE IF NOT EXISTS `accountant_purchase_receivable` (
  `receivable_voucher_id` bigint(30) unsigned NOT NULL,
  `purchase_invoice_id` bigint(30) unsigned NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`receivable_voucher_id`,`purchase_invoice_id`),
  KEY `fk_purchase_receivable_created_user` (`created_by_userid`),
  KEY `fk_purchase_receivable_modified_user` (`last_modified_by_userid`),
  KEY `fk_purchase_receivable_purchase` (`purchase_invoice_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `accountant_purchase_receivable`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_purchase_specificity`
--

DROP TABLE IF EXISTS `accountant_purchase_specificity`;
CREATE TABLE IF NOT EXISTS `accountant_purchase_specificity` (
  `purchase_specificity_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `specificity_text` varchar(300) NOT NULL,
  `import` tinyint(1) unsigned NOT NULL,
  PRIMARY KEY (`purchase_specificity_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=17 ;

--
-- Dumping data for table `accountant_purchase_specificity`
--

INSERT INTO `accountant_purchase_specificity` (`purchase_specificity_id`, `specificity_text`, `import`) VALUES
(0, '', 0),
(1, 'Nguyên liệu, vật liệu', 1),
(2, 'Công cụ, dụng cụ', 0),
(3, 'Hàng hóa', 1),
(4, 'Tài sản cố định hữu hình', 1),
(5, 'Tài sản cố định vô hình', 0),
(6, 'Bất động sản đầu tư', 0),
(7, 'Phương pháp kiểm kê định kỳ', 0),
(8, 'Chi phí nguyên liệu, vật liệu trực tiếp', 0),
(9, 'Chi phí sử dụng máy thi công', 0),
(10, 'Chi phí sản xuất chung', 0),
(11, 'Chi phí bán hàng', 0),
(12, 'Chi phí quản lý doanh nghiệp', 0),
(13, 'Xây dựng cơ bản dở dang', 0),
(14, 'Chi phí trả trước ngắn hạn', 0),
(15, 'Chi phí trả trước dài hạn', 0),
(16, 'Giao bán ngay', 0);

-- --------------------------------------------------------

--
-- Table structure for table `accountant_receivable_cash`
--

DROP TABLE IF EXISTS `accountant_receivable_cash`;
CREATE TABLE IF NOT EXISTS `accountant_receivable_cash` (
  `receivable_voucher_id` bigint(30) unsigned NOT NULL,
  `cash_voucher_id` bigint(30) unsigned NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`receivable_voucher_id`,`cash_voucher_id`),
  KEY `fk_receivable_cash_modified_user` (`last_modified_by_userid`),
  KEY `fk_relation_receivable_cash_voucher` (`cash_voucher_id`),
  KEY `fk_receivable_cash_created_user` (`created_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `accountant_receivable_cash`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_receivable_mapping`
--

DROP TABLE IF EXISTS `accountant_receivable_mapping`;
CREATE TABLE IF NOT EXISTS `accountant_receivable_mapping` (
  `inc_receivable_voucher_id` bigint(30) unsigned NOT NULL,
  `dec_receivable_voucher_id` bigint(30) unsigned NOT NULL,
  `amount` decimal(18,4) NOT NULL,
  `currency_id` bigint(30) unsigned NOT NULL,
  `forex_rate` decimal(18,4) NOT NULL,
  `converted_amount` decimal(18,4) NOT NULL,
  `uneven_amount` decimal(18,4) NOT NULL,
  `inactive` tinyint(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`inc_receivable_voucher_id`,`dec_receivable_voucher_id`),
  KEY `fk_dec_receivable_voucher` (`dec_receivable_voucher_id`),
  KEY `fk_receivable_mapping_currency` (`currency_id`),
  KEY `fk_receivable_mapping_created_user` (`created_by_userid`),
  KEY `fk_receivable_mapping_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `accountant_receivable_mapping`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_receivable_type`
--

DROP TABLE IF EXISTS `accountant_receivable_type`;
CREATE TABLE IF NOT EXISTS `accountant_receivable_type` (
  `receivable_type_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `receivable_type_name` varchar(100) NOT NULL,
  `from_customer` tinyint(1) unsigned NOT NULL,
  `from_government` tinyint(1) unsigned NOT NULL,
  `from_staff` tinyint(1) unsigned NOT NULL,
  `is_inside` tinyint(1) unsigned NOT NULL,
  `inactive` tinyint(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`receivable_type_id`),
  KEY `fk_receivable_type_created_user` (`created_by_userid`),
  KEY `fk_receivable_type_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `accountant_receivable_type`
--

INSERT INTO `accountant_receivable_type` (`receivable_type_id`, `receivable_type_name`, `from_customer`, `from_government`, `from_staff`, `is_inside`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, '', 0, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(1, 'tersdt', 1, 1, 1, 1, 0, 1, '2010-07-23 11:10:18', 1, '2010-07-23 14:25:18');

-- --------------------------------------------------------

--
-- Table structure for table `accountant_receivable_voucher`
--

DROP TABLE IF EXISTS `accountant_receivable_voucher`;
CREATE TABLE IF NOT EXISTS `accountant_receivable_voucher` (
  `receivable_voucher_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `voucher_id` bigint(30) unsigned NOT NULL COMMENT 'Quan hệ một - một với bảng accountant_transaction_voucher',
  `receivable_voucher_number` varchar(20) NOT NULL,
  `receivable_voucher_date` datetime NOT NULL,
  `receivable_type_id` bigint(30) unsigned NOT NULL,
  `inc_dec` tinyint(1) unsigned NOT NULL,
  `inc_subject_id` bigint(30) unsigned NOT NULL,
  `dec_subject_id` bigint(30) unsigned NOT NULL,
  `inc_staff_id` bigint(30) unsigned NOT NULL,
  `dec_staff_id` bigint(30) unsigned NOT NULL,
  `tax_id` bigint(30) unsigned NOT NULL,
  `discount_date` datetime NOT NULL,
  `discount_rate` decimal(18,4) unsigned NOT NULL,
  `due_date` datetime NOT NULL,
  `due_rate` decimal(18,4) unsigned NOT NULL,
  `amount` decimal(18,4) NOT NULL,
  `currency_id` bigint(30) unsigned NOT NULL,
  `forex_rate` decimal(18,4) NOT NULL,
  `converted_amount` decimal(18,4) NOT NULL,
  `description` varchar(500) NOT NULL,
  `is_locked` tinyint(1) unsigned NOT NULL COMMENT 'Dùng để xác định tình trạng cho phép chỉnh sửa hay không của Phiếu định khoản phải thu',
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`receivable_voucher_id`),
  KEY `fk_receivable_voucher` (`voucher_id`),
  KEY `fk_receivable_created_user` (`created_by_userid`),
  KEY `fk_receivable_currency` (`currency_id`),
  KEY `fk_receivable_dec_staff` (`dec_staff_id`),
  KEY `fk_receivable_dec_subject` (`dec_subject_id`),
  KEY `fk_receivable_inc_staff` (`inc_staff_id`),
  KEY `fk_receivable_inc_subject` (`inc_subject_id`),
  KEY `fk_receivable_modified_user` (`last_modified_by_userid`),
  KEY `fk_receivable_tax` (`tax_id`),
  KEY `fk_receivable_type` (`receivable_type_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=18 ;

--
-- Dumping data for table `accountant_receivable_voucher`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_relation_tax`
--

DROP TABLE IF EXISTS `accountant_relation_tax`;
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

INSERT INTO `accountant_relation_tax` (`product_id`, `tax_id`, `specification_id`, `tax_rate_id`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, 1, 1, 6, 1, '2010-08-04 13:18:26', 1, '2010-08-04 13:18:26'),
(0, 1, 2, 6, 1, '2010-07-22 10:22:36', 1, '2010-07-22 10:22:52'),
(0, 1, 3, 5, 1, '2010-08-12 08:18:51', 1, '2010-08-12 08:18:51'),
(0, 2, 1, 7, 1, '2010-08-04 13:18:54', 1, '2010-08-04 13:18:54'),
(0, 2, 2, 8, 1, '2010-08-12 08:18:26', 1, '2010-08-12 08:18:26'),
(0, 2, 6, 7, 1, '2010-08-04 13:21:12', 1, '2010-08-04 13:21:12'),
(0, 4, 1, 10, 1, '2010-08-04 13:19:42', 1, '2010-08-12 08:17:47'),
(0, 4, 6, 9, 1, '2010-08-04 13:20:38', 1, '2010-08-04 13:20:38'),
(1, 1, 1, 6, 1, '2010-08-04 13:18:26', 1, '2010-08-04 13:18:26'),
(1, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(1, 1, 3, 5, 1, '2010-08-12 08:18:51', 1, '2010-08-12 08:18:51'),
(1, 1, 6, 6, 1, '2010-07-28 08:31:02', 1, '2010-07-28 09:57:14'),
(1, 2, 1, 7, 1, '2010-08-04 13:18:54', 1, '2010-08-04 13:18:54'),
(1, 2, 2, 8, 1, '2010-08-12 08:18:26', 1, '2010-08-12 08:18:26'),
(1, 2, 6, 7, 1, '2010-08-04 13:21:11', 1, '2010-08-04 13:21:12'),
(1, 4, 1, 10, 1, '2010-08-04 13:19:42', 1, '2010-08-12 08:17:47'),
(1, 4, 6, 9, 1, '2010-08-04 13:20:38', 1, '2010-08-04 13:20:38'),
(2, 1, 1, 6, 1, '2010-07-22 10:19:15', 1, '2010-08-04 13:18:26'),
(2, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(2, 1, 3, 5, 1, '2010-08-12 08:18:51', 1, '2010-08-12 08:18:51'),
(2, 1, 6, 6, 1, '2010-07-28 08:31:02', 1, '2010-07-28 09:57:14'),
(2, 2, 1, 7, 1, '2010-08-04 13:18:54', 1, '2010-08-04 13:18:54'),
(2, 2, 2, 8, 1, '2010-08-12 08:18:26', 1, '2010-08-12 08:18:26'),
(2, 2, 6, 7, 1, '2010-08-04 13:21:12', 1, '2010-08-04 13:21:12'),
(2, 4, 1, 10, 1, '2010-08-04 13:19:42', 1, '2010-08-12 08:17:47'),
(2, 4, 6, 9, 1, '2010-08-04 13:20:38', 1, '2010-08-04 13:20:38'),
(3, 1, 1, 6, 1, '2010-08-04 13:18:26', 1, '2010-08-04 13:18:26'),
(3, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(3, 1, 3, 5, 1, '2010-08-12 08:18:51', 1, '2010-08-12 08:18:51'),
(3, 1, 6, 6, 1, '2010-07-28 08:31:02', 1, '2010-07-28 09:57:14'),
(3, 2, 1, 7, 1, '2010-08-04 13:18:54', 1, '2010-08-04 13:18:54'),
(3, 2, 2, 8, 1, '2010-08-12 08:18:26', 1, '2010-08-12 08:18:26'),
(3, 2, 6, 7, 1, '2010-08-04 13:21:12', 1, '2010-08-04 13:21:12'),
(3, 4, 1, 10, 1, '2010-08-04 13:19:42', 1, '2010-08-12 08:17:47'),
(3, 4, 6, 9, 1, '2010-08-04 13:20:38', 1, '2010-08-04 13:20:38'),
(4, 1, 1, 6, 1, '2010-08-04 13:18:26', 1, '2010-08-04 13:18:26'),
(4, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(4, 1, 3, 5, 1, '2010-08-12 08:18:51', 1, '2010-08-12 08:18:51'),
(4, 1, 6, 6, 1, '2010-07-28 08:31:02', 1, '2010-07-28 09:57:14'),
(4, 2, 1, 7, 1, '2010-08-04 13:18:54', 1, '2010-08-04 13:18:54'),
(4, 2, 2, 8, 1, '2010-08-12 08:18:26', 1, '2010-08-12 08:18:26'),
(4, 2, 6, 7, 1, '2010-08-04 13:21:12', 1, '2010-08-04 13:21:12'),
(4, 4, 1, 10, 1, '2010-08-04 13:19:42', 1, '2010-08-12 08:17:47'),
(4, 4, 6, 9, 1, '2010-08-04 13:20:38', 1, '2010-08-04 13:20:38'),
(5, 1, 1, 6, 1, '2010-08-04 13:18:26', 1, '2010-08-04 13:18:26'),
(5, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(5, 1, 3, 5, 1, '2010-08-12 08:18:51', 1, '2010-08-12 08:18:51'),
(5, 1, 6, 6, 1, '2010-07-28 08:31:02', 1, '2010-07-28 09:57:14'),
(5, 2, 1, 7, 1, '2010-08-04 13:18:54', 1, '2010-08-04 13:18:54'),
(5, 2, 2, 8, 1, '2010-08-12 08:18:26', 1, '2010-08-12 08:18:26'),
(5, 2, 6, 7, 1, '2010-08-04 13:21:12', 1, '2010-08-04 13:21:12'),
(5, 4, 1, 10, 1, '2010-08-04 13:19:42', 1, '2010-08-12 08:17:47'),
(5, 4, 6, 9, 1, '2010-08-04 13:20:38', 1, '2010-08-04 13:20:38'),
(6, 1, 1, 6, 1, '2010-08-04 13:18:26', 1, '2010-08-04 13:18:26'),
(6, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(6, 1, 3, 5, 1, '2010-08-12 08:18:51', 1, '2010-08-12 08:18:51'),
(6, 1, 6, 6, 1, '2010-07-28 08:31:02', 1, '2010-07-28 09:57:14'),
(6, 2, 1, 7, 1, '2010-08-04 13:18:54', 1, '2010-08-04 13:18:54'),
(6, 2, 2, 8, 1, '2010-08-12 08:18:26', 1, '2010-08-12 08:18:26'),
(6, 2, 6, 7, 1, '2010-08-04 13:21:12', 1, '2010-08-04 13:21:12'),
(6, 4, 1, 10, 1, '2010-08-04 13:19:42', 1, '2010-08-12 08:17:47'),
(6, 4, 6, 9, 1, '2010-08-04 13:20:38', 1, '2010-08-04 13:20:38'),
(7, 1, 1, 6, 1, '2010-08-04 13:18:26', 1, '2010-08-04 13:18:26'),
(7, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(7, 1, 3, 5, 1, '2010-08-12 08:18:51', 1, '2010-08-12 08:18:51'),
(7, 1, 6, 6, 1, '2010-07-28 08:31:02', 1, '2010-07-28 09:57:14'),
(7, 2, 1, 7, 1, '2010-08-04 13:18:54', 1, '2010-08-04 13:18:54'),
(7, 2, 2, 8, 1, '2010-08-12 08:18:26', 1, '2010-08-12 08:18:26'),
(7, 2, 6, 7, 1, '2010-08-04 13:21:12', 1, '2010-08-04 13:21:12'),
(7, 4, 1, 10, 1, '2010-08-04 13:19:42', 1, '2010-08-12 08:17:47'),
(7, 4, 6, 9, 1, '2010-08-04 13:20:38', 1, '2010-08-04 13:20:38'),
(8, 1, 1, 6, 1, '2010-08-04 13:18:26', 1, '2010-08-04 13:18:26'),
(8, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(8, 1, 3, 5, 1, '2010-08-12 08:18:51', 1, '2010-08-12 08:18:51'),
(8, 1, 6, 6, 1, '2010-07-28 08:31:02', 1, '2010-07-28 09:57:14'),
(8, 2, 1, 7, 1, '2010-08-04 13:18:54', 1, '2010-08-04 13:18:54'),
(8, 2, 2, 8, 1, '2010-08-12 08:18:26', 1, '2010-08-12 08:18:26'),
(8, 2, 6, 7, 1, '2010-08-04 13:21:12', 1, '2010-08-04 13:21:12'),
(8, 4, 1, 10, 1, '2010-08-04 13:19:42', 1, '2010-08-12 08:17:47'),
(8, 4, 6, 9, 1, '2010-08-04 13:20:38', 1, '2010-08-04 13:20:38'),
(9, 1, 1, 6, 1, '2010-08-04 13:18:26', 1, '2010-08-04 13:18:26'),
(9, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(9, 1, 3, 5, 1, '2010-08-12 08:18:51', 1, '2010-08-12 08:18:51'),
(9, 1, 6, 6, 1, '2010-07-28 08:31:02', 1, '2010-07-28 09:57:14'),
(9, 2, 1, 7, 1, '2010-08-04 13:18:54', 1, '2010-08-04 13:18:54'),
(9, 2, 2, 8, 1, '2010-08-12 08:18:25', 1, '2010-08-12 08:18:27'),
(9, 2, 6, 7, 1, '2010-08-04 13:21:12', 1, '2010-08-04 13:21:12'),
(9, 4, 1, 10, 1, '2010-08-04 13:19:42', 1, '2010-08-12 08:17:47'),
(9, 4, 6, 9, 1, '2010-08-04 13:20:38', 1, '2010-08-04 13:20:38'),
(10, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(10, 1, 6, 6, 1, '2010-07-28 08:31:02', 1, '2010-07-28 09:57:15'),
(10, 2, 6, 7, 1, '2010-08-04 13:21:27', 1, '2010-08-04 13:21:27'),
(10, 4, 6, 9, 1, '2010-08-23 08:55:19', 1, '2010-08-23 08:55:19'),
(11, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(11, 1, 6, 6, 1, '2010-07-28 09:53:57', 1, '2010-07-28 09:53:57'),
(11, 2, 6, 7, 1, '2010-08-04 13:21:27', 1, '2010-08-04 13:21:27'),
(11, 4, 6, 9, 1, '2010-08-23 08:55:19', 1, '2010-08-23 08:55:19'),
(12, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(12, 1, 6, 6, 1, '2010-07-28 09:53:57', 1, '2010-07-28 09:53:57'),
(12, 2, 6, 7, 1, '2010-08-04 13:21:29', 1, '2010-08-04 13:21:29'),
(12, 4, 6, 9, 1, '2010-08-23 08:55:19', 1, '2010-08-23 08:55:19'),
(13, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(13, 1, 6, 6, 1, '2010-07-28 09:53:57', 1, '2010-07-28 09:53:57'),
(13, 2, 6, 7, 1, '2010-08-04 13:21:28', 1, '2010-08-04 13:21:28'),
(13, 4, 6, 9, 1, '2010-08-23 08:55:19', 1, '2010-08-23 08:55:19'),
(14, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(14, 1, 6, 6, 1, '2010-07-28 09:53:57', 1, '2010-07-28 09:53:57'),
(14, 2, 6, 7, 1, '2010-08-04 13:21:28', 1, '2010-08-04 13:21:28'),
(14, 4, 6, 9, 1, '2010-08-23 08:55:19', 1, '2010-08-23 08:55:19'),
(15, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(15, 1, 6, 6, 1, '2010-07-28 09:53:57', 1, '2010-07-28 09:53:57'),
(15, 2, 6, 7, 1, '2010-08-04 13:21:29', 1, '2010-08-04 13:21:29'),
(15, 4, 6, 9, 1, '2010-08-23 08:55:19', 1, '2010-08-23 08:55:19'),
(16, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(16, 1, 6, 6, 1, '2010-07-28 09:53:57', 1, '2010-07-28 09:53:57'),
(16, 2, 6, 7, 1, '2010-08-04 13:21:30', 1, '2010-08-04 13:21:30'),
(16, 4, 6, 9, 1, '2010-08-23 08:55:19', 1, '2010-08-23 08:55:19'),
(17, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(17, 1, 6, 6, 1, '2010-07-28 09:53:57', 1, '2010-07-28 09:53:57'),
(17, 2, 6, 7, 1, '2010-08-04 13:21:30', 1, '2010-08-04 13:21:30'),
(17, 4, 6, 9, 1, '2010-08-23 08:55:19', 1, '2010-08-23 08:55:19'),
(18, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(18, 1, 6, 6, 1, '2010-07-28 09:53:57', 1, '2010-07-28 09:53:57'),
(18, 2, 6, 7, 1, '2010-08-04 13:21:31', 1, '2010-08-04 13:21:31'),
(18, 4, 6, 9, 1, '2010-08-23 08:55:19', 1, '2010-08-23 08:55:19'),
(19, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(19, 1, 6, 6, 1, '2010-07-28 09:53:57', 1, '2010-07-28 09:53:57'),
(19, 2, 6, 7, 1, '2010-08-04 13:21:31', 1, '2010-08-04 13:21:31'),
(19, 4, 6, 9, 1, '2010-08-23 08:55:19', 1, '2010-08-23 08:55:19'),
(20, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(20, 1, 6, 6, 1, '2010-07-28 09:53:57', 1, '2010-07-28 09:53:57'),
(20, 2, 6, 7, 1, '2010-08-04 13:21:32', 1, '2010-08-04 13:21:32'),
(20, 4, 6, 9, 1, '2010-08-23 08:55:26', 1, '2010-08-23 08:55:26'),
(21, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(21, 1, 6, 6, 1, '2010-07-28 09:54:12', 1, '2010-07-28 09:54:12'),
(21, 2, 6, 7, 1, '2010-08-04 13:21:32', 1, '2010-08-04 13:21:32'),
(21, 4, 6, 9, 1, '2010-08-23 08:55:26', 1, '2010-08-23 08:55:26'),
(22, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(22, 1, 6, 6, 1, '2010-07-28 09:54:12', 1, '2010-07-28 09:54:12'),
(22, 2, 6, 7, 1, '2010-08-04 13:21:32', 1, '2010-08-04 13:21:32'),
(22, 4, 6, 9, 1, '2010-08-23 08:55:26', 1, '2010-08-23 08:55:26'),
(23, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(23, 1, 6, 6, 1, '2010-07-28 09:54:12', 1, '2010-07-28 09:54:12'),
(23, 2, 6, 7, 1, '2010-08-04 13:21:33', 1, '2010-08-04 13:21:33'),
(23, 4, 6, 9, 1, '2010-08-23 08:55:26', 1, '2010-08-23 08:55:26'),
(24, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(24, 1, 6, 6, 1, '2010-07-28 09:54:12', 1, '2010-07-28 09:54:12'),
(24, 2, 6, 7, 1, '2010-08-04 13:21:35', 1, '2010-08-04 13:21:35'),
(24, 4, 6, 9, 1, '2010-08-23 08:55:26', 1, '2010-08-23 08:55:26'),
(25, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(25, 1, 6, 6, 1, '2010-07-28 09:54:12', 1, '2010-07-28 09:54:12'),
(25, 2, 6, 7, 1, '2010-08-04 13:21:33', 1, '2010-08-04 13:21:33'),
(25, 4, 6, 9, 1, '2010-08-23 08:55:26', 1, '2010-08-23 08:55:26'),
(26, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(26, 1, 6, 6, 1, '2010-07-28 09:54:07', 1, '2010-07-28 09:54:12'),
(26, 2, 6, 7, 1, '2010-08-04 13:21:34', 1, '2010-08-04 13:21:34'),
(26, 4, 6, 9, 1, '2010-08-23 08:55:26', 1, '2010-08-23 08:55:26'),
(27, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(27, 1, 6, 6, 1, '2010-07-28 09:54:12', 1, '2010-07-28 09:54:12'),
(27, 2, 6, 7, 1, '2010-08-04 13:21:34', 1, '2010-08-04 13:21:34'),
(27, 4, 6, 9, 1, '2010-08-23 08:55:26', 1, '2010-08-23 08:55:26'),
(28, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(28, 1, 6, 6, 1, '2010-07-28 09:54:12', 1, '2010-07-28 09:54:12'),
(28, 2, 6, 7, 1, '2010-08-04 13:21:33', 1, '2010-08-04 13:21:33'),
(28, 4, 6, 9, 1, '2010-08-23 08:55:26', 1, '2010-08-23 08:55:26'),
(29, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(29, 1, 6, 6, 1, '2010-07-28 09:54:12', 1, '2010-07-28 09:54:12'),
(29, 4, 6, 9, 1, '2010-08-23 08:55:24', 1, '2010-08-23 08:55:26'),
(30, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(30, 1, 6, 6, 1, '2010-07-28 09:54:12', 1, '2010-07-28 09:54:12'),
(30, 4, 6, 9, 1, '2010-08-23 08:55:32', 1, '2010-08-23 08:55:32'),
(31, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(31, 1, 6, 6, 1, '2010-07-28 09:54:25', 1, '2010-07-28 09:54:25'),
(31, 4, 6, 9, 1, '2010-08-23 08:55:32', 1, '2010-08-23 08:55:32'),
(32, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(32, 1, 6, 6, 1, '2010-07-28 09:54:25', 1, '2010-07-28 09:54:25'),
(32, 4, 6, 9, 1, '2010-08-23 08:55:32', 1, '2010-08-23 08:55:32'),
(33, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(33, 1, 6, 6, 1, '2010-07-28 09:54:25', 1, '2010-07-28 09:54:25'),
(33, 4, 6, 9, 1, '2010-08-23 08:55:32', 1, '2010-08-23 08:55:32'),
(34, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(34, 1, 6, 6, 1, '2010-07-28 09:54:25', 1, '2010-07-28 09:54:25'),
(34, 4, 6, 9, 1, '2010-08-23 08:55:32', 1, '2010-08-23 08:55:32'),
(35, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(35, 1, 6, 6, 1, '2010-07-28 09:54:25', 1, '2010-07-28 09:54:25'),
(35, 4, 6, 9, 1, '2010-08-23 08:55:32', 1, '2010-08-23 08:55:32'),
(36, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(36, 1, 6, 6, 1, '2010-07-28 09:54:25', 1, '2010-07-28 09:54:25'),
(36, 4, 6, 9, 1, '2010-08-23 08:55:32', 1, '2010-08-23 08:55:32'),
(37, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(37, 1, 6, 6, 1, '2010-07-28 09:54:25', 1, '2010-07-28 09:54:25'),
(37, 4, 6, 9, 1, '2010-08-23 08:55:32', 1, '2010-08-23 08:55:32'),
(38, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(38, 1, 6, 6, 1, '2010-07-28 09:54:25', 1, '2010-07-28 09:54:25'),
(38, 4, 6, 9, 1, '2010-08-23 08:55:32', 1, '2010-08-23 08:55:32'),
(39, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(39, 1, 6, 6, 1, '2010-07-28 09:54:25', 1, '2010-07-28 09:54:25'),
(39, 4, 6, 9, 1, '2010-08-23 08:55:31', 1, '2010-08-23 08:55:33'),
(40, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(40, 1, 6, 6, 1, '2010-07-28 09:54:25', 1, '2010-07-28 09:54:25'),
(41, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(41, 1, 6, 6, 1, '2010-07-28 09:54:34', 1, '2010-07-28 09:54:34'),
(42, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(42, 1, 6, 6, 1, '2010-07-28 09:54:34', 1, '2010-07-28 09:54:34'),
(43, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(43, 1, 6, 6, 1, '2010-07-28 09:54:34', 1, '2010-07-28 09:54:34'),
(44, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(44, 1, 6, 6, 1, '2010-07-28 09:54:34', 1, '2010-07-28 09:54:34'),
(45, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(45, 1, 6, 6, 1, '2010-07-28 09:54:34', 1, '2010-07-28 09:54:34'),
(46, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(46, 1, 6, 6, 1, '2010-07-28 09:54:34', 1, '2010-07-28 09:54:34'),
(47, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(47, 1, 6, 6, 1, '2010-07-28 09:54:34', 1, '2010-07-28 09:54:34'),
(48, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(48, 1, 6, 6, 1, '2010-07-28 09:54:34', 1, '2010-07-28 09:54:34'),
(49, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(49, 1, 6, 6, 1, '2010-07-28 09:54:34', 1, '2010-07-28 09:54:34'),
(50, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(50, 1, 6, 6, 1, '2010-07-28 09:54:34', 1, '2010-07-28 09:54:34'),
(51, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(51, 1, 6, 6, 1, '2010-07-28 09:54:42', 1, '2010-07-28 09:54:42'),
(52, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(52, 1, 6, 6, 1, '2010-07-28 09:54:42', 1, '2010-07-28 09:54:42'),
(53, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(53, 1, 6, 6, 1, '2010-07-28 09:54:42', 1, '2010-07-28 09:54:42'),
(54, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(54, 1, 6, 6, 1, '2010-07-28 09:54:42', 1, '2010-07-28 09:54:42'),
(55, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(55, 1, 6, 6, 1, '2010-07-28 09:54:42', 1, '2010-07-28 09:54:42'),
(56, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(56, 1, 6, 6, 1, '2010-07-28 09:54:42', 1, '2010-07-28 09:54:42'),
(57, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(57, 1, 6, 6, 1, '2010-07-28 09:54:42', 1, '2010-07-28 09:54:42'),
(58, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(58, 1, 6, 6, 1, '2010-07-28 09:54:42', 1, '2010-07-28 09:54:42'),
(59, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(59, 1, 6, 6, 1, '2010-07-28 09:54:42', 1, '2010-07-28 09:54:42'),
(60, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(60, 1, 6, 6, 1, '2010-07-28 09:54:42', 1, '2010-07-28 09:54:42'),
(61, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(61, 1, 6, 6, 1, '2010-07-28 09:54:48', 1, '2010-07-28 09:55:34'),
(62, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(62, 1, 6, 6, 1, '2010-07-28 09:54:50', 1, '2010-07-28 09:55:34'),
(63, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(63, 1, 6, 6, 1, '2010-07-28 09:54:50', 1, '2010-07-28 09:55:34'),
(64, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(64, 1, 6, 6, 1, '2010-07-28 09:54:50', 1, '2010-07-28 09:55:34'),
(65, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(65, 1, 6, 6, 1, '2010-07-28 09:54:50', 1, '2010-07-28 09:55:34'),
(66, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(66, 1, 6, 6, 1, '2010-07-28 09:54:50', 1, '2010-07-28 09:55:35'),
(67, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(67, 1, 6, 6, 1, '2010-07-28 09:54:50', 1, '2010-07-28 09:55:35'),
(68, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(68, 1, 6, 6, 1, '2010-07-28 09:54:50', 1, '2010-07-28 09:55:35'),
(69, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(69, 1, 6, 6, 1, '2010-07-28 09:54:50', 1, '2010-07-28 09:55:35'),
(70, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(70, 1, 6, 6, 1, '2010-07-28 09:54:50', 1, '2010-07-28 09:55:35'),
(71, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(71, 1, 6, 6, 1, '2010-07-28 09:55:32', 1, '2010-07-28 09:55:32'),
(72, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(72, 1, 6, 6, 1, '2010-07-28 09:56:38', 1, '2010-07-28 09:56:38'),
(73, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(73, 1, 6, 6, 1, '2010-07-28 09:56:39', 1, '2010-07-28 09:56:39'),
(74, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(75, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(76, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(77, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(78, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(79, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(80, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(81, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(82, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(83, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(84, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(85, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(86, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(87, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(88, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(89, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(90, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(91, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(92, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(93, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(94, 1, 2, 6, 1, '2010-07-22 10:22:27', 1, '2010-07-22 10:22:43'),
(95, 1, 2, 6, 1, '2010-07-22 10:22:28', 1, '2010-07-22 10:22:43'),
(96, 1, 2, 6, 1, '2010-07-22 10:22:28', 1, '2010-07-22 10:22:43'),
(97, 1, 2, 6, 1, '2010-07-22 10:22:28', 1, '2010-07-22 10:22:43'),
(98, 1, 2, 6, 1, '2010-07-22 10:22:28', 1, '2010-07-22 10:22:43'),
(99, 1, 2, 6, 1, '2010-07-22 10:22:28', 1, '2010-07-22 10:22:43'),
(100, 1, 1, 6, 1, '2010-08-04 13:18:39', 1, '2010-08-04 13:18:39'),
(100, 1, 2, 6, 1, '2010-07-22 10:22:28', 1, '2010-07-22 10:22:43'),
(100, 2, 1, 7, 1, '2010-08-04 13:19:03', 1, '2010-08-04 13:19:03'),
(100, 2, 6, 7, 1, '2010-08-04 13:21:21', 1, '2010-08-04 13:21:21'),
(100, 4, 1, 9, 1, '2010-08-04 13:19:49', 1, '2010-08-04 13:19:49');

-- --------------------------------------------------------

--
-- Table structure for table `accountant_sales_invoice`
--

DROP TABLE IF EXISTS `accountant_sales_invoice`;
CREATE TABLE IF NOT EXISTS `accountant_sales_invoice` (
  `sales_invoice_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `voucher_id` bigint(30) unsigned NOT NULL COMMENT 'Quan hệ một - một với bảng accountant_transaction_voucher',
  `sales_serial_number` varchar(10) NOT NULL,
  `sales_invoice_number` varchar(20) NOT NULL,
  `sales_invoice_date` datetime NOT NULL,
  `customer_id` bigint(30) unsigned NOT NULL,
  `customer_name` varchar(100) NOT NULL,
  `customer_address` varchar(100) NOT NULL,
  `customer_tax_code` varchar(20) NOT NULL,
  `customer_contact` varchar(100) NOT NULL,
  `payment_type` varchar(20) NOT NULL COMMENT 'hình thức thanh toán',
  `debit_account_id` bigint(30) NOT NULL,
  `credit_account_id_amount` bigint(30) NOT NULL,
  `credit_account_id_vat` bigint(30) NOT NULL,
  `crediit_account_id_export` bigint(30) NOT NULL,
  `credit_acount_id_excise` bigint(30) NOT NULL,
  `currency_id` bigint(30) unsigned NOT NULL,
  `forex_rate` decimal(18,4) NOT NULL,
  `by_export` tinyint(1) unsigned NOT NULL,
  `for_service` tinyint(1) unsigned NOT NULL,
  `description` varchar(500) NOT NULL,
  `sales_type` tinyint(1) unsigned NOT NULL COMMENT '0: hóa đơn bán hàng thông thường; 1: hóa đơn có hàng bán bị trả lại hoặc giảm giá hàng bán; 2: hóa đơn nhận về do hàng bán trả lại; 3: hóa đơn xuất lại do giảm giá hàng bán',
  `is_locked` tinyint(1) unsigned NOT NULL COMMENT 'Dùng để xác định tình trạng cho phép chỉnh sửa hay không của Hóa đơn mua hàng',
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`sales_invoice_id`),
  KEY `fk_sales_invoice_voucher` (`voucher_id`),
  KEY `fk_sales_invoice_created_user` (`created_by_userid`),
  KEY `fk_sales_invoice_currency` (`currency_id`),
  KEY `fk_sales_invoice_customer` (`customer_id`),
  KEY `fk_sales_invoice_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=18 ;

--
-- Dumping data for table `accountant_sales_invoice`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_sales_payable`
--

DROP TABLE IF EXISTS `accountant_sales_payable`;
CREATE TABLE IF NOT EXISTS `accountant_sales_payable` (
  `payable_voucher_id` bigint(30) unsigned NOT NULL,
  `sales_invoice_id` bigint(30) unsigned NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`payable_voucher_id`,`sales_invoice_id`),
  KEY `fk_sales_payable_created_user` (`created_by_userid`),
  KEY `fk_sales_payable_modified_user` (`last_modified_by_userid`),
  KEY `fk_sales_payable_sales` (`sales_invoice_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `accountant_sales_payable`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_sales_receivable`
--

DROP TABLE IF EXISTS `accountant_sales_receivable`;
CREATE TABLE IF NOT EXISTS `accountant_sales_receivable` (
  `receivable_voucher_id` bigint(30) unsigned NOT NULL,
  `sales_invoice_id` bigint(30) unsigned NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`receivable_voucher_id`,`sales_invoice_id`),
  KEY `fk_sales_receivable_created_user` (`created_by_userid`),
  KEY `fk_sales_receivable_modified_user` (`last_modified_by_userid`),
  KEY `fk_sales_receivable_sales` (`sales_invoice_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `accountant_sales_receivable`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_sales_reissue`
--

DROP TABLE IF EXISTS `accountant_sales_reissue`;
CREATE TABLE IF NOT EXISTS `accountant_sales_reissue` (
  `primary_sales_invoice_id` bigint(30) unsigned NOT NULL,
  `secondary_sales_invoice_id` bigint(30) unsigned NOT NULL,
  PRIMARY KEY (`primary_sales_invoice_id`,`secondary_sales_invoice_id`),
  KEY `fk_reissue_secondary` (`secondary_sales_invoice_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `accountant_sales_reissue`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_sales_returns`
--

DROP TABLE IF EXISTS `accountant_sales_returns`;
CREATE TABLE IF NOT EXISTS `accountant_sales_returns` (
  `sales_invoice_id` bigint(30) unsigned NOT NULL,
  `returns_invoice_id` bigint(30) unsigned NOT NULL,
  PRIMARY KEY (`sales_invoice_id`,`returns_invoice_id`),
  KEY `fk_returns_sales_returns` (`returns_invoice_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `accountant_sales_returns`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_tax_rate`
--

DROP TABLE IF EXISTS `accountant_tax_rate`;
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=11 ;

--
-- Dumping data for table `accountant_tax_rate`
--

INSERT INTO `accountant_tax_rate` (`tax_rate_id`, `tax_id`, `rate`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 1, 5, 0, 0, '2010-06-07 14:59:55', 0, '2010-06-07 14:59:55'),
(6, 1, 10, 0, 0, '2010-06-07 15:00:00', 0, '2010-06-07 15:00:00'),
(7, 2, 5, 0, 0, '2010-06-07 15:00:09', 0, '2010-06-07 15:00:09'),
(8, 2, 10, 0, 0, '2010-06-07 15:00:14', 0, '2010-06-07 15:00:14'),
(9, 4, 5, 0, 0, '2010-06-07 15:00:22', 0, '2010-06-07 15:00:22'),
(10, 4, 10, 0, 1, '2010-08-12 08:17:16', 1, '2010-08-12 08:17:16');

-- --------------------------------------------------------

--
-- Table structure for table `accountant_transaction_arising`
--

DROP TABLE IF EXISTS `accountant_transaction_arising`;
CREATE TABLE IF NOT EXISTS `accountant_transaction_arising` (
  `transaction_arising_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Khóa chính từng bút toán của các loại chứng từ',
  `batch_id` bigint(30) unsigned NOT NULL,
  `description` text NOT NULL COMMENT 'Diễn giải cho bút toán để hiện lên báo cáo',
  `subject_id` bigint(30) unsigned NOT NULL COMMENT 'Mã đối tượng hạch toán, đối tượng nợ hoặc đối tượng có',
  `entry_account_id` bigint(30) unsigned NOT NULL COMMENT 'Tài khoản hạch toán',
  `corresponding_account_id` bigint(30) unsigned NOT NULL COMMENT 'Tài khoản đối ứng',
  `amount` decimal(18,4) NOT NULL COMMENT 'Giá trị nguyên tệ của bút toán',
  `currency_id` bigint(30) unsigned NOT NULL COMMENT 'Loại tiền tệ',
  `forex_rate` decimal(18,4) NOT NULL COMMENT 'Tỷ giá qui đổi',
  `debit_amount_number` decimal(18,4) NOT NULL DEFAULT '0.0000' COMMENT 'Số tiền phát sinh nợ',
  `credit_amount_number` decimal(18,4) NOT NULL DEFAULT '0.0000' COMMENT 'Số tiền phát sinh có',
  PRIMARY KEY (`transaction_arising_id`),
  KEY `fk_transaction_arising_batch` (`batch_id`),
  KEY `fk_transaction_arising_subject` (`subject_id`),
  KEY `fk_transaction_arising_entry_account` (`entry_account_id`),
  KEY `fk_transaction_arising_corresponding_account` (`corresponding_account_id`),
  KEY `fk_transaction_arising_currency` (`currency_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT AUTO_INCREMENT=1 ;

--
-- Dumping data for table `accountant_transaction_arising`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_transaction_batch`
--

DROP TABLE IF EXISTS `accountant_transaction_batch`;
CREATE TABLE IF NOT EXISTS `accountant_transaction_batch` (
  `batch_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT COMMENT 'bó bút toán',
  `voucher_id` bigint(30) unsigned NOT NULL,
  `execution_id` bigint(30) unsigned NOT NULL COMMENT 'khác với phần hành của voucher, phần hành này thể hiện nơi mà bút toán thuộc về, bắt buộc phải thuộc phân hệ kế toán',
  `batch_note` varchar(300) NOT NULL,
  `obj_type_id` bigint(30) NOT NULL,
  `obj_key_id` bigint(30) NOT NULL,
  PRIMARY KEY (`batch_id`),
  KEY `fk_accountant_batch_voucher` (`voucher_id`),
  KEY `fk_accountant_batch_execution` (`execution_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=131 ;

--
-- Dumping data for table `accountant_transaction_batch`
--

INSERT INTO `accountant_transaction_batch` (`batch_id`, `voucher_id`, `execution_id`, `batch_note`, `obj_type_id`, `obj_key_id`) VALUES
(109, 84, 13, 'Hóa đơn mua hàng trong nước số "sadfsd", ngày "14/09/2010", "Hợp Tác Xã VTHH Và Xe Du Lịch THỦ ĐỨC"', 0, 0),
(110, 84, 13, 'Hóa đơn mua hàng trong nước số "sadfsd", ngày "14/09/2010", "Hợp Tác Xã VTHH Và Xe Du Lịch THỦ ĐỨC"', 0, 0),
(111, 85, 13, 'Hóa đơn mua hàng trong nước số "adsfasd", ngày "14/09/2010", "Chi Cục Thuế Quận Thủ Đức"', 0, 0),
(112, 85, 13, 'Hóa đơn mua hàng trong nước số "adsfasd", ngày "14/09/2010", "Chi Cục Thuế Quận Thủ Đức"', 0, 0),
(113, 86, 13, 'Hóa đơn mua hàng trong nước số "adsfasd", ngày "14/09/2010", "Chi Cục Thuế Quận Thủ Đức"', 0, 0),
(114, 86, 13, 'Hóa đơn mua hàng trong nước số "adsfasd", ngày "14/09/2010", "Chi Cục Thuế Quận Thủ Đức"', 0, 0),
(115, 87, 13, 'Hóa đơn mua hàng trong nước số "adsfasd", ngày "14/09/2010", "Chi Cục Thuế Quận Thủ Đức"', 0, 0),
(116, 87, 13, 'Hóa đơn mua hàng trong nước số "adsfasd", ngày "14/09/2010", "Chi Cục Thuế Quận Thủ Đức"', 0, 0),
(117, 88, 13, 'Hóa đơn mua hàng trong nước số "adsfasd", ngày "14/09/2010", "Chi Cục Thuế Quận Thủ Đức"', 0, 0),
(118, 88, 13, 'Hóa đơn mua hàng trong nước số "adsfasd", ngày "14/09/2010", "Chi Cục Thuế Quận Thủ Đức"', 0, 0),
(119, 89, 13, 'Hóa đơn mua hàng trong nước số "adsfasd", ngày "14/09/2010", "Chi Cục Thuế Quận Thủ Đức"', 0, 0),
(120, 89, 13, 'Hóa đơn mua hàng trong nước số "adsfasd", ngày "14/09/2010", "Chi Cục Thuế Quận Thủ Đức"', 0, 0),
(121, 90, 13, 'Hóa đơn mua hàng trong nước số "adsfasd", ngày "14/09/2010", "Chi Cục Thuế Quận Thủ Đức"', 0, 0),
(122, 90, 13, 'Hóa đơn mua hàng trong nước số "adsfasd", ngày "14/09/2010", "Chi Cục Thuế Quận Thủ Đức"', 0, 0),
(123, 91, 13, 'Hóa đơn mua hàng trong nước số "adsfasd", ngày "14/09/2010", "Chi Cục Thuế Quận Thủ Đức"', 0, 0),
(124, 91, 13, 'Hóa đơn mua hàng trong nước số "adsfasd", ngày "14/09/2010", "Chi Cục Thuế Quận Thủ Đức"', 0, 0),
(125, 92, 13, 'Hóa đơn mua hàng trong nước số "adsfasd", ngày "14/09/2010", "Chi Cục Thuế Quận Thủ Đức"', 0, 0),
(126, 92, 13, 'Hóa đơn mua hàng trong nước số "adsfasd", ngày "14/09/2010", "Chi Cục Thuế Quận Thủ Đức"', 0, 0),
(127, 93, 13, 'Hóa đơn mua hàng trong nước số "adsfasd", ngày "14/09/2010", "Chi Cục Thuế Quận Thủ Đức"', 0, 0),
(128, 93, 13, 'Hóa đơn mua hàng trong nước số "adsfasd", ngày "14/09/2010", "Chi Cục Thuế Quận Thủ Đức"', 0, 0),
(129, 94, 13, 'Hóa đơn mua hàng trong nước số "adsfasd", ngày "14/09/2010", "Chi Cục Thuế Quận Thủ Đức"', 0, 0),
(130, 94, 13, 'Hóa đơn mua hàng trong nước số "adsfasd", ngày "14/09/2010", "Chi Cục Thuế Quận Thủ Đức"', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `accountant_transaction_correspondence`
--

DROP TABLE IF EXISTS `accountant_transaction_correspondence`;
CREATE TABLE IF NOT EXISTS `accountant_transaction_correspondence` (
  `correspondence_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `entry_id` bigint(30) unsigned NOT NULL,
  `detail_account_id` bigint(30) unsigned NOT NULL COMMENT 'tài khoản bên nhiều trong quan hệ một - nhiều',
  `debit_credit` tinyint(1) NOT NULL COMMENT 'thể hiện tài khoản bên một là bên nợ (-1) hay bên có (1)',
  `original_amount` decimal(18,4) NOT NULL,
  `currency_id` bigint(30) unsigned NOT NULL,
  `forex_rate` decimal(18,4) NOT NULL,
  `converted_amount` decimal(18,4) NOT NULL,
  `note` text NOT NULL,
  `obj_type_id_1` bigint(30) NOT NULL,
  `obj_key_id_1` bigint(30) NOT NULL,
  `obj_type_id_2` bigint(30) NOT NULL,
  `obj_key_id_2` bigint(30) NOT NULL,
  `obj_type_id_3` bigint(30) NOT NULL,
  `obj_key_id_3` bigint(30) NOT NULL,
  `obj_type_id_4` bigint(30) NOT NULL,
  `obj_key_id_4` bigint(30) NOT NULL,
  `obj_type_id_5` bigint(30) NOT NULL,
  `obj_key_id_5` bigint(30) NOT NULL,
  PRIMARY KEY (`correspondence_id`),
  KEY `fk_accountant_correspondence_entry` (`entry_id`),
  KEY `fk_accountant_correspondence_account` (`detail_account_id`),
  KEY `fk_accountant_correspondence_currency` (`currency_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=208 ;

--
-- Dumping data for table `accountant_transaction_correspondence`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_transaction_detail_arising`
--

DROP TABLE IF EXISTS `accountant_transaction_detail_arising`;
CREATE TABLE IF NOT EXISTS `accountant_transaction_detail_arising` (
  `transaction_detail_arising_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Khóa chính bảng chi tiết của các bút toán',
  `transaction_arising_id` bigint(30) unsigned NOT NULL COMMENT 'Bút toán hạch toán',
  `description` text NOT NULL COMMENT 'Diễn giải chi tiết bút toán',
  `entry_account_id` bigint(30) unsigned NOT NULL COMMENT 'tài khoản',
  `corresponding_account_id` bigint(30) unsigned NOT NULL COMMENT 'tài khoản đối ứng',
  `amount` decimal(18,4) NOT NULL COMMENT 'nguyên tệ',
  `currency_id` bigint(30) unsigned NOT NULL COMMENT 'loại tiền tệ',
  `forex_rate` decimal(18,4) NOT NULL COMMENT 'tỷ giá qui đổi',
  `debit_amount_number` decimal(18,4) NOT NULL COMMENT 'số phát sinh nợ',
  `credit_amount_number` decimal(18,4) NOT NULL COMMENT 'số phát sinh có',
  `object_type1` bigint(30) NOT NULL,
  `object_key1` bigint(30) NOT NULL,
  `object_type2` bigint(30) NOT NULL,
  `object_key2` bigint(30) NOT NULL,
  `object_type3` bigint(30) NOT NULL,
  `object_key3` bigint(30) NOT NULL,
  `object_type4` bigint(30) NOT NULL,
  `object_key4` bigint(30) NOT NULL,
  PRIMARY KEY (`transaction_detail_arising_id`),
  KEY `fk_transaction_detail_arising_id` (`transaction_arising_id`),
  KEY `fk_transaction_detail_entry_account` (`entry_account_id`),
  KEY `fk_transaction_detail_corresponding_account` (`corresponding_account_id`),
  KEY `fk_transaction_detail_currency` (`currency_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `accountant_transaction_detail_arising`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_transaction_entry`
--

DROP TABLE IF EXISTS `accountant_transaction_entry`;
CREATE TABLE IF NOT EXISTS `accountant_transaction_entry` (
  `entry_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `entry_type_id` bigint(30) unsigned NOT NULL,
  `batch_id` bigint(30) unsigned NOT NULL,
  `master_account_id` bigint(30) unsigned NOT NULL COMMENT 'tài khoản bên một trong quan hệ một - nhiều',
  `debit_credit` tinyint(1) NOT NULL COMMENT 'thể hiện tài khoản bên một là bên nợ (-1) hay bên có (1)',
  `original_amount` decimal(18,4) NOT NULL,
  `currency_id` bigint(30) unsigned NOT NULL,
  `forex_rate` decimal(18,4) NOT NULL,
  `converted_amount` decimal(18,4) NOT NULL,
  `note` text NOT NULL,
  `obj_type_id_1` bigint(30) NOT NULL,
  `obj_key_id_1` bigint(30) NOT NULL,
  `obj_type_id_2` bigint(30) NOT NULL,
  `obj_key_id_2` bigint(30) NOT NULL,
  `obj_type_id_3` bigint(30) NOT NULL,
  `obj_key_id_3` bigint(30) NOT NULL,
  `obj_type_id_4` bigint(30) NOT NULL,
  `obj_key_id_4` bigint(30) NOT NULL,
  `obj_type_id_5` bigint(30) NOT NULL,
  `obj_key_id_5` bigint(30) NOT NULL,
  PRIMARY KEY (`entry_id`),
  KEY `fk_accountant_entry_batch` (`batch_id`),
  KEY `fk_accountant_entry_account` (`master_account_id`),
  KEY `fk_accountant_entry_currency` (`currency_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=152 ;

--
-- Dumping data for table `accountant_transaction_entry`
--


-- --------------------------------------------------------

--
-- Table structure for table `accountant_transaction_voucher`
--

DROP TABLE IF EXISTS `accountant_transaction_voucher`;
CREATE TABLE IF NOT EXISTS `accountant_transaction_voucher` (
  `voucher_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT COMMENT 'chứng từ có thể phát sinh từ phân hệ kế toán, hay có thể từ các phân hệ khác chuyển qua',
  `from_transference` tinyint(1) unsigned NOT NULL COMMENT 'Cờ phân biệt phiếu định khoản tổng hợp, hay từ các phần hành khác chuyển sang',
  `execution_id` bigint(30) unsigned NOT NULL COMMENT 'phần hành nơi chứng từ phát sinh, có thể không thuộc phân hệ kế toán',
  `period_id` bigint(30) unsigned NOT NULL,
  `voucher_number` varchar(100) NOT NULL COMMENT 'số chứng từ, phát sinh từ phân hệ gốc, lưu nguyên qua đây',
  `voucher_date` datetime NOT NULL COMMENT 'ngày chứng từ, lấy giá trị từ phân hệ gốc chuyển qua',
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`voucher_id`),
  KEY `fk_accountant_voucher_execution` (`execution_id`),
  KEY `fk_accountant_voucher_created_user` (`created_by_userid`),
  KEY `fk_accountant_voucher_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=95 ;

--
-- Dumping data for table `accountant_transaction_voucher`
--

INSERT INTO `accountant_transaction_voucher` (`voucher_id`, `from_transference`, `execution_id`, `period_id`, `voucher_number`, `voucher_date`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, 0, 0, 0, '', '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(84, 1, 13, 1, 'sadfsd', '2010-09-14 01:52:24', 1, '2010-09-15 01:52:24', 1, '2010-09-15 01:52:24'),
(85, 1, 13, 1, 'adsfasd', '2010-09-14 02:02:44', 1, '2010-09-15 02:02:44', 1, '2010-09-15 02:02:44'),
(86, 1, 13, 1, 'adsfasd', '2010-09-14 02:03:00', 1, '2010-09-15 02:03:00', 1, '2010-09-15 02:03:00'),
(87, 1, 13, 1, 'adsfasd', '2010-09-14 02:04:35', 1, '2010-09-15 02:04:35', 1, '2010-09-15 02:04:35'),
(88, 1, 13, 1, 'adsfasd', '2010-09-14 02:05:44', 1, '2010-09-15 02:05:44', 1, '2010-09-15 02:05:44'),
(89, 1, 13, 1, 'adsfasd', '2010-09-14 02:06:29', 1, '2010-09-15 02:06:29', 1, '2010-09-15 02:06:29'),
(90, 1, 13, 1, 'adsfasd', '2010-09-14 02:07:50', 1, '2010-09-15 02:07:50', 1, '2010-09-15 02:07:50'),
(91, 1, 13, 1, 'adsfasd', '2010-09-14 02:08:32', 1, '2010-09-15 02:08:32', 1, '2010-09-15 02:08:32'),
(92, 1, 13, 1, 'adsfasd', '2010-09-14 02:08:53', 1, '2010-09-15 02:08:53', 1, '2010-09-15 02:08:53'),
(93, 1, 13, 1, 'adsfasd', '2010-09-14 02:10:21', 1, '2010-09-15 02:10:21', 1, '2010-09-15 02:10:21'),
(94, 1, 13, 1, 'adsfasd', '2010-09-14 02:11:04', 1, '2010-09-15 02:11:04', 1, '2010-09-15 02:11:04');

-- --------------------------------------------------------

--
-- Table structure for table `core_acl_role_parent`
--

DROP TABLE IF EXISTS `core_acl_role_parent`;
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

DROP TABLE IF EXISTS `core_cache`;
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

DROP TABLE IF EXISTS `core_config_field`;
CREATE TABLE IF NOT EXISTS `core_config_field` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `path` varchar(255) NOT NULL,
  `title` varchar(128) NOT NULL,
  `config_type` varchar(15) NOT NULL DEFAULT '',
  `model` varchar(128) NOT NULL,
  `model_assigned_with` varchar(128) NOT NULL,
  `config_options` text,
  `description` text,
  `can_change` tinyint(1) unsigned NOT NULL,
  `display_order` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_path` (`path`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=34 ;

--
-- Dumping data for table `core_config_field`
--

INSERT INTO `core_config_field` (`id`, `path`, `title`, `config_type`, `model`, `model_assigned_with`, `config_options`, `description`, `can_change`, `display_order`) VALUES
(1, 'main', 'Main', 'string', '', '', NULL, '', 0, 0),
(2, 'main/store', 'Store', 'string', '', '', NULL, '', 0, 0),
(3, 'main/store/name', 'Name', 'string', '', '', NULL, '', 0, 0),
(4, 'main/store/country', 'Country', 'select', 'Country', '', NULL, 'Store Country', 0, 0),
(5, 'main/store/zone', 'Zone', 'select', 'ZoneByCountry', 'main/store/country', NULL, 'Store zone(state,province)', 0, 0),
(6, 'main/store/city', 'City', 'string', '', '', NULL, '', 0, 0),
(7, 'main/store/taxBasis', 'Tax Basis for products', 'select', 'TaxBasis', '', NULL, 'Basis that will be used for calculating products taxes', 0, 0),
(8, 'main/store/language', 'Default language', 'select', 'Language', '', NULL, 'Default site language', 1, 1),
(9, 'main/store/currency', 'Default display currency', 'select', 'Currency', '', NULL, 'Default currency', 1, 2),
(10, 'main/store/zip', 'Zipcode', 'string', '', '', NULL, 'Zip code', 0, 0),
(11, 'main/store/owner', 'Store owner', 'string', '', '', NULL, '', 0, 0),
(12, 'main/store/locale', 'Default locale', 'select', 'ZendLocale', '', NULL, 'Default site locale', 1, 3),
(13, 'main/store/timezone', 'Timezone', 'select', 'ZendTimezone', '', NULL, 'Timezone', 1, 4),
(14, 'sale/main/saleRoute', 'Sale router', 'string', '', '', NULL, 'Sale url (example.com/<b>saleRoute</b>/product)', 0, 0),
(15, 'design/main/frontTemplateId', 'Front Template', 'select', 'Template', '', NULL, '', 0, 0),
(16, 'design/main/adminTemplateId', 'Admin Template', 'select', 'Template', '', NULL, '', 0, 0),
(17, 'design/htmlHead/titlePattern', 'Title Pattern', 'multiple', '', '', 'Page Title,Parent Page Titles,Site Name', 'Check values, which you want to see on page title', 0, 0),
(18, 'translation', 'Translation', 'string', '', '', NULL, '', 0, 0),
(19, 'translation/main', 'Main', 'string', '', '', NULL, '', 0, 0),
(20, 'translation/main/autodetect', 'Autodetect new words', 'bool', '', '', NULL, 'Autodetect new words (run if set TRUE: >chmod -R 0777 [root_path]/app/locale)', 0, 0),
(21, 'general/main/generalRoute', 'general router', 'string', '', '', NULL, 'general url', 0, 0),
(22, 'auth/main/authRoute', 'Authenticate router', 'string', '', '', NULL, '', 0, 0),
(23, 'language/main/languageRoute', 'Language router', 'string', '', '', NULL, '', 0, 0),
(24, 'accountant/main/accountantRoute', 'Accountant Route', 'string', '', '', NULL, NULL, 0, 0),
(25, 'inventory/main/inventoryRoute', 'Inventory Route', 'string', '', '', NULL, NULL, 0, 0),
(26, 'purchase/main/purchaseRoute', 'Purchase Route', 'string', '', '', NULL, NULL, 0, 0),
(27, 'sale/main/saleRoute', 'Sale Route', 'string', '', '', NULL, NULL, 0, 0),
(28, 'main/store/defaultTheme', 'Default Theme', 'string', '', '', NULL, NULL, 1, 5),
(29, 'main/store/companyName', 'Company Name', 'string', '', '', NULL, NULL, 1, 6),
(30, 'main/store/defaultDateTime', 'Default DateTime', 'string', '', '', NULL, NULL, 1, 7),
(31, 'main/store/defaultDecimalSeparator', 'Default Decimal Separator', 'string', '', '', NULL, NULL, 1, 8),
(32, 'main/store/defaultThousandSeparator', 'Default Thousand Separator', 'string', '', '', NULL, NULL, 1, 9),
(33, 'main/store/defaultDecimals', 'Default Decimals', 'string', '', '', NULL, NULL, 1, 10);

-- --------------------------------------------------------

--
-- Table structure for table `core_config_value`
--

DROP TABLE IF EXISTS `core_config_value`;
CREATE TABLE IF NOT EXISTS `core_config_value` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `config_field_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `path` varchar(128) NOT NULL,
  `value` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_config_field_id` (`config_field_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=30 ;

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
(26, 30, 'main/store/defaultDateTime', 'd/m/Y'),
(27, 31, 'main/store/defaultDecimalSeparator', ','),
(28, 32, 'main/store/defaultThousandSeparator', '.'),
(29, 33, 'main/store/defaultDecimals', '2');

-- --------------------------------------------------------

--
-- Table structure for table `core_language`
--

DROP TABLE IF EXISTS `core_language`;
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

DROP TABLE IF EXISTS `core_module_language`;
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
(1, 'definition_list_execution', '', 31, 'Importer - TL'),
(1, 'definition_list_execution', '', 32, 'Report - KT'),
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
(1, 'definition_list_function', '', 36, 'The proposed receivable bills'),
(1, 'definition_list_function', '', 37, 'Disarmament receivable'),
(1, 'definition_list_function', '', 38, 'Payables management'),
(1, 'definition_list_function', '', 39, 'The proposed payables bills'),
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
(1, 'definition_list_function', '', 81, 'List of fixed assets'),
(1, 'definition_list_function', '', 82, 'List of accounts payable'),
(1, 'definition_list_function', '', 83, 'List of accounts receivable'),
(1, 'definition_list_function', '', 84, 'Import Customer data'),
(1, 'definition_list_function', '', 85, 'Import Supplier data'),
(1, 'definition_list_function', '', 86, 'Import Product data'),
(1, 'definition_list_function', '', 87, 'Ending of accouting period'),
(1, 'definition_list_function', '', 88, 'Accounting Semiautomatic'),
(1, 'definition_list_function', '', 89, 'Company Preferences'),
(1, 'definition_list_function', '', 90, 'Department Maintenance'),
(1, 'definition_list_function', '', 91, 'Configuration Settings'),
(1, 'definition_list_function', '', 92, 'Staff Maintenance'),
(1, 'definition_list_function', '', 93, 'Role Permissions'),
(1, 'definition_list_function', '', 117, 'Account Balance'),
(1, 'definition_list_function', '', 119, 'Accounting Balance'),
(1, 'definition_list_function', '', 120, 'Business Results'),
(1, 'definition_list_function', '', 121, 'Bank Account Maintenance'),
(1, 'definition_list_function', '', 122, 'The list sold'),
(1, 'definition_list_function', '', 123, 'The list purchase'),
(1, 'definition_list_function', '', 124, 'Customer ledger'),
(1, 'definition_list_function', '', 125, 'General Receivable'),
(1, 'definition_list_function', '', 126, 'General journal'),
(1, 'definition_list_function', '', 127, 'Vat'),
(1, 'definition_list_function', '', 128, 'Collecting diaries'),
(1, 'definition_list_function', '', 129, 'Collecting diaries'),
(1, 'definition_list_function', '', 130, 'Spending diary'),
(1, 'definition_list_function', '', 131, 'Purchase diaries'),
(1, 'definition_list_function', '', 132, 'Sales diary'),
(1, 'definition_list_function', '', 133, 'Book details goods'),
(1, 'definition_list_function', '', 134, 'Export vote'),
(1, 'definition_list_function', '', 135, 'Sheet goods'),
(1, 'definition_list_function', '', 136, 'Stamp Debit'),
(1, 'definition_list_function', '', 137, 'Stamp Credit'),
(1, 'definition_list_function', '', 138, 'Service Catalog'),
(1, 'definition_list_function', '', 139, 'Warehouse Maintenance'),
(1, 'definition_list_function', '', 140, 'Setup Account Balance'),
(1, 'definition_list_function', '', 141, 'List Voucher type'),
(1, 'definition_list_function', '', 142, 'Export The Sale Invoice'),
(1, 'definition_list_function', '', 143, 'Export The detailed list of sale invoice'),
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
(2, 'definition_list_execution', '', 31, 'TL dữ liệu - TL'),
(2, 'definition_list_execution', '', 32, 'Báo cáo - KT'),
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
(2, 'definition_list_function', '', 36, 'Phiếu đề nghị thu'),
(2, 'definition_list_function', '', 37, 'Giải trừ phải thu'),
(2, 'definition_list_function', '', 38, 'Quản lý phải trả'),
(2, 'definition_list_function', '', 39, 'Phiếu đề nghị chi'),
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
(2, 'definition_list_function', '', 81, 'Danh mục tài sản cố định'),
(2, 'definition_list_function', '', 82, 'Danh mục khoản phải trả'),
(2, 'definition_list_function', '', 83, 'Danh mục khoản phải thu'),
(2, 'definition_list_function', '', 84, 'Thiết lập dữ liệu Khách hàng'),
(2, 'definition_list_function', '', 85, 'Thiết lập dữ liệu Nhà cung cấp'),
(2, 'definition_list_function', '', 86, 'Thiết lập dữ liệu Hàng hóa'),
(2, 'definition_list_function', '', 87, 'Khóa sổ cuối kỳ'),
(2, 'definition_list_function', '', 88, 'Định khoản bán tự động'),
(2, 'definition_list_function', '', 89, 'Thông tin công ty'),
(2, 'definition_list_function', '', 90, 'Thông tin phòng ban'),
(2, 'definition_list_function', '', 91, 'Cài đặt cấu hình'),
(2, 'definition_list_function', '', 92, 'Thông tin nhân viên'),
(2, 'definition_list_function', '', 93, 'Quyền hạn người dùng'),
(2, 'definition_list_function', '', 117, 'Bảng cân đối tài khoản'),
(2, 'definition_list_function', '', 119, 'Bảng cân đối kế toán'),
(2, 'definition_list_function', '', 120, 'Báo cáo kết quả kinh doanh'),
(2, 'definition_list_function', '', 121, 'Tài khoản ngân hàng'),
(2, 'definition_list_function', '', 122, 'Bảng kê bán ra'),
(2, 'definition_list_function', '', 123, 'Bảng kê mua vào'),
(2, 'definition_list_function', '', 124, 'Sổ chi tiết khách hàng'),
(2, 'definition_list_function', '', 125, 'Bảng tổng hợp công nợ phải thu'),
(2, 'definition_list_function', '', 126, 'Nhật ký chung'),
(2, 'definition_list_function', '', 127, 'Vat'),
(2, 'definition_list_function', '', 128, 'Sổ cái chi tiết'),
(2, 'definition_list_function', '', 129, 'Sổ nhật ký thu tiền'),
(2, 'definition_list_function', '', 130, 'Sổ nhật ký chi tiền'),
(2, 'definition_list_function', '', 131, 'Sổ nhật ký mua hàng'),
(2, 'definition_list_function', '', 132, 'Sổ nhật ký bán hàng'),
(2, 'definition_list_function', '', 133, 'Sổ chi tiết mặt hàng'),
(2, 'definition_list_function', '', 134, 'Phiết xuất kho'),
(2, 'definition_list_function', '', 135, 'Bảng xuất nhập tồn hàng hóa'),
(2, 'definition_list_function', '', 136, 'Phiếu thu'),
(2, 'definition_list_function', '', 137, 'Phiếu chi'),
(2, 'definition_list_function', '', 138, 'Danh mục dịch vụ'),
(2, 'definition_list_function', '', 139, 'Danh mục kho hàng'),
(2, 'definition_list_function', '', 140, 'Số dư tài khoản'),
(2, 'definition_list_function', '', 141, 'Danh mục loại chứng từ'),
(2, 'definition_list_function', '', 142, 'Xuất hóa đơn bán hàng'),
(2, 'definition_list_function', '', 143, 'Bảng kê chi tiết'),
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

DROP TABLE IF EXISTS `definition_detail_account`;
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
(2, 1, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(2, 1, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(2, 1, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(3, 1, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 1, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 1, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(6, 1, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(6, 5, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(6, 5, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(7, 1, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(8, 1, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(8, 1, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(10, 1, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(10, 1, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(10, 1, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(11, 1, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(12, 1, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(12, 1, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(14, 1, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(15, 1, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(16, 1, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(16, 1, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(16, 1, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(17, 1, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(17, 1, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(17, 1, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(18, 1, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(18, 1, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(18, 1, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(19, 1, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_detail_currency`
--

DROP TABLE IF EXISTS `definition_detail_currency`;
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
(1, 1, '2010-05-22 00:07:22', '1.0000', 0, '2010-05-22 00:07:33', 0, '2010-05-22 00:07:36'),
(1, 1, '2010-05-23 13:31:44', '1.0000', 0, '2010-05-24 13:31:54', 0, '2010-05-24 13:31:57'),
(1, 3, '2010-05-23 13:32:51', '1.3000', 0, '2010-05-24 13:33:05', 0, '2010-06-04 18:04:01'),
(3, 1, '2010-05-24 08:34:18', '1.9000', 0, '2010-05-24 08:34:34', 0, '2010-05-24 08:34:38');

-- --------------------------------------------------------

--
-- Table structure for table `definition_detail_group`
--

DROP TABLE IF EXISTS `definition_detail_group`;
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

INSERT INTO `definition_detail_group` (`product_id`, `criteria_id`, `group_id`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, 1, 6, 1, '2010-07-28 14:49:19', 1, '2010-07-28 14:49:19'),
(1, 1, 6, 1, '2010-07-28 14:02:21', 1, '2010-07-28 14:05:52'),
(2, 1, 6, 1, '2010-07-28 14:02:21', 1, '2010-07-28 14:05:52'),
(3, 1, 6, 1, '2010-07-28 14:02:21', 1, '2010-07-28 14:05:52'),
(4, 1, 6, 1, '2010-07-28 13:57:42', 1, '2010-07-28 14:53:42'),
(5, 1, 6, 1, '2010-07-28 13:57:42', 1, '2010-07-28 14:53:42'),
(6, 1, 6, 1, '2010-07-28 13:57:43', 1, '2010-07-28 14:53:42'),
(7, 1, 5, 1, '2010-07-28 13:57:43', 1, '2010-07-28 14:53:54'),
(8, 1, 5, 1, '2010-07-28 14:02:21', 1, '2010-07-28 14:08:34'),
(9, 1, 5, 1, '2010-07-28 14:02:21', 1, '2010-07-28 14:08:34'),
(10, 1, 5, 1, '2010-07-28 14:02:21', 1, '2010-07-28 14:08:34'),
(11, 1, 5, 1, '2010-07-28 13:58:30', 1, '2010-07-28 14:53:29'),
(12, 1, 5, 1, '2010-07-28 13:58:30', 1, '2010-07-28 14:53:29'),
(13, 1, 5, 1, '2010-07-28 13:58:30', 1, '2010-07-28 14:53:29'),
(14, 1, 5, 1, '2010-07-28 13:58:30', 1, '2010-07-28 14:53:29'),
(15, 1, 5, 1, '2010-07-28 14:02:21', 1, '2010-07-28 14:08:34'),
(16, 1, 5, 1, '2010-07-28 14:02:21', 1, '2010-07-28 14:08:34'),
(17, 1, 5, 1, '2010-07-28 14:02:21', 1, '2010-07-28 14:08:35'),
(18, 1, 5, 1, '2010-07-28 14:02:21', 1, '2010-07-28 14:08:35'),
(19, 1, 5, 1, '2010-07-28 14:02:21', 1, '2010-07-28 14:07:57'),
(20, 1, 5, 1, '2010-07-28 14:02:21', 1, '2010-07-28 14:07:57'),
(21, 1, 5, 1, '2010-07-28 14:02:21', 1, '2010-07-28 14:07:57'),
(22, 1, 5, 1, '2010-07-28 14:02:21', 1, '2010-07-28 14:07:57'),
(23, 1, 5, 1, '2010-07-28 14:02:22', 1, '2010-07-28 14:08:06'),
(24, 1, 5, 1, '2010-07-28 14:02:22', 1, '2010-07-28 14:08:06'),
(25, 1, 5, 1, '2010-07-28 14:02:22', 1, '2010-07-28 14:08:06'),
(26, 1, 5, 1, '2010-07-28 14:02:42', 1, '2010-07-28 14:08:06'),
(27, 1, 5, 1, '2010-07-28 14:02:42', 1, '2010-07-28 14:08:06'),
(28, 1, 5, 1, '2010-07-28 14:02:42', 1, '2010-07-28 14:07:23'),
(29, 1, 5, 1, '2010-07-28 14:02:42', 1, '2010-07-28 14:07:50'),
(30, 1, 5, 1, '2010-07-28 14:02:42', 1, '2010-07-28 14:07:50'),
(31, 1, 5, 1, '2010-07-28 14:02:42', 1, '2010-07-28 14:07:50'),
(32, 1, 5, 1, '2010-07-28 14:02:42', 1, '2010-07-28 14:07:50'),
(33, 1, 5, 1, '2010-07-28 14:02:42', 1, '2010-07-28 14:07:50'),
(34, 1, 5, 1, '2010-07-28 14:02:42', 1, '2010-07-28 14:07:50'),
(35, 1, 5, 1, '2010-07-28 14:02:42', 1, '2010-07-28 14:07:50'),
(36, 1, 5, 1, '2010-07-28 14:02:42', 1, '2010-07-28 14:07:50'),
(37, 1, 5, 1, '2010-07-28 14:02:42', 1, '2010-07-28 14:07:50'),
(38, 1, 5, 1, '2010-07-28 14:02:42', 1, '2010-07-28 14:07:50'),
(39, 1, 5, 1, '2010-07-28 14:02:42', 1, '2010-07-28 14:07:50'),
(40, 1, 5, 1, '2010-07-28 14:02:42', 1, '2010-07-28 14:07:50'),
(41, 1, 5, 1, '2010-07-28 14:02:42', 1, '2010-07-28 14:07:50'),
(42, 1, 5, 1, '2010-07-28 14:02:42', 1, '2010-07-28 14:05:34'),
(43, 1, 5, 1, '2010-07-28 14:03:03', 1, '2010-07-28 14:05:41'),
(44, 1, 5, 1, '2010-07-28 14:03:03', 1, '2010-07-28 14:05:41'),
(45, 1, 5, 1, '2010-07-28 14:03:03', 1, '2010-07-28 14:05:41'),
(46, 1, 5, 1, '2010-07-28 14:03:03', 1, '2010-07-28 14:05:42'),
(47, 1, 5, 1, '2010-07-28 14:03:03', 1, '2010-07-28 14:05:42'),
(48, 1, 5, 1, '2010-07-28 14:03:03', 1, '2010-07-28 14:05:42'),
(49, 1, 5, 1, '2010-07-28 14:03:03', 1, '2010-07-28 14:05:42'),
(50, 1, 5, 1, '2010-07-28 14:03:03', 1, '2010-07-28 14:05:42'),
(51, 1, 5, 1, '2010-07-28 14:03:03', 1, '2010-07-28 14:05:42'),
(52, 1, 5, 1, '2010-07-28 14:03:04', 1, '2010-07-28 14:05:42'),
(53, 1, 2, 1, '2010-07-28 14:03:04', 1, '2010-07-28 14:03:04'),
(54, 1, 2, 1, '2010-07-28 14:03:04', 1, '2010-07-28 14:03:04'),
(55, 1, 2, 1, '2010-07-28 14:03:04', 1, '2010-07-28 14:03:04'),
(56, 1, 2, 1, '2010-07-28 14:03:04', 1, '2010-07-28 14:03:04'),
(57, 1, 2, 1, '2010-07-28 14:03:04', 1, '2010-07-28 14:03:04'),
(58, 1, 2, 1, '2010-07-28 14:03:04', 1, '2010-07-28 14:03:04'),
(59, 1, 2, 1, '2010-07-28 14:03:04', 1, '2010-07-28 14:03:04'),
(60, 1, 5, 1, '2010-07-28 14:10:58', 1, '2010-07-28 14:10:58'),
(61, 1, 5, 1, '2010-07-28 14:10:58', 1, '2010-07-28 14:10:58'),
(62, 1, 5, 1, '2010-07-28 14:10:58', 1, '2010-07-28 14:10:58'),
(63, 1, 5, 1, '2010-07-28 14:10:58', 1, '2010-07-28 14:10:58'),
(64, 1, 5, 1, '2010-07-28 14:10:58', 1, '2010-07-28 14:10:58'),
(65, 1, 5, 1, '2010-07-28 14:10:58', 1, '2010-07-28 14:10:58'),
(66, 1, 5, 1, '2010-07-28 14:10:58', 1, '2010-07-28 14:10:58'),
(67, 1, 5, 1, '2010-07-28 14:10:58', 1, '2010-07-28 14:10:58'),
(68, 1, 5, 1, '2010-07-28 14:10:58', 1, '2010-07-28 14:10:58'),
(69, 1, 5, 1, '2010-07-28 14:10:58', 1, '2010-07-28 14:10:58'),
(70, 1, 5, 1, '2010-07-28 14:10:58', 1, '2010-07-28 14:10:58'),
(71, 1, 5, 1, '2010-07-28 14:10:58', 1, '2010-07-28 14:10:58'),
(72, 1, 5, 1, '2010-07-28 14:10:58', 1, '2010-07-28 14:10:58'),
(73, 1, 5, 1, '2010-07-28 14:10:58', 1, '2010-07-28 14:10:58'),
(74, 1, 5, 1, '2010-07-28 14:10:59', 1, '2010-07-28 14:10:59'),
(75, 1, 5, 1, '2010-07-28 14:10:59', 1, '2010-07-28 14:10:59'),
(76, 1, 5, 1, '2010-07-28 14:10:59', 1, '2010-07-28 14:10:59'),
(77, 1, 5, 1, '2010-07-28 14:11:13', 1, '2010-07-28 14:11:13'),
(78, 1, 5, 1, '2010-07-28 14:11:13', 1, '2010-07-28 14:11:13'),
(79, 1, 5, 1, '2010-07-28 14:11:13', 1, '2010-07-28 14:11:13'),
(80, 1, 5, 1, '2010-07-28 14:11:13', 1, '2010-07-28 14:11:13'),
(81, 1, 5, 1, '2010-07-28 14:11:13', 1, '2010-07-28 14:11:13'),
(82, 1, 5, 1, '2010-07-28 14:11:13', 1, '2010-07-28 14:11:13'),
(83, 1, 5, 1, '2010-07-28 14:11:13', 1, '2010-07-28 14:11:13'),
(84, 1, 5, 1, '2010-07-28 14:11:13', 1, '2010-07-28 14:11:13'),
(85, 1, 5, 1, '2010-07-28 14:11:13', 1, '2010-07-28 14:11:13'),
(86, 1, 5, 1, '2010-07-28 14:11:13', 1, '2010-07-28 14:11:13'),
(87, 1, 5, 1, '2010-07-28 14:11:13', 1, '2010-07-28 14:11:13'),
(88, 1, 5, 1, '2010-07-28 14:11:13', 1, '2010-07-28 14:11:13'),
(89, 1, 5, 1, '2010-07-28 14:11:13', 1, '2010-07-28 14:11:13'),
(90, 1, 5, 1, '2010-07-28 14:11:13', 1, '2010-07-28 14:11:13'),
(91, 1, 5, 1, '2010-07-28 14:11:14', 1, '2010-07-28 14:11:14'),
(92, 1, 5, 1, '2010-07-28 14:11:14', 1, '2010-07-28 14:11:14'),
(93, 1, 5, 1, '2010-07-28 14:11:14', 1, '2010-07-28 14:11:14'),
(94, 1, 5, 1, '2010-07-28 14:11:28', 1, '2010-07-28 14:11:28'),
(95, 1, 5, 1, '2010-07-28 14:11:28', 1, '2010-07-28 14:11:28'),
(96, 1, 5, 1, '2010-07-28 14:11:28', 1, '2010-07-28 14:11:28'),
(97, 1, 5, 1, '2010-07-28 14:11:28', 1, '2010-07-28 14:11:28'),
(98, 1, 5, 1, '2010-07-28 14:11:28', 1, '2010-07-28 14:11:28'),
(99, 1, 5, 1, '2010-07-28 14:11:28', 1, '2010-07-28 14:11:28'),
(100, 1, 5, 1, '2010-07-28 14:11:28', 1, '2010-07-28 14:11:28');

-- --------------------------------------------------------

--
-- Table structure for table `definition_detail_property`
--

DROP TABLE IF EXISTS `definition_detail_property`;
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

DROP TABLE IF EXISTS `definition_detail_rank`;
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

DROP TABLE IF EXISTS `definition_list_account`;
CREATE TABLE IF NOT EXISTS `definition_list_account` (
  `account_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `account_code` varchar(10) NOT NULL,
  `account_name` varchar(100) NOT NULL,
  `account_parent_id` bigint(30) DEFAULT NULL,
  `account_note` varchar(100) NOT NULL,
  `execution_id` bigint(30) unsigned NOT NULL COMMENT 'phần hành mà tài khoản thuộc về, phải thuộc phân hệ kế toán',
  `debit_credit_balance` tinyint(1) NOT NULL COMMENT 'Tài khoản dư Nợ (-1) hoặc dư Có (1) hoặc không dư (0) hoặc vừa dư Nợ vừa dư Có (2)',
  `inactive` tinyint(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`account_id`),
  KEY `fk_account_created_user` (`created_by_userid`),
  KEY `fk_account_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=217 ;

--
-- Dumping data for table `definition_list_account`
--

INSERT INTO `definition_list_account` (`account_id`, `account_code`, `account_name`, `account_parent_id`, `account_note`, `execution_id`, `debit_credit_balance`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, '', 'Hệ thống tài khoản kế toán', NULL, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(2, '111', 'Tiền mặt', 1, '', 0, 1, 0, 0, '1900-01-01 00:00:00', 1, '2010-07-28 16:22:32'),
(3, '1111', 'Tiền Việt Nam', 2, '', 0, 1, 0, 0, '1900-01-01 00:00:00', 1, '2010-07-28 16:20:12'),
(4, '1112', 'Ngoại tệ', 2, '', 0, 1, 0, 0, '1900-01-01 00:00:00', 1, '2010-07-28 16:20:16'),
(5, '1113', 'Vàng, bạc, kim khí quý, đá quý', 2, '', 0, 1, 0, 0, '1900-01-01 00:00:00', 1, '2010-07-28 16:20:25'),
(6, '112', 'Tiền gửi Ngân hàng', 1, 'Chi tiết theo từng ngân hàng', 0, 1, 0, 0, '1900-01-01 00:00:00', 1, '2010-07-28 16:23:20'),
(7, '1121', 'Tiền Việt Nam', 6, '', 0, 1, 0, 0, '1900-01-01 00:00:00', 1, '2010-07-28 16:20:32'),
(8, '1122', 'Ngoại tệ', 6, '', 0, 1, 0, 0, '1900-01-01 00:00:00', 1, '2010-07-28 16:20:40'),
(9, '1123', 'Vàng, bạc, kim khí quý, đá quý', 6, '', 0, 1, 0, 0, '1900-01-01 00:00:00', 1, '2010-07-28 16:20:43'),
(10, '113', 'Tiền đang chuyển', 1, '', 0, 1, 0, 0, '1900-01-01 00:00:00', 1, '2010-07-28 16:22:23'),
(11, '1131', 'Tiền Việt Nam', 10, '', 0, 1, 0, 0, '1900-01-01 00:00:00', 1, '2010-07-28 16:22:29'),
(12, '1132', 'Ngoại tệ', 10, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(13, '121', 'Đầu tư chứng khoán ngắn hạn', 1, '', 0, 1, 0, 0, '1900-01-01 00:00:00', 1, '2010-07-28 16:24:01'),
(14, '1211', 'Cổ phiếu', 13, '', 0, 1, 0, 0, '1900-01-01 00:00:00', 1, '2010-07-28 16:24:19'),
(15, '1212', 'Trái phiếu, tín phiếu, kỳ phiếu', 13, '', 0, 1, 0, 0, '1900-01-01 00:00:00', 1, '2010-07-28 16:24:32'),
(16, '128', 'Đầu tư ngắn hạn khác', 1, '', 0, 1, 0, 0, '1900-01-01 00:00:00', 1, '2010-07-28 16:26:25'),
(17, '1281', 'Tiền gửi có kỳ hạn', 16, '', 0, 1, 0, 0, '1900-01-01 00:00:00', 1, '2010-07-28 16:26:46'),
(18, '1288', 'Đầu tư ngắn hạn khác', 16, '', 0, 1, 0, 0, '1900-01-01 00:00:00', 1, '2010-07-28 16:26:59'),
(19, '129', 'Dự phòng giảm giá đầu tư ngắn hạn', 1, '', 0, 1, 0, 0, '1900-01-01 00:00:00', 1, '2010-07-28 16:27:07'),
(20, '131', 'Phải thu của khách hàng', 1, 'Chi tiết theo đối tượng', 0, 2, 0, 0, '1900-01-01 00:00:00', 1, '2010-07-28 16:27:17'),
(21, '133', 'Thuế GTGT được khấu trừ', 1, '0', 0, 2, 0, 0, '1900-01-01 00:00:00', 1, '2010-07-28 16:30:22'),
(22, '1331', 'Thuế GTGT được khấu trừ của hàng hóa, dịch vụ', 21, '0', 0, 2, 0, 0, '1900-01-01 00:00:00', 1, '2010-07-28 16:34:15'),
(23, '1332', 'Thuế GTGT được khấu trừ của TSCĐ', 21, '0', 0, 2, 0, 0, '1900-01-01 00:00:00', 1, '2010-07-28 16:34:31'),
(24, '136', 'Phải thu nội bộ', 1, '0', 0, 2, 0, 0, '1900-01-01 00:00:00', 1, '2010-07-28 16:34:41'),
(25, '1361', 'Vốn kinh doanh ở các đơn vị trực thuộc', 24, '0', 0, -1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(26, '1368', 'Phải thu nội bộ khác', 24, '0', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(27, '138', 'Phải thu khác', 1, '0', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(28, '1381', 'Tài sản thiếu chờ xử lý', 27, '0', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(29, '1385', 'Phải thu về cổ phần hóa', 27, '0', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(30, '1388', 'Phải thu khác', 27, '0', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(31, '139', 'Dự phòng phải thu khó đòi', 1, '0', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(32, '141', 'Tạm ứng', 1, '1', 0, -1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(33, '142', 'Chi phí trả trước ngắn hạn', 1, '0', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(34, '144', 'Cầm cố, ký quỹ, ký cược ngắn hạn', 1, '0', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(35, '151', 'Hàng mua đang đi đường', 1, '0', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(36, '152', 'Nguyên liệu, vật liệu', 1, 'Chi tiết theo yêu cầu quản lý', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(37, '153', 'Công cụ, dụng cụ', 1, '0', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(38, '154', 'Chi phí sản xuất, kinh doanh dở dang', 1, '0', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(39, '155', 'Thành phẩm', 1, '0', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(40, '156', 'Hàng hóa', 1, '0', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(41, '1561', 'Giá mua hàng hóa', 40, '0', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(42, '1562', 'Chi phí thu mua hàng hóa', 40, '0', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(43, '1567', 'Hàng hóa bất động sản', 40, '0', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(44, '157', 'Hàng gửi đi bán', 1, '0', 0, 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(45, '158', 'Hàng hóa kho bảo thuế', 1, 'Đơn vị có XNK được lập kho bảo thuế', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(46, '159', 'Dự phòng giảm giá hàng tồn kho', 1, '0', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(47, '161', 'Chi sự nghiệp', 1, '0', 0, 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(48, '1611', 'Chi sự nghiệp năm trước', 47, '0', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(49, '1612', 'Chi sự nghiệp năm nay', 47, '0', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(50, '211', 'Tài sản cố định hữu hình', 1, '', 0, 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(51, '2111', 'Nhà cửa, vật kiến trúc', 50, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(52, '2112', 'Máy móc, thiết bị', 50, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(53, '2113', 'Phương tiện vận tải, truyền dẫn', 50, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(54, '2114', 'Thiết bị, dụng cụ quản lý', 50, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(55, '2115', 'Cây lâu năm, súc vật làm việc và cho sản phẩm', 50, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(56, '2118', 'TSCĐ khác', 50, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(57, '212', 'Tài sản cố định thuê tài chính', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(58, '213', 'Tài sản cố định vô hình', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(59, '2131', 'Quyền sử dụng đất', 58, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(60, '2132', 'Quyền phát hành', 58, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(61, '2133', 'Bản quyền, bằng sáng chế', 58, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(62, '2134', 'Nhãn hiệu hàng hoá', 58, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(63, '2135', 'Phần mềm máy vi tính', 58, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(64, '2136', 'Giấy phép và giấy phép nhượng quyền', 58, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(65, '2138', 'TSCĐ vô hình khác', 58, '', 0, -1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(66, '214', 'Hao mòn tài sản cố định', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(67, '2141', 'Hao mòn TSCĐ hữu hình', 66, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(68, '2142', 'Hao mòn TSCĐ thuê tài chính', 66, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(69, '2143', 'Hao mòn TSCĐ vô hình', 66, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(70, '2147', 'Hao mòn bất động sản đầu tư', 66, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(71, '217', 'Bất động sản đầu tư', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(72, '221', 'Đầu tư vào công ty con', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(73, '222', 'Vốn góp liên doanh', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(74, '223', 'Đầu tư vào công ty liên kết', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(75, '228', 'Đầu tư dài hạn khác', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(76, '2281', 'Cổ phiếu', 75, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(77, '2282', 'Trái phiếu', 75, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(78, '2288', 'Đầu tư dài hạn khác', 75, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(79, '229', 'Dự phòng giảm giá đầu tư dài hạn', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(80, '241', 'Xây dựng cơ bản dở dang', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(81, '2411', 'Mua sắm TSCĐ', 80, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(82, '2412', 'Xây dựng cơ bản', 80, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(83, '2413', 'Sửa chữa lớn TSCĐ', 80, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(84, '242', 'Chi phí trả trước dài hạn', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(85, '243', 'Tài sản thuế thu nhập hoãn lại', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(86, '244', 'Ký quỹ, ký cược dài hạn', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(87, '311', 'Vay ngắn hạn', 1, '', 0, 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(88, '315', 'Nợ dài hạn đến hạn trả', 1, '', 0, 2, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(89, '331', 'Phải trả cho người bán', 1, 'Chi tiết theo đối tượng', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(90, '333', 'Thuế và các khoản phải nộp Nhà nước', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(91, '3331', 'Thuế giá trị gia tăng phải nộp', 90, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(92, '33311', 'Thuế GTGT đầu ra', 91, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(93, '33312', 'Thuế GTGT hàng nhập khẩu', 91, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(94, '3332', 'Thuế tiêu thụ đặc biệt', 90, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(95, '3333', 'Thuế xuất, nhập khẩu', 90, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(96, '3334', 'Thuế thu nhập doanh nghiệp', 90, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(97, '3335', 'Thuế thu nhập cá nhân', 90, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(98, '3336', 'Thuế tài nguyên', 90, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(99, '3337', 'Thuế nhà đất, tiền thuê đất', 90, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(100, '3338', 'Các loại thuế khác', 90, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(101, '3339', 'Phí, lệ phí và các khoản phải nộp khác', 90, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(102, '334', 'Phải trả người lao động', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(103, '3341', 'Phải trả công nhân viên', 102, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(104, '3348', 'Phải trả người lao động khác', 102, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(105, '335', 'Chi phí phải trả', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(106, '336', 'Phải trả nội bộ', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(107, '337', 'Thanh toán theo tiến độ kế hoạch hợp đồng xây dựng', 1, 'DN xây lắp có thanh toán theo tiến độ kế hoạch', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(108, '338', 'Phải trả, phải nộp khác', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(109, '3381', 'Tài sản thừa chờ giải quyết', 108, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(110, '3382', 'Kinh phí công đoàn', 108, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(111, '3383', 'Bảo hiểm xã hội', 108, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(112, '3384', 'Bảo hiểm y tế', 108, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(113, '3385', 'Phải trả về cổ phần hoá', 108, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(114, '3386', 'Nhận ký quỹ, ký cược ngắn hạn', 108, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(115, '3387', 'Doanh thu chưa thực hiện', 108, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(116, '3388', 'Phải trả, phải nộp khác', 108, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(117, '341', 'Vay dài hạn', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(118, '342', 'Nợ dài hạn', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(119, '343', 'Trái phiếu phát hành', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(120, '3431', 'Mệnh giá trái phiếu', 119, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(121, '3432', 'Chiết khấu trái phiếu', 119, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(122, '3433', 'Phụ trội trái phiếu', 119, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(123, '344', 'Nhận ký quỹ, ký cược dài hạn', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(124, '347', 'Thuế thu nhập hoãn lại phải trả', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(125, '351', 'Quỹ dự phòng trợ cấp mất việc làm', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(126, '352', 'Dự phòng phải trả', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(127, '411', 'Nguồn vốn kinh doanh', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(128, '4111', 'Vốn đầu tư của chủ sở hữu', 127, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(129, '4112', 'Thặng dư vốn cổ phần', 127, 'C.ty cổ phần', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(130, '4118', 'Vốn khác', 127, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(131, '412', 'Chênh lệch đánh giá lại tài sản', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(132, '413', 'Chênh lệch tỷ giá hối đoái', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(133, '4131', 'Chênh lệch tỷ giá hối đoái đánh giá lại cuối năm tài chính', 132, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(134, '4132', 'Chênh lệch tỷ giá hối đoái trong giai đoạn đầu tư XDCB', 132, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(135, '414', 'Quỹ đầu tư phát triển', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(136, '415', 'Quỹ dự phòng tài chính', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(137, '418', 'Các quỹ khác thuộc vốn chủ sở hữu', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(138, '419', 'Cổ phiếu quỹ', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(139, '421', 'Lợi nhuận chưa phân phối', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(140, '4211', 'Lợi nhuận chưa phân phối năm trước', 139, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(141, '4212', 'Lợi nhuận chưa phân phối năm nay', 139, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(142, '431', 'Quỹ khen thưởng, phúc lợi', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(143, '4311', 'Quỹ khen thưởng', 142, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(144, '4312', 'Quỹ phúc lợi', 142, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(145, '4313', 'Quỹ phúc lợi đã hình thành TSCĐ', 142, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(146, '441', 'Nguồn vốn đầu tư xây dựng cơ bản', 1, 'Áp dụng cho DNNN', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(147, '461', 'Nguồn kinh phí sự nghiệp', 1, 'Dùng cho các công ty, TCty có nguồn kinh phí', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(148, '4611', 'Nguồn kinh phí sự nghiệp năm trước', 147, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(149, '4612', 'Nguồn kinh phí sự nghiệp năm nay', 147, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(150, '466', 'Nguồn kinh phí đã hình thành TSCĐ', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(151, '511', 'Doanh thu bán hàng và cung cấp dịch vụ', 1, 'Chi tiết theo yêu cầu quản lý', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(152, '5111', 'Doanh thu bán hàng hóa', 151, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(153, '5112', 'Doanh thu bán các thành phẩm', 151, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(154, '5113', 'Doanh thu cung cấp dịch vụ', 151, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(155, '5114', 'Doanh thu trợ cấp, trợ giá', 151, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(156, '5117', 'Doanh thu kinh doanh bất động sản đầu tư', 151, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(157, '512', 'Doanh thu bán hàng nội bộ', 1, 'Áp dụng khi có bán hàng nội  bộ', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(158, '5121', 'Doanh thu bán hàng hóa', 157, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(159, '5122', 'Doanh thu bán các thành phẩm', 157, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(160, '5123', 'Doanh thu cung cấp dịch vụ', 157, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(161, '515', 'Doanh thu hoạt động tài chính', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(162, '521', 'Chiết khấu thương mại', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(163, '531', 'Hàng bán bị trả lại', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(164, '532', 'Giảm giá hàng bán', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(165, '611', 'Mua hàng', 1, 'Áp dụng phương pháp kiểm kê định kỳ', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(166, '6111', 'Mua nguyên liệu, vật liệu', 165, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(167, '6112', 'Mua hàng hóa', 165, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(168, '621', 'Chi phí nguyên liệu, vật liệu trực tiếp', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(169, '622', 'Chi phí nhân công trực tiếp', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(170, '623', 'Chi phí sử dụng máy thi công', 1, 'Áp dụng cho đơn vị xây lắp', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(171, '6231', 'Chi phí nhân công', 170, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(172, '6232', 'Chi phí vật liệu', 170, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(173, '6233', 'Chi phí dụng cụ sản xuất', 170, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(174, '6234', 'Chi phí khấu hao máy thi công', 170, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(175, '6237', 'Chi phí dịch vụ mua ngoài', 170, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(176, '6238', 'Chi phí bằng tiền khác', 170, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(177, '627', 'Chi phí sản xuất chung', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(178, '6271', 'Chi phí nhân viên phân xưởng', 177, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(179, '6272', 'Chi phí vật liệu', 177, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(180, '6273', 'Chi phí dụng cụ sản xuất', 177, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(181, '6274', 'Chi phí khấu hao TSCĐ', 177, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(182, '6277', 'Chi phí dịch vụ mua ngoài', 177, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(183, '6278', 'Chi phí bằng tiền khác', 177, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(184, '631', 'Giá thành sản xuất', 1, 'PP.Kkê định kỳ', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(185, '632', 'Giá vốn hàng bán', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(186, '635', 'Chi phí tài chính', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(187, '641', 'Chi phí bán hàng', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(188, '6411', 'Chi phí nhân viên', 187, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(189, '6412', 'Chi phí vật liệu, bao bì', 187, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(190, '6413', 'Chi phí dụng cụ, đồ dùng', 187, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(191, '6414', 'Chi phí khấu hao TSCĐ', 187, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(192, '6415', 'Chi phí bảo hành', 187, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(193, '6417', 'Chi phí dịch vụ mua ngoài', 187, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(194, '6418', 'Chi phí bằng tiền khác', 187, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(195, '642', 'Chi phí quản lý doanh nghiệp', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(196, '6421', 'Chi phí nhân viên quản lý', 195, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(197, '6422', 'Chi phí vật liệu quản lý', 195, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(198, '6423', 'Chi phí đồ dùng văn phòng', 195, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(199, '6424', 'Chi phí khấu hao TSCĐ', 195, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(200, '6425', 'Thuế, phí và lệ phí', 195, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(201, '6426', 'Chi phí dự phòng', 195, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(202, '6427', 'Chi phí dịch vụ mua ngoài', 195, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(203, '6428', 'Chi phí bằng tiền khác', 195, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(204, '711', 'Thu nhập khác', 1, 'Chi tiết theo hoạt động', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(205, '811', 'Chi phí khác', 1, 'Chi tiết theo hoạt động', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(206, '821', 'Chi phí thuế thu nhập doanh nghiệp', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(207, '8211', 'Chi phí thuế TNDN hiện hành', 206, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(208, '8212', 'Chi phí thuế TNDN hoãn lại', 206, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(209, '911', 'Xác định kết quả kinh doanh', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(210, '001', 'Tài sản thuê ngoài', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '2010-06-01 10:59:39'),
(211, '002', 'Vật tư, hàng hóa nhận giữ hộ, nhận gia công', 1, 'Chi tiết theo yêu cầu quản lý', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(212, '003', 'Hàng hóa nhận bán hộ, nhận ký gửi, ký cược', 1, '', 0, 1, 0, 0, '1900-01-01 00:00:00', 0, '2010-06-01 10:59:56'),
(213, '004', 'Nợ khó đòi đã xử lý', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '2010-06-01 11:00:06'),
(214, '007', 'Ngoại tệ các loại', 1, '', 0, -1, 0, 0, '1900-01-01 00:00:00', 0, '2010-06-01 11:02:06'),
(215, '008', 'Dự toán chi sự nghiệp, dự án', 1, '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(216, '', '', NULL, '', 0, 0, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_account_path`
--

DROP TABLE IF EXISTS `definition_list_account_path`;
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

DROP TABLE IF EXISTS `definition_list_criteria`;
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

DROP TABLE IF EXISTS `definition_list_currency`;
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `definition_list_currency`
--

INSERT INTO `definition_list_currency` (`currency_id`, `currency_code`, `currency_name`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, '', '', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(1, 'VND', 'Tiền đồng Việt Nam', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(2, 'JPY', 'Tiền yên Nhật Bản', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(3, 'USD', 'Tiền Đô La Mỹ', 0, 0, '2010-05-24 08:33:58', 0, '2010-05-24 08:34:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_department`
--

DROP TABLE IF EXISTS `definition_list_department`;
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `definition_list_department`
--

INSERT INTO `definition_list_department` (`department_id`, `subject_id`, `department_code`, `department_name`, `department_function`, `is_sales`, `is_finance`, `is_purchasing`, `is_inventory`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, 0, '', '', '', 0, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(1, 1, 'KT', 'Kế toán', '', 0, 1, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(2, 1, 'KD', 'Kinh doanh', '', 1, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(3, 1, 'MH', 'Mua hàng', '', 0, 0, 1, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 1, 'KH', 'Kho hàng', '', 0, 0, 0, 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 1, 'GN', 'Giao nhận', '', 1, 0, 0, 0, 0, 0, '1900-01-01 00:00:00', 1, '2010-07-23 15:00:45'),
(6, 1, 'HC', 'Hành chính nhân sự', '', 0, 1, 0, 0, 0, 0, '1900-01-01 00:00:00', 1, '2010-07-28 15:17:47'),
(7, 1, 'OP', 'Nhận đơn hàng', 'Nhận đơn đặt hàng và phiếu', 1, 0, 0, 0, 0, 1, '2010-07-28 15:17:31', 1, '2010-07-28 15:17:31');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_execution`
--

DROP TABLE IF EXISTS `definition_list_execution`;
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=33 ;

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
(30, 7, 'LK', 'TL khác - TL', 0, 3, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(31, 7, 'LK', 'TL dữ liệu - TL', 0, 4, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(32, 4, 'BC', 'Báo cáo - KT', 0, 11, 'transactions.gif', 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_factor`
--

DROP TABLE IF EXISTS `definition_list_factor`;
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

DROP TABLE IF EXISTS `definition_list_function`;
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=144 ;

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
(14, 8, 'DMKH', 'Danh mục kho hàng', 'inventory/maintenance/stock-catalog', 1, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
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
(27, 13, 'CNPR', 'Công nợ phải trả (closed)', 'accountant/purchase/owe-topay', 1, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(28, 13, 'PBMH', 'Phân bổ chi phí (closed)', 'accountant/purchase/apportion-expenditure', 1, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(29, 14, 'HDBH', 'Hóa đơn bán hàng', 'accountant/sale/sale-billing', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(30, 14, 'HBTL', 'Hàng bán trả lại', 'accountant/sale/product-return', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(31, 14, 'GGHB', 'Giảm giá hàng bán', 'accountant/sale/product-saleoff', 0, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(32, 15, 'QLTK', 'Quản lý hàng tồn kho', 'accountant/inventory/stock-manage', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(33, 15, 'XLTT', 'Xử lý thừa thiếu kho (closed)', 'accountant/inventory/stock-clean', 1, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(34, 15, 'TGXK', 'Tính giá xuất kho', 'accountant/inventory/output-price-product', 0, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(35, 16, 'QLPT', 'Quản lý phải thu', 'accountant/receivable/receivable-manage', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(36, 16, 'PTCN', 'Phiếu đề nghị thu', 'accountant/receivable/receivable-letter', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(37, 16, 'GTPT', 'Giải trừ phải thu', 'accountant/receivable/receivable-resolve', 0, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(38, 17, 'QLPR', 'Quản lý phải trả', 'accountant/payable/payment-manage', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(39, 17, 'PCCN', 'Phiếu đề nghị chi', 'accountant/payable/payment-letter', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
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
(80, 12, 'TKHT', 'Thiết lập tài khoản hạch toán', 'accountant/maintenance/to-accounting', 0, 8, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(81, 30, 'TSCD', 'Danh mục tài sản cố định', 'core/other/asset-catalog', 1, 1, 0, '2010-05-26 08:22:31', 0, '2010-05-26 08:22:35'),
(82, 12, 'PATY', 'Danh mục khoản phải trả', 'accountant/maintenance/payable-catalog', 0, 9, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(83, 12, 'RETY', 'Danh mục khoản phải thu', 'accountant/maintenance/receivable-catalog', 0, 10, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(84, 31, 'DLKH', 'Thiết lập dữ liệu Khách hàng', 'core/importer/data-customer', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(85, 31, 'DLNC', 'Thiết lập dữ liệu Nhà cung cấp', 'core/importer/data-supplier', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(86, 31, 'DLHH', 'Thiết lập dữ liệu Hàng hóa', 'core/importer/data-product', 0, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(87, 21, 'KSCK', 'Khóa sổ cuối kỳ', 'accountant/general/ending-period', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(88, 21, 'ABTD', 'Định khoản bán tự động', 'accountant/general/accounting-semiauto', 0, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(89, 30, 'CPIF', 'Thông tin công ty', 'core/other/company-preference', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(90, 30, 'DPIF', 'Thông tin phòng ban', 'core/other/department-maintenance', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(91, 30, 'CFST', 'Cài đặt cấu hình', 'core/other/config-setting', 0, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(92, 30, 'STIF', 'Thông tin nhân viên', 'core/other/staff-maintenance', 0, 5, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(93, 30, 'ROLP', 'Quyền hạn người dùng', 'core/other/role-permission', 0, 4, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(94, 12, '', 'Accountant Purchase', 'accountant/purchase', 1, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(95, 12, '', 'Accountant Sale', 'accountant/sale', 1, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(96, 12, '', 'Accountant Inventory', 'accountant/inventory', 1, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(97, 12, '', 'Accountant Receivable', 'accountant/receivable', 1, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(98, 12, '', 'Accountant Payable', 'accountant/payable', 1, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(99, 12, '', 'Accountant Fund', 'accountant/fund', 1, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(100, 12, '', 'Accountant Asset', 'accountant/asset', 1, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(101, 12, '', 'Accountant General', 'accountant/general', 1, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(102, 28, '', 'Core Other', 'core/other', 1, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(103, 28, '', 'Core Importer', 'core/importer', 1, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(104, 28, '', 'Core Index', 'core/index', 1, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(105, 28, '', 'Core Index', 'core/index/index', 1, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(106, 1, '', 'purchase Index', 'purchase/index', 1, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(107, 1, '', 'purchase Index', 'purchase/index/index', 1, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(108, 8, '', 'inventory Index', 'inventory/index', 1, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(109, 8, '', 'inventory Index', 'inventory/index/index', 1, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(110, 28, '', 'Sale Index', 'sale/index', 1, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(111, 28, '', 'Sale Index', 'sale/index/index', 1, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(112, 12, '', 'Accountant Index', 'accountant/index', 1, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(113, 12, '', 'Accountant Index', 'accountant/index/index', 1, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(114, 28, '', 'General Index', 'general', 1, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(115, 28, '', 'General Index', 'general/index', 1, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(116, 28, '', 'General Index', 'general/index/index', 1, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(117, 32, 'ACBL', 'Bảng cân đối tài khoản', 'accountant/report/account-balance', 0, 1, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(118, 12, '', 'Accountant Report', 'accountant/report', 1, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(119, 32, 'ATBL', 'Bảng cân đối kế toán', 'accountant/report/accounting-balance', 0, 2, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(120, 32, 'KQKD', 'Báo cáo kết quả kinh doanh', 'accountant/report/business-result', 0, 3, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(121, 30, 'TKNH', 'Tài khoản ngân hàng', 'core/other/bank-maintenance', 0, 6, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(122, 32, 'BKBR', 'Bảng kê bán ra', 'accountant/report/list-sold', 0, 4, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(123, 32, 'BKMV', 'Bảng kê mua vào', 'accountant/report/list-purchased', 0, 5, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(124, 32, 'CTKH', 'Sổ chi tiết khách hàng', 'accountant/report/main-customer', 0, 6, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(125, 32, 'CNPT', 'Bảng tổng hợp công nợ phải thu', 'accountant/report/receivable-debt', 0, 7, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(126, 32, 'SNKC', 'Nhật ký chung', 'accountant/report/general-journal', 0, 8, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(127, 32, 'VAT', 'Vat', 'accountant/report/vat-list', 0, 14, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(128, 32, 'SCCT', 'Sổ cái chi tiết', 'accountant/report/ledger-detail', 0, 9, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(129, 32, 'NKTT', 'Sổ nhật ký thu tiền', 'accountant/report/collecting-diary', 0, 10, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(130, 32, 'NKCT', 'Sổ nhật ký chi tiền', 'accountant/report/spending-diary', 0, 11, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(131, 32, 'NKMH', 'Sổ nhật ký mua hàng', 'accountant/report/purchase-diary', 0, 12, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(132, 32, 'NKBH', 'Sổ nhật ký bán hàng', 'accountant/report/sale-diary', 0, 13, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(133, 32, 'CTMH', 'Sổ chi tiết mặt hàng', 'accountant/report/main-product', 0, 15, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(134, 32, 'PXK', 'Phiết xuất kho', 'accountant/report/export-vote', 0, 16, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(135, 32, 'BTHH', 'Bảng xuất nhập tồn hàng hóa', 'accountant/report/sheet-goods', 0, 17, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(136, 32, 'PTHU', 'Phiếu thu', 'accountant/report/stamp-debit', 0, 18, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(137, 32, 'PCHI', 'Phiếu chi', 'accountant/report/stamp-credit', 0, 19, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(138, 30, 'TTDV', 'Danh mục dịch vụ', 'core/other/service-catalog', 0, 7, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(139, 30, 'TKNH', 'Danh mục kho hàng', 'core/other/inventory-maintenance', 0, 7, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(140, 12, 'SDBD', 'Số dư tài khoản', 'accountant/maintenance/account-balance', 0, 11, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(141, 30, 'DMCT', 'Danh mục loại chứng từ', 'core/other/voucher-type', 0, 8, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(142, 14, 'XHDB', 'Xuất hóa đơn bán hàng', 'accountant/sale/export-sale-invoice', 0, 4, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(143, 14, 'BKCT', 'Bảng kê chi tiết', 'accountant/sale/export-detailed-list', 0, 5, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_group`
--

DROP TABLE IF EXISTS `definition_list_group`;
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=18 ;

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
(9, 1, 3, 'DIH', 'Dài hạn', 'Thời hạn sử dụng dài', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(10, 3, 1, 'test 1.1', 'test 1.1 name', '', 0, 0, '2010-06-14 16:23:34', 0, '2010-06-14 16:24:02'),
(11, 3, 10, '[Empty]', 'New Group', '', 0, 0, '2010-06-14 16:24:09', 0, '2010-06-14 16:24:09'),
(12, 3, 1, '[Empty]', 'New Group', '', 0, 0, '2010-06-14 16:24:14', 0, '2010-06-14 16:24:14'),
(14, 1, 1, 'Tieudung', 'Hàng tiêu dùng', '', 0, 1, '2010-07-28 14:27:35', 1, '2010-07-28 14:28:31'),
(15, 1, 14, 'td1', 'Hàng mau hỏng', '', 0, 1, '2010-07-28 14:29:09', 1, '2010-07-28 14:29:45'),
(17, 1, 14, 'td2', 'Hàng lâu hỏng', '', 0, 1, '2010-07-28 14:29:53', 1, '2010-07-28 14:30:45');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_group_path`
--

DROP TABLE IF EXISTS `definition_list_group_path`;
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
(9, '/1/3/9/'),
(10, '/1/10/'),
(11, '/1/10/11/'),
(12, '/1/12/'),
(14, '/1/14/'),
(15, '/1/14/15/'),
(17, '/1/14/17/');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_module`
--

DROP TABLE IF EXISTS `definition_list_module`;
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

DROP TABLE IF EXISTS `definition_list_period`;
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
(0, 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(1, 1, 3, 7, 2010, 0, 1, 0, 0, '2010-05-22 14:01:42', 0, '2010-05-24 10:43:01');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_product`
--

DROP TABLE IF EXISTS `definition_list_product`;
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
  `is_material` tinyint(3) unsigned NOT NULL,
  `is_tool` tinyint(3) unsigned NOT NULL,
  `is_work` tinyint(3) unsigned NOT NULL,
  `is_finished` tinyint(3) unsigned NOT NULL,
  `is_goods` tinyint(3) unsigned NOT NULL,
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=101 ;

--
-- Dumping data for table `definition_list_product`
--

INSERT INTO `definition_list_product` (`product_id`, `product_code`, `product_name`, `producer_id`, `product_model`, `product_picture`, `product_description`, `base_unit_id`, `regular_unit_id`, `is_material`, `is_tool`, `is_work`, `is_finished`, `is_goods`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, '', '', 0, '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:03:54', 0, '2010-06-29 15:56:08'),
(1, '000000', 'Cắt băng keo Tape Dispenser nhỏ -Black', 0, '', '', '', 1, 3, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 1, '2010-08-09 09:14:38'),
(2, '000001', 'Cắt băng keo Tape Dispenser nhỏ-Blue', 0, '', '', '', 1, 12, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 1, '2010-08-09 09:15:20'),
(3, '000002', 'Cắt băng keo Tape Dispenser lớn-Black', 0, '', '', '', 1, 8, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 1, '2010-08-09 09:16:00'),
(4, '000003', 'Cắt băng keo Tape Dispenser lớn-Blue', 0, '', '', '', 1, 1, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:12'),
(5, '000004', 'Cắt băng keo Tape Dispenser-Black- #816', 0, '', '', '', 1, 1, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:12'),
(6, '000005', 'Cắt băng keo Tape Dispenser-Blue- #816', 0, '', '', '', 1, 1, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:12'),
(7, '000500', 'Băng keo giấy kraft.48mm x 50 yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:12'),
(8, '000501', 'Băng keo vải. Nâu 48mm x 15 yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:12'),
(9, '000502', 'Băng keo trong.48mm x 100 yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:12'),
(10, '000503', 'Băng keo đục.48mm x 100 yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:12'),
(11, '000504', 'Băng keo OPP.Màu vàng.48mm x 70 yard', 0, '', '', '', 4, 3, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 1, '2010-08-12 10:47:34'),
(12, '000505', 'Băng keo OPP.Màu đỏ.48mm x 70 yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:12'),
(13, '000506', 'Băng keo OPP.Xanh lá cây.48mm x 70 yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:13'),
(14, '000507', 'Băng keo OPP.Xanh dương.48mm x 70 yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:13'),
(15, '000508', 'Băng keo OPP.trắng .48mm x 70 yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:13'),
(16, '000509', 'Băng keo OPP.Cam.48mm x 70 yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:13'),
(17, '000510', 'Băng keo OPP.Đen.48mm x 70 yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:13'),
(18, '000511', 'Băng keo 2 mặt.24mm x 9 yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:13'),
(19, '000512', 'Băng keo 2 mặt.48mm x 9 yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:13'),
(20, '000513', 'Băng keo giấy. Nhăn.12mm x 25 yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:13'),
(21, '000514', 'Băng keo VP. 12mmx5yard', 0, '', '', '', 5, 5, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:13'),
(22, '000515', 'Băng keo VP. 18mmx25yard', 0, '', '', '', 6, 6, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:13'),
(23, '000516', 'Băng keo vải. Nâu 48mm x 25m (27yard)', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:13'),
(24, '000517', 'Băng keo 2 mặt 48mm x 18 yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:14'),
(25, '000518', 'Băng keo 2 mặt mouse giữa 24mm x 10 yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:14'),
(26, '000519', 'Băng keo vải.Angel Nâu 48mm x 15 yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:14'),
(27, '000520', 'Băng keo đục Rabbit 60mm x 100 yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:14'),
(28, '000521', 'Băng keo giấy .Angel Nâu 48mm x 50 yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:14'),
(29, '000522', 'Băng keo 2 mặt 5mm x 9yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:14'),
(30, '000523', 'Băng keo trong Angel 24mm*80y/0.043', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:14'),
(31, '000524', 'Băng keo giấy nhăn Angel 24mm*30y', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:14'),
(32, '000525', 'Băng keo 2 mặt Angel 12mm*10y', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:14'),
(33, '000526', 'Băng keo trong Rabbit 48mm*100y/0.05', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:14'),
(34, '000527', 'Băng keo đục Angel  60mm x 80 yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:14'),
(35, '000528', 'Băng keo xé simili vàng 48mm*16yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:14'),
(36, '000529', 'Băng keo xé simili đỏ 48mm*16yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:15'),
(37, '000530', 'Băng keo giấy nhăn Angel 48mm*25y', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:42', 0, '2010-06-29 15:52:15'),
(38, '000531', 'Băng keo 2 mặt dầu Angel 48mm*23yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:15'),
(39, '000532', 'Băng keo giấy bò ĐL .Angel Nâu 48mm x 50 yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:15'),
(40, '000533', 'Băng keo xé simili xanh lá 48mm*16yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:15'),
(41, '000534', 'Băng keo trong Rabbit 60mm*100y/0.05', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:15'),
(42, '000535', 'Băng keo xé simili xanh dương 48mm*16yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:15'),
(43, '000536', 'Băng keo đục 048 .48mm x 100 yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:15'),
(44, '000537', 'Băng keo đục 043 .48mm x 80 yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:15'),
(45, '000538', 'Băng keo xé simili trắng 48mm*10 mét', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:15'),
(46, '000539', 'Băng keo Scotch 3M Magic12mmx4m', 0, '', '', '', 1, 1, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:15'),
(47, '000540', 'Băng keo Scotch 3M Magic19mmx16.5m', 0, '', '', '', 1, 1, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:15'),
(48, '000541', 'Băng keo Scotch 3M Magic12.7mmx32.9m', 0, '', '', '', 1, 1, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:16'),
(49, '000542', 'Băng keo Scotch 3M Magic19mmx32.9m', 0, '', '', '', 1, 1, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:16'),
(50, '000543', 'Băng keo Trong DEER 24mm*70m', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:16'),
(51, '000544', 'Băng keo Simili Trắng', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:16'),
(52, '000545', 'Băng keo điện 18mm x 9.1m', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:16'),
(53, '000546', 'Băng keo trong NITTO DENKO 0.067*50mm*50m', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:16'),
(54, '000547', 'Băng keo trong Rabbit 12mm x 100 yard / 48', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:16'),
(55, '000548', 'Băng keo 2 mặt 12mm x 10 yard (lõi Vui Vui)', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:16'),
(56, '000549', 'Băng keo giấy Kraft 712F. Nitto Denko 0.145mm *50mm*50m', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:17'),
(57, '000550', 'Băng keo 2 mặt mouse giữa 48mm x 8M', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:17'),
(58, '000551', 'Băng keo vải xám 48mm * 15y', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:17'),
(59, '000552', 'Băng keo vải nâu lõi CAT 48mm*15y', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:17'),
(60, '000553', 'Băng keo vải xám lõi CAT 48mm*15y', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:17'),
(61, '000554', 'Băng keo xé simili trắng 48mm*7 mét', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:17'),
(62, '000555', 'Băng keo 2 mặt lõi Happy 48mm x 9 yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:17'),
(63, '000556', 'Băng keo trong lõi CAT 24mm*80y', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:17'),
(64, '000558', 'Băng keo đục lõi HAPPY 48mm*100y', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:17'),
(65, '000559', 'Băng keo simili trắng,48mm x12y', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:17'),
(66, '000560', 'Băng keo giấy nhăn 16x22Yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:17'),
(67, '000561', 'Băng Keo 2 mặt 1.5x9 Yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:18'),
(68, '000562', 'Băng keo vải Cat 48mm x 15yard -xanh dương', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:18'),
(69, '000563', 'Bk 2mặt mouse giữa 2,4cm *9y', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:18'),
(70, '000564', 'Bk 2mặt mouse giữa 4.8cm *9y', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:18'),
(71, '000565', 'Bk simili vàng 48mm*12y', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:18'),
(72, '000566', 'Băng keo Nitto Denko 395N 0.125mmx25m-hồng', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:18'),
(73, '000567', 'Bk đục lõi CAT 60*80y', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:18'),
(74, '000569', 'Băng keo trong NITTO DENKO  3903EX 0.067*50mm*50m', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:18'),
(75, '000570', 'Băng keo trong SB 48 x 100 Yard/048', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:18'),
(76, '000571', 'Bk trong SB 48mm*50y/065', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:18'),
(77, '000572', 'Bk trong SB 48mm*100y/090', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:43', 0, '2010-06-29 15:52:18'),
(78, '000573', 'Băng keo đục SB 48 x 100 Yard/048', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:44', 0, '2010-06-29 15:52:18'),
(79, '000574', 'Băng keo trong SB 60mmx 100yard/048', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:44', 0, '2010-06-29 15:52:19'),
(80, '000575', 'Bk đục 60*100y', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:44', 0, '2010-06-29 15:52:19'),
(81, '000577', 'Băng keo trong SB 24mmx 100 yard/043', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:44', 0, '2010-06-29 15:52:19'),
(82, '000578', 'Băng keo SB 2 mặt mouse giữa 24 x 8000 keo tốt', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:44', 0, '2010-06-29 15:52:19'),
(83, '000580', 'Băng keo vải Vàng 48mm x 15 yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:44', 0, '2010-06-29 15:52:19'),
(84, '000581', 'Băng keo giấy nhăn.24mm x 25Y', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:44', 0, '2010-06-29 15:52:19'),
(85, '000582', 'Băng keo SB giấy da bò 48mm x 30 yard', 0, '', '', '', 4, 4, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:44', 0, '2010-06-29 15:52:19'),
(86, '001000', 'băng dán -Tape Glue ECO TG-310', 0, '', '', '', 1, 1, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:44', 0, '2010-06-29 15:52:19'),
(87, '001001', 'ruôt băng dán-Refill of TG-310.TG-310R', 0, '', '', '', 1, 1, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:44', 0, '2010-06-29 15:52:19'),
(88, '001500', 'Keo nước Bến Nghé GL200 - 30ml', 0, '', '', '', 7, 7, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:44', 0, '2010-06-29 15:52:19'),
(89, '001501', 'Keo nước Bến Nghé GL202 - 52ml', 0, '', '', '', 8, 8, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:44', 0, '2010-06-29 15:52:20'),
(90, '001502', 'Keo 502 – 30gr', 0, '', '', '', 8, 8, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:44', 0, '2010-06-29 15:52:20'),
(91, '001503', 'Keo 502 – L6', 0, '', '', '', 9, 9, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:44', 0, '2010-06-29 15:52:20'),
(92, '001504', 'Keo 502 – L9', 0, '', '', '', 9, 9, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:44', 0, '2010-06-29 15:52:20'),
(93, '001505', 'Keo 502 – L10', 0, '', '', '', 9, 9, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:44', 0, '2010-06-29 15:52:20'),
(94, '001506', 'Hồ lỏng .30ml', 0, '', '', '', 9, 9, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:44', 0, '2010-06-29 15:52:20'),
(95, '001507', 'Hồ khô', 0, '', '', '', 10, 10, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:44', 0, '2010-06-29 15:52:20'),
(96, '001508', 'Keo 502 L1', 0, '', '', '', 8, 8, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:44', 0, '2010-06-29 15:52:20'),
(97, '001509', 'Hồ khô post it', 0, '', '', '', 10, 10, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:44', 0, '2010-06-29 15:52:20'),
(98, '001510', 'Hồ lỏng G08', 0, '', '', '', 11, 11, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:44', 0, '2010-06-29 15:52:21'),
(99, '001511', 'Hồ lỏng Quế Lâm 30ml', 0, '', '', '', 11, 11, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:44', 0, '2010-06-29 15:52:21'),
(100, '001512', 'Hồ kho Staedtler', 0, '', '', '', 11, 11, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:02:44', 0, '2010-06-29 15:52:21');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_property`
--

DROP TABLE IF EXISTS `definition_list_property`;
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

DROP TABLE IF EXISTS `definition_list_rank`;
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `definition_list_rank`
--

INSERT INTO `definition_list_rank` (`rank_id`, `term_id`, `rank_parent_id`, `rank_name`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, 1, NULL, 'VIP', 0, 0, '2010-06-15 14:38:56', 0, '2010-06-15 14:45:08'),
(2, 1, 1, 'New Rank', 0, 0, '2010-06-15 14:45:10', 0, '2010-06-15 14:45:10'),
(3, 1, 1, 'Vãng lai', 0, 0, '2010-06-15 14:45:24', 0, '2010-06-15 14:45:33'),
(4, 2, 1, 'New Rank', 0, 1, '2010-07-28 13:55:12', 1, '2010-07-28 13:55:12');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_rank_path`
--

DROP TABLE IF EXISTS `definition_list_rank_path`;
CREATE TABLE IF NOT EXISTS `definition_list_rank_path` (
  `rank_id` bigint(30) unsigned NOT NULL,
  `path` text,
  PRIMARY KEY (`rank_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `definition_list_rank_path`
--

INSERT INTO `definition_list_rank_path` (`rank_id`, `path`) VALUES
(1, '/1/'),
(2, '/1/2/'),
(3, '/1/3/'),
(4, '/1/4/');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_role`
--

DROP TABLE IF EXISTS `definition_list_role`;
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=11 ;

--
-- Dumping data for table `definition_list_role`
--

INSERT INTO `definition_list_role` (`role_id`, `department_id`, `role_code`, `role_name`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, 0, 'VTM', 'Toàn quyền', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 1, 'KT1', 'Kế toán 1', 0, 0, '2010-07-04 12:16:12', 0, '2010-07-04 14:04:28'),
(5, 2, 'KD1', 'Kinh doanh 1', 0, 0, '2010-07-04 12:17:03', 0, '2010-07-04 12:17:03'),
(6, 2, 'KD2', 'Kinh doanh 2', 0, 0, '2010-07-04 12:18:29', 0, '2010-07-04 12:18:29'),
(8, 1, 'Admin', 'Quyền quản trị', 0, 0, '2010-07-04 12:19:03', 0, '2010-07-04 15:47:14'),
(10, 4, 'KH1', 'Quản lí kho', 0, 0, '2010-07-04 22:44:28', 1, '2010-07-13 21:05:16');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_service`
--

DROP TABLE IF EXISTS `definition_list_service`;
CREATE TABLE IF NOT EXISTS `definition_list_service` (
  `service_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `service_code` varchar(10) NOT NULL,
  `service_name` varchar(100) NOT NULL,
  `supplier_id` bigint(30) unsigned NOT NULL,
  `service_picture` varchar(100) NOT NULL,
  `service_description` varchar(500) NOT NULL,
  `unit_id` bigint(30) unsigned NOT NULL,
  `inactive` tinyint(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`service_id`),
  KEY `fk_service_supplier` (`supplier_id`),
  KEY `fk_service_unit` (`unit_id`),
  KEY `fk_service_created_user` (`created_by_userid`),
  KEY `fk_service_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `definition_list_service`
--

INSERT INTO `definition_list_service` (`service_id`, `service_code`, `service_name`, `supplier_id`, `service_picture`, `service_description`, `unit_id`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, '', '', 0, '', '', 0, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(1, 'DVVT', 'Dịch vụ vận tải', 2, '', '', 0, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(2, 'DVHK', 'Dịch vụ hàng không', 2, '', '', 0, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(3, 'DVDK', 'Tiếp khách', 1, '', '', 0, 0, 1, '2010-08-23 09:07:24', 1, '2010-08-23 09:07:24');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_staff`
--

DROP TABLE IF EXISTS `definition_list_staff`;
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `definition_list_staff`
--

INSERT INTO `definition_list_staff` (`staff_id`, `department_id`, `staff_code`, `first_name`, `middle_name`, `last_name`, `birth_date`, `id_number`, `id_issuing_office`, `id_issuing_date`, `social_number`, `resident_address`, `contact_address`, `home_phone`, `cell_phone`, `email`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, 0, 'VTM', 'Nhân viên', '', 'VTM', '1900-01-01 00:00:00', '', '', '1900-01-01 00:00:00', '', '', '', '', '', '', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(3, 1, 'ADMIN', '', '', 'Administrator', '2010-07-13 20:53:33', '', '', '0000-00-00 00:00:00', '', '', '', '', '', '', 0, 0, '2010-07-13 20:53:33', 1, '2010-07-21 21:10:10'),
(4, 1, '0105', 'hkjhjk', 'ldjlkajd', 'Trần Phúc Hoàng', '1979-01-01 15:21:09', '456546546', 'kdj;aj;kjj;akl', '0000-00-00 00:00:00', '4465456', 'l;djjfajfkl;j', 'oidsuoiaugoi', '65465456', '65465465465', 'hoang@yahoo.com', 0, 1, '2010-07-28 15:21:09', 1, '2010-07-28 15:29:46'),
(5, 3, '0107', 'd;lkfd;lsk', 'hdjksfhj', 'tú', '1978-03-01 15:31:48', '446465', '4656546546', '2007-04-05 00:00:00', '5456565', 'dsfljadljf;', 'dasjaddkjhadkh', '465456465', '65465465465', 'tu@yahoo.com', 0, 1, '2010-07-28 15:31:48', 1, '2010-07-28 15:32:36'),
(6, 3, '0108', '', '', 'minh', '1980-01-01 08:26:19', '', '', '0000-00-00 00:00:00', '', '', '', '', '', '', 0, 1, '2010-07-30 08:26:19', 1, '2010-07-30 08:26:19');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_subject`
--

DROP TABLE IF EXISTS `definition_list_subject`;
CREATE TABLE IF NOT EXISTS `definition_list_subject` (
  `subject_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `subject_code` varchar(30) NOT NULL,
  `subject_name` text NOT NULL,
  `subject_address` text NOT NULL,
  `subject_tax_code` varchar(20) NOT NULL,
  `subject_contact_person` text NOT NULL,
  `subject_telephone` varchar(50) NOT NULL,
  `subject_fax` varchar(50) NOT NULL,
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=776 ;

--
-- Dumping data for table `definition_list_subject`
--

INSERT INTO `definition_list_subject` (`subject_id`, `subject_code`, `subject_name`, `subject_address`, `subject_tax_code`, `subject_contact_person`, `subject_telephone`, `subject_fax`, `currency_id`, `is_software_user`, `is_producer`, `is_supplier`, `is_customer`, `is_government`, `is_bank`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, '', '', '', '', '', '', '', 0, 0, 1, 1, 1, 1, 1, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(1, 'N2H', 'Công ty Nhanh Nhanh', 'Thu Duc', '34123423', 'chị ngân', '', '', 1, 1, 0, 1, 1, 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(2, 'Mizuho', 'Ngân hàng MIZUHO', '115 Nguyễn Huệ, Q1, TPHCM', '0304413344', '', '', '', 1, 0, 0, 0, 0, 0, 1, 0, 0, '1900-01-01 00:00:00', 1, '2010-07-23 14:55:41'),
(3, 'VCB', 'Ngân hàng TM Ngoại thương', 'PGD Bình Thọ - CN Thủ Đức', '1111111111', '', '', '', 1, 0, 0, 0, 0, 0, 1, 0, 0, '1900-01-01 00:00:00', 1, '2010-07-23 14:56:56'),
(4, 'UFJ', 'The Bank of Tokyo-Mitsubishi UFJ', '5B Tôn Đức Thắng, Q1, TPHCM', '2222222222', '', '', '', 1, 0, 0, 0, 0, 0, 1, 0, 0, '1900-01-01 00:00:00', 1, '2010-07-23 14:58:58'),
(5, '111-001', 'CTY TNHH DOTCOM VIỆT NAM', '40-42 Phan Bội Châu, P. Bến Thành, Q1', '0305084734', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-07-04 16:24:14'),
(6, '111-002', 'Trần Phúc Hoàng', '', '', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-07-04 15:42:05'),
(7, '111-003', 'Chi Cục Thuế Quận Thủ Đức', '16 đường 6, P.Linh Chiểu, Q. Thủ Đức', '0301519977022', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-07-04 15:42:06'),
(8, '111-004', 'CÔNG TY TNHH TM ĐỒNG NAM', '67-69-71 Trương Định, Q1. TPHCM', '0300835779001', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-07-04 15:42:07'),
(9, '111-005', 'Vũ Thị Kim Ngân', '', '', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-07-04 15:42:08'),
(10, '111-006', 'Hợp Tác Xã Vận Tải Số 10', '100 Hùng Vương, P9, Q5', '0302847593', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-07-04 15:42:09'),
(11, '111-007', 'Cty TNHH May THIÊN ĐỨC TÂM', '197/2 Ba Đình, P8, Q8, TPHCM', '0303237720', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-07-04 15:42:09'),
(12, '111-008', 'Hợp Tác Xã VTHH Và Xe Du Lịch THỦ ĐỨC', '30 Võ Văn Ngân, P. Bình Thọ, Q. Thủ Đức', '0301459132', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-07-04 15:42:10'),
(13, '111-009', 'Cty CP Việt Đỉnh', 'Lầu 4, số 141, đường D3, P25, Q. Bình Thạnh', '0304397068', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-07-04 15:42:11'),
(14, '111-010', 'Cty TNHH TÂN ĐÔNG DƯƠNG', '45 Trương Định,P6, Q3', '0301449173', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(15, '111-011', 'TAXI', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(16, '111-012', 'Công Ty Cổ Phần Thương Mại Dịch Vụ Phong Vũ', '125 Cách Mạng Tháng 8, P. Bến Thành, Q1, TPHCM', '0304998358', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(17, '111-013', 'Anh Tuấn ( cty  Nhanh Nhanh)', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(18, '111-014', 'Trung Đoàn TT23-QK7', '102 Phổ Quang, P2, Q.TB, TPHCM', '0301832040', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(19, '111-015', 'Anh Đời Cty Nhanh Nhanh', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(20, '111-016', 'Cty TNHH DVBV Hoàng Gia', 'km 92-QL5-Hùng Vương-HB-HP', '0200356067', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(21, '111-017', 'Anh Thanh', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(22, '111-018', 'Anh Hùng', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(23, '111-019', 'Anh Phước (Thủ Đức)', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(24, '111-020', 'Mr. Taro', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(25, '111-021', 'Cty TNHH MTV Nhanh Nhanh', 'Số 37, Đường số 7, P. Linh Trung, Q. TĐ', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(26, '111-022', 'CTY Cổ Phần Hai Bốn Bảy', '57 Nguyễn Quang Bích, P13, Q. TB', '0304043037', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(27, '111-023', 'Tổng Công Ty Viễn Thông Quân Đội ( Viettel Corporation)', 'Số 1, Giang Minh, Ba Đình, Hà Nội', '0100109106', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(28, '111-024', 'CTY CP THƯƠNG MẠI NGUYỄN KIM', '63-65 Trần Hưng Đạo, Q1, TP.HCM', '0302286281', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(29, '111-025', 'Anh Sơn', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(30, '111-026', 'Nguyễn Văn Trương', 'Đường số 7, P. Linh Trung, Q TĐ', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(31, '111-027', 'Cty TNHH Columbia ASIA(VN)', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(32, '111-028', 'Cty Điện Thoại Đông TP (CN Thủ Đức)', '125 Hai Bà Trưng, P. Bến Nghé, Q1', '0300954529028', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(33, '111-029', 'Công Ty Cổ Phần VON', '64-64 Bis Võ Thị Sáu, P. Tân Định, Q1', '0303284985', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(34, '111-030', 'Cửa Hàng Thanh An', '87b Thủ Khoa Huân, P8, Q.TB', '0303182302', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(35, '111-031', 'Cty CP Siêu Thanh', '254 Trần Hưng Đạo Q1', '0302563707', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(36, '111-032', 'Nguyễn Xuân Hùng (HTX-VT&DL Phương Nam)', '6/6 Trần Não, P. Bình An, Q2', '0301555277', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(37, '111-033', 'Anh Hoành', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(38, '111-034', 'CỤC QUẢN LÝ XUẤT NHẬP CẢNH', '', '0301464848', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(39, '111-035', 'Kho Bạc Nhà Nước Thủ Đức ( Điểm Giao Dịch Số 61)', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(40, '111-036', 'Cửa Hàng Vật Liệu Xây Dựng ĐỨC HUỲNH', '1133 Kha Vạn Cân-KP4 P.LT, Q. Thủ Đức', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(41, '111-037', 'Công Ty  TNHH TM Thế Giới Hộp Mực', 'Số 4 Trương Định P6, Q3', '0304258716', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(42, '111-038', 'CTY BẢO MINH CHỢ LỚN', '26 Tôn Thất Đạm, Q1, TPHCM', '0300446973055', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(43, '111-039', 'Cty TNHH Viễn Thông FPT Miền Nam', '68 Võ Văn Tầng, P.6 Q.3, TPHCM', '0305617774', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(44, '111-040', 'Sách Tài Chính - Chính Trị', '44/49 Đường Số 14, P11, Q. GV', '0305845234', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(45, '111-041', 'BHXH Quận Thủ Đức', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(46, '111-042', 'CÔNG TY TNHH SÀI GÒN TAXI', '82 Đường 45, P. tân Quy, Q7', '0303651755', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(47, '111-043', 'CỬA HÀNG ĐIỆN-ĐTDĐ THANH XUÂN', '75 Lê Văn Việt, kp3, p. Hiệp Phú, Q9, TPHCM', '0301722217', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(48, '111-044', 'CTY TNHH DV VẬN TẢI TÂN VĨNH THỊNH', '67 Lê Thị Hồng Gấm, Q1, TPHCM', '0301464414001', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(49, '111-045', 'CÔNG TY CP HẢI NINH', '82B, QL13, P. Hiệp Bình Phước, TPHCM', '0303466872', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(50, '111-046', 'CTY ĐIỆN LỰC THÀNH PHỐ HCM', 'Thủ Đức', '0300951119001', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(51, '111-047', 'CTY CP CẤP NƯỚC THỦ ĐỨC', 'Thủ Đức', '0304803601', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(52, '111-048', 'Chi Cục Hải Quan Cửa Khẩu cảng Sài Gòn KV1(Tân cảng)', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:25', 0, '2010-06-21 00:46:25'),
(53, '111-049', 'CN TRUNG TÂM THẮNG HƯNG', 'Ấp 8 Xã Lương Hòa, H, Bến Lức, T. Long An', '0302788066001', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(54, '111-050', 'TỔNG CTY  BƯU CHÍNH VIỆT NAM (VNPT)', '', '0300954529', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(55, '111-051', 'Cửa Hàng Vải Thúy Loan', '327 Hai Bà Trưng, P8, Q3', '0302861929', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(56, '111-052', 'CÔNG TY TNHH SX-TM&DV PHÚ BÌNH HƯƠNG', '13/9A Lê Văn Thọ, P12, Q.Gò Vấp, TPHCM', '0303675298', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(57, '111-053', 'CÔNG TY CỔ PHẦN ÁNH DƯƠNG VN', '306 Điện Biên Phủ, P.22, QBT', '0302035520', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(58, '111-054', 'CÔNG TY CỔ PHẦN NGÔI SAO TƯƠNG LAI', '01 Hoa Sứ, P7, Q. Phú Nhuận', '0304917581', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(59, '111-055', 'Tổng Cục Thuế', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(60, '111-056', 'CÔNG TY TNHH SCS (VIỆT NAM) - CHI NHÁNH TP. HCM', '115 Nguyễn Huệ, Q. 1, TP. HCM', '0101407070001', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(61, '111-057', 'CTY TNHH DRAGON LOGISTICS-ĐỒNG NAI', '101/1 KCN Amata, Biên Hòa, Đồng Nai', '0100112691003', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(62, '111-058', 'Anh Quả', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(63, '111-059', 'HTX VẬN TẢI SỐ 3 GÒ VẤP', '372 Nguyễn Thái Sơn, P5, Q. GV', '0301450549', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(64, '111-060', 'Ngân Hàng Vietcombank', 'Thủ Đức', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(65, '111-061', 'Thương Xá Tax', '135 Nguyễ Huệ, Q1, TPHCM', '0300100037003', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(66, '111-062', 'Cửa Hàng Trinh', '109-111A Tôn Thất Đạm, Q1, TPHCM', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(67, '111-063', 'CÔNG TY BẢO HIỂM LIÊN HIỆP', '803, Lầu 8, Sun Wah, 115 Nguyễn Huệ, Q1, TPHCM', '0100112571001001', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(68, '111-064', 'CÔNG TY TNHH SX TM TTNT ĐÔNG GIA', '53 Ngô Gia Tự, Q10, TPHCM', '0302566377', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(69, '111-065', 'CÔNG TY CP DU LỊCH TĨNH BÀ RỊA VŨNG TÀU', '207 Võ Thị Sáu-Phường Thắng Tam-TP Vũng Tàu', '3500101812001', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(70, '111-066', 'CÔNG TY DỊCH VỤ LỮ HÀNH SÀI GÒN TOURIST', '49 Lê Thánh Tôn, Q1, TP HCM', '0300625210025001', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(71, '111-067', 'CTY TNHH TM DƯỢC PHẨM LAN KHUÊ', '520-522-524-526 CMT8,P11, Q3', '0302971015', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(72, '111-068', 'CÔNG TY CP TÌM KIẾM NHÂN TÀI VINA', '365 Lê Quang Định, P5, Q. Bình Thạnh', '0303452460', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(73, '111-069', 'CHI NHÁNH 2-CÔNG TY CP BVMT QUỐC TẾ ICARE', '240 Võ Văn Ngân, P. Bình Thọ, Q. Thủ Đức', '0303897195005', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(74, '111-070', 'Công ty tnhh tm-dv Hàm Rồng', '475 Lạc Long Quân , P5, Q11', '0302863651', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(75, '111-071', 'Công ty tnhh bảo hiểm PNT MSIG VN', 'tầng 6 sài gòn centre, số 65 Lê Lợi, p Bến Nghé, Q1', '0102973336-001', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(76, '111-072', 'Công ty VTM Việt Nam', 'Lầu 6 phòng 6, tòa nhà Etown 2,364 Cộng hòa, p13, Q. TB', '0304239135', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(77, '111-073', 'Công ty tnhh dv&tm Đông Á', '5/6 Nguyễn Siêu, Q1 TPHCM', '0302441963', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(78, '111-074', 'Công ty tnhh mtv xd-tm dv-qc Vương Đại Dương', '23.26 Bình Dương 1 X. An bình H. Dĩ An Bình Dương', '3701349179', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(79, '111-075', 'Công ty tnhh Hoàng Trường Sa', '82 Nguyễn Bá Tuyển, P12 Q. Tân bình', '0308077950', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(80, '111-076', 'Công ty xăng dầu khu vực II', '15 Lê Duẩn Q1, TP HCM', '0300555450-001', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(81, '111-077', 'Công ty tnhh giấy Vi Tính Liên Sơn', '34 Nguyễn Bỉnh Khiêm Q1 TPHCM', '0301452923', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(82, '111-078', 'Công ty tnhh Bí Bo', '77G - 77H Bùi Thị Xuân, P. PNL - Q1', '0302906802', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(83, '111-079', 'Công ty tnhh tmdv Quốc tế BigC Dong Nai', 'KP1-Long Bình Tân, TP Biên Hòa Tỉnh Đồng Nai', '3600258976', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(84, '111-080', 'Công ty CP Khóa Việt Tiệp', '20 Đường số 7, P11, Q6, TPHCM', '0100100537-002', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(85, '111-081', 'Công ty tnhh mtv Giải Pháp Trí Tuệ', '9 Hoa huệ p.7 - Q. Phú Nhuận', '0309174805', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(86, '111-082', 'Công ty tnhh Acer Việt Nam', 'Tòa nhà Petro Việt Nam số 1-5 Lê Duẫn, Q.1 TP.HCM', '0301883398', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(87, '111-083', 'CH TẠP HÓA VŨ THỊ THANH HẰNG', 'Chợ thủ đức A _ P. Linh Tây', '0301611901', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(88, '111-084', 'Ngân Hàng Công Thương Việt Nam', 'Chi nhánh Thủ Đức', '0100111948-110', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(89, '111-085', 'HTX  Vận Tải & Du Lịch Phước Lộc', '616 cộng Hòa -F13- TB', '03002802384', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(90, '111-086', 'Công ty tnhh MTV QC IN ẤN Hồng Anh', '39 Bis Đặng Dung, P.Tân Định, Q1', '0309277550', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(91, '111-087', 'Co.opMart Nguyễn Kiệm', '571-573 Nguyễn Kiệm Q.Phú Nhuận', '0305778394', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(92, '111-088', 'CÔNG TY TNHH SX-TM KHANG THỊNH', '171 Hậu Giang, P5, Q6, tp HCM', '0304924980', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(93, '111-089', 'Công ty tnhh Máy Tính Xách tay Bảo Huy', '806 Trần Hưng Đạo P7-Q5', '0305247315', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(94, '111-090', 'Công ty tnhh dịch thuật chuyên nghiệp CNN', 'số 470 nguyễn trãi  Thanh Xuân Trung_ Thanh Xuân_HN', '0101759107', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(95, '111-091', 'CÔNG TY CP TÌM KIẾM NHÂN TÀI VINA', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(96, '111-092', 'Công ty tnhh tk-tm Minh Trí Dũng', '136/20 Lê Thánh Tôn _ P. Bến Thành. Q1', '0303266048', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(97, '111-093', 'Công ty tnhh Cetus Việt nam', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(98, '111-094', 'Công ty tnhh Sài Gòn Co.op Xa lộ Hà Nội', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(99, '111-095', 'Công ty tnhh tv-tm-dv Kỳ Long', '31 Bế Văn Đàn - P14 - Q. Tân Bình', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(100, '111-096', 'Cửa hàng Dũng', 'Dĩ An Bình Dương', '3700840761', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(101, '111-097', 'CH TẠP HÓA VŨ THỊ THANH HẰNG', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(102, '111-098', 'Công ty tnhh Metro Cash & Carry Việt Nam', 'An Phú-An Khánh, Q2, TPHCM', '0302249586', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(103, '111-099', 'Công ty TNHH SX Nhựa -Tủ Anh Minh.', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(104, '111-100', 'VP Bán vé hãng HK Nhật Bản (JAL) tại tp.hcm.', '88 Đồng khởi, Quận 1 tphcm.', '0301551258', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(105, '112-001', 'Ngân hàng MIZUHO', '115 Nguyễn Huệ, Q1, TPHCM', '0304413344', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:26', 0, '2010-06-21 00:46:26'),
(106, '112-002', 'The Bank of Tokyo-Mitsubishi UFJ', '5B Tôn Đức Thắng, Q1, TPHCM', '0301224067', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 0, '2010-06-21 00:46:27'),
(107, '112-003', 'Ngân hàng Sumitomo', '5B Tôn Đức Thắng, Q1, TPHCM', '0304198827', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 0, '2010-06-21 00:46:27'),
(108, '112-004', 'Ngân Hàng VietCombank', 'PGD Bình Thọ - CN Thủ Đức', '0100112437-062', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 0, '2010-06-21 00:46:27'),
(109, '331-01', 'CÔNG TY TNHH-TM-BÌNH HƯƠNG', '51 Pasteur Q.1', '0305790722', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 1, '2010-07-28 15:55:56'),
(110, '331-02', 'CÔNG TY CHẤN LONG', 'Số 2, Đường 36, P10, Q6', '0302718245', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 1, '2010-07-28 15:55:56'),
(111, '331-03', 'CO.OP MAX', '191 Quang Trung, Phường Hiệp Phú, Q9, TPHCM', '0305767459', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 1, '2010-07-28 15:55:58'),
(112, '331-04', 'CỬA HÀNG SỐ 42', '42 Huỳnh Thúc Kháng, Phường Bến Nghé, Q1', '0302723904', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 1, '2010-07-28 15:55:59'),
(113, '331-05', 'CÔNG TY TNHH SX-TM-DV-XNK ĐẠI DƯƠNG', '92 Hồ Ngọc Lãm, An Lạc, Bình Tân', '0302787947', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 1, '2010-07-28 15:56:00'),
(114, '331-06', 'CÔNG TY CỔ PHẦN SX-TM ĐÀO TIÊN', 'Lô 2, Đường E, KCN Tân Tạo, Q.Tân Bình', '0302567645', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 1, '2010-07-28 15:56:01'),
(115, '331-07', 'CÔNG TY CỔ PHẦN ĐIỆN MÁY TPHCM', '29 Tôn Đức Thắng, Q1, HCM', '0300646919', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 1, '2010-07-28 15:56:08'),
(116, '331-08', 'CÔNG TY CỔ PHẦN DIỆU THƯƠNG', 'ấp Long Đức 1, Xã Tam Phước, Huyện Long Thành, Tỉnh Đồng Nai.', '3600257203', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 1, '2010-07-28 15:56:09'),
(117, '331-09', 'C.TY TNHH-SX-TM DƯƠNG THÀNH', '22/10 Lê Lăng, P. Phú Thọ Hòa, Q. Tân Phú', '0302778406', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 1, '2010-07-28 15:56:10'),
(118, '331-10', 'CÔNG TY CP GIẤY TÂN MAI', 'Phường Thống Nhất, Biên Hòa, Đồng Nai', '3600260196', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 1, '2010-07-28 15:56:11'),
(119, '331-11', 'CÔNG TY TNHH TM CN GIẤY VĨNH THỊNH', '346 Bến Vân Đồn, P1,Q4', '0301445450-001', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 1, '2010-07-28 15:56:11'),
(120, '331-12', 'CÔNG TY TNHH SX TM GIMIKO', '57 Trần Quốc Thảo,P7,Q3', '0301692805', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 1, '2010-07-28 15:56:12'),
(121, '331-13', 'CÔNG TY TNHH SX HẠ PHONG', 'Lô 114, Đường B1-KDC Tân Thới Hiệp-Q12', '0301903492', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 1, '2010-07-28 15:56:13'),
(122, '331-14', 'CÔNG TY TNHH HẢO VỌNG', '86 Hàm Nghi, Q1', '0303374389', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 1, '2010-07-28 15:56:14'),
(123, '331-15', 'CÔNG TY TNHH HOÀNG LINH XANH', '251 Hồng Lạc, P10, Q. Tân Bình', '0302884676', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 1, '2010-07-28 15:56:14'),
(124, '331-16', 'CÔNG TY TNHH SX TM HOÀNG QUAN', '2967 Phạm Thế Hiển, P7, Q8', '0302422287', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 1, '2010-07-28 15:56:15'),
(125, '331-17', 'CÔNG TY TNHH TB HOÀNG THANH', '69/30 Đào Huy Tư, P17, Q. Phú Nhuận', '0302983162', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 1, '2010-07-28 15:56:16'),
(126, '331-18', 'DNTN NHỰA HỒNG PHÁT', '58-60-62, Đường số 8, Khu Bình Phú, P11,Q6', '0303833843', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 1, '2010-07-28 15:56:17'),
(127, '331-19', 'CỬA HÀNG HUÂN TRINH', '10/29C Tân Lập, Tổ 2, KP3, P Hiệp Phú, Q9', '0302767531', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 1, '2010-07-28 15:56:20'),
(128, '331-20', 'CÔNG TY TNHH HƯNG THỊNH', '49 Hồ Văn Tư, Q Thủ Đức', '0301289995', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 1, '2010-07-28 15:56:22'),
(129, '331-21', 'CÔNG TY TNHH KEN DO', '211 Nam Kỳ Khởi Nghĩa,P7, Q3', '0303728398', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 1, '2010-07-28 15:56:23'),
(130, '331-22', 'CÔNG TY TNHH SX-TM KIM HOÀN VŨ', 'H31 Bis K300-Cộng Hòa-P12-Q. Tân Bình', '0301424549-001', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 1, '2010-07-28 15:56:24'),
(131, '331-23', 'CÔNG TY TNHH MAI HUY', '180 Trần Phú, Phú Hà, Phan Rang, Ninh Thuận', '4500240328', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 1, '2010-07-28 15:56:24'),
(132, '331-24', 'CÔNG TY TNHH TM MẪN ĐẠT', '98F Lê Lai, P Bến Thành, Q1', '0302225296', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 1, '2010-07-28 15:56:25'),
(133, '331-25', 'Công ty tnhh Metro Cash & Carry Việt Nam', 'An Phú-An Khánh, Q2, TPHCM', '0302249586', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 0, '2010-06-21 00:46:27'),
(134, '331-26', 'CÔNG TY TNHH NAM NHẬT TIÊN', '69 Nguyễn Cữu Vân, P17, QTB', '0301895227', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 0, '2010-06-21 00:46:27'),
(135, '331-27', 'CƠ SỞ NGÔ THỤC THIÊM', '36 Lô C, Đường Số 7, P11, Q6', '0302280473', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 0, '2010-06-21 00:46:27'),
(136, '331-28', 'CTY TNHH TM DV KT NGỌC VẠN', '41 Phú Hữu, P 14, Q5', '0303207846', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 0, '2010-06-21 00:46:27'),
(137, '331-29', 'CÔNG TY TNHH NGUYỄN TRẦN', '3/24 Hiệp Bình Phước, Q.TĐ', '0302868924', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 0, '2010-06-21 00:46:27'),
(138, '331-30', 'CÔNG TY TNHH SX-TM PHÚC LONG', '42/24-42/26, Đường Số 643, Tạ Quang Bửu, P4, Q8', '0302108546', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 0, '2010-06-21 00:46:27'),
(139, '331-31', 'CƠ SỞ SX CHỔI PHƯỚC LỘC', '265/3 Tổ 8, Ấp Thượng, Xã Tân Thông Hội, Củ Chi', '0303893377', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 0, '2010-06-21 00:46:27'),
(140, '331-32', 'CÔNG TY TNHH PILOT', '19 Trương Công Định, Q. Tân Bình', '0300735686', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 0, '2010-06-21 00:46:27'),
(141, '331-33', 'CÔNG TY CỔ PHẦN PIN ẮC QUY MIỀN NAM', '21-23 Trần Hưng Đạo, Q1, TPHCM', '0300405462-001', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 0, '2010-06-21 00:46:27'),
(142, '331-34', 'CÔNG TY TNHH TM DV QUỐC VIỆT', '425 Võ Văn Tần, Q3', '0300974726', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 0, '2010-06-21 00:46:27'),
(143, '331-35', 'CÔNG TY CỔ PHẦN TM THIẾT BỊ VĂN PHÒNG SÁNG TẠO', '119 Hồng Hà, P2, Q.TB', '0305257232', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 0, '2010-06-21 00:46:27'),
(144, '331-36', 'CỬA HÀNG SAO MAI', '1/6 Nguyễn Hữu Tiến, P.Tây Thạnh, Q. Tân Phú', '0302249226', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 0, '2010-06-21 00:46:27'),
(145, '331-37', 'CÔNG TY TNHH SONG NHƯ', '60/35 Trần Hưng Đạo,P7, Q5', '0303317581', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 0, '2010-06-21 00:46:27'),
(146, '331-38', 'CÔNG TY TNHH SX-TM THIÊN CƯỜNG', '111/12 Lê Đình Cẩn, P. Tân Tạo, Q. Tân Bình', '0302367928', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 0, '2010-06-21 00:46:27'),
(147, '331-39', 'CÔNG TY TNHH THU NGUYỆT', '270 Tổ 10, Ấp Kiến Điền, Xã An Điền, Huyện Bến Cát, Bình Dương', '3700676543', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 0, '2010-06-21 00:46:27'),
(148, '331-40', 'CÔNG TY TNHH TM DV TOÀN KHÁNH', '183/241 Nguyễn Duy,P9,Q8', '0305029067', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 0, '2010-06-21 00:46:27'),
(149, '331-41', 'CÔNG TY CP TM TOÀN LỰC', '34-36 Phan Văn Trị, P2, Q5', '0301307242', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 0, '2010-06-21 00:46:27'),
(150, '331-42', 'CHI NHÁNH CÔNG TY TNHH NHẬT LINH', '35/3B Ấp Mỹ Hòa 4, Xã Xuân Thới Đông, HM', '0100372026-001', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 0, '2010-06-21 00:46:27'),
(151, '331-43', 'CÔNG TY TNHH TRẦN THU VÂN', '198A, Phùng Hưng, P14, Q5', '0305403243', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 0, '2010-06-21 00:46:27'),
(152, '331-44', 'CÔNG TY TNHH TRUNG HUY', '26 Phan Đình Chú, Q5', '0302082753', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 0, '2010-06-21 00:46:27'),
(153, '331-45', 'CÔNG TY TRƯỜNG PHÁT (TRẦN SIÊU DUNG)', '65 Hải Thượng Lãng Ông, P10, Q5', '0303921151', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 0, '2010-06-21 00:46:27'),
(154, '331-46', 'CÔNG TY TNHH VẠN HƯNG', '124 Đường Hòa Bình, P. Hòa Thạnh, Q.TP', '0302146887', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 0, '2010-06-21 00:46:27'),
(155, '331-47', 'CÔNG TY TNHH TM-DV-TV VIỆT ĐỨC', '295 Trần Hưng Đạo, P Công Giang, Q1', '0305256486', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 0, '2010-06-21 00:46:27'),
(156, '331-48', 'CÔNG TY TNHH-SX-TM VIỆT LIÊN', 'Tầng 8, Phòng 8.4, Tòa nhà E Town, 364 Cộng Hòa, Phường 13, Q.Tân Bình, TPHCM', '0302244997', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 0, '2010-06-21 00:46:27'),
(157, '331-49', 'CN. CÔNG TY CP TẬP ĐOÀN PHÚ THÁI', '80D, Lý Chiêu Hoàng, P10, Q6', '0100368686-007', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 0, '2010-06-21 00:46:27'),
(158, '331-50', 'CÔNG TY TNHH MTV BỐN GIẢI PHÁP', '602/51B Điện Biên Phủ, P22, Q. TB', '0306105384', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 0, '2010-06-21 00:46:27'),
(159, '331-51', 'CÔNG TY TNHH TRANG TRÍ NỘI THẤT VẠN TÍN ĐẠT', '143/20 Gò Dầu, P. Tân Quý, Q. Tân Phú', '0303347988', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 0, '2010-06-21 00:46:27'),
(160, '331-52', 'CÔNG TY TNHH-TM-DV TKH', '126 Lê Thị Hồng Gấm-P.NTB, Q1', '0301616970', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:27', 0, '2010-06-21 00:46:27'),
(161, '331-53', 'HÓA ĐƠN LẺ', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(162, '331-54', 'CÔNG TY TNHH TM-DV-TOÀN NGỌC', '835/12 Trần Hưng Đạo, P1, Q5', '0304676470', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(163, '331-55', 'MINH PHÁT', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(164, '331-56', 'CÔNG TY TNHH TM SX TÂN PHÚ VINH', '143 Nguyễn Chí Thanh, F9, Q5', '0302401858', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(165, '331-57', 'VPP PHÚC', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(166, '331-58', 'CÔNG TY TNHH MAGX VIET NAM', '114, KCN AMATA, Biên Hòa', '3600487239', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(167, '331-59', 'CÔNG TY TNHH NEW TOYO PULPPY(VN)', 'Lầu 5, 71, Điện Biên Phủ, P15, Q. Bình Thạnh', '3700240066-001', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(168, '331-60', 'CÔNG TY TNHH Công Nghiệp PLUS Việt Nam', 'Số 3, đường 1A, KCN Biên Hòa 2, Đồng Nai', '3600256520-001', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(169, '331-61', 'CÔNG TY CỔ PHẦN QUỐC HUY ANH', '54 Nguyễn Bá Tuyển P12, Q.TB', '0303430107', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(170, '331-62', 'CÔNG TY TNHH IN ẤN MING SHENG', '18 đường số 2, KCN Sống Thần 2, Dĩ An, BD', '3700403909', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(171, '331-63', 'CÔNG TY TNHH THIẾT BỊ Y KHOA', '24 Năm Châu,P11,QTB', '0302792048', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(172, '331-64', 'CÔNG TY TIẾN PHÁT', 'D22/18A Phan Anh, P. Bình Trị Đông, Q. BT', '0302103280', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(173, '331-65', 'HỢP TÁC XÃ TM Q3 (Unilever VN)', '171, Trần Quốc Thảo, Q3 TPHCM', '0301451221-001', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(174, '331-66', 'C.TY TNHH TM DV BẢO QUYÊN', '4A1, Tổ 17, KP6, Nguyễn Ái Quốc, P Trung Dũng, BH, ĐN', '3601023060', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(175, '331-67', 'CÔNG TY  TNHH PHƯƠNG VIỆT HOÀNG', '9/20 Bùi Thị Xuân P2, Q. TB', '0303600870', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(176, '331-68', 'CTY CP VIỆT ĐỈNH', 'Lầu 4, số 141, đường D3, P25, Q. Bình Thạnh', '0304397068', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(177, '331-69', 'CÔNG TY TNHH QUẢNG CÁO SEN VÀNG', '157/16/30 lê lợi, P.3 Q.Gò Vấp', '0304675406', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(178, '331-70', 'CÔNG TY TNHH TM NGỌC HẠNH', '40 Đường 9, Phước Bình, Q9', '0304381420', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(179, '331-71', 'CÔNG TY TNHH TM VPP GIA THÀNH', '177 Đường 24, P. Bình Trị Đông, Q.TB', '0304564329', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(180, '331-72', 'CN CÔNG TY CP VINACAFE BIÊN HÒA', '10 Hoàng Dư Khương, P12, Q10', '3600261626-002', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(181, '331-73', 'CÔNG TY PHAN HƯNG', '300A Nguyễn Thị Định Q2', '0304423550', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(182, '331-74', 'THẾ GIỚI DOANH NHÂN', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(183, '331-75', 'CƠ SỞ THÀNH ĐẠT', '708/19/6 Hồng Bàng, P11, Q11', '0304857678', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(184, '331-76', 'CÔNG TY TNHH NHỰA DUY TÂN', '298 Hồ Ngọc Lãm, P. An Lạc, Q. BT', '0301417196', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(185, '331-77', 'MAGX CO.LTD', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(186, '331-78', 'CÔNG TY TỰ LẬP', '341/20S Lạc Long Quân, P5, Q11', '0300398896', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(187, '331-79', 'CÔNG TY CP VIỆT TỐP', '106 Đỗ Xuân Hợp, P. Phước Long A, Q9', '0305026644', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(188, '331-80', 'DNTN VY HỒNG NGỌC', '585 Nguyễn Kiệm, P9, Q. PN', '0304502178', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(189, '331-81', 'CÔNG TY TNHH KỲ HÒA', '237/23 An Dương Vương, KP4, An lạc, Bình Tân', '0301735544', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(190, '331-82', 'CÔNG TY TNHH VIẾT BẠCH KIM VIỆT NAM', '131/89 Tô Hiến Thành P13, Q10 TPHCM', '0304810655', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(191, '331-83', 'CÔNG TY TNHH TẬP VIỆT', '87 Cao Xuân Dục, P12, Q8, TPHCM', '0303527451', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(192, '331-84', 'CÔNG TY LUKI VIỆT NAM', '45, C10 Hoa Hồng 2, P2, Q. Phú Nhuận, TPHCM', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(193, '331-85', 'CÔNG TY 4R GROUP', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(194, '331-86', 'CÔNG TY TNHH TM-DV-SX SONG HOÀNG', '443 Lạc Long Quân, P5, Q11, TPhcm', '0301792165', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(195, '331-87', 'COOP MART NGUYỄN ĐÌNH CHIỂU', '168 Nguyễn Đình Chiểu, Q3', '0305772762', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(196, '331-88', 'CÔNG TY ĐẠI HƯNG', '110/43/2/7 Bà Hom, P13, Q6', '0302040376', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(197, '331-89', 'CÔNG TY CỔ PHẦN VĂN HÓA VĂN LANG', '117 Nguyễn Văn Đậu, P5, Q. BT, TPHCM', '0301458989', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(198, '331-90', 'CÔNG TY TNHH-SX-TM-DV NAM CƯỜNG', 'Ấp 1B Xã An Phú H. Thuận An, T. Bình Dương', '0301441897', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(199, '331-91', 'VĂN PHÒNG PHẨM VIỆT NAM', '480 Lạc Long Quân, Phường 5, Q11, TPHCM', '0306029165', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(200, '331-92', 'CH. VĂN PHÒNG PHẨM LA ĐÔ', '117/80/3 Nguyễn Hữu Cảnh, P22. Q. BT', '0305484690', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(201, '331-93', 'CÔNG TY TNHH ĐIỆN TỬ GIA MINH', '26/16 Âu Cơ, P14, Q. Tân Bình, TPHCM', '0303504655', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(202, '331-94', 'TRƯƠNG TÚ LIÊN', 'Sạp 15, Tổ 24, Chợ Kim Biên, P13, Q5', '0300356737-004', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(203, '331-95', 'COOP MART CỐNG QUỲNH', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(204, '331-96', 'CÔNG TY TNHH SX-TM-DV NAM VIỆT CƯỜNG', '239 Nguyễn Thượng Hiền, P6, Q. Bình Thạnh', '0305857102', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(205, '331-97', 'CÔNG TY TNHH SX TM DV MAI HOÀNG LONG', '49 Yersin, P. Cầu Ông Lãnh, Q1, TPHCM', '0304586347', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(206, '331-98', 'CÔNG TY TNHH KHANG TÙNG', '49 Tân Hải, P13, Q. tân Bình', '0305255595', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(207, '331-99', 'CÔNG TY CỔ PHẦN GIẤY LINH XUÂN', '34, Đường số 9, KP5, P. Linh Xuân, Q. TĐ', '0302269744', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(208, '331-100', 'CÔNG TY TNHH TM ĐẠI HOÀNG NGUYÊN', '254 Nguyễn Văn Đậu, P11, Q. Bình Thạnh', '0303735123', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(209, '331-101', 'Chi Nhánh Công Ty Dịch Vụ và Thương Mại', '171 Võ Thị Sáu,Q3,TPHCM', '0100113159-001', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(210, '331-102', 'CÔNG TY TNHH TM MẬU DỊCH LIÊN KẾT', '11 Trần Doãn Khanh, P.ĐK, Q1', '0304396762', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(211, '331-103', 'Cty TNHH Tam Giác Vàng', '211 Ngô Tất Tố, P22, QTB', '0303268535', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(212, '331-104', 'CTY TNHH NỀN TẢNG KINH DOANH VIỆT NAM', 'Phòng 1503, tầng 15, Tòa nhà VIT, Số 519 Kim Mã, Q.Ba Đình, HN', '0304835794', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(213, '331-105', 'CTY TÂN CẢNG SÀI GÒN', 'P22, Q. Bình Thạnh, TPHCM', '0300514849', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(214, '331-106', 'CÔNG TY TNHH TIẾP VẬN THĂNG LONG - ĐN', '101/1 KCN Amata Biên Hòa, Đồng Nai', '0100112691-002', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(215, '331-107', 'CÔNG TY TNHH VẬN TẢI BIỂN PHƯỢNG HOÀNG', '27, Nuyễn Trung Trực, Q1, TPHCM', '0304263233', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(216, '331-108', 'CTY CP ĐẠI LÝ GIAO NHẬN VẬN TẢI XẾP DỠ TÂN CẢNG', 'Nguyễn Thị Định, P. Cát Lái, Q2, TPHCM', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(217, '331-109', 'CÔNG TY TNHH TM DV ANH PHƯỚC', '71/5, nguyễn Trãi, Q1, TPHCM', '0301485534-001', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(218, '331-110', 'CÔNG TY IN BAO BÌ TÂM BẢO', '79 KCNTB, Tây Thạnh, Q. Tân Phú, TPHCM', '0302871691', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(219, '331-111', 'CÔNG TY TNHH TM-DV MẮT BÃO', 'Nhà 4, Công Viên Phần Mềm Quang Trung, Q12', '0302712571', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(220, '331-112', 'CTY TNHH GIẤY VI TÍNH LIÊN SƠN', '34 Nguyễn Bỉnh Kiêm, Q1, TPHCM', '0301452923', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(221, '331-113', 'CÔNG TY TNHH GIAI PHÁT', 'TK 21/17 Nguyễn Cảnh Chân, P. Cầu Kho, Q1, TPHCM', '0302157215', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(222, '331-114', 'CÔNG TY TNHH PHÚC LAI', '64 Tân Thành, Bắc Sơn, Trảng Bom, Đồng Nai', '3600975370', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(223, '331-115', 'Big C Đồng Nai', 'KP1, Long Bình Tân, TP Biên Hòa, Tỉnh Đồng Nai', '3600258976', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:28', 0, '2010-06-21 00:46:28'),
(224, '331-116', 'Công ty tnhh một thành viên giấy sài gòn _ Mỹ Xuân.', 'Khu công nghiệp mỹ xuân A, huyện Tân Thành, tỉnh bà rịa _vũng tàu, Việt Nam.', '3500813231', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(225, '331-117', 'CÔNG TY TNHH MỘT THÀNH VIÊN DIỆU TUẤN', '49/40/23 Trịnh Đình Trọng, P. Phú Trung, Q. Tân Phú', '0305905116', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(226, '331-118', 'NGUYỄN THỊ NHƯ', '19 Lê Quang Sung, P2, Q6, TPHCM', '0304890121', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(227, '331-119', 'CÔNG TY CỔ PHẦN TM QUỐC TẾ-ITC', '101 Nam Kỳ Khởi Nghĩa, P. Bến Thành, Q1, TPHCM', '0301481089', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(228, '331-120', 'CÔNG TY TNHH DV-TM M&P QUỐC TẾ', 'Số 5 Nguyễn Gia Thiều, Q3, tp HCM', '0301939555-001', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(229, '331-121', 'CÔNG TY TNHH YANG MINH (VIỆT NAM)', '200 Điện Biên Phủ, P7, Q3, tp HCM', '0303419992', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(230, '331-122', 'CỬA HÀNG BÍCH LIÊN', 'C65 Tầng hầm chợ An Đông', '0302107648', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(231, '331-123', 'CÔNG TY TNHH SX-TM KHANG THỊNH', '171 Hậu Giang, P5, Q6, tp HCM', '0304924980', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(232, '331-124', 'CÔNG TY TNHH DỊCH VỤ KHỞI NGHIỆP', '168 Phan Xích Long, P2, Q. Phú Nhuận, TP. HCM', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(233, '331-125', 'CÔNG TY TNHH TMDV-XNK SAO MAI VINA', '72 Phổ Quang, Phường 2, Q. Tân Bình, Tp. HCM', '0303281335', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(234, '331-126', 'CTY TNHH TM-DV QUẢNG CÁO SAO NAM MỚI', '401/4B Kinh Dương Vương, P12, Q6, TPHCM', '0302957966', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(235, '331-127', 'Cửa hàng CHẤN THÀNH', '64 Pastuer, Q1, TPHCM', '0304326846', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(236, '331-128', 'CÔNG TY CỔ PHẦN GIẤY VĨNH HUÊ', '66/5-Quốc Lộ 1, P. Linh Xuân, Q. Thủ Đức- TpHCM', '0302566539', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(237, '331-129', 'CÔNG TY TNHH THẢO VY', 'Số 52, P. Linh Trung, Q. Thủ Đức', '0303631928', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(238, '331-130', 'CHI NHÁNH CÔNG TY TNHH TÂM CHÂU (Tỉnh Lâm Đồng)', '907 Trần Hưng Đạo, P.1, Q5, TPHCM', '5800234888-002', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(239, '331-131', 'CÔNG TY TNHH NGÔI NHÀ THẢO NGUYÊN', '158C Võ Thị Sáu, P8, Q3, tpHCM', '0304788833', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(240, '331-132', 'CÔNG TY TNHH VY VY', 'B6/1 Đường 47, P. Bình Thuận, Q7, TPHCM', '0303898470', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(241, '331-133', 'DNTN NGUYÊN CHÂU', '480 Lạc Long Quân, Phường 5, Q11, TPHCM', '0304325264', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(242, '331-134', 'CÔNG TY TNHH VINH CƠ', '505/14 Bến Bình Đông, P13, Q8 TPHCM', '0301856718', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(243, '331-135', 'CƠ SỞ DÉP XỐP HẢI ÂU', '571 Âu Cơ, P. Phú Trung, Q. Tân Phú', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(244, '331-136', 'CÔNG TY TNHH VẬT LIỆU BĂNG KEO NITTO DENKO(VIỆT NAM)', 'Lô C, Kho Mapletree, Số 1, Đường 10, VSIP, TA, BD', '3700367915', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(245, '331-137', 'CN CTY CỔ PHẦN CÔNG NGHỆ SILICOM', 'Lầu 9, Zen Plaza 54-56 Nguyễn Trãi, Q1, TPHCM', '0100777230-001', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(246, '331-138', 'NHÀ PHÂN PHỐI ĐỨC LỢI', '221 Đặng Văn Bi, Thủ Đức, TPHCM', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(247, '331-139', 'CÔNG TY TNHH ALPHA VIỆT NAM', '204 Nơ Trang Long, P12, Q BT, TPHCM', '0303534716', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(248, '331-140', 'CÔNG TY TNHH SX-GIA CÔNG CƠ KHÍ ĐẠI PHÁT', '31 Võ Văn Vân-KP1-Tân Tạo, Q. TB, TPHCM', '0307653263', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(249, '331-141', 'CÔNG TY TNHH ONG ĐẤT VIỆT', '6G, Trần Não, P. Bình An, Q2, TPHCM', '030491918031', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(250, '331-142', 'DNTN XNK THÁI HƯNG', '89-91 Đường 30, P10, Q6, TPHCM', '0302686836', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(251, '331-143', 'CÔNG TY TNHH SX&MB HOÀN MỸ', '11/8 Tân Quý, P.Tân Quý, Q. Tân Phú', '0302309228', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(252, '331-144', 'CÔNG TY TNHH SX-TM LIÊN CƠ', '52A/ Đương 47, Tân Quy, Q7, TPHCM', '0302547060', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(253, '331-145', 'CÔNG TY CP TRÀ VIỆT', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(254, '331-146', 'NDTN GIÀY Á CHÂU', '41 Công Trường An Đông, P9, Q5. HCM', '0302057669', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(255, '331-147', 'Công Ty SX-TM Áo Mưa Hồng', '134/1 Bùi thị xuân- P. Phạm ngủ lão-Q1', '0303151505', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(256, '331-148', 'Cửa hàng giấy - văn phòng phẩm Trường Thịnh', 'Gian hàng số 1 chợ Phước bình Q9', '0301578323', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(257, '331-149', 'Công ty tnhh Điện Thành Vinh', '189 Tô Hiến Thành P-13. Q10', '0303612481', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(258, '331-150', 'Công ty tnhh thiết bị văn phòng Sao Mai', '66/13 Phổ Quang .P2.Quận TB.TPHCM', '0302342698', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(259, '331-151', 'Cơ Sở Băng keo Hiệp Phát', '1472/1 Ba Tơ, P7, Q8-TP.HCM', '0300589202-002', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(260, '331-152', 'Phan van chung', 'Ấp Đồng - Phước tân -Long Thành -ĐN', '3600660148', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29');
INSERT INTO `definition_list_subject` (`subject_id`, `subject_code`, `subject_name`, `subject_address`, `subject_tax_code`, `subject_contact_person`, `subject_telephone`, `subject_fax`, `currency_id`, `is_software_user`, `is_producer`, `is_supplier`, `is_customer`, `is_government`, `is_bank`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(261, '331-153', 'Công ty tnhh Quế Lâm', '57/47A Hậu Giang  F.11', '0302956560', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(262, '331-154', 'Cửa hàng Mẫn Đạt', '116 Hùng Vương . P9,Q5', '0300268657-003', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(263, '331-155', 'CÔNG TY TNHH SXTM XNK ĐẠI PHÁT', '221/2 ĐẶNG VĂN BI - P TRƯỜNG THỌ-Q. TD', '0308241079', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(264, '331-156', 'DNTN Minh Minh Phương', '1068/5 Kha Vạn Cân - P Linh Chiểu Q.TD -TPHCM', '0305065379', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(265, '331-157', 'Công ty cổ phần Việt Thương', '166/2 Lý Thái Tổ - P1- Q3', '01-01496401-001', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(266, '331-158', 'Công ty tnhh tmdv Sao Nam An', '21 Nguyễn Xuân Phụng-P2-Q6', '0303609778', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(267, '331-159', 'Công ty cổ phần TM-DV-SX Hương Thủy', '12 trần xuân hòa, P7, Q5, TP.HCM', '0304898593', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(268, '331-160', 'Công ty tnhh sx tm dv nhựa Tân Hiệp Hưng', '909 Đường 3/2-P.7 - Q11', '0301074781', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(269, '331-161', 'Công ty tnhh sx Nam việt', '51 Tôn thất thuyết  P.18, Q4 TPHCM', '0302203493', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(270, '331-162', 'Công ty tnhh tm dv siêu thị Bigc An Lạc', '1231 QL1A, Phường Bình Trị Đông B Quận Bình Tân, TPHCM', '0301472278', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(271, '331-163', 'Công ty tnhh Một Thành Viên Bến Nghé', '331 DE trần hưng đạo, p cô giang, Q1. tphcm', '0302382940', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(272, '331-164', 'CÔNG TY cổ phần xnk Nam Thái sơn', '934D3 Đường D- kcn cát lái . Q2 - tphcm', '0301482452', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(273, '331-165', 'Công ty cổ phần SX-TM Nhựa Hiệp Thành', '48-49-50 Bãi Sậy, P-1, Q.6', '0301343138', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(274, '331-166', 'Công ty tnhh Sao Thăng Long', '297/1 TÔ HIẾN THÀNH - P13- Q10', '0102284463-001', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(275, '331-167', 'Công ty tnhh sx Bảo Thạch', 'Ấp Lai Khê - Xã Lai Hưng - Bến Cát - Bình Dương', '0301400516', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(276, '331-168', 'Công ty tnhh sx-tm Bạch Kim', '131/89 Tô Hiến Thành P13, Q10 TPHCM', '0303528222', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(277, '331-169', 'Công ty tnhh tm-sx Phát Thành', '41 Đội Cung F11-Q11-TPHCM', '0301183004', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(278, '331-170', 'Công ty CP TM_ DV XEM SƠN', '126 Điện Biên Phủ .q1', '0301005756', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(279, '331-171', 'Công ty tnhh Huỳnh Minh Trí', '1080 Âu Cơ - P14 - Q. Tân Bình', '0309018676', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:29', 0, '2010-06-21 00:46:29'),
(280, '331-172', 'Công ty tnhh - Thương Mại Kim Liên', 'Tòa Nhà ETOWN2-364 Cộng Hòa, P13, Q.Tân Bình', '0301441174', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(281, '331-173', 'Nhà Sách Sơn Hà', '365 Nguyễn Thị Định, P Bình Trưng Tây - Q2', '0301383701', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(282, '331-174', 'Co.op mart Nguyễn Kiệm', '571-573 Nguyễn Kiệm Q.Phú Nhuận', '0305778394', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(283, '331-175', 'Công ty cổ phần Acecook Việt Nam', 'Lô II - 3, II - 5 Đường số 11, nhóm CN II, KCN TB, Q.Tân Phú, TP.HCM', '0300808687', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(284, '331-176', 'CÔNG TY TNHH SB ADHESIVE SPECIALIST VIỆT NAM', 'kCN Tam Phước, H.Long Thành, Đồng Nai', '3601047505', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(285, '331-177', 'Cty tnhh Quang Tiên', '311 Tô ngọc vân kp.2 -p Linh Đông -Q TD', '0303697911', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(286, '331-178', 'Công ty tnhh Yaho', '119 khu phố 17 Đường Bình Long, P Bình Hưng Hòa A, Q BT', '0302729215', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(287, '331-179', 'Công ty tnhh sx-tm Đồng Tiến Việt', '1/12 Tô Vĩnh Diện _ P.Linh Chiểu _Q.T Đ', '0305602979', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(288, '331-180', 'Công ty tnhh thương mại dịch vụ Trí Đức', '586 Điện Biên Phủ -p 1 - Quận 10', '0300884053', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(289, '331-181', 'Xí nghiệp dệt Hồng Quân', 'KM Phố Quang Trung thành phố Thái Bình', '1000214081', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(290, '331-182', 'Công ty tnhh một thành viên Cơ Bản', '5, KDC 6A Him Lam, Đường 11, xã Bình Hưng, H Bình Chánh_TPHCM', '0305895958', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(291, '331-183', 'Công ty CP TM_DV Quận 3', '158 Võ Văn Tần _Q3', '0301454021', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(292, '331-184', 'Công ty AJINOMOTO Việt Nam', 'KCN Biên Hòa.', '3600244645', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(293, '331-185', 'Công ty tnhh sxtm Ty Ty', '838 tỉnh lộ 43 -P Bình Chiểu -Q Thủ Đức', '0302543059', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(294, '331-186', 'Công ty Bình Tây', '110-112 Hậu Giang Q.6 tphcm', '0302562816', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(295, '331-187', 'Công ty tnhh DKSH Việt Nam', 'số 23, Đại Lộ Độc Lập, KCN Việt Nam - Singapore, huyện Thuận An, Tỉnh BD', '3700303206', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(296, '331-188', 'Công ty tnhh tmdv văn phòng phẩm Đức Trí', '812-814 Trần Hưng Đạo _ P.7_ Q.5', '0305687281', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(297, '331-189', 'Công ty CP Khóa Việt Tiệp', '20 Đường số 7, P11, Q6, TPHCM', '0100100537-002', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(298, '331-190', 'Công ty tnhh Cetus Việt Nam', 'Nguyễn Đình Chiểu P Đakao, Q1', '0303160002', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(299, '331-191', 'Công ty tnhh sx-xd-tm Rạng Đông S.P.CA', '21/3B thống nhất . P16-gv', '0302871476', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(300, '331-192', 'Công ty tnhh King Jim Việt Nam', 'D-4A-CN&D-4C-CN, KCN Mỹ Phước III, BC-BD', '3700789850', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(301, '331-193', 'Công ty CP TM_DV Tân Sinh Toa', '28 Đường 16, KDC Bình Phú , P11.Q6', '0302875008', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(302, '331-194', 'Công ty tnhh Điện Tử Sharp Việt Nam', '9 Đinh Tiên Hoàng, quận 1 HCM', '0308159258', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(303, '331-195', 'Công ty tnhh tm & dv Hoằng Nghiệp', '220 quốc lộ 13-P26-Q-BT- TPCHM.', '0304994995', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(304, '331-196', 'HTX_TM DV Phú Nhuận', '133A Trần Huy Liệu _F8-PN.', '0301427268.', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(305, '331-197', 'Cửa Hàng Châu.', '69 Phạm Ngũ Lão.', '0303747464', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(306, '331-198', 'Công ty tnhh Thảo nhiên', '116/874/1k Nguyễn Kiệm, P.3, Q. Gò Vấp, Tphcm', '0304004486', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(307, '331-199', 'Cửa hàng Lâm Đức Chiêu', 'Sạp 14 tổ 24, chợ Kim Biên', '0300356529-4', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(308, '331-200', 'DNTN. Hùng Ngọc Rạng Đông', '61/31 tổ 19 kp 1 P. Long Bình Tân, Biên Hòa, DN', '3601412606', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(309, '331-201', 'Công ty Taisho Việt Nam.', 'Quốc lộ 1A suối hiệp, Diên Khanh - khánh hòa.', '4200381102', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(310, '331-202', 'CÔNG TY TNHH TMDV TẤN LỢI PHÁT', '14 Hiền vương, p Hiệp Phú, Q9', '0307813157', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(311, '331-203', 'Công ty tnhh tm - dv Lạc Phát', '96/3A Võ Thành Trang - F11-Quận Tân Bình.', '0309278392.', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(312, '331-204', 'Công ty tnhh Sanyo.', 'số 2 st, Amata IP, Long Bình, BH, DN.', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, '2010-06-21 00:46:30', 0, '2010-06-21 00:46:30'),
(313, 'CUS_0000000158', 'CÔNG TY TNHH AKZO NOBEL COATINGS VIETNAM', 'Lô 107, KCN Amata, Biên Hòa, Đồng Nai', '0300850801', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:16', 0, '2010-06-21 00:48:26'),
(314, 'CUS_0000000078', 'VP BÁN VÉ CỦA HÃNG HÀNG KHÔNG ALL NIPPON AIRWAYS CO.,LTD TẠI TP.HCM', 'Lầu 16, Cao ốc SunWah Tower,115 Nguyễn Huệ, Quận 1, TP.HCM', '0306663526', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:16', 0, '2010-06-21 00:48:26'),
(315, 'CUS_0000000074', 'APEX AODAI TOUR DESK', '393B Trần Hưng Đạo, Q.1, TP. HCM', '0301210120001', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:16', 0, '2010-06-21 00:48:25'),
(316, 'CUS_0000000017', 'CÔNG TY LIÊN DOANH DU LỊCH APEX VIỆT NAM', '16 ngô Thời Nhiệm ,Phường 7 ,Q.3 ,TP HCM', '0301210120', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:16', 0, '2010-06-21 00:48:25'),
(317, 'CUS_0000000082', 'CÔNG TY TNHH ASIA PACIFIC SOLUTIONS', 'Phòng 1201, lầu 12, Sailing Tower, 111A Pasteur, P.Bến Nghé, Q.1', '0303639282', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:16', 0, '2010-06-21 00:48:26'),
(318, 'CUS_0000000161', 'CÔNG TY TNHH  THỰC PHẨM ASUZAC', 'Đường số 10, KCX Tân Thuận, Quận 7, Tp.HCM', '0300787620', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:16', 0, '2010-06-21 00:48:26'),
(319, 'CUS_0000000096', 'CÔNG TY BẢO HIỂM LIÊN HIỆP', 'R803 Sun Wah Tower, 115 Nguyen Hue, Dist.1, HCMC', '01001125710011', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:16', 0, '2010-06-21 00:48:21'),
(320, 'CUS_0000000014', 'CÔNG TY LIÊN DOANH TNHH BÔNG SEN YAMACHI', '99 Pasteur, Bến Nghé, Quận 1, TP. HCM', '0300582694', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:16', 0, '2010-06-21 00:48:25'),
(321, 'CUS_0000000163', 'CÔNG TY TNHH KHO NGẦM XĂNG DẦU DẦU KHÍ VIỆT NAM', 'KCN Dầu Khí Long Sơn ,Xã Long Sơn -TP Vũng Tàu ,Tỉnh Bà Rịa- Vũng Tàu', '3500889978', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:16', 0, '2010-06-21 00:48:26'),
(322, 'CUS_0000000162', 'CÔNG TY TNHH TÂN CHÂU BÌNH VINA', 'Số 1 Trương Đình Hợi, Phường 18, Quận 4, TP. HCM', '0305563705', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:16', 0, '2010-06-21 00:48:26'),
(323, 'CUS_0000000034', 'CETUS VIETNAM CO., LTD', '287 Huỳnh Văn Bánh, P.11, Q. Phú Nhuận, TP. HCM', '0303160002', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:16', 0, '2010-06-21 00:48:21'),
(324, 'CUS_0000000100', 'CHI NHÁNH CÔNG TY TNHH FUJITSU VIỆT NAM', 'Lầu 5, 163 Hai Bà Trưng, Q.3, TP. HCM', '0100851188001', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:16', 0, '2010-06-21 00:48:26'),
(325, 'CUS_0000000168', 'CÔNG TY TNHH DENTSU ALPHA', '65 Lê Lợi Sài Gòn Center Q1-TP HCM', '0303841026', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:16', 0, '2010-06-21 00:48:26'),
(326, 'CUS_0000000001', 'CÔNG TY CỔ PHẦN DREAM INCUBATOR VIỆT NAM', 'Sun Wah Tower,số 115 đường Nguyễn Huệ ,P. Bến Nghé, Q.1, TP.HCM', '0305223307', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:16', 0, '2010-06-21 00:48:25'),
(327, 'CUS_0000000033', 'CÔNG TY TNHH MEINAN (VIETNAM)', 'Lô 67 Đường 1 KCX Linh Trung 2, Bình Chiểu, Q.Thủ Đức, TP.HCM', '0302602610', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:16', 0, '2010-06-21 00:48:25'),
(328, 'CUS_0000000039', 'CÔNG TY TNHH MOVINA', 'Lô B3 đường 15A, KCX Loteco, Long Bình, Biên Hòa, Đồng Nai', '3600727120', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:16', 0, '2010-06-21 00:48:22'),
(329, 'CUS_0000000099', 'NIDEC COPAL (VIETNAM) CO., LTD', 'Đường 18, KCX Tân Thuận, P. Tân Thuận Đông, Q.7, TP. HCM', '0301581728', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:16', 0, '2010-06-21 00:48:22'),
(330, 'CUS_0000000060', 'CÔNG TY TNHH NIDEC SANKYO VIỆT NAM', 'Lô I1-N1 Khu công nghệ cao, Q. 9, TP. HCM', '0303826116', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:16', 0, '2010-06-21 00:48:22'),
(331, 'CUS_0000000134', 'CÔNG TY TNHH NIDEC SERVO VIỆT NAM', 'Lô I1.3-N1, Khu công nghệ cao, Q.9, TP. HCM', '0305399558', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:16', 0, '2010-06-21 00:48:22'),
(332, 'CUS_0000000173', 'CÔNG TY TNHH NIDEC TOSOK VIỆT NAM', 'Đường số 16, KCX Tân Thuận, P. Tân Thuận Đông, Q. 7, TP. HCM', '0301471355', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:16', 0, '2010-06-21 00:48:22'),
(333, 'CUS_0000000130', 'CÔNG TY TNHH NIDEC VIETNAM CORPORATION', 'LÔ I1 - N2 KHU CÔNG NGHỆ CAO, Q.9, TP.HCM', '0304227309', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:16', 0, '2010-06-21 00:48:22'),
(334, 'CUS_0000000112', 'CÔNG TY TNHH OLYMPUS VIỆT NAM', 'KCN Long Thành, huyện Long Thành, Đồng Nai', '3600939069', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:16', 0, '2010-06-21 00:48:22'),
(335, 'CUS_0000000007', 'CÔNG TY TNHH RICCO VIET NAM', 'Lô 74, Đường C KCX Linh Trung 2, P.Bình Chiểu, Q.Thủ Đức, TP.HCM', '0303006988', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:16', 0, '2010-06-21 00:48:25'),
(336, 'CUS_0000000164', 'CÔNG TY TNHH SHISEIDO VIỆT NAM', 'KCN Amata, P.Long Bình, Biên Hòa, Đồng Nai', '3600994768', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:16', 0, '2010-06-21 00:48:26'),
(337, 'CUS_0000000038', 'CÔNG TY TNHH TAKAKO VIỆT NAM', '27 Đại Lộ Độc Lập, VSIP, Thuận An, Bình Dương', '3700483421', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:16', 0, '2010-06-21 00:48:22'),
(338, 'CUS_0000000056', 'CÔNG TY TNHH FIGLA VIỆT NAM', 'Lô 109/1 đường Amata, KCN Amata, Biên Hòa, Đồng Nai', '3600515662', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:16', 0, '2010-06-21 00:48:22'),
(339, 'CUS_0000000114', 'CÔNG TY TNHH FIVE STAR SOLUTIONS VIET NAM', '2A-4A Tôn Đức Thắng , Quận 1, TP.HCM', '0303520921', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:16', 0, '2010-06-21 00:48:26'),
(340, 'CUS_0000000021', 'CÔNG TY TNHH FLAGSHIP VIETNAM', '2 Bis 4-6 Lê Thánh Tôn, Quận 1,Tp.HCM', '0305543508', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:16', 0, '2010-06-21 00:48:25'),
(341, 'CUS_0000000010', 'CÔNG TY TNHH GIA CÔNG KIM LOẠI SÀI GÒN', 'Lô 72A, đường số 1, KCX Linh Trung II, Q. Thủ Đức, TP. HCM', '0304371020', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:25'),
(342, 'CUS_0000000085', 'CÔNG TY TNHH CÔNG NGHỆ TECHNOPRO VIỆT NAM', 'Tòa Nhà Etown , P 8.9, 8.10,Tầng 8 ,364 Cộng Hòa Phường13, QTân Bình TP-HCM', '3600673394', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:26'),
(343, 'CUS_0000000154', 'CÔNG TY TNHH TM - DV HẢO VỌNG', '185 (Trệt) Cô Giang, Phường Cô Giang, Quận 1, Tp.HCM', '0303374389', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:26'),
(344, 'CUS_0000000115', 'HIỆP HỘI DOANH NGHIỆP NHẬT BẢN TẠI TP. HỒ CHÍ MINH', 'Phòng 1407, lầu 14, Tòa nhà Sun Wah, 115 Nguyễn Huệ, Q.1', 'Không có MST', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:26'),
(345, 'CUS_0000000172', 'CÔNG TY TNHH HIỆP PHÁT', 'Lô B3-B22, Đường số 9, KCN Lê Minh Xuân, Bình Chánh', '0302649626', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:26'),
(346, 'CUS_0000000167', 'CÔNG TY TNHH I AND COM', 'Tòa nhà JVPE, CVPM Quang Trung, P.Tân Chánh Hiệp, Q.12, Tp Hồ Chí Minh', '0304339676', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:26'),
(347, 'CUS_0000000031', 'CÔNG TY TNHH IWASAKI ELECTRIC VIỆT NAM', 'Lô 73, đường số 1, KCX Linh Trung II, P. Bình Chiểu, Q. Thủ Đức, TP. HCM', '0302724344', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:25'),
(348, 'CUS_0000000143', 'CÔNG TY TNHH JAPAN ASIA INVESTMENT', 'Phòng B 501, Số  2 Thi Sách , Phường Bến Nghé, Q 1,TP.HCM', '0305667750', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:26'),
(349, 'CUS_0000000159', 'VPDĐ FUJITA CORPORATION', '65 Nguyễn Du, Lầu 8, Quận 1', '0', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:26'),
(350, 'CUS_0000000084', 'VPĐD JETRO', 'Tầng 14.,Tòa Nhà  Sun Wah , 115 Nguyễn Huệ,Q.1, TP.HCM', 'VPDD ko có MST', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:26'),
(351, 'CUS_0000000128', 'CÔNG TY TNHH KINTETSU WORLD EXPRESS VIỆT NAM', '76 Yên Thế, P.2, Q. Tân Bình, TP. HCM', '0303721875', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:26'),
(352, 'CUS_0000000186', 'CÔNG TY LD TNHH NIPPON EXPRESS VIỆT NAM', 'P5.3,Tòa nhà E-Town I, 364 Cộng Hòa, P13, Q.Tân Bình', '0302065148', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:26'),
(353, 'CUS_0000000077', 'CÔNG TY TNHH KỸ THUẬT SHINSEI VIỆT NAM', '384 Đường Hoàng Diệu Phường 6, Quận 4, TP.HCM', '0305245484', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:26'),
(354, 'CUS_0000000012', 'VPĐD  KANEMATSU', 'P1809,Lầu 18,37 Tôn đức thắng ,Quận 1,TP HCM', '0', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:25'),
(355, 'CUS_0000000127', 'CN CTLD VT HH VIỆT NHẬT SỐ 2 (LOGITEM VIETNAM)', 'Lô 87, KCX Linh Trung II, P.Bình Chiểu,Thủ Đức, Tp.HCM', '0100113582002', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:22'),
(356, 'CUS_0000000416', 'CÔNG TY TNHH TM ĐỊA DƯỠNG', '8/2 ấp Bình Đáng, xã Bình Hòa, Thuận An, Bình Dương', '0303335911', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:21'),
(357, 'CUS_0000000105', 'CÔNG TY CỔ PHẦN MAI THÀNH', '28 Mạc Đĩnh Chi, P. Đa Kao, Quận 1, TP. HCM', '0302481194', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:26'),
(358, 'CUS_0000000019', 'CÔNG TY TNHH TM - SX HOÀNG NHẬT VŨ', 'Số 9, Lô A2-A3 đường D2, P. 25, Q. Bình Thạnh, TP. HCM', '0303753813', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:22'),
(359, 'CUS_0000000147', 'CÔNG TY TNHH MASS TRADING VIET NAM', 'Số 2,Phùng Khắc khoan ,Phường ĐaKao ,Q.1,TP.HCM', '0305797541', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:26'),
(360, 'CUS_0000000018', 'CÔNG TY TNHH BẢO HIỂM PHI NHÂN THỌ MSIG VIỆT NAM - CHI NHÁNH TP.HCM', 'Phòng 2B&3, tầng 6, Sài Gòn Centre, 65 Lê Lợi, Phường Bến Nghé, Quận 1, TP. HCM', '0102973336-001', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:25'),
(361, 'CUS_0000000175', 'CÔNG TY TNHH MOL LOGISTICS VIỆT NAM', 'Cao ốc E-Town, 364 đường Cộng Hòa, Tân Bình', '0304047345', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:22'),
(362, 'CUS_0000000116', 'SAKAI CHEMICAL (VIETNAM) CO., LTD.', 'Lot B - 1A - CN, My Phuoc Industrial Park 3, Ben Cat Dist., Binh Duong', '3700857677', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:17'),
(363, 'CUS_0000000087', 'CÔNG TY TNHH MỘT THÀNH VIÊN I.M.LINK VIỆT NAM', '40-42 Phan Bội Châu, P.Bến Thành, Q.1,TP.HCM', '0304927967', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:26'),
(364, 'CUS_0000000160', 'CÔNG TY TNHH NIDEC SERVO VIỆT NAM', 'Lô I1.3-N1, Khu Công Nghệ Cao, Quận 9.', '305399558', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:22'),
(365, 'CUS_0000000176', 'CÔNG TY TNHH NIDEC SANKYO VIỆT NAM', 'Lô I1-N1 Khu công nghệ cao, Q. 9, TP. HCM', '0303826116', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:22'),
(366, 'CUS_0000000180', 'Kim Nga', '0', '', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:22'),
(367, 'CUS_0000000068', 'CÔNG TY CỔ PHẦN NHẬT VIỆT TINH', '23 Tôn Đức Thắng ,Phường Bến Nghé ,Quận 1, TP.HCM', '0303852518', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:25'),
(368, 'CUS_0000000171', 'NISSHO PRECISION VIỆT NAM CO., LTD', '6A Đường 3, VSIP, Thuận An, Bình Dương', '3700875644', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:22'),
(369, 'CUS_0000000079', 'CÔNG TY TNHH THÔNG TIN  NTT VIỆT NAM', 'Tòa nhà Sailing Tower, số 51 đường Nguyễn Thị Minh Khai, Quận 1, TP. Hồ Chí Minh', '0302534921', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:26'),
(370, 'CUS_0000000073', 'CÔNG TY OBAYASHI VIỆT NAM', 'Saigon Trade Center, Unit 1906, 37 Tôn Đức Thắng ,Q.1,TP.HCM', '0304436870', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:25'),
(371, 'CUS_0000000070', 'CÔNG TY TNHH PHẦN MỀM TỐC ĐỘ VĂN HÓA', '140 Cô Bắc,P.Cô Giang ,Quận 1, TP.HCM', '0304683365', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:25'),
(372, 'CUS_0000000133', 'CÔNG TY TNHH TM - DV PHÁT VIỆT', '247bis Huỳnh Văn Bánh, P.12, Q. Phú Nhuận, TP. HCM', '0302314475', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:26'),
(373, 'CUS_0000000016', 'CÔNG TY PHOTOM', '75 Huỳnh Thúc Kháng, P. Bến Nghé, Q.1, TP. HCM', '', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:22'),
(374, 'CUS_0000000131', 'CÔNG TY TNHH RICCO VIET NAM', 'Lot 74,Road C,Linh Trung Export Processing Zone No.2,Binh Chieu', '0303006988', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:22'),
(375, 'CUS_0000000075', 'ROHTO-MENTHOLATUM (VIETNAM) CO., LTD.', '18th floor, Saigon Trade Center, 37 Ton Duc Thang St., Dist. 1, HCMC', '3700239769001', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:17', 0, '2010-06-21 00:48:25'),
(376, 'CUS_0000000027', 'VPĐD SANYU PAINT', '99 Pasteur, P. Bến Nghé, Q1, TP. HCM', '', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:25'),
(377, 'CUS_0000000042', 'CÔNG TY TNHH SCS (VIỆT NAM) - CHI NHÁNH TP. HCM', '115 Nguyễn Huệ, Q. 1, TP. HCM', '0101407070001', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:25'),
(378, 'CUS_0000000063', 'CÔNG TY TNHH SECOM VIỆT NAM', '#1109, lầu 11 Zen Plaza, 54-56 Nguyễn Trãi, Q.1, TP. HCM', '0304183281', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:25'),
(379, 'CUS_0000000151', 'SKETCH DIVISION', 'Lầu 7, 393B Trần Hưng Đạo, Q.1, TP. HCM', '', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:22'),
(380, 'CUS_0000000061', 'SUMITOMO MITSUI BANKING CORPORATION - CN TP. HCM', 'Lầu 9 The Landmark, 5B Tôn Đức Thắng, Q. 1, TP. HCM', '0304198827', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:25'),
(381, 'CUS_0000000108', 'SUN WAH PROPERTIES (VIETNAM) JOINT STOCK COMPANY', '115 Nguyen Hue, District 1, Ho Chi Minh City', '0300762016', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:26'),
(382, 'CUS_0000000036', 'CÔNG TY TNHH TAISHO VIETNAM', 'QL 1A Suối Hiệp, huyện Diên Khánh, Khánh Hòa', '4200381102', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:25'),
(383, 'CUS_0000000152', 'CÔNG TY CỔ PHẦN THĂNG TIẾN', '29 Lê Thánh Tôn , Phường Bến Nghé, Quận 1, TPHCM', '0304930575', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:26'),
(384, 'CUS_0000000025', 'THE JAPANESE SCHOOL IN HO CHI MINH CITY', 'Khu đô thị Nam Sài Gòn, Lô M9, Đường Tân Phú, P. Tân Phú, Q.7, TP. HCM', 'Không có MST', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:25'),
(385, 'CUS_0000000043', 'CÔNG TY TNHH ẮC QUY GS VIỆT NAM', '18, Đường 3 VSIP , Thuận An , Bình Dương', '3700255457', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:22'),
(386, 'CUS_0000000020', 'CÔNG TY TNHH MỘT THÀNH VIÊN TÓC ĐỈNH CAO', '96 Nam Kỳ Khởi Nghĩa, Q.1, TP. HCM', '0305212009', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:25'),
(387, 'CUS_0000000088', 'CÔNG TY CỔ PHẦN TRÚC QUANG', 'P502 lầu 5, Số 2 Thi Sách, P. Bến Nghé, Q.1, TP. HCM', '0303321066', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:26'),
(388, 'CUS_0000000054', 'Trung tâm dạy nghề tư thục Tường Minh', 'Số 10, Đặng Văn Ngữ, P. 10, Q. Phú Nhuận, TP. HCM', '0305589319', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:25'),
(389, 'CUS_0000000066', 'CÔNG TY TNHH UCHIHASHI VIET NAM', 'Số 23  Đường số 4 ,  VSIP II , Bến cát  , Bình Dương', '3700781611', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:25'),
(390, 'CUS_0000000139', 'CÔNG TY TNHH TRUNG TÂM ĐỒ HỌA VI TÍNH KIKUKAWA', 'Số 2 Thi Sách, P. Bến Nghé, Quận 1, TP. HCM', '0305263476', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:26'),
(391, 'CUS_0000000035', 'CÔNG TY CỔ PHẦN VIỄN THÔNG TÂN TẠO', 'Lô 16 , đường số 2 , KCN Tân tạo, Quận Bình Tân, TP.HCM', '0305246488', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:25'),
(392, 'CUS_0000000111', 'VPĐD CÔNG TY U-TECH', 'Phòng 15, số 23 Phùng Khắc Khoan, P. Đakao, Q.1, TP. HCM', '0305746018', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:26'),
(393, 'CUS_0000000095', 'VPĐH NHÀ THẦU EBARA CORP (GÓI THẦU E)', 'Xã Bình Hưng, Huyện Bình Chánh, TP.HCM', '0303765914', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:26'),
(394, 'CUS_0000000015', 'VPĐD KONOIKE TRANSPORT CO., LTD', '203 Đồng Khởi, Lầu 1, Phòng 103, Q.1, TP. HCM', '0304647695', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:25'),
(395, 'CUS_0000000138', 'CÔNG TY TNHH ABE INDUSTRIAL VN', '28 Đường số 1 , KCN VSIP II , Bến Cát , BD', '3700775907', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:23'),
(396, 'CUS_0000000013', 'CÔNG TY TNHH ẮC QUY GS VIỆT NAM', '18, Đường 3 VSIP , Thuận An , Bình Dương', '3700255457', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:23'),
(397, 'CUS_0000000026', 'CÔNG TY TNHH ASUZAC', 'Số 1, đường số 8, KCN Việt Nam - Singapore, Thuận An, Bình Dương', '0302232712', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:23'),
(398, 'CUS_0000000064', 'CÔNG TY TNHH TIẾP VẬN THĂNG LONG - CN HỒ CHÍ MINH', '1A Công trường Mê Linh, Q. 1, TP. HCM', '0100112691-002', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:23'),
(399, 'CUS_0000000170', 'CÔNG TY TNHH SAIGON STEC', 'Số 7 VSIP II Đường số 7, KCN Việt Nam- Singapore II, Bến Cát, Bình Dương', '3700830717', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:23'),
(400, 'CUS_0000000057', 'CÔNG TY DUTCH LADY VN (FRIESLANDCAMPINA VIETNAM)', 'Bình Hòa, Thuận An, Bình Dương', '3700229344', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:23'),
(401, 'CUS_0000000092', 'CÔNG TY TNHH AIPHONE COMMUNICATIONS (VIỆT NAM)', 'P.12 Số 8 Đại Lộ Hữu Nghị, KCN VSIP I, Thuận An, Bình Dương', '3700838473', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:23'),
(402, 'CUS_0000000120', 'CÔNG TY TNHH BIC JAPAN', '30A Đại lộ Tự Do, VSIP, Thuận An, Bình Dương', '3700658086', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:23'),
(403, 'CUS_0000000169', 'CÔNG TY TNHH KANETSU VIỆT NAM', 'P205, Số 2 Thi Sách, P.Bến Nghé, Quận 1,TP. HCM', '0309127040', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:26'),
(404, 'CUS_0000000118', 'CÔNG TY TNHH HI-TECH WIRES ASIA', '46 Đường số 6, KCN VSIP 1, Thuận An, Bình Dương', '3700773000', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:23'),
(405, 'CUS_0000000011', 'CÔNG TY TNHH HOYA LENS VIỆT NAM', 'No.20, VSIP II,DUONG 4, VSIP II, Ben Cat Dist., Binh Duong', '3700778993', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:23'),
(406, 'CUS_0000000126', 'CONSULATE GENERAL OF JAPAN AT HỒ CHÍ MINH city', '13-17 nguyễn huệ Q1.TP HCM', '', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:26'),
(407, 'CUS_0000000149', 'CÔNG TY TNHH SHOWA GLOVES VIỆT N', '23 Đại lộ tự do, KCN VSIP I , Thuận An , Bình Dương', '3700522790', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:23'),
(408, 'CUS_0000000090', 'TOKYO ROPE VIETNAM CO., LTD', '30 VSIP Street 3, VSIP II, Bến Cát, Bình Dương', '3700716940', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:23'),
(409, 'CUS_0000000148', 'CÔNG TY TNHH ĐIỆN TỬ FOSTER ( VIỆTNAM )', 'SỐ 6A đường số 6,VSIP, Thuận An – Bình Dương', '3700689599', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:23'),
(410, 'CUS_0000000150', 'CÔNG TY TNHH ĐIỆN TỬ FOSTER ( VIỆTNAM )', 'SỐ 6A đường số 6,VSIP, Thuận An – Bình Dương', '3700689599', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:23'),
(411, 'CUS_0000000048', 'CÔNG TY TNHH KASUGA ELECTRIC VIET NAM', '36 VSIP II , Đường số 1 , KCN VN - SINGAPORE , BD', '3700868904', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:23'),
(412, 'CUS_0000000141', 'CÔNG TY TNHH  KING JIM ( VIET NAM )', 'Lô D- 4A- CN & D4C-CN , Đường NE8B, KCN Mỵ Phước 3, Bến cát , BD', '3700789850', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:23'),
(413, 'CUS_0000000140', 'CÔNG TY TNHH KOBE EM&N VIETNAM', 'Số 6 đường 2A, KCN Biên Hòa 2, Biên Hòa, Đồng Nai', '3600254499', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:23'),
(414, 'CUS_0000000178', 'CÔNG TY TNHH  MARUHA CHEMICAL VIET NAM', 'Số 56 , Đường 1 , vsip 2 , Bến Cát , Bình Dương', '3700803544', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:23'),
(415, 'CUS_0000000032', 'OHMORI VIETNAM CO., LTD', '50 VSIP II, Đường dân Chủ, VSIPII, Bến Cát , Bình Dương', '3700780992', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:23'),
(416, 'CUS_0000000089', 'CÔNG TY TNHH OMRON HEALTHCARE  MANUFACTURING VIỆT NAM', 'SỐ 28 , ĐƯỜNG SỐ 2 , KHU CÔNG NGHIỆP VIỆT NAM - SINGpore II - BẾN CÁT - BÌNH DƯƠNG', '3700785542', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:23'),
(417, 'CUS_0000000002', 'CÔNG TY TNHH PEACE VINA', '1/182 Hòa Lân - Thuận Giao - Thuận An - BD', '3700446719', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:23'),
(418, 'CUS_0000000093', 'CÔNG TY TNHH PERSTIMA VN', 'Số 15, đường số 6, KCN Vietnam Singapore, Thuận An, Bình Dương', '3700444535', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:23'),
(419, 'CUS_0000000051', 'CÔNG TY TNHH RINNAI VIETNAM', 'KCN Đồng An, Thuận An, Bình Dương', '3700300974', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:18', 0, '2010-06-21 00:48:23'),
(420, 'CUS_0000000040', 'SEIWA KAIUN VIETNAM CO., LTD', 'Số 8 đường 22, KCN Sóng Thần 2, Dĩ An, Bình Dương', '3700736369', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:23'),
(421, 'CUS_0000000041', 'CÔNG TY TNHH SUNMORE VIỆT NAM', 'ấp Đông Chiêu, xã Tân Đông Hiệp, Dĩ An, Bình Dương', '3700850537', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:23'),
(422, 'CUS_0000000037', 'CÔNG TY TNHH VIỆT NAM SUCCESS', 'Đường Số 1 KCN Đồng An, Thuận An, Bình Dương', '3700703525', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:23'),
(423, 'CUS_0000000123', 'CÔNG TY TNHH VINA SHOWA', '23 Đại lộ tự do, VSIP I , Thuận An , Bình Dương', '3700483887', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:23'),
(424, 'CUS_0000000030', 'YAZAKI EDS VIETNAM CO., LTD', 'Dĩ An, Bình Dương', '3700230036', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:23'),
(425, 'CUS_0000000107', 'CÔNG TY TNHH AKZO NOBEL COATINGS VIET NAM', 'Lô 107- KCN Amata- Biên Hòa, Đồng Nai', '0300850801', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:23'),
(426, 'CUS_0000000155', 'CÔNG TY TNHH CAMPLAS MOULD VIỆT NAM', '222/2 Đường số 4, KCN Amata, Biên Hòa, Đồng Nai', '3600918132', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:23'),
(427, 'CUS_0000000137', 'CÔNG TY TNHH VIETNAM MEI WA', 'Số 1, Đường 15A, KCN Biên Hòa II, Biên Hòa, Đồng Nai', '3600401760', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:23'),
(428, 'CUS_0000000071', 'CÔNG TY TNHH SẢN PHẨM MÁY TÍNH FUJITSU VIỆT NAM,', 'Số 31, đường 3A, KCN Biên Hòa II, Đồng Nai', '3600240030', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:23'),
(429, 'CUS_0000000177', 'CÔNG Y TNHH FUKUYAMA GOSEI VIỆT NAM', '122 KCN AMATA , TP BIEN HOA , DONG NAI', '3600552086', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:23'),
(430, 'CUS_0000000153', 'CÔNG TY TNHH  CÔNG NGHIỆP HUNG YIH VIET NAM', 'Số 7 , Đường 1A , KCN Biên Hòa II , ĐN', '3600458894', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:23'),
(431, 'CUS_0000000104', 'CÔNG TY TNHH CƠ KHÍ  KAO MENG', 'KCN Amata, P. Long Bình, Biên Hòa, Đồng Nai', '3600481734', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:23'),
(432, 'CUS_0000000156', 'CÔNG TY TNHH  INDOCHINE ENGINEERING VIEÄT NAM - (MS.XUYÊN NOK)', '203 Ñoàng Khôûi, Quaän 1, Tp. HCM', '0303958553', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:23'),
(433, 'CUS_0000000157', 'NEC LOGISTICS HONG KONG', 'Phòng 2.11 , SỐ 1 , ĐƯỜNG 3A, TÒA NHÀ  SONADERI KHU CÔNG NGHIỆP BH 2,TP BIÊN HÒA ,DN', 'VPDD KMST', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:23'),
(434, 'CUS_0000000146', 'CÔNG TY TNHH NHỰA SAKAGUCHI VIỆT NAM', '105/1 KCN AMATA , PHƯỜNG LONG BÌNH ,  ĐỒNG NAI', '3600711392', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:23'),
(435, 'CUS_0000000129', 'CÔNG TY CỔ PHẦN FURNIWEB', 'LÔ D - 8.2, KCN LONG BÌNH, BIÊN HÒA, ĐỒNG NAI', '', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:23'),
(436, 'CUS_0000000024', 'CÔNG TY SANYO DI SOLUTIONS VIỆT NAM', 'Số 10 đường 17A, KCN Biên Hòa 2, Đồng Nai', '3600692936', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:23'),
(437, 'CUS_0000000113', 'CÔNG TY TNHH TIẾP VẬN THĂNG LONG - CN HỒ CHÍ MINH', '1A Công trường Mê Linh, Quận 1, TP. HCM', '0100112691002', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:26'),
(438, 'CUS_0000000065', 'CÔNG TY TNHH VIỆT NAM SUZUKI', 'Đường số 2, KCN Long Bình, Biên Hòa, Đồng Nai', '3600244035', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:23'),
(439, 'CUS_0000000136', 'CÔNG TY TNHH YP REX VIỆT NAM', 'Lô 222 , đường số 4 , KCN Amata, Biên Hòa , Đồng Nai', '3600713600', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:23'),
(440, 'CUS_0000000081', 'CÔNG TY AJINOMOTO VIỆT NAM', 'Khu công nghiệp Biên Hòa I, Đồng Nai', '3600244645', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:23'),
(441, 'CUS_0000000005', 'CÔNG TY TNHH ARAI VIỆT NAM', 'Lô 101/1-3, KCN Amata ,P. Long Binh ,TP. Bien Hoa , Dong Nai.', '3600512608', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:23'),
(442, 'CUS_0000000003', 'CÔNG TY TNHH CÔNG NGHIỆP PLUS VIỆT NAM', 'Số 3, Đường 1A, KCN Biên Hòa 2, Biên Hòa, Đồng Nai', '3600256520', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:23'),
(443, 'CUS_0000000006', 'CÔNG TY TNHH WATABE WEDDING VIỆT NAM', 'LÔ 200 KCN Amata, Biên Hòa, Đồng Nai', '3600753931', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:23'),
(444, 'CUS_0000000106', 'CÔNG TY TNHH ARTUS VIỆT NAM PACIFIC SCIENTIFIC', 'Số 7, đường 16A, KCN Biên Hòa 2, Đồng Nai', '3600242246', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:23'),
(445, 'CUS_0000000142', 'CÔNG TY TNHH EMERALD BLUE VIỆT NAM', 'Lô 105 , KCN AMATA , LONG BÌNH, BIÊN HÒA , ĐN', '3600666693', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:23'),
(446, 'CUS_0000000053', 'CÔNG TY MABUCHI MOTOR VN', 'số 2 Đường5A , KCN Biên Hoà II, Đồng  Nai', '3600240707', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:23'),
(447, 'CUS_0000000119', 'CÔNG TY TNHH MATSUYA R&D (VIỆT NAM)', '101/2-7 đường 3B, KCN Amata, Biên Hòa, Đồng Nai', '3601000200', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:23'),
(448, 'CUS_0000000103', 'CÔNG TY NEC-TOKIN ELECTRONICS VIỆT NAM', 'Lô A5-A6 KCX Long Bình, Biên Hòa, Đồng Nai', '3600242574', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:23'),
(449, 'CUS_0000000110', 'CÔNG TY TNHH SAKAI CIRCUIT DEVICE VIỆT NAM', 'Lô D - 8.2, KCN Long Bình, Biên Hòa, Đồng Nai', '3600805869', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:23'),
(450, 'CUS_0000000045', 'CÔNG TY TNHH SHIRAI VIETNAM', 'Lô 218, KCN  Amata , P.Long Bình, Biên Hòa, Đồng Nai', '3600816236', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:24'),
(451, 'CUS_0000000135', 'CÔNG TY TNHH SOLNO ENTERPRISES VIỆT NAM', 'Lô 101/2-6, đường 3B, KCN Amata, P. Long Bình, Biên Hòa, Đồng Nai', '3600637692', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:24'),
(452, 'CUS_0000000050', 'CÔNG TY TNHH VIỆT NAM  MEI WA', 'Số 1, Đường 15A, KCN Biên Hòa II, Biên Hòa, Đồng Nai', '3600401760', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:24'),
(453, 'CUS_0000000046', 'CÔNG TY TNHH  VINA MELT TECHNOS', 'Lô 101/1-1 KCN Amata, Long Bình, Biên Hòa, Đồng Nai', '3600731141', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:24'),
(454, 'CUS_0000000098', 'CÔNG TY TNHH GAS VIỆT NHẬT', 'Số 33 đường 3A, KCN Biên Hòa II, Biên Hòa, Đồng Nai', '3600258422', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:24'),
(455, 'CUS_0000000067', 'CÔNG TY TNHH HÓA CHẤT & MÔI TRƯỜNG AUREOLE MITANI', 'Lô D4-1 KCN Long Bình, Biên Hòa, Đồng Nai', '3600241718', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:24'),
(456, 'CUS_0000000072', 'CÔNG TY TNHH HÓA CHẤT WASHIN VIỆT NAM', 'Lô 122/1 đường Amata, KCN Amata, Biên Hòa, Đồng Nai', '3600728621', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:24'),
(457, 'CUS_0000000059', 'CÔNG TY TNHH KAO VIỆT NAM', 'A12 KCN Amata, Biên Hòa, Đồng Nai', '3600246811', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:24'),
(458, 'CUS_0000000049', 'CÔNG TY TNHH KỸ THUẬT MURO VIỆT NAM', 'Lô 207, KCN Amata, P. Long Bình, Biên Hòa, Đồng Nai', '3600725250', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:19', 0, '2010-06-21 00:48:24'),
(459, 'CUS_0000000047', 'CÔNG TY TNHH MAGX VIỆT NAM', 'Lô 114  KCN Amata ,Biên Hoà, Đồng Nai', '3600487239', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:24'),
(460, 'CUS_0000000145', 'CÔNG TY TNHH  MUTO VIET NAM', 'Số 02- Đường 9A , KCN Biên Hòa II, Đồng Nai', '3600253061', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:24'),
(461, 'CUS_0000000022', 'CÔNG TY TNHH NICCA VIỆT NAM', '224 / 6 ĐƯỜNG 2 , KCN AMATA , BIÊN HÒA , ĐỒNG NAI', '3600681571', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:24'),
(462, 'CUS_0000000062', 'CÔNG TY TNHH NIKKO VIỆT NAM', 'Lô 101/2-5, Đường 3B, KCN Amata, P.Long Binh, Biên Hoà, Đồng Nai', '3600952334', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:24'),
(463, 'CUS_0000000044', 'CÔNG TY TNHH OKAMOTO VIỆT NAM', '105/2, KCN Amata, Biên Hòa, Đồng Nai', '3600666686', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:24'),
(464, 'CUS_0000000122', 'CÔNG TY TNHH SAMSUN VIỆT NAM', 'Số 9, Đường 16A, KCN Biên Hòa II, Đồng Nai', '3600370960', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:24'),
(465, 'CUS_0000000183', 'HONDA METAL INDUSTRIES VIETNAM', '31 Đại lộ Tự Do, VSIP, Thuận An, Bình Dương', '3700631084', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:24'),
(466, 'CUS_0000000008', 'CÔNG TY TNHH SANKO MOLD VIETNAM', 'Lô 116/1 KCN Amata ,Long Bình ,Biên Hòa ,Đồng Nai', '3600470683', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:24'),
(467, 'CUS_0000000080', 'CÔNG TY SANYO HA ASEAN', 'Số 8, Đường 17A,KCN Bien Hoa II, Bien Hoa, Dong Nai', '3600257517', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:24'),
(468, 'CUS_0000000069', 'CÔNG TY THHH SUNDAT CROP SCIENCE', 'Lô 101/8, Đường 1,KCN Amata, Biên Hòa, Đồng Nai', '3600744895', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:24'),
(469, 'CUS_0000000009', 'CÔNG TY TNHH TIẾP VẬN THĂNG LONG - CHI NHÁNH ĐỒNG NAI', 'Lô 101 Đường Amata, KCN Amata, Biên Hòa, Đồng Nai', '0100112691003', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:24'),
(470, 'CUS_0000000109', 'CÔNG TY TNHH UNITEK ENTERPRISE', 'Lô C8, KCN Loteco, Biên Hòa, Đồng Nai', '3600696715', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:24'),
(471, 'CUS_0000000058', 'CÔNG TY TNHH YAMATO PROTEC VIET NAM', '', '3700483439', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:24'),
(472, 'CUS_0000000052', 'CÔNG TY TNHH VIỆT NAM SHINE', '104/2-5, 4-2 Đường Amata, KCN Amata, P.Long Bình, Biên Hòa, Đồng Nai', '3600644900', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:24'),
(473, 'CUS_0000000076', 'CÔNG TY TNHH VINAPOLY', 'Số 2, đường 10A, KCN Biên Hòa II, Biên Hòa, Đồng Nai', '3600232833', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:24'),
(474, 'CUS_0000000055', 'CÔNG TY TNHH YKK VIETNAM', '104-106-108 KCN Amata, Biên Hòa, Đồng Nai', '3600255100001', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:24'),
(475, 'CUS_0000000188', 'Bán Lẻ', '0', '', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:26'),
(476, 'CUS_0000000189', 'Bán Lẻ', '', '', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:20'),
(477, 'CUS_0000000182', 'CHINA SOUTHERN AIRLINES', '21-23 Nguyễn Thị Minh Khai, P. Bến nghé, Quận 1, Tp.HCM', '0303794136', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:26'),
(478, 'CUS_0000000185', 'CÔNG TY TNHH MASS TRADING VIET NAM', 'Tầng 6, LTA Building, Số 15 Đống Đa, Q. Tân Bình, TP. HCM', '0305797541', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:24'),
(479, 'CUS_0000000181', 'YAZAKI EDS VIETNAM CO., LTD', 'Dĩ An, Bình Dương', '3700230036', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:24'),
(480, 'CUS_0000000190', 'MS.DUNG ( MAGX )', 'Lô 114 Khu Công Nghiệp Amata ,Bien Hoa City, Dong Nai', '', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:24'),
(481, 'CUS_0000000191', '', '', 'Bán Lẻ', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:20'),
(482, 'CUS_0000000192', 'CÔNG TY TNHH SHINPOONG DAEWOO', '13 ĐƯỜNG BIÊN HÒA , KCN BIÊN HÒA II , DN', '', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:24'),
(483, 'CUS_0000000193', 'CÔNG TY TNHH DID ELECTRONICS VIỆT NAM', 'Lô 47B, KCX Linh Trung 2, P. Bình Chiểu, Thủ Đức, TP.HCM', '0302485600', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:26'),
(484, 'CUS_0000000195', 'CÔNG TY TNHH KUBOTA VIỆT NAM', 'Lô B-3A2-CN, KCN Mỹ Phước 3, Huyện Bến Cát, Bình Dương', '3701007993', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:20'),
(485, 'CUS_0000000198', 'CÔNG TY TNHH THƯƠNG MẠI DỊCH VỤ -XÂY DƯNG LỘC SƠN', 'Số 1190/8 Kha Vạn Cân, Khu Phố 1, Phường Linh Chiểu, Quận Thủ Đức, TP.HCM', '0306140413', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:26'),
(486, 'CUS_0000000196', 'CÔNG TY TNHH TATUNG VIỆT NAM', 'Đường NA3,KCN Mỹ Phước II, Bến Cát, Bình Dương', '3700650601', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:20'),
(487, 'CUS_0000000199', 'CƠ SỞ BẢNG HIỆP', 'Xã Vĩnh Phú ,Thuận An ,Bình Dương', '', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:20');
INSERT INTO `definition_list_subject` (`subject_id`, `subject_code`, `subject_name`, `subject_address`, `subject_tax_code`, `subject_contact_person`, `subject_telephone`, `subject_fax`, `currency_id`, `is_software_user`, `is_producer`, `is_supplier`, `is_customer`, `is_government`, `is_bank`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(488, 'CUS_0000000200', 'CÔNG TY TNHH TOKYO DEVELOPMENT CONSULTANTS VIỆT NAM', 'Số 23, Lầu 7, Cao ốc Sao Xanh, Tôn Đức Thắng, P.Bến Nghé, Q.1, TP.HCM', '0305352542', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:26'),
(489, 'CUS_0000000201', 'CÔNG TY TNHH CÔNG NGHIỆP CICA', 'KCN Hố Nai 3, Trảng Bom, Đồng Nai', '3600630055', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:24'),
(490, 'CUS_0000000202', 'TRƯỜNG ÚC VIỆT', 'Phạm Văn Thuận , Phường Tam Hiệp, Biên Hòa , Đồng Nai', '', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:24'),
(491, 'CUS_0000000203', 'TRUNG TÂM NĂNG SUẤT VIỆT NAM', 'Số 8 Đường Hoàng Quốc Việt, Quận Cầu Giấy Ha Nội', '0100428399', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:20'),
(492, 'CUS_0000000197', 'CÔNG TY TNHH FUJIKURA FIBER OPTICS VIỆT NAM', 'Số 9 VSIP, đường 6, KCN VSIP, Thuận An, Bình Dương', '3700344643', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:20'),
(493, 'CUS_0000000205', 'CÔNG TY DOTCOM VIỆT NAM', '40-42 Phan Bội Châu, P Bến Thành, Q1, TP.HCM', '0305084734', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:20'),
(494, 'CUS_0000000206', 'CÔNG TY CỔ PHẦN HAI BỐN  BẢY', '57 Nguyễn Quang Bích, P13, Q Tân Bình', '0304043037', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:20'),
(495, 'CUS_0000000208', 'CÔNG TY TNHH KẾT CẤU THÉP TOÀN CẦU VINA -JAPAN', 'Số 26, Đường số 7, VSIPII, Huyện Bến Cát, Bình Dương', '3700871583', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:20'),
(496, 'CUS_0000000209', 'CÔNG TY MASUOKA', 'Phòng 518, 99 Pasteur, Bến Nghé, Q1, TP HCM', '', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:20'),
(497, 'CUS_0000000210', 'NHÀ KHÁCH THẮNG LỢI', '14,Võ văn Tần ,Phường 6, Q3, TP HCM', '0303587958', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:26'),
(498, 'CUS_0000000211', 'CÔNG TY TNHH SHIMADA SHOJI(VIỆT NAM )', '28 VSIP, Đường số 3,KCN VSIP, Thuận An, Bình Dương', '3700726730', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:20'),
(499, 'CUS_0000000212', 'CHI NHÁNH CÔNG TY TNHH GOSHU KOHSAN (VIỆT NAM )', 'Số 40 Đường số 3 ,KCN Việt Nam - Singgapore, Thuận An ,Bình Dương', '3700611994001', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:20'),
(500, 'CUS_0000000213', 'CÔNG TY TNHH  TSUCHIYA TSCO(VIỆT NAM)', '05 Đại lộ độc lập ,KCN Việt Nam-Singapore,Thuận An ,Bình Dương', '3700433646', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:20'),
(501, 'CUS_0000000124', 'KSS', '', '', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:23'),
(502, 'CUS_0000000214', 'CTY TNHH DUEL VIET NAM', 'Số 38, đường 4, KCN VSIP, Thuận An, BD', '3700626951', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:20'),
(503, 'CUS_0000000215', 'CTY TNHH WONDERFUL SAI GON ELECTRIC', 'Số 16, đường 10, KCN VSIP, Thuận An, BD', '3700673599', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:20'),
(504, 'CUS_0000000194', 'CTY TNHH YAKULT VIET NAM', 'Số 5, Dai Lo Tu Do, KCN VSIP, Thuận An, BD', '3700723994', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:20'),
(505, 'CUS_0000000217', 'CTY TNHH KI-WORKS VIET NAM', 'Số 40, Đại Lộ Độc Lập, KCN VSIP, Thuận An, BD', '3700422080', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:20'),
(506, 'CUS_0000000204', 'CTY TNHH VẬT LIỆU BĂNG KEO NITTO DENKO VN', 'Lô C, Kho Mapletree, Số 1,Đường 10, KCN VSIP, Thuận An, Bình Dương', '3700367915', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:20'),
(507, 'CUS_0000000224', 'CÔNG TY TNHH VIỆT NAM PARKERIZING', 'Số 12, Đai Lo doc lap, KCN VSIP, Thuận An, BD', '3700236013', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:20'),
(508, 'CUS_0000000226', 'CÔNG TY TNHH NASTEC VIET NAM', 'Số 36, Đai Lo Tu Do, KCN VSIP, Thuận An, BD', '3700611458', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:20'),
(509, 'CUS_0000000227', 'CÔNG TY TNHH ASUZAC ACM', 'Số 1A, duong so 8, KCN Việt Nam - Singapore, Thuận An, Bình Dương', '3700626775', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:20'),
(510, 'CUS_0000000228', 'RIVERSEDGE FUNITURE', '', '', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:20'),
(511, 'CUS_0000000237', 'CTY TNHH KURABE INDUSTRIAL (VIET NAM )', 'Số 26 Dai Lo Tu Do, KCN VSIP, Thuận An, BD', '3700358942', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:20'),
(512, 'CUS_0000000219', 'VP ĐIỀU HÀNH - CÔNG TY KUBOTA CORPORATION', '128, Tổ 1A, Khu phố 11, Phường An Bình, Tp.Biên hòa, Đồng Nai,Việt Nam.', '3601027403', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:24'),
(513, 'CUS_0000000240', 'CTY TNHH NITTO-FUJI INTERNATIONAL VN', '49, Đường 8, VSIP, Thuận An , Bình Dương', '3700716891', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:20'),
(514, 'CUS_0000000242', 'CTY TNHH KEY PLASTICS VN', '2B, Đường Dân Chủ, VSIP 2, Bến Cát, Bình Dương', '3700967415', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:20'),
(515, 'CUS_0000000243', 'CTY CỔ PHẦN DƯỢC PHẨM BOSTON VIỆT NAM', '43, đường số 8, VSIP, Thuận An , Bình dương', '3700843113', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:20', 0, '2010-06-21 00:48:20'),
(516, 'CUS_0000000251', 'CTY TNHH MACRO FORCE', 'Số 31, Dân Chủ, KCN VSIP 2, Bến Cát, Bình Dương', '3700830957', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(517, 'CUS_0000000249', 'CTY TNHH FORTE GROW MEDICAL (VN)', 'Số 20 Đại Lộ Tự Do, KCN VSIP, Thuận An, Bình Dương', '3700373820', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(518, 'CUS_0000000255', 'CTY TNHH NL VÀ KỸ THUẬT MT FUJIKASUI', 'Số 03, đường số 20, KCN STHẦN 2, Dĩ An , Bình Dương', '3700347436', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(519, 'CUS_0000000257', 'CTY TNHH A&M VIỆT NAM', 'Số 05, KCN Đồng An, Thuận An, Bình Dương', '3700631415', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(520, 'CUS_0000000254', 'CTY TNHH VIỆT NAM SEIBI SEMICONDUCTOR', 'Số 20 vsip 2, Đường 6, vsip 2, Bến Cát Bình Dương', '3700929032', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(521, 'CUS_0000000260', 'CTY TNHH KANEKA PHARMA VIỆT NAM', 'Số 35 vsip , Đường 6, vsip 1, Thuận An, Bình Dương', '3700691541', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(522, 'CUS_0000000265', 'CTY TNHH SƠN LẬP', 'Ấp Đông Chiêu, Xã Tân Đông Hiệp, Dĩ An, Bình Dương', '3700388376', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(523, 'CUS_0000000270', 'CTY TNHH DAI-ICHI SEIKO VIỆT NAM', 'Số 41, Đại Lộ Tư Do, VSIP, Thuận An, Bình Dương', '3700722609', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(524, 'CUS_0000000271', 'CTY TNHH BAO BÌ & MƯC IN VIỆT NAM', 'Số 72B, Trần Bình Trọng, P.1, Q. Gò Vấp', '0301449092', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(525, 'CUS_0000000278', 'CÔNG TY TNHH OJITEX VIỆT NAM', 'Số 12, đường 9A, KCN Biên Hoà 2, Đồng Nai', '3600411423', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:24'),
(526, 'CUS_0000000279', 'CÔNG TY TNHH YAMAKEN APPAREL VIETNAM', 'Đường số 3, KCN Đồng An, Thuận An ,Bình Dương', '3700480212', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(527, 'CUS_0000000269', 'CÔNG TY TNHH ODA VIỆT NAM', 'Lô A, đường 1B, KCN Đồng An, Thuận An ,Bình Dương', '3700961413', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(528, 'CUS_0000000276', 'CÔNG TY TNHH YUWA VIỆT NAM', '15 VSIP 2, đường 6, KCN VSIP2, Bình Dương', '3700812718', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(529, 'CUS_0000000280', 'CÔNG TY TNHH HISON VINA', 'Khu công nghiệp Bình Đường, Dĩ An, Bình Dương', '3700332648', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(530, 'CUS_0000000268', 'CÔNG TY TNHH TOMBOW VIỆT NAM', '21 Đại lộ độc lập, KCN VSIP, Thuận An, Bình Dương', '3700479986', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(531, 'CUS_0000000286', 'CÔNG TY TNHH VIỆT NAM LSI COOLER', '32 Đường số 2, KCN VSIP 2, Bến Cát, Bình Dương', '3700719317', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(532, 'CUS_0000000277', 'CÔNG TY CỔ PHẦN SUN STEEL', 'ĐT 743, Ấp Đông An, xã Tân Đông Hiệp, Dĩ An, Bình Dương', '3700236207', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(533, 'CUS_0000000291', 'CÔNG TY TNHH SAKATA  INX VIỆT NAM', '33 Đại Lộ Tự Do, KCN VSIP, Thuận An, Bình Dươn', '0303177976', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(534, 'CUS_0000000306', 'CÔNG TY TNHH TAISEI BIJUTSU PRINGTING (VN)', 'Lô D-8F2-CN, KCN Mỹ Phước 3, Bến Cát, Bình Dương', '3700842769', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(535, 'CUS_0000000311', 'CÔNG TY TNHH HOTTA VIỆT NAM', 'Lô A-1B1-CN, KCN Bàu Bàng, Bến Cát, Bình Dương', '3701225448', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(536, 'CUS_0000000326', 'CÔNG TY TNHH KIMBERLY CLARK VIỆT NAM', '32 Đại lộ hữu nghị , KCN VSIP, Thuận An, Bình Dương', '0100114522', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(537, 'CUS_0000000315', 'CÔNG TY TNHH IWAI PLANT TECH VIET NAM', 'Lô A-1A-CN, KCN Mỹ Phước 3, Bến Cát, Bình Dương', '3700738020', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(538, 'CUS_0000000329', 'CÔNG TY TNHH MARUEI VIỆT NAM PRECISION', 'Lô 111B, số 9, Đại Lộ Độc Lập, KCN VSIP, Thuận An, Bình Dương', '3700387887', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(539, 'CUS_0000000336', 'CÔNG TY ĐIỆN TỬ ASTI', 'Âp Đông An, Tân Đông Hiệp, Dĩ An, Bình Dương', '3700255295', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(540, 'CUS_0000000345', 'CÔNG TY TNHH NHÀ MÁY VIET CHALLENGE', 'FA-10-2, KCN Bàu Bàng, Bến Cát, Bình Dương', '3700939288', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(541, 'CUS_0000000361', 'CÔNG TY TNHH DƯỢC PHẨM SÀI GÒN (SAGOPHA)', 'Số 5, Tăng Bạt Hổ, Quận 5, Tp. HCM', '0301266187-1', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(542, 'CUS_0000000340', 'CÔNG TY TNHH COPAL YAMADA VIỆT NAM', 'Đường số 12, KCX Tân Thuận, Quận 7, TP.HCM', '0305482238', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:28'),
(543, 'CUS_0000000368', 'CÔNG TY TNHH VIỆT NAM KURAUDIA', 'Số 01VSIP, đường 7, KCN VSIP, Thuận An, Bình Dương', '3701247233', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(544, 'CUS_0000000376', 'CÔNG TY TNHH TPR VIỆT NAM', 'Số 26 VSIP2, đường 2, KCN VSIP2, Bến Cát, Bình Dương', '3700722616', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(545, 'CUS_0000000378', 'CÔNG TY TNHH V-EIKOU', 'Lô L-4B-CN , KCN Mỹ Phước 2, Bến Cát, Bình Dương', '3700755202', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(546, 'CUS_0000000408', 'CÔNG TY TNHH NƯỚC GIẢI KHÁT KIRIN ACECOOK VIỆT NAM', 'Lô D-3A-CN , KCN Mỹ Phước 2, Bến Cát, Bình Dương', '3700895030', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(547, 'CUS_0000000388', 'NGÂN HÀNG VID PUBLIC CHI NHÁNH BÌNH DƯƠNG', 'Ñöôøng ÑT 743, xaõ Bình Hoøa, Thuaän An, Bình Döông', '0100112733004', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(548, 'CUS_0000000396', 'CÔNG TY TNHH FLEX VIET NAM', 'KP KHÁNH HỘI, TT TÂN PHƯỚC KHÁNH, TÂN UYÊN, BÌNH DƯƠNG', '3701411973', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(549, 'CUS_0000000401', 'CÔNG TY CỔ PHẦN PHÁT TRIỂN PHÚ MỸ', '', '3700778619', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(550, 'CUS_0000000229', 'CÔNG TY TNHH TAIYO GIKEN VIỆT NAM', 'Số 15 VSIP, đường 10, KCN VSIP1, Thuận An, Bình Dương', '3700711967', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(551, 'CUS_0000000414', 'CHI NHÁNH CÔNG TY TNHH YASAKA FRUIT', 'Âp Bình Giao, xã Thuận Giao, Huyện Thuận An, Bình Dương', '0305360381001', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(552, 'CUS_0000000422', 'CÔNG TY TNHH NIDEC TOSOK AKIBA VIỆT NAM', 'Đường số 16, KCX Tân Thuận, P. Tân Thuận Đông, Q. 7, TP. HCM', '0309286918', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(553, 'CUS_0000000425', 'CÔNG TY TNHH QUẢNG CÁO TM-DV-SX LINH-NGA-THỌ', 'Ấp Tân Mỹ, xã Thái Hòa, Huyện Tân Uyên, Bình Dương', '3700586508', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(554, 'CUS_0000000423', 'CÔNG TY TNHH HONDA LOGICOM VIỆT NAM', 'Lô 16, số 3, 18L1-2, đường 3, VSIP2, Khu LHCN-DV-ĐT Binh Dương, Bình Dương', '3701576703', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(555, 'CUS_0000000409', 'CÔNG TY TNHH DDK VIỆT NAM', 'Số 20 VSIP2, Đường Dân Chủ, KCN VSIP 2, Bến Cát, Bình Dương', '3700820814', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(556, 'CUS_0000000445', 'CÔNG TY CỔ PHẦN TÂN TÂN', '32C Ấp Nội Hóa, Xã Bình An, Huyện Dĩ An, Bình Dương', '3700257990', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(557, 'CUS_0000000457', 'CÔNG TY GỐM SỨ SÀI GÒN NHẬT BẢN', 'Xã Tân Đông Hiệp, Huyện Dĩ An, Bình Dương', '3700239790', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(558, 'CUS_0000000470', 'CÔNG TY TNHH DAIDO VIỆT NAM', '145/46 Đông Hòa, Dĩ An, Bình Dương', '3700228693', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(559, 'CUS_0000000473', 'CÔNG TY TNHH MỘT THÀNH VIÊN TM DV THANH THANH BÌNH', '44/14 Đại Lộ Bình Dương, Thủ dầu một, Bình Dương', '3700877433', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(560, 'CUS_0000000489', 'CÔNG TY TNHH GLOBAL MOLD', 'Số 26 dđường 1 VSIP 2, KCN VSIP 2, Bến Cát, Bình Dương', '3700711371', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(561, 'CUS_0000000490', 'CÔNG TY TNHH MTV CÔNG NGHỆ TỰ ĐỘNG TIẾN TRÍ VIỆT', '', '', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:21', 0, '2010-06-21 00:48:21'),
(562, 'CUS_0000000091', 'CÔNG TY TNHH MAEDA VIỆT NAM', 'P.908, Zen Plaza,54-56 Nguyễn Trãi, P.Bến Thành, Quận 1, TP.HCM', '0305412368', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:22', 0, '2010-06-21 00:48:26'),
(563, 'CUS_0000000174', 'CÔNG TY CỔ PHẦN MAI THÀNH', '28 Mạc Đĩnh Chi, P. Đa Kao, Q.1, TP. HCM', '0302481194', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:22', 0, '2010-06-21 00:48:22'),
(564, 'CUS_0000000086', 'NGÂN HÀNG TOKYO-MITSUBISHI UFJ - CN HỒ CHÍ MINH', 'Lầu 8, Tòa nhà Landmark,5B Tôn Đức Thắng,Phường Bến Nghé, Q.1, TP.HCM', '0301224067-1', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:22', 0, '2010-06-21 00:48:26'),
(565, 'CUS_0000000102', 'CÔNG TY TNHH PRONICS VIỆT NAM', 'Đường số 12, KCX Tân Thuận, Quận 7', '0303823725', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:23', 0, '2010-06-21 00:48:26'),
(566, 'CUS_0000000221', 'CÔNG TY CỔ PHẦN VTM VIỆT NAM', 'Phòng 6.1, Toà nhà E.town 2, 364 Cộng Hoà, P. 13, Q. Tân Bình, TP. HCM', '0304239135', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:24', 0, '2010-06-21 00:48:26'),
(567, 'CUS_0000000222', 'CÔNG TY HH SX GIA CÔNG VIỆT NHẤT', 'Đường Số 4 , KCN  Hố nai 3 , Trảng Bom , Đồng nai', '3600454681', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:24', 0, '2010-06-21 00:48:24'),
(568, 'CUS_0000000231', 'CÔNG TY TNHH   KUREHA VIỆT NAM', '227/3, Đường số 13, KCN Amata P. long Bình , Biên hòa ,Đồng nai', '3600967316', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:24', 0, '2010-06-21 00:48:24'),
(569, 'CUS_0000000230', 'CÔNG TY TNHH THEP JFE SHOJI VIỆT NAM', 'Lô 202, KCN Amata,Biên Hòa -Đồng Nai', '3600819692', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:24', 0, '2010-06-21 00:48:24'),
(570, 'CUS_0000000233', 'CÔNG TY TNHH BMB', 'Số 228 , Đường Số 4, KCN Amata, Biên hòa ,Đồng Nai', '3600688545', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:24', 0, '2010-06-21 00:48:24'),
(571, 'CUS_0000000236', 'CÔNG TY TNHH VIỆT NAM TAKAGI', 'Lô 226/6 , Đường 2, KCN Amata, Phường Long Bình, Biên Hòa, Đồng Nai', '3600861101', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:24', 0, '2010-06-21 00:48:24'),
(572, 'CUS_0000000241', 'CÔNG TY TNHH SHIOGAI SEIKI VIỆT NAM', 'Số 224/4, Đương 24-2, KCN Amata P. Long Bình ,Biên Hòa ,Đồng Nai', '3600715894', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:24', 0, '2010-06-21 00:48:24'),
(573, 'CUS_0000000250', 'CHI NHÁNH CÔNG TY CỔ PHẦN CÔNG NGHIỆP  NHỰA PHÚ LÂM', 'LÔ 109 KCN Amata, P. Long Bình , Biên Hòa, Đồng Nai', '0200109445002', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:24', 0, '2010-06-21 00:48:24'),
(574, 'CUS_0000000235', 'CÔNG TY  TNHH OKURA', 'Lô VI - 3A, Đường số 2, KCN Hố Nai, Trảng Bom, Đồng Nai', '3600817303', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:24', 0, '2010-06-21 00:48:24'),
(575, 'CUS_0000000262', 'CÔNG TY PHÁT THƯƠNG 1', 'D-0-1 KCN Long Bình, Biên Hoà, Đồng Nai', '3600506273', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:24', 0, '2010-06-21 00:48:27'),
(576, 'CUS_0000000234', 'CÔNG TY TNHH ĐẠI ĐÌNH', 'Số 1005, Tổ 20, Khu 5 , Ấp 2 An Hòa ,Long Thành ,Đồng Nai', '3600799238', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:24', 0, '2010-06-21 00:48:24'),
(577, 'CUS_0000000275', 'CÔNG TY TNHH KOTOBUKI SEA', 'Lô104/6, Đường Amata 24-2-4, KCN Amata, P. Long Bình, TP Biên Hòa, Đồng Nai', '3600691643', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:24', 0, '2010-06-21 00:48:24'),
(578, 'CUS_0000000284', 'CÔNG TY TNHH NEW NEW VIỆT NAM', '109/4,KCN Amata, Biên Hòa, Đồng Nai', '3600545709', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:24', 0, '2010-06-21 00:48:24'),
(579, 'CUS_0000000285', 'CÔNG TY TNHH MAINETTI VIỆT NAM', 'KCN Long Thành-Huyện Long Thành-Tỉnh Đồng Nai', '3600660490', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:24', 0, '2010-06-21 00:48:24'),
(580, 'CUS_0000000294', 'CÔNG TY TNHH DƯỢC PHẨM HISAMITSU VIỆT NAM', 'Số 14-15 ,Đường 2A, KCN 2 Biên hòa , Đồng Nai', '3600245712', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:24', 0, '2010-06-21 00:48:27'),
(581, 'CUS_0000000298', 'CÔNG TY TNHH  BAYER VIỆT  NAM', 'Lô 118/4 Amata, P.Long Bình , Biên  Hòa , ĐN', '3600359484', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:24', 0, '2010-06-21 00:48:24'),
(582, 'CUS_0000000304', 'CÔNG TY TNHH QUADRILLE VIỆT NAM', '118 KCN Amata, Long Bình , Biên Hòa , Đồng Nai', '3600263817', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:24', 0, '2010-06-21 00:48:24'),
(583, 'CUS_0000000312', 'CÔNG TY TNHH QUỐC TẾ FLEMING VIỆT NAM', '103/2 Nhà Máy Số 16,KCN Amata, P.Long Bình ,Biên Hòa, Đồng Nai', '3600701228', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:24', 0, '2010-06-21 00:48:24'),
(584, 'CUS_0000000316', 'CÔNG TY TNHH SHOWPLA VIỆT NAM', 'Số 10, Đường 9A, KCN Biên Hòa 2, Đồng Nai', '3600253135', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:24', 0, '2010-06-21 00:48:24'),
(585, 'CUS_0000000313', 'CÔNG TY TNHH OLYMPUS VIỆT NAM', 'KCN Long Thành, huyện Long Thành, Đồng Nai', '3600939069', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:24', 0, '2010-06-21 00:48:24'),
(586, 'CUS_0000000310', 'CÔNG TY TNHH MITSUBA M-TECH VIỆT NAM', 'KCN Long Bình,Biên Hòa,Đồng Nai', '3600241066', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:24', 0, '2010-06-21 00:48:24'),
(587, 'CUS_0000000331', 'CÔNG TY TNHH HOME VIỆT NAM', 'Số 2, Đường 19A, KCN Biên Hòa 2, Đồng Nai', '3600737062', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:24', 0, '2010-06-21 00:48:24'),
(588, 'CUS_0000000337', 'CÔNG TY TNHH SANYO VIỆT NAM', 'Lô 226/10 Đường 2-KCN Amata-Long Bình-Biên Hòa-Đồng Nai', '3601022437', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:24', 0, '2010-06-21 00:48:24'),
(589, 'CUS_0000000342', 'CÔNG TY TNHH TOMIYA SUMMIT', 'Lô B1,KCX Long Bình ,Biên Hòa ,Đồng Nai', '3600606574', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:25', 0, '2010-06-21 00:48:25'),
(590, 'CUS_0000000354', 'CÔNG TY TNHH OKEN SEIKO VIỆT NAM', 'KCN Long Bình , Biên Hòa, Đồng Nai', '3601405373', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:25', 0, '2010-06-21 00:48:25'),
(591, 'CUS_0000000373', 'CÔNG TY TNHH TOHOKU CHEMICAL INDUSTRIES VIỆT NAM', 'Lô 211-Đường 9-KCN Amata- Biên Hòa -Đồng Nai', '3600726550', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:25', 0, '2010-06-21 00:48:25'),
(592, 'CUS_0000000411', 'CÔNG TY TNHH SẢN PHẨM CÔNG NGHIỆP TOSHIBA ASIA', 'Lô 309,Đường số 9,KCN Amata,TP Biên Hòa ,Đồng Nai', '3601324879', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:25', 0, '2010-06-21 00:48:25'),
(593, 'CUS_0000000413', 'CÔNG TY TNHH HIROTA PRECISION VIỆT NAM', 'Đường số 10,KCN Nhơn Trạch 1,Đồng Nai', '3600365047', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:25', 0, '2010-06-21 00:48:25'),
(594, 'CUS_0000000420', 'MARUMA SHO JI CORPORATION', '57/C1 Khu Phố 1,Phường Long Bình Tân ,Biên Hòa ,Đồng Nai', '3601295120', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:25', 0, '2010-06-21 00:48:25'),
(595, 'CUS_0000000417', 'CÔNG TY TNHH YOUNG SUNG VINA', 'Số 19,Đường 3A,KCN Biên Hòa 2, Biên Hòa ,Đồng Nai', '3601040394', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:25', 0, '2010-06-21 00:48:25'),
(596, 'CUS_0000000428', 'CÔNG TY TNHH TOYO INK VIỆT NAM', 'Lô 101, Đường Amata ,KCN Amata -Biên Hòa -Đồng Nai', '3600668186', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:25', 0, '2010-06-21 00:48:25'),
(597, 'CUS_0000000462', 'CÔNG TY TNHH  EPE PACKAGING VIỆT NAM', 'Đường số 4-KCN Amata-Biên Hòa -Đồng Nai', '3601117199', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:25', 0, '2010-06-21 00:48:25'),
(598, 'CUS_0000000272', 'CÔNG TY TNHH SANKEI VIỆT NAM', 'Đường 14,KCX Tân Thuận,P.Tân Thuận Đông,Q.7', '0300671986', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:25', 0, '2010-06-21 00:48:27'),
(599, 'CUS_0000000302', 'CÔNG TY TNHH BAO BÌ NHẬT BẢN (VIỆT NAM)', 'U 33b-35, Đường 20, KCX Tân Thuận, P.Tân Thuận Đông, Q.7,Tp.HCM', '0300673888', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:25', 0, '2010-06-21 00:48:27'),
(600, 'CUS_0000000327', 'CÔNG TY TNHH YASUDA ( VIỆT NAM)', 'Đường 14, KCX Tân Thuận, Quận 7, TP.HCM', '0300768593', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:25', 0, '2010-06-21 00:48:27'),
(601, 'CUS_0000000330', 'CÔNG TY TNHH RƯỢU THỰC PHẨM', 'Đường 8, Khu Chế Xuất Tân Thuận, Quận 7, Tp.HCM', '0300657484', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:25', 0, '2010-06-21 00:48:27'),
(602, 'CUS_0000000332', 'CÔNG TY TNHH THỜI TRANG S.B SÀI GÒN', 'Đường số 8, KCX Tân Thuận, Phường Tân Thuận Đông, Q.7,HCM', '0300803424', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:25', 0, '2010-06-21 00:48:27'),
(603, 'CUS_0000000339', 'CÔNG TY TNHH SHOWA (VIỆT NAM)', 'Đường 14, KCX Tân Thuận, Quận 7, TP.HCM', '0300667098', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:25', 0, '2010-06-21 00:48:27'),
(604, 'CUS_0000000343', 'CÔNG TY TNHH TOYO PRECISION', 'Đường số 6, KCX Tân Thuận, Quận 7, TP.HCM', '0300763796', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:25', 0, '2010-06-21 00:48:28'),
(605, 'CUS_0000000346', 'CÔNG TY TNHH THIẾT KẾ RENESAS VIỆT NAM', 'Lô W.29-30-31a, Đường Tân Thuận, KCX Tân Thuận, Q.7, TP.HCM', '0303543502', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:25', 0, '2010-06-21 00:48:28'),
(606, 'CUS_0000000341', 'CÔNG TY TNHH VINA COSMO', 'Đường 15, KCX Tân Thuận, P. Tân Thuận Đông, Q. 7, TP. HCM', '0300710064', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:25', 0, '2010-06-21 00:48:28'),
(607, 'CUS_0000000359', 'CÔNG TY TNHH CÔNG NGHIỆP TEMPEARL (VIỆT NAM)', 'Đường số 8, KCX Tân Thuận,Quận 7, TP.HCM', '0300760530', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:25', 0, '2010-06-21 00:48:28'),
(608, 'CUS_0000000367', 'CÔNG TY TNHH QT CÂN BẰNG TRỌNG LƯỢNG T VIỆT NAM', 'Lầu 3, đơn vị 1C, nhà xưởng TC số 2, đường 15, KCX Tân Thuận, Q.7, TP.HCM', '0305476280', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:25', 0, '2010-06-21 00:48:28'),
(609, 'CUS_0000000374', 'CÔNG TY TNHH UNIMAX SAIGON', 'M.08a-10-12 Đường 12, KCX tân Thuận, Quận 7', '0300792483', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:25', 0, '2010-06-21 00:48:28'),
(610, 'CUS_0000000399', 'CÔNG TY TNHH KTC ( VIỆT NAM )', 'Đường số 8, KCX Tân Thuận, Phường Tân Thuận Đông, Q.7,HCM', '0300759366', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:25', 0, '2010-06-21 00:48:28'),
(611, 'CUS_0000000402', 'CÔNG TY TNHH CÔNG NGHIỆP TOWA', 'Đường 10, KCX Tân Thuận, Quận 7, TP.HCM', '0300716267', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:25', 0, '2010-06-21 00:48:28'),
(612, 'CUS_0000000426', 'CÔNG TY TNHH KYOSHIN VIỆT NAM', 'Đường 12, Khu Chế Xuất Tân Thuận, Quận 7', '0300782968', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:25', 0, '2010-06-21 00:48:29'),
(613, 'CUS_0000000438', 'CÔNG TY TNHH CHUBU RIKA (VN)', 'Đường số 18, KCX Tân Thuận,Quận 7, TP. HCM', '0302792707', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:25', 0, '2010-06-21 00:48:25'),
(614, 'CUS_0000000441', 'CÔNG TY TNHH UNIKA VIE-PAN', 'Đường 12, Khu Chế Xuất Tân Thuận,P.Tân Thuận Đông, Quận 7, Tp.HCM', '0300767504', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:25', 0, '2010-06-21 00:48:29'),
(615, 'CUS_0000000471', 'CÔNG TY TNHH NIKKISO VIỆT NAM', 'Đường 19 ,KCX Tân Thuận ,P.Tân Thuận Đông ,Q7 ,TP.HCM', '0300668084', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:25', 0, '2010-06-21 00:48:25'),
(616, 'CUS_0000000493', 'CÔNG TY TNHH VIỆT HƯNG', 'KCX Tân Thuận ,Quận 7', '0300766701', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:25', 0, '2010-06-21 00:48:25'),
(617, 'CUS_0000000004''', 'CÔNG TY TNHH VINA WOMAN VIỆT NAM', '4 Nguyễn Đình Chiểu, P. Đakao, Quận 1, TP.HCM', '0308614355', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:25', 0, '2010-06-21 00:48:25'),
(618, 'CUS_0000000028', 'CÔNG TY CỔ PHẦN MẶT TRỜI XANH', '5.8A,Etown 2, 364 Cong Hoa, Q.Tan Binh,TPHCM.', '0303672829', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:25', 0, '2010-06-21 00:48:25'),
(619, 'CUS_0000000034''', 'CÔNG TY TNHH CETUS VIỆT NAM', '4 Nguyễn Đình Chiểu, P. Đakao, Quận 1, TP.HCM', '0303160002', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:25', 0, '2010-06-21 00:48:25'),
(620, 'CUS_0000000117', 'NGÂN HÀNG MIZUHO CORPORATE BANK,LTD. - CHI NHÁNH TPHCM', 'Lâù 18, Sun Wah Tower,115 Nguyễn Huệ, Q.1,Tp.HCM', '0304413344', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:26', 0, '2010-06-21 00:48:26'),
(621, 'CUS_0000000207', 'CÔNG TY TNHH DENTSU VIỆT NAM', '115 Nguyễn Huệ, Q.1, TP.HCM', '0302822422', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:26', 0, '2010-06-21 00:48:26'),
(622, 'CUS_0000000216', 'CÔNG TY TNHH JESCO SE (VIET NAM)', 'TTTM Thuận Kiều, 190 Hồng Bàng, Q.5, TPHCM', '0302447355', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:26', 0, '2010-06-21 00:48:26'),
(623, 'CUS_0000000218', 'CÔNG TY TNHH BROTHER INTERNATIONAL (VIỆT NAM)', '63 Đường Tú Xương Phường 7, Quận 3, TP.HCM', '0307933662', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:26', 0, '2010-06-21 00:48:26'),
(624, 'CUS_0000000220', 'CÔNG TY TNHH DỊCH VỤ GIẢI TRÍ MỸ TÂM', '139H, Nguyễn Đình Chính, P.8, Q.Phú Nhuận, Tp.HCM', '0304979813', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:26', 0, '2010-06-21 00:48:26'),
(625, 'CUS_0000000223', 'CÔNG TY TNHH MTV TƯ VẤN THƯƠNG MẠI VIỆT NHẬT', 'Lầu 1, Tòa nhà Blue star, số 23, Tôn Đức Thắng, P.Bến Nghé, Q.1, TP.HCM', '0309363270', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:26', 0, '2010-06-21 00:48:26'),
(626, 'CUS_0000000225', 'SAGAWA EXPERESS VIỆT NAM', '117A-117B, P.Linh Trung, Quận Thủ Đức, Tp.HCM', '0300740037001', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:26', 0, '2010-06-21 00:48:26'),
(627, 'CUS_0000000232', 'SHIMIZU CORPORATION', '69-71 Thạch Thị Thanh,Q1,TP HCM', 'ko ghi MST', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:26', 0, '2010-06-21 00:48:26'),
(628, 'CUS_0000000238', 'DNTN XÂY DỰNG VÀ THƯƠNG MẠI GIANG MINH', '314 Võ Văn Ngân,Phường Bình Thọ,Q.Thủ Đức,Tp.HCM', '0304264163', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:26', 0, '2010-06-21 00:48:26'),
(629, 'CUS_0000000239', 'CÔNG TY TNHH TM-DV HỒNG LỢI', '30 Nguyễn Văn Cừ, Q.1, Tp.HCM', '0301529598', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(630, 'CUS_0000000244', 'KHÁCH SẠN MELIA HÀ NỘI', '44 Lý Thường Kiệt, Hà Nội', '0100112324', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(631, 'CUS_0000000245', 'TOHO VIETNAM CO.,LTD', 'Thang Long Industrial Park, Dong Anh Dist, Hanoi, Vietnam', '0101344920', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(632, 'CUS_0000000246', 'YURTEC CORPORATION', '410 Ung Van Khiem st, Ward 25, Binh Thanh Dist, HCMC', '', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(633, 'CUS_0000000247', 'CÔNG TY TNHH DV&GTVL NHẬT HIỀN', '326 Ngũ Hành Sơn, Thành Phố Đà Nẵng', '0400539269', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(634, 'CUS_0000000248', 'CÔNG TY TNHH ICT', 'P304, 12 Mạc Đĩnh Chi, Q. 1, TP. HCM', '', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(635, 'CUS_0000000252', 'CÔNG TY TNHH SX - TM LAN PHƯƠNG', '19 Nguyễn Văn Đậu, P.5, Q. Phú Nhuận, TP.HCM', '0301441960', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(636, 'CUS_0000000253', 'CÔNG TY TNHH ÔTÔ ISUZU VIỆT NAM', '100 Quang Trung, P.8, Q.Gò Vấp, Tp.HCM', '0301236665', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(637, 'CUS_0000000256', 'CÔNG TY TNHH TM ACS VIỆT NAM', '31 Nguyễn Trãi, P. Bến Thành, Quận 1, TP. HCM', '0305732706', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(638, 'CUS_0000000258', 'BAN ĐIỀU HÀNH KHU PHỐ 2', '41A Đường 68, Khu phố 2, Hiệp Phú, Q. 9, TP. HCM', 'ko có MST', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(639, 'CUS_0000000259', 'CÔNG TY TNHH VITALIFY Á CHÂU', 'Số 232, Đường 3/2, Phường 12, Quận 10, TP.HCM', '0305745984', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(640, 'CUS_0000000261', 'CÔNG TY TNHH I.CTION VIỆT NAM', 'Tòa nhà Ánh Kim, Số 43 Lê Thị Hồng Gấm, P.Nguyễn Thái Bình,Q1,Tp.HCM', '0305509169', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(641, 'CUS_0000000263', 'CÔNG TY TNHH ALPHA VIỆT NAM', '204 Nơ Trang Long, P.12, Q. Bình Thạnh, TP. HCM', '0303534716', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(642, 'CUS_0000000264', 'CÔNG TY CP ĐỈNH CAO TOÀN CẦU', 'Lô CR 3-6, 3-7, Toà nhà Southern Cross Sky View, P. Tân Phú, Q. 7, TP. HCM', '0305626698', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(643, 'CUS_0000000266', 'CÔNG TY TNHH SOUTHERN CROSS VN', 'Lô CR 3-6, 3-7, Toà nhà Southern Cross Sky View, P. Tân Phú, Q. 7, TP. HCM', '0301466549', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(644, 'CUS_0000000267', 'CÔNG TY TNHH HOSHINO (VIỆT NAM)', 'Lô C 55/ II, đường số 8, KCN Vĩnh Lộc, xã Vĩnh Lộc A, huyện Bình Chánh, Tp.HCM', '0303514438', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(645, 'CUS_0000000273', 'CÔNG TY TNHH SOJITZ VIỆT NAM', '183 Lý Chính Thắng, Quận 3, TP.HCM', '0307636500', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(646, 'CUS_0000000274', 'Công ty TNHH Dịch vụ Johnson Controls Việt Nam', '8B Trần Quang Diệu, Phường 13, Quận 3, TP.HCM', '0305795671', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(647, 'CUS_0000000281', 'VPĐD FUJI XEROX', '81 - 85 Hàm Nghi, Quận 1, TP. HCM', '', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(648, 'CUS_0000000282', 'CÔNG TY TNHH MỘT THÀNH VIÊN CƠ BẢN', '6, Khu dân cư 6A Himlam, Đường 11, Xã Bình Hưng, Huyện Bình Chánh', '0305895958', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(649, 'CUS_0000000283', 'CÔNG TY TNHH QUỐC TẾ ACG VIỆT NAM', 'Đại Lộ Đông Tây (Liên tỉnh lộ 25B), P.An Phú, Q.2, TP.HCM', '0304489424', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(650, 'CUS_0000000287', 'CÔNG TY TNHH VẬN TẢI VÀ GIAO NHẬN YUSEN VIỆT NAM', '39B Trường Sơn, Phường 4, Quận Tân Bình', '0303467869', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(651, 'CUS_0000000288', 'CÔNG TY CỔ PHẦN HỆ THỐNG GÔ ẤT', '393B Trần Hưng Đạo,P.Cầu Kho,Q.1,Tp.HCM', '0304596786', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(652, 'CUS_0000000289', 'CÔNG TY TNHH NỀN TẢNG KINH DOANH VIỆT NAM', 'P.903, Lầu 9, Tòa nhà Sun Wah, 115 Nguyễn Huệ, Quận 1, HCM', '0304835794', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(653, 'CUS_0000000290', 'CÔNG TY TNHH TOYO PIANO VIỆT NAM', 'Lô I - 10A, đường 13, KCN Tân Bình, Q.Tân Phú, TP.HCM', '0303277138', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(654, 'CUS_0000000292', 'CÔNG TY TNHH KỸ THUẬT LẮP MÁY ĐIỆN CƠ MIỀN NAM', '75, đường 275, Phường Hiệp Phú, Quận 9', '0303907982', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(655, 'CUS_0000000293', 'CÔNG TY TNHH MINH CẢNH VẠN LỢI', 'Số 15, đường Nguyễn Hữu Cảnh, P.22, Q. Bình Thạnh, TP. HCM', '3600678385', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(656, 'CUS_0000000295', 'HỘ KINH DOANH MÌ NHẤT', '27/5 Nguyễn Bỉnh Khiêm, P. Đakao, Q. 1, TP. HCM', '0305919038', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(657, 'CUS_0000000296', 'CÔNG TY TNHH MANKICHI SOFTWARE (VIETNAM)', 'Số 2 Thi Sách, P.Bến Nghé, Q.1, TP.HCM', '0302977289', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(658, 'CUS_0000000297', 'DAIICHI JITSUGYO ASIA PTE. LTD. (HCM REP. OFFICE)', 'Suite 1107, Fl. 11, Zen Plaza, 54-56 Nguyen Trai, Dist. 1, HCMC.', '', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(659, 'CUS_0000000299', 'CÔNG TY TNHH TƯ VẤN NGUỒN NHÂN LỰC PHẦN THƯỞNG', '64 Nguyễn Đình Chiểu ,P.Đao Kao ,Q.1 ,TP.HCM', '0306045689', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(660, 'CUS_0000000300', 'CÔNG TY TNHH EKETS VIỆT NAM', '76 Đường Số 9, Kp1, Phường Tân Phú, Quận 7', '0304413369', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(661, 'CUS_0000000301', 'CÔNG TY TNHH TOSADENSHI VIỆT NAM', 'Lô I-8C Đường số 11, Nhóm CN1, KCN Tân Bình, P.Sơn Kỳ, Q. Tân Phú, TP.HCM', '0303940108', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(662, 'CUS_0000000303', 'CÔNG TY TNHH KACHIBOSHI ( VIỆT NAM )', 'Khu Chế Xuất Linh Trung I, Quận Thủ Đức, TP.HCM', '0300789402', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(663, 'CUS_0000000305', 'CÔNG TY TNHH GAS SOPET', 'Ấp 2, Xã Phước Khánh, Nhơn Trạch, Đồng Nai', '3600817399', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(664, 'CUS_0000000307', 'CÔNG TY TNHH TM & DV MIỀN MẶT TRỜI', '3B05-3B06 lầu 4, tòa nhà Indochina, số 4, Nguyễn Đình Chiểu, Quận 1', '0305909061', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(665, 'CUS_0000000308', 'CN CÔNG TY CP ĐỐI TÁC MẶT TRỜI TOÀN CẦU A.I', '39 Ngô Đức Kế, P. Bến Nghé, Q. 1, TP. HCM', '0102936197-001', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(666, 'CUS_0000000309', 'CÔNG TY TNHH KÝ HIỆU', 'P606 Số 4 Nguyễn Đình Chiểu, P. Đakao, Q. 1, TP. HCM', '0305745871', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(667, 'CUS_0000000314', 'VAMP', '56-58-60 Hai Bà Trưng, P. Bén Nghé, Q. 1, TP. HCM', '', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(668, 'CUS_0000000317', 'CÔNG TY TNHH SAIGON PRECISION', 'Đường D, KCX Linh Trung I, Phường Linh Trung, Quận Thủ Đức.', '0300737411', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(669, 'CUS_0000000318', 'CÔNG TY TNHH NAC ( VIỆT NAM )', '63A Nam Kỳ Khởi Nghĩa, P.Bến Thành, Quận 1, TP.HCM', '0309288986', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(670, 'CUS_0000000319', 'CHI NHÁNH CÔNG TY TNHH KINDEN VIỆT NAM', 'Lầu 7, 05 Nguyễn Gia Thiều, Phường 6, Quận 3', '0100112846001', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(671, 'CUS_0000000320', 'NAKANO CORPORATION-THẦU TKXD NHÀ MÁY MỚI CÔNG TY TNHH CÔNG NGHIỆP PLUS VIỆT NAM TẠI KCN NHƠN TRẠCH III', 'Lô T1, đường số 10&đường số 3, KCN Nhơn Trạch III, xã Hiệp Phước, huyện Nhơn Trạch, tỉnh Đồng Nai', '3601749663', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(672, 'CUS_0000000321', 'OSC TRAVEL ( SMI GROUP ) CO.,LTD', '143 Nguyễn Văn Trỗi, Q. Phú Nhuận, TP. HCM', '35001018830031', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(673, 'CUS_0000000322', 'SENSHUKAI HONGKONG HCMC REP. OFFICE', 'Zen Plaza Bldg., Unit #903, 9th Floor, 54-56 Nguyen Trai St., Dist. 1, HCMC.', '0304638179', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(674, 'CUS_0000000323', 'CÔNG TY TNHH MITSUI O.S.K LINES (VIET NAM)', 'P.1103, Lầu 11, Tòa nhà Sunwah, 115 Nguyễn Huệ, Q.1,TP.HCM', '0304491818', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(675, 'CUS_0000000324', 'CÔNG TY TNHH THIẾT KẾ CHÂU Á KUME', 'Tầng 9, tòa nhà CDC, 25 Lê Đại Hành, Hai Bà Trưng, Hà Nội', '0103255867', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(676, 'CUS_0000000325', 'CÔNG TY CỔ PHẦN GABB VIỆT NAM', 'Tầng 12,P.1201, Cao ốc Zen Plaza, 54-56 Nguyễn Trãi, P.Bến Thành, Q.1,Tp.HCM', '0302521305', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(677, 'CUS_0000000328', 'CÔNG TY TNHH ITOKOKI VIỆT NAM', 'P.205, Tòa nhà Sky View, Lô Cr3-6,Cr3-7, P.Tân Phú, Quận 7, TP.HCM', '0304929668', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(678, 'CUS_0000000333', 'CÔNG TY TNHH KIẾN TRÚC ANH', '24M, Đường số 1, KDC Miếu Nổi, Phường 3, Q.Bình Thạnh', '0304764342', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(679, 'CUS_0000000335', 'CÔNG TY TNHH DVBV HOÀNG GIA', 'C6-019, Bình Thuận 2, Thuận Giao, Thuận An, Bình Dương', '0200356067-001', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:27', 0, '2010-06-21 00:48:27'),
(680, 'CUS_0000000344', 'VPĐD CORONA MARUDAI CO., LTD TẠI TP. HCM', '208 Nguyễn Trãi, Lầu M, P. Phạm Ngũ Lão, Q. 1, TP. HCM', '0308578682', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(681, 'CUS_0000000347', 'OVERSEAS MERCHANDISE INSEPCTION CO., LTD.', '45 Dinh Tien Hoang St., Dist. 1, HCMC.', '', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(682, 'CUS_0000000348', 'CÔNG TY TNHH THƯƠNG MẠI XUẤT NHẬP KHẨU THIẾT BỊ VẬT TƯ MKC', 'Số 1101 A4, KĐT Đền Lừ 2, Hoàng Văn Thụ, Q.Hoàng Mai, Hà Nội', '0102634855', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(683, 'CUS_0000000349', 'GALONDRINA 26', '28023 Marid, Spain', 'B - 85104073', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(684, 'CUS_0000000350', 'CÔNG TY LIÊN DOANH NHÔM VIỆT NHẬT', 'Lô C, Đường số 3, KCN Bình Chiểu, Q.Thủ Đức', '0300780985001', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(685, 'CUS_0000000351', 'CÔNG TY TNHH MTV TM-XNK TÂN THÀNH LỢI', '8A/A19 Thái Văn Lung, P.Bến Nghé, Quận 1, TP.HCM', '0306377211', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(686, 'CUS_0000000352', 'CÔNG TY TNHH WELL BE VIỆT NAM', 'P.5C, Tòa nhà The Times Building, 84 Triệu Việt Vương, P.Bùi Thị Xuân,Q.Hai Bà Trưng, TP.Hà Nội', '0104035254', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(687, 'CUS_0000000353', 'CÔNG TY TNHH TM PHẠM HUY HOÀNG', '15A8 Lê Thánh Tôn, P. Bến Nghé, Q. 1, TP. HCM', '0301807044', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(688, 'CUS_0000000355', 'CÔNG TY TNHH PHÚ AN HUY', '490/2 Đường TTH 21, P. Tân Thới Hiệp, Q. 12, TP. HCM', '0305956135', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(689, 'CUS_0000000356', 'CÔNG TY TNHH TM & DV HOÀNG KHUÊ', '119 Trưng Nữ Vương, Quận Hải Châu, TP.Đà Nẵng', '0400620209', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(690, 'CUS_0000000357', 'VPĐD SUMIKIN BUSSAN CORPORATION', '162 Pasteur, Lầu 3, Quận 1, TP.HCM', '0304650384', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(691, 'CUS_0000000358', 'CÔNG TY TNHH KHANG VIÊN', '428 Kha Vạn Cân, P.Hiệp Bình Chánh, Quận Thủ Đức', '0304302852', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(692, 'CUS_0000000362', 'CÔNG TY LIÊN DOANH DU LỊCH APEX VIỆT NAM', '16 Ngô Thời Nhiệm,Phường 7 , Quận 3, Tp.HCM', '0301210120', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(693, 'CUS_0000000363', 'CÔNG TY CP ĐẦU TƯ VÀ THƯƠNG MẠI TẠP PHẨM SÀI GÒN', '35 Lê Quý Đôn, Phường 7, Quận 3, TP. HCM', '0301462583', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(694, 'CUS_0000000364', 'CÔNG TY TNHH PANASONIC AVC NETWORKS VIETNAM', 'Đường Đỗ Xuân Hợp, P. Phước Long B, Q. 9, TP. HCM', '0300792187', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(695, 'CUS_0000000365', 'CÔNG TY TNHH CYBOZU VIỆT NAM', 'Tòa nhà Etown 3, 364 Cộng Hòa, P. 13, Q. Tân Bình, TP. HCM', '0306507862', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(696, 'CUS_0000000366', 'CHI NHÁNH CÔNG TY CỔ PHẦN GIÓ VÀ NƯỚC (TỈNH BÌNH DƯƠNG)', '87 Lý Chiêu Hoàng, Phường 10, Quận 6, TP. HCM', '3701364000-001', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(697, 'CUS_0000000369', 'CÔNG TY TNHH ICHI CORPORATION VIỆT NAM', '147-149 Võ Văn Tần, Phường 6, Quận 3', '0303455912', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(698, 'CUS_0000000370', 'CÔNG TY TNHH MORITA VIỆT NAM', 'Km31, xã Minh Đức, huyện Mỹ Hào, Tỉnh Hưng Yên', '0900285245', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(699, 'CUS_0000000371', 'CÔNG TY TNHH SX - TM - DV LÊ MÂY', 'Số 10 đường 23, ấp Bình Khánh 2, Phường Bình An, Quận 2', '0303077611', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(700, 'CUS_0000000372', 'CÔNG TY TNHH KUMON VIỆT NAM', '157 Nguyễn Văn Trỗi, P. 11, Q. Phú Nhuận, TP. HCM', '0304436285', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(701, 'CUS_0000000375', 'CÔNG TY TNHH SINH THÁI HOA ANH ĐÀO', 'SE 6-1 Cảnh Viên 1, Phú Mỹ Hưng, P.Tân Phú, Quận 7, TP.HCM', '0305368768', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(702, 'CUS_0000000377', 'CÔNG TY CỔ PHẦN PHÁT TRIỂN CHIẾN LƯỢC ĐẦU TƯ TOÀN CẦU', 'CB 1- 3-11, Lô H29-3, Khu phố Mỹ Phúc, Phường Tân Phong, Q.7, TP.HCM', '0306112462', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(703, 'CUS_0000000380', 'CÔNG TY TNHH TM-DV THỦY LAM', 'Số 1 đường Mỹ Thái 2A, Phường Tân Phú, Quận 7', '0308250235', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(704, 'CUS_0000000381', 'CÔNG TY TNHH MANZA VIỆT NAM', '12M Nguyễn Thị Minh Khai, P. Đakao, Quận 1, TP. HCM', '0304876247', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28');
INSERT INTO `definition_list_subject` (`subject_id`, `subject_code`, `subject_name`, `subject_address`, `subject_tax_code`, `subject_contact_person`, `subject_telephone`, `subject_fax`, `currency_id`, `is_software_user`, `is_producer`, `is_supplier`, `is_customer`, `is_government`, `is_bank`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(705, 'CUS_0000000382', 'CÔNG TY TNHH MAY THÊU XUẤT KHẨU NHẬT - VIỆT', 'Lô 4.2, Nhóm CN IV, Đường số 5, KCN Tân Bình, Quận Tân Phú, TP.HCM', '0304655752', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(706, 'CUS_0000000383', 'CHI NHÁNH CÔNG TY UNIMAX SAIGON - NHÀ MÁY BẾN LỨC', '309 Voi Lá, Thị Trấn Bến Lức, Tỉnh Long An', '0300792483-001', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(707, 'CUS_0000000384', 'CÔNG TY TNHH TM VĂN PHÒNG PHẨM THIÊN TRÍ', '47 Phan Đình Phùng, Phường 17, Quận Phú Nhuận, TP.HCM', '0305440189', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(708, 'CUS_0000000385', 'CÔNG TY TNHH CĂN HỘ CAO CẤP ĐĂKLẮK - NHẬT BẢN', '149 Nguyễn Đình Chiểu,Phường 6, Quận 3. TP.HCM', '0300605888', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(709, 'CUS_0000000386', 'CHI NHÁNH CÔNG TY TNHH DU LỊCH H.I.S SÔNG HÀN VIỆT NAM TẠI TP.HCM', 'Lâù 5,186-188 Lê Thánh Tôn, P.Bến Thành, Q.1,Tp.HCM', '0400542293-001', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(710, 'CUS_0000000387', 'CHI NHÁNH CÔNG TY TNHH KDDI VIỆT NAM TẠI TP.HCM', '26-28 Hàm Nghi, P. Bến Nghé, Quận 1, TP. HCM', '0100971460001', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(711, 'CUS_0000000390', 'CÔNG TY TNHH MTV XNK MAY MẶC THANH THÚY', '46 Bùi Đình Túy, Phường 12, Quận Bình Thạnh, TP.HCM', '0309243368', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(712, 'CUS_0000000391', 'CÔNG TY TNHH SHINKAWA VIỆT NAM', 'Tầng 3, Tòa nhà Anna, Khu phần mềm Quang Trung, P. Tân Chánh Hiệp, Q. 12, TP. HCM', '0308956750', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(713, 'CUS_0000000392', 'CÔNG TY TNHH KIM TRƯỜNG PHÚC', '313/8 Khu Phố 5B, P.Tân Biên, Biên Hòa, Đồng Nai', '3601048121', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(714, 'CUS_0000000393', 'VPĐD SUHEUNG CAPSULE', '243/1/26 Tô Hiến Thành, Phường 13, Quận 10, TP. HCM', 'Không có MST', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(715, 'CUS_0000000394', 'Công ty LD Happy Songlim', 'Lô CR3-3 Đô thị mới nam thành phố, P.Tân Phú, Quận 7', '0304763596', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(716, 'CUS_0000000395', 'Công ty TNHH LD Beautiful SaiGon', 'Số 77, đường Hoàng Văn Thái, P.Tân Phú, Quận 7', '0304829800', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(717, 'CUS_0000000397', 'CÔNG TY TNHH CHẾ BIẾN THỰC PHẨM HOA SEN', 'Lô 29-31 KCN Tân Tạo, Đường Tân Tạo, P.Tân Tạo A, Q.Bình Tân', '0304485853', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(718, 'CUS_0000000398', 'TRẠM BẢO HÀNH MÁY MAY BROTHER', '171 Xuân Hồng, Phường 12, Quận Tân Bình, TP.HCM', '0300401524', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(719, 'CUS_0000000400', 'CHI NHÁNH CÔNG TY TNHH VẬN TẢI HỖN HỢP VIỆT NHẬT SỐ 1', 'Số 1, Đường 38, Phường Thảo Điền, Quận 2, TP.HCM', '0100113769001', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(720, 'CUS_0000000403', 'CÔNG TY TNHH UNICARE', '168 Phan Xích Long, Phường 2, Quận Phú Nhuận', '0304246661', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(721, 'CUS_0000000404', 'CÔNG TY TNHH MỘT THÀNH VIÊN TOKYO BEAUTY VIỆT NAM', '67 Bis Trương Định, Phường 6, Quận 3, TP.HCM', '0309299603', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(722, 'CUS_0000000405', 'CÔNG TY TNHH TODA VIỆT NAM', 'P.117, Số 243-243B Hoàng Văn Thụ, Phường 1, Quận Tân Bình, TP.HCM', '0309323045', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(723, 'CUS_0000000406', 'CÔNG TY TNHH SẢN PHẨM GIẤY NHÔM TOYO (VIỆT)', 'Đường A, Khu công nghiệp Bình Chiểu, Q.Thủ Đức', '0300736665', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(724, 'CUS_0000000407', 'CÔNG TY TNHH NHÀ HÀNG AN BÌNH', '14E15 Đường Thảo Điền ,P.Thảo Điền ,Q.2,TP.HCM', '0305149685', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(725, 'CUS_0000000410', 'CALPIS CO.,LTD - HCMC REP OFFICE', '10th Floor, Itaxa Building,126 Nguyen Thi Minh Khai Str, Ward 6, Dist 3, HCMC', '0306182004', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(726, 'CUS_0000000412', 'CÔNG TY TNHH FUJI MOLD VIETNAM', 'Lô F-8A, KCN Nomura, Quán Toan, Hải Phòng', '0200468331', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:28', 0, '2010-06-21 00:48:28'),
(727, 'CUS_0000000418', 'GANNON VIETNAM CO., LTD', '198 Nam Kỳ Khởi Nghĩa, P.6, Q.3, TP. HCM', '0302137360', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(728, 'CUS_0000000419', 'CÔNG TY TNHH CUBE SYSTEM VIỆT NAM', 'Tầng 6,Tòa nhà JVPE,Công viên Phần Mềm Quang Trung,P.Tân Chánh Hiệp,Q.12,TP.HCM', '0305617830', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(729, 'CUS_0000000421', 'JICA - HCMUT PROJECT TEAM', 'R401-403, A4,HCMUT,268 Ly Thuong Kiet, Dist 10, HCMC', 'Không có MST', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(730, 'CUS_0000000427', 'CÔNG TY TNHH CN XD VÀ TM HÒA THẮNG', '314 Võ Văn Ngân, Phường Bình Thọ, Q.Thủ Đức, Tp.HCM', '0309381921', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(731, 'CUS_0000000429', 'HONGAHNH ART CO.,LTD', '39 Bis Đường Đặng Dung, P. Tân Định, Quận 1, Tp.HCM', '', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(732, 'CUS_0000000430', 'CÔNG TY TNHH KIỂM TOÁN SCS GLOBAL', 'P.1503, Tầng 15, Tòa nhà VIT , 519 Kim Mã, Q. Ba Đình, Hà Nội', '0103021019', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(733, 'CUS_0000000431', 'CÔNG TY TNHH CƠ KHÍ CHÍNH XÁC MIEN HUA', 'Quốc lộ 1, Xã Khánh Hậu, Thị Xã Tân An, Long Thành', '1100499578', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(734, 'CUS_0000000432', 'CÔNG TY TNHH SX & TM TRANG TRÍ NỘI THẤT ĐÔNG GIA', '53 Ngô Gia Tự, Quận 10, Tp.HCM', '0302566377', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(735, 'CUS_0000000433', 'DOANH NGHIỆP TƯ NHÂN TRẦN NGUYỄN', '68/33 Trần Nhân Tôn, Phường 2, Quận 10, TP.HCM', '0304491328', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(736, 'CUS_0000000434', 'CÔNG TY CỔ PHẦN CHINA STEEL SUMIKIN VIỆT NAM', 'KCN Mỹ Xuân A2, Xã Mỹ Xuân, Huyện Tân Thành, Tỉnh Bà Rịa - Vũng Tàu', '3501382588', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(737, 'CUS_0000000435', 'CÔNG TY TNHH KIWA INDUSTRY', '233/1 Nguyễn Bính, xã Phú Xuân, Huyện Nhà Bè, TP.HCM', '0303676894', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(738, 'CUS_0000000436', 'CÔNG TY CỔ PHẦN XÂY DỰNG THƯƠNG MẠI ĐẦU TƯ VIỆT MỸ', '359 Điện Biên Phủ, Quận 3, TP.HCM', '0303811991', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(739, 'CUS_0000000437', 'VPĐD MORITO', 'D004 Nguyễn Bính ,Mỹ Phước , Phú Mỹ Hưng, P. Tân  Phong, Q.7, TP.HCM', '0306266656', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(740, 'CUS_0000000439', 'CÔNG TY TNHH POU YUEN VIỆT NAM', 'D10/89Q, Quốc lộ 1A, Phường Tân Tạo, Quận Tân Bình, TP.HCM', '0300813662', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(741, 'CUS_0000000440', 'CÔNG TY TNHH TM - DV HƯNG BÌNH', '71/10/03 Đường 4, KP 2, Phường Linh Tây, Quận Thủ Đức, TP.HCM', '305493776', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(742, 'CUS_0000000442', 'Công ty Cổ Phần Quảng Cáo Cộng Thêm', '26-28 Hàm Nghi, P. Bến Nghé, Quận 1, TP. HCM', '0307806625', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(743, 'CUS_0000000443', 'Chi nhánh tại TP.HCM Cty Cổ Phần Crown Line (TP.Hà Nội)', 'Tòa nhà IES Số 53/10 Trần Khánh Dư, P.Tân Định, Quận 1, TP.HCM', '0103924532-001', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(744, 'CUS_0000000444', 'Công ty TNHH Cảng Quốc Tế Tân Cảng - Cái Mép', 'Xã Tân Phước, Huyện Tân Thành, Tỉnh Bà Rịa - Vũng Tàu', '3501473524', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(745, 'CUS_0000000447', 'NIPPON MANUFACTURING SERVICE VIETNAM', 'Ground Floor, Sogetraco Building, 30 Dang Van Ngu St., Ward 10, Phu Nhuan Dist., HCMC.', '', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(746, 'CUS_0000000448', 'CÔNG TY TNHH DATALOGIC SCANNING VIETNAM', 'Lô I-4b Khu công nghệ cao TP.HCM, Quận 9, TP.HCM', '0306686509', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(747, 'CUS_0000000450', 'Công ty CP Thiết Kế Kiến Trúc và Xây Dựng Tân Kỷ Nguyên', '276PC7 Nguyễn Tất Thành, Phường 13, Quận 4, TP.HCM', '0309444956', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(748, 'CUS_0000000449', 'CÔNG TY TNHH MỘT THÀNH VIÊN ALLEXCEED VIETNAM', 'Lầu 8, Tòa nhà LANT, 56-58-60 Hai Bà Trưng, Phường Bến Nghé, Quận 1, TP.HCM', '', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(749, 'CUS_0000000453', 'CÔNG TY TNHH SAN VI', '181/4 Trần Kế Xương, P. 7, Q. Phú Nhuận, TP. HCM', '0301937607', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(750, 'CUS_0000000452', 'CÔNG TY TNHH MTV THƯƠNG MẠI DU LỊCH BẦU TRỜI CAM', 'P.502 Lầu 5, 91 Ký Con, Phường Nguyễn Thái Bình, Quận 1, TP.HCM', '0309456976', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(751, 'CUS_0000000454', 'CÔNG TY CỔ PHẦN XÂY DỰNG TIẾN THÀNH', '29/2 Đường số 15, Phường Hiệp Bình Chánh, Quận Thủ Đức, TP.HCM', '0303901194', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(752, 'CUS_0000000455', 'CÔNG TY TNHH ICHIHIRO VIỆT NAM', 'Lô 103, KCX và Công Nghiệp Linh Trung III, Huyện Trảng Bàng, Tỉnh Tây Ninh', '3900377597', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(753, 'CUS_0000000458', 'CÔNG TY LUẬT TNHH JS HORIZON VIỆT NAM', 'Phòng 2205, Saigon Trade Center, 37 Tôn Đức Thắng, Quận 1, TP.HCM', '0305165912', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(754, 'CUS_0000000459', 'CÔNG TY TNHH MTV MỸ NHÂN', '117 Võ Văn Tần, Phường 6, Quận 3, TP.HCM', '0309455394', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(755, 'CUS_0000000461', 'VPĐD CÔNG TY METAWATER', 'Lầu 6, Tòa nhà MELINH POINT, Số 2 Ngô Đức Kế, Quận 1, TP.HCM', 'Không có MST', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(756, 'CUS_0000000460', 'CÔNG TY TNHH TRỒNG RỪNG CHÂU Á', 'Thửa đất số 381, Khu phố 8, Gia Ray Commune, Xuân Lộc Ward, Đồng Nai Province', '3600751162', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(757, 'CUS_0000000463', 'CÔNG TY TNHH CUỘC SỐNG CHÂU Á XUẤT SẮC', '22B Lam Sơn, Phường 2, Quận Tân Bình, TP.HCM', '0307066353', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(758, 'CUS_0000000464', 'CÔNG TY TNHH MTV LAI VIÊN', '58/22 Nguyễn Bỉnh Khiêm, Phường Đa Kao, Quận 1, TP.HCM', '0309266069', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(759, 'CUS_0000000466', 'CÔNG TY TNHH TM - DV - VẬN TẢI THIÊN ĐẠT', '30/9 Đường 176, KP2, Phường Phước Long A, Quận  9, TP. HCM', '0305179834', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(760, 'CUS_0000000465', 'CÔNG TY TNHH NISSEI ELECTRIC VIETNAM', 'Lô 95-96-97 KCX Saigon Linh Trung I, Quận Thủ Đức, TP.HCM', '0301864878', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(761, 'CUS_0000000467', 'CÔNG TY TNHH BẢO HIỂM NHÂN THỌ DAI-ICHI VIETNAM', '2A-4A Tôn Đức Thắng, Quận 1, TP.HCM', '0301851276', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(762, 'CUS_0000000468', 'CÔNG TY TNHH MỘT THÀNH VIÊN KIM THỦY MỘC', '30 Thái Văn Lung, Phường Bến Nghé, Quận 1, TP.HCM', '0309514000', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(763, 'CUS_0000000469', 'CÔNG TY TNHH GIA ĐÌNH', '69 đường  Nguyễn Khắc Nhu, P.Cô Giang ,Q.1, TP HCM', '0309454665', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(764, 'CUS_0000000488', 'VĂN PHÒNG ĐẠI DIỆN  CÔNG TY CỔ PHẦN AEON MALL CO.,LTD', 'Phòng 34A,Lầu 31,Saigon Trade Center,37 Tôn đức Thắng ,P.Bến Nghé ,Q.1,TPHCM', '0309669276', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(765, 'CUS_0000000487', 'VĂN PHÒNG ĐẠI DIỆN  CÔNG TY CỔ PHẦN AEON  CO.,LTD', 'Phòng 34A,Lầu 31,Saigon Trade Center,37 Tôn đức Thắng ,P.Bến Nghé ,Q.1,TPHCM', '0309726340', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(766, 'CUS_0000000491', 'CÔNG TY JACCS CO.,LTD', '115 NGUYỄN HUỆ ,QUẬN 1,TP.HCM', '', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(767, 'CUS_0000000492', 'CÔNG TY PHÁT TRIỂN PHẦN MỀM XÂY DỰNG AUREOLE', 'P.1906 ,Lầu 19,115 Nguyễn Huệ ,Q.1,TP.HCM', '0302260501', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(768, 'CUS_0000000494', 'CÔNG TY TNHH MẠNH TRƯỜNG BÌNH', '12 Phan Kế Bính ,Ba Đình ,Hà Nội', '0101290520', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(769, 'CUS_0000000498', 'CÔNG TY TNHH KI-MÔ-NÔ-E NHẬT', 'Lô IV.2,Nhóm CN IV,Đường số 5,KCN Tân Bình ,Q.Tân Phú ,TP.HCM', '0304655752', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(770, 'CUS_0000000502', 'CÔNG TY CP ĐẦU TƯ THƯƠNG MẠI THẾ GIỚI', '193B Nam Kỳ Khởi Nghĩa ,P.7,Q.3 ,TP.HCM', '0309589119', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(771, 'CUS_0000000506', 'ISHIDA CO.,LTD.VIETNAM REPRESENTATIVE OFFICE', 'SA1-1,Parcel S19-2,My Khang Complex,Phú Mỹ Hưng ,P.Tân Phú ,Q.7,TPHCM', '', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(772, 'CUS_0000000496', 'CÔNG TY TNHH MTV DỊCH VỤ TV-TM BÁCH TÙNG BẢN', '117/54 Nguyễn Hữu Cảnh ,Phường 22,Q.Bình Thạnh ,TP.HCM', '', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(773, 'CUS_0000000507', 'Planning YOSHI Ltd', 'R201,37A Phan Xchi Long ST, Phu Nhuân Dist, HCM', '', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(774, 'CUS_0000000514', 'VPDD Canon Singapore tai Tp. HCM', 'Tang 6, SaiGon Centre, 65 Le Loi, Q1', '0304656227', '', '', '', 0, 0, 0, 0, 1, 0, 0, 0, 0, '2010-06-21 00:48:29', 0, '2010-06-21 00:48:29'),
(775, 'SUM', 'Ngân hàng Sumitomo', '5B Tôn Đức Thắng, Q1, TPHCM', '33333333333333', '', '', '', 1, 0, 0, 0, 0, 0, 1, 0, 1, '2010-07-23 14:59:31', 1, '2010-07-23 15:00:11');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_table`
--

DROP TABLE IF EXISTS `definition_list_table`;
CREATE TABLE IF NOT EXISTS `definition_list_table` (
  `table_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `table_name` varchar(50) NOT NULL,
  `column_key` varchar(50) NOT NULL COMMENT 'Primary key of table',
  `column_display` varchar(50) NOT NULL,
  `column_name` varchar(50) CHARACTER SET latin1 NOT NULL,
  `description` varchar(100) NOT NULL,
  `inactive` tinyint(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`table_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=29 ;

--
-- Dumping data for table `definition_list_table`
--

INSERT INTO `definition_list_table` (`table_id`, `table_name`, `column_key`, `column_display`, `column_name`, `description`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, 'definition_list_currency', 'currency_id', 'currency_name', '', 'Chi tiết theo loại tiền tệ', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(2, 'definition_list_department', 'department_id', 'department_name', '', 'Chi tiết theo phòng ban', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(3, 'definition_list_product', 'product_id', 'product_name', '', 'Chi tiết theo sản phẩm', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, 'definition_list_staff', 'staff_id', 'last_name', '', 'Chi tiết theo nhân viên', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(5, 'definition_list_subject', 'subject_id', 'subject_name', 'is_bank', 'Chi tiết theo ngân hàng', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(6, 'definition_list_subject', 'subject_id', 'subject_name', 'is_supplier', 'Chi tiết theo nhà cung cấp', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(7, 'definition_list_subject', 'subject_id', 'subject_name', 'is_customer', 'Chi tiết theo khách hàng', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(8, 'accountant_list_expense', 'expense_id', 'expense_name', 'for_wage', 'Chi tiết theo chi phí nhân công, nhân viên', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(9, 'accountant_list_expense', 'expense_id', 'expense_name', 'for_tool', 'Chi tiết theo chi phí dụng cụ, đồ dùng', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(10, 'accountant_list_expense', 'expense_id', 'expense_name', 'for_depreciation', 'Chi tiết theo chi phí khấu hao', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(11, 'accountant_list_expense', 'expense_id', 'expense_name', 'for_services', 'Chi tiết theo chi phí dịch vụ mua ngoài', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(12, 'accountant_list_expense', 'expense_id', 'expense_name', 'for_rest', 'Chi tiết theo chi phí khác', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(13, 'accountant_list_expense', 'expense_id', 'expense_name', 'for_sales', 'Chi tiết theo chi phí bán hàng', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(14, 'accountant_list_expense', 'expense_id', 'expense_name', 'for_management', 'Chi tiết theo chi phí quản lý', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(15, 'accountant_list_expense', 'expense_id', 'expense_name', 'for_fee', 'Chi tiết theo thuế, phí, lệ phí', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(16, 'accountant_list_expense', 'expense_id', 'expense_name', 'finance_cost', 'Chi tiết theo chi phí tài chính', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(17, 'definition_list_unit', 'unit_id', 'unit_name', '', 'Chi tiết theo đơn vị tính', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(18, 'accountant_list_expense', 'expense_id', 'expense_name', '', 'Chi tiết theo chi phí', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(19, 'accountant_assets_voucher', 'assets_voucher_id', 'assets_name', '', 'Chi tiết theo tài sản cố định', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(20, 'definition_list_product', 'product_id', 'product_name', 'is_tool', 'Chi tiết theo công cụ, dụng cụ', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(21, 'accountant_bank_account', 'bank_account_id', 'bank_account_number', '', 'Chi tiết theo tài khoản ngân hàng', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(22, 'definition_list_subject', 'subject_id', 'subject_name', 'is_government', 'Chi tiết theo từng cơ quan nhà nước', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(23, 'accountant_payable_type', 'payable_type_id', 'payable_type_name', '', 'Chi tiết theo loại phải trả', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(24, 'accountant_list_tax', 'tax_id', 'tax_name', '', 'Chi tiết theo loại thuế', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(25, 'accountant_receivable_type', 'receivable_type_id', 'receivable_type_name', '', 'Chi tiết theo loại phải thu', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(26, 'definition_list_warehouse', 'warehouse_id', 'warehouse_name', '', 'Chi tiết theo kho hàng', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(27, 'definition_list_subject', 'subject_id', 'subject_name', '', 'Chi tiết theo đối tượng', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(28, 'definition_list_service', 'service_id', 'service_name', '', 'Chi tiết theo dịch vụ', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_term`
--

DROP TABLE IF EXISTS `definition_list_term`;
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `definition_list_term`
--

INSERT INTO `definition_list_term` (`term_id`, `term_name`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, 'Mức độ quan trọng', 0, 0, '2010-06-15 14:38:00', 0, '2010-06-15 14:38:28'),
(2, 'Doanh số', 0, 0, '2010-06-15 14:38:07', 0, '2010-06-15 14:38:42');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_unit`
--

DROP TABLE IF EXISTS `definition_list_unit`;
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=189 ;

--
-- Dumping data for table `definition_list_unit`
--

INSERT INTO `definition_list_unit` (`unit_id`, `unit_code`, `unit_name`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, '', '', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(1, 'cái', 'cái', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(2, 'm', 'mét', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(3, 'kg', 'kí lô gam', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(4, '', 'cuộn', 0, 0, '2010-06-17 13:32:35', 0, '2010-06-17 13:32:35'),
(5, '', '12 cuộn/ cây', 0, 0, '2010-06-17 13:32:36', 0, '2010-06-17 13:32:36'),
(6, '', '10cuộn/ cây', 0, 0, '2010-06-17 13:32:36', 0, '2010-06-17 13:32:36'),
(7, '', 'tube', 0, 0, '2010-06-17 13:32:38', 0, '2010-06-17 13:32:38'),
(8, '', 'bình', 0, 0, '2010-06-17 13:32:38', 0, '2010-06-17 13:32:38'),
(9, '', 'chai', 0, 0, '2010-06-17 13:32:38', 0, '2010-06-17 13:32:38'),
(10, '', 'cây', 0, 0, '2010-06-17 13:32:38', 0, '2010-06-17 13:32:38'),
(11, '', 'lọ', 0, 0, '2010-06-17 13:32:38', 0, '2010-06-17 13:32:38'),
(12, '', '100 cái/hộp', 0, 0, '2010-06-17 13:32:39', 0, '2010-06-17 13:32:39'),
(13, '', '35 cái/hộp', 0, 0, '2010-06-17 13:32:39', 0, '2010-06-17 13:32:39'),
(14, '', '24 cái/hộp', 0, 0, '2010-06-17 13:32:39', 0, '2010-06-17 13:32:39'),
(15, '', '12 cái/hộp', 0, 0, '2010-06-17 13:32:39', 0, '2010-06-17 13:32:39'),
(16, '', 'hộp', 0, 0, '2010-06-17 13:32:39', 0, '2010-06-17 13:32:39'),
(17, '', '10 cái/hộp', 0, 0, '2010-06-17 13:32:41', 0, '2010-06-17 13:32:41'),
(18, '', 'tấm', 0, 0, '2010-06-17 13:32:41', 0, '2010-06-17 13:32:41'),
(19, '', 'hộ', 0, 0, '2010-06-17 13:32:42', 0, '2010-06-17 13:32:42'),
(20, '', 'con', 0, 0, '2010-06-17 13:32:47', 0, '2010-06-17 13:32:47'),
(21, '', '10 cái/bao', 0, 0, '2010-06-17 13:32:48', 0, '2010-06-17 13:32:48'),
(22, '', '10 cái/ bao', 0, 0, '2010-06-17 13:32:48', 0, '2010-06-17 13:32:48'),
(23, '', '2 cái/ bộ', 0, 0, '2010-06-17 13:32:48', 0, '2010-06-17 13:32:48'),
(24, '', 'bộ', 0, 0, '2010-06-17 13:32:49', 0, '2010-06-17 13:32:49'),
(25, '', 'quyển', 0, 0, '2010-06-17 13:32:50', 0, '2010-06-17 13:32:50'),
(26, '', '12 tờ/bao', 0, 0, '2010-06-17 13:32:52', 0, '2010-06-17 13:32:52'),
(27, '', '4xấp/bao', 0, 0, '2010-06-17 13:32:52', 0, '2010-06-17 13:32:52'),
(28, '', '1xấp/bao', 0, 0, '2010-06-17 13:32:52', 0, '2010-06-17 13:32:52'),
(29, '', 'xấp', 0, 0, '2010-06-17 13:32:52', 0, '2010-06-17 13:32:52'),
(30, '', '10 tờ/ xấp', 0, 0, '2010-06-17 13:32:52', 0, '2010-06-17 13:32:52'),
(31, '', 'xấp 50 tờ', 0, 0, '2010-06-17 13:32:53', 0, '2010-06-17 13:32:53'),
(32, '', 'gói 4 xấp', 0, 0, '2010-06-17 13:32:53', 0, '2010-06-17 13:32:53'),
(33, '', 'gói 2 xấp', 0, 0, '2010-06-17 13:32:53', 0, '2010-06-17 13:32:53'),
(34, '', 'gói 5 xấp', 0, 0, '2010-06-17 13:32:53', 0, '2010-06-17 13:32:53'),
(35, '', 'vỉ', 0, 0, '2010-06-17 13:32:53', 0, '2010-06-17 13:32:53'),
(36, '', '50 tờ/xấp', 0, 0, '2010-06-17 13:32:54', 0, '2010-06-17 13:32:54'),
(37, '', 'tờ', 0, 0, '2010-06-17 13:32:54', 0, '2010-06-17 13:32:54'),
(38, '', 'xấp 50 cái', 0, 0, '2010-06-17 13:32:55', 0, '2010-06-17 13:32:55'),
(39, '', 'xấp 100 cái', 0, 0, '2010-06-17 13:32:55', 0, '2010-06-17 13:32:55'),
(40, '', 'xấp 100 tờ', 0, 0, '2010-06-17 13:32:56', 0, '2010-06-17 13:32:56'),
(41, '', '100 tờ/hộp', 0, 0, '2010-06-17 13:32:56', 0, '2010-06-17 13:32:56'),
(42, '', 'ống', 0, 0, '2010-06-17 13:32:58', 0, '2010-06-17 13:32:58'),
(43, '', '12/tube', 0, 0, '2010-06-17 13:32:59', 0, '2010-06-17 13:32:59'),
(44, '', '1 ống 40 thanh', 0, 0, '2010-06-17 13:32:59', 0, '2010-06-17 13:32:59'),
(45, '', 'vỉ 24 thanh', 0, 0, '2010-06-17 13:32:59', 0, '2010-06-17 13:32:59'),
(46, '', 'cục', 0, 0, '2010-06-17 13:32:59', 0, '2010-06-17 13:32:59'),
(47, '', '20 thanh/ống', 0, 0, '2010-06-17 13:33:00', 0, '2010-06-17 13:33:00'),
(48, '', 'vỉ 2 ống 24', 0, 0, '2010-06-17 13:33:00', 0, '2010-06-17 13:33:00'),
(49, '', 'viên', 0, 0, '2010-06-17 13:33:01', 0, '2010-06-17 13:33:01'),
(50, '', '12cây/vỉ', 0, 0, '2010-06-17 13:33:09', 0, '2010-06-17 13:33:09'),
(51, '', 'bộ10 cái', 0, 0, '2010-06-17 13:33:17', 0, '2010-06-17 13:33:17'),
(52, '', '50 cái/hộp', 0, 0, '2010-06-17 13:33:17', 0, '2010-06-17 13:33:17'),
(53, '', 'bộ 6 trang', 0, 0, '2010-06-17 13:33:17', 0, '2010-06-17 13:33:17'),
(54, '', 'bộ 12 trang', 0, 0, '2010-06-17 13:33:17', 0, '2010-06-17 13:33:17'),
(55, '', '500 cái/hộp', 0, 0, '2010-06-17 13:33:17', 0, '2010-06-17 13:33:17'),
(56, '', '100 cái /bao', 0, 0, '2010-06-17 13:33:17', 0, '2010-06-17 13:33:17'),
(57, '', '100tờ/xấp', 0, 0, '2010-06-17 13:33:17', 0, '2010-06-17 13:33:17'),
(58, '', '4 cái/vỉ', 0, 0, '2010-06-17 13:33:24', 0, '2010-06-17 13:33:24'),
(59, '', 'bao 20 cái', 0, 0, '2010-06-17 13:33:25', 0, '2010-06-17 13:33:25'),
(60, '', 'vỉ 5 cái', 0, 0, '2010-06-17 13:33:26', 0, '2010-06-17 13:33:26'),
(61, '', 'vỉ 4 cái', 0, 0, '2010-06-17 13:33:26', 0, '2010-06-17 13:33:26'),
(62, '', 'vỉ 10 cái', 0, 0, '2010-06-17 13:33:26', 0, '2010-06-17 13:33:26'),
(63, '', 'thanh', 0, 0, '2010-06-17 13:33:26', 0, '2010-06-17 13:33:27'),
(64, '', '500gr', 0, 0, '2010-06-17 13:33:28', 0, '2010-06-17 13:33:28'),
(65, '', '9m/ cuộn', 0, 0, '2010-06-17 13:33:31', 0, '2010-06-17 13:33:31'),
(66, '', '500 tờ', 0, 0, '2010-06-17 13:33:32', 0, '2010-06-17 13:33:32'),
(67, '', '100 tờ/xấp', 0, 0, '2010-06-17 13:33:32', 0, '2010-06-17 13:33:32'),
(68, '', '20 tờ/xấp', 0, 0, '2010-06-17 13:33:33', 0, '2010-06-17 13:33:33'),
(69, '', '500 tờ/grm', 0, 0, '2010-06-17 13:33:33', 0, '2010-06-17 13:33:33'),
(70, '', '250 tờ/xấp', 0, 0, '2010-06-17 13:33:33', 0, '2010-06-17 13:33:33'),
(71, '', '500 tờ/gsm', 0, 0, '2010-06-17 13:33:34', 0, '2010-06-17 13:33:34'),
(72, '', 'ram', 0, 0, '2010-06-17 13:33:34', 0, '2010-06-17 13:33:34'),
(73, '', '500tờ/gsm', 0, 0, '2010-06-17 13:33:34', 0, '2010-06-17 13:33:34'),
(74, '', '1000 tờ/xấp', 0, 0, '2010-06-17 13:33:34', 0, '2010-06-17 13:33:34'),
(75, '', '20 tờ/bao', 0, 0, '2010-06-17 13:33:34', 0, '2010-06-17 13:33:34'),
(76, '', 'hộp 10 cái', 0, 0, '2010-06-17 13:33:37', 0, '2010-06-17 13:33:37'),
(77, '', '3 quyển/hộp', 0, 0, '2010-06-17 13:33:38', 0, '2010-06-17 13:33:38'),
(78, '', 'hộp 50 cái', 0, 0, '2010-06-17 13:33:38', 0, '2010-06-17 13:33:38'),
(79, '', '100 bộ', 0, 0, '2010-06-17 13:33:40', 0, '2010-06-17 13:33:40'),
(80, '', '100 cái/lốc', 0, 0, '2010-06-17 13:33:42', 0, '2010-06-17 13:33:42'),
(81, '', '100 sợi/bao', 0, 0, '2010-06-17 13:33:42', 0, '2010-06-17 13:33:42'),
(82, '', '85 sợi', 0, 0, '2010-06-17 13:33:43', 0, '2010-06-17 13:33:43'),
(83, '', '100 sợi/ bao', 0, 0, '2010-06-17 13:33:43', 0, '2010-06-17 13:33:43'),
(84, '', 'bóng', 0, 0, '2010-06-17 13:33:43', 0, '2010-06-17 13:33:43'),
(85, '', '2 cục', 0, 0, '2010-06-17 13:33:44', 0, '2010-06-17 13:33:44'),
(86, '', '4 viên /vỉ', 0, 0, '2010-06-17 13:33:44', 0, '2010-06-17 13:33:44'),
(87, '', '2 cục/vỉ', 0, 0, '2010-06-17 13:33:44', 0, '2010-06-17 13:33:44'),
(88, '', '4 cục/vỉ', 0, 0, '2010-06-17 13:33:44', 0, '2010-06-17 13:33:44'),
(89, '', '2 cục /vỉ', 0, 0, '2010-06-17 13:33:44', 0, '2010-06-17 13:33:44'),
(90, '', '4 viên/vỉ', 0, 0, '2010-06-17 13:33:44', 0, '2010-06-17 13:33:44'),
(91, '', '2 viên/vỉ', 0, 0, '2010-06-17 13:33:44', 0, '2010-06-17 13:33:44'),
(92, '', '4 cục /vỉ', 0, 0, '2010-06-17 13:33:45', 0, '2010-06-17 13:33:45'),
(93, '', '2cục/vỉ', 0, 0, '2010-06-17 13:33:45', 0, '2010-06-17 13:33:45'),
(94, '', 'sợi', 0, 0, '2010-06-17 13:33:46', 0, '2010-06-17 13:33:46'),
(95, '', '50 cái/bao', 0, 0, '2010-06-17 13:33:47', 0, '2010-06-17 13:33:47'),
(96, '', '50cái/lốc', 0, 0, '2010-06-17 13:33:47', 0, '2010-06-17 13:33:47'),
(97, '', 'bao', 0, 0, '2010-06-17 13:33:47', 0, '2010-06-17 13:33:47'),
(98, '', '24 gói/bao', 0, 0, '2010-06-17 13:33:47', 0, '2010-06-17 13:33:47'),
(99, '', '18 gói/hộp', 0, 0, '2010-06-17 13:33:47', 0, '2010-06-17 13:33:47'),
(100, '', 'hộp 500g', 0, 0, '2010-06-17 13:33:48', 0, '2010-06-17 13:33:48'),
(101, '', 'lon', 0, 0, '2010-06-17 13:33:48', 0, '2010-06-17 13:33:48'),
(102, '', 'bịch', 0, 0, '2010-06-17 13:33:48', 0, '2010-06-17 13:33:48'),
(103, '', 'gói', 0, 0, '2010-06-17 13:33:48', 0, '2010-06-17 13:33:48'),
(104, '', 'thùng', 0, 0, '2010-06-17 13:33:48', 0, '2010-06-17 13:33:48'),
(105, '', 'gói 100gr', 0, 0, '2010-06-17 13:33:48', 0, '2010-06-17 13:33:48'),
(106, '', 'thùng 24 chai', 0, 0, '2010-06-17 13:33:49', 0, '2010-06-17 13:33:49'),
(107, '', '24 chai/thung', 0, 0, '2010-06-17 13:33:49', 0, '2010-06-17 13:33:49'),
(108, '', '24 lon/thùng', 0, 0, '2010-06-17 13:33:49', 0, '2010-06-17 13:33:49'),
(109, '', 'lốc 6 hộp', 0, 0, '2010-06-17 13:33:49', 0, '2010-06-17 13:33:49'),
(110, '', 'lốc 6 lon', 0, 0, '2010-06-17 13:33:50', 0, '2010-06-17 13:33:50'),
(111, '', '48hộp/thùng', 0, 0, '2010-06-17 13:33:50', 0, '2010-06-17 13:33:50'),
(112, '', 'kg', 0, 0, '2010-06-17 13:33:50', 0, '2010-06-17 13:33:50'),
(113, '', '6cái/hộp', 0, 0, '2010-06-17 13:33:50', 0, '2010-06-17 13:33:50'),
(114, '', '6 cây/bộ', 0, 0, '2010-06-17 13:33:51', 0, '2010-06-17 13:33:51'),
(115, '', 'bao 50 cái', 0, 0, '2010-06-17 13:33:51', 0, '2010-06-17 13:33:51'),
(116, '', '6cây/vỉ', 0, 0, '2010-06-17 13:33:52', 0, '2010-06-17 13:33:52'),
(117, '', 'cặp', 0, 0, '2010-06-17 13:33:54', 0, '2010-06-17 13:33:54'),
(118, '', 'miếng', 0, 0, '2010-06-17 13:33:56', 0, '2010-06-17 13:33:56'),
(119, '', 'gói 3 miếng', 0, 0, '2010-06-17 13:33:56', 0, '2010-06-17 13:33:56'),
(120, '', '3miếng/gói', 0, 0, '2010-06-17 13:33:57', 0, '2010-06-17 13:33:57'),
(121, '', 'gói12 miếng', 0, 0, '2010-06-17 13:33:57', 0, '2010-06-17 13:33:57'),
(122, '', '100gr/bao', 0, 0, '2010-06-17 13:33:57', 0, '2010-06-17 13:33:57'),
(123, '', '250gr/bao', 0, 0, '2010-06-17 13:33:57', 0, '2010-06-17 13:33:57'),
(124, '', '500gr/bao', 0, 0, '2010-06-17 13:33:57', 0, '2010-06-17 13:33:57'),
(125, '', '15 cái/ bao', 0, 0, '2010-06-17 13:33:59', 0, '2010-06-17 13:33:59'),
(126, '', '12 cuộn/bao', 0, 0, '2010-06-17 13:33:59', 0, '2010-06-17 13:33:59'),
(127, '', '10 cuộn/bao', 0, 0, '2010-06-17 13:33:59', 0, '2010-06-17 13:33:59'),
(128, '', '1 kg', 0, 0, '2010-06-17 13:34:00', 0, '2010-06-17 13:34:00'),
(129, '', '1 kg / 3 cuộn', 0, 0, '2010-06-17 13:34:00', 0, '2010-06-17 13:34:00'),
(130, '', 'đôi', 0, 0, '2010-06-17 13:34:01', 0, '2010-06-17 13:34:01'),
(131, '', '1 cái/vỉ', 0, 0, '2010-06-17 13:34:01', 0, '2010-06-17 13:34:01'),
(132, '', '5 cái/vỉ', 0, 0, '2010-06-17 13:34:01', 0, '2010-06-17 13:34:01'),
(133, '', '3 cái/vỉ', 0, 0, '2010-06-17 13:34:01', 0, '2010-06-17 13:34:01'),
(134, '', '2 cái/vỉ', 0, 0, '2010-06-17 13:34:01', 0, '2010-06-17 13:34:01'),
(135, '', '1 cái/bịch', 0, 0, '2010-06-17 13:34:02', 0, '2010-06-17 13:34:02'),
(136, '', '2 cái/bịch', 0, 0, '2010-06-17 13:34:02', 0, '2010-06-17 13:34:02'),
(137, '', '50 đôi/hộp', 0, 0, '2010-06-17 13:34:03', 0, '2010-06-17 13:34:03'),
(138, '', '50 cái/ hộp', 0, 0, '2010-06-17 13:34:04', 0, '2010-06-17 13:34:04'),
(139, '', '100 cái/gói', 0, 0, '2010-06-17 13:34:05', 0, '2010-06-17 13:34:05'),
(140, '', 'hộp 12 cây', 0, 0, '2010-06-17 13:34:07', 0, '2010-06-17 13:34:07'),
(141, '', '12 cây/hộp', 0, 0, '2010-06-17 13:34:10', 0, '2010-06-17 13:34:10'),
(142, '', '20 cây/hộp', 0, 0, '2010-06-17 13:34:10', 0, '2010-06-17 13:34:10'),
(143, '', '30 cây/hộp', 0, 0, '2010-06-17 13:34:11', 0, '2010-06-17 13:34:11'),
(144, '', '10 cây/hộp', 0, 0, '2010-06-17 13:34:12', 0, '2010-06-17 13:34:12'),
(145, '', '50 cây/hộp', 0, 0, '2010-06-17 13:34:12', 0, '2010-06-17 13:34:12'),
(146, '', '30cây/ hộp', 0, 0, '2010-06-17 13:34:12', 0, '2010-06-17 13:34:12'),
(147, '', '20cây/ lon', 0, 0, '2010-06-17 13:34:12', 0, '2010-06-17 13:34:12'),
(148, '', '30 cây/ rổ', 0, 0, '2010-06-17 13:34:12', 0, '2010-06-17 13:34:12'),
(149, '', '25 cây/ hộp', 0, 0, '2010-06-17 13:34:13', 0, '2010-06-17 13:34:13'),
(150, '', '20cây/ hộp', 0, 0, '2010-06-17 13:34:13', 0, '2010-06-17 13:34:13'),
(151, '', 'hộp/ 12 cây', 0, 0, '2010-06-17 13:34:13', 0, '2010-06-17 13:34:13'),
(152, '', '20 cây/ hộp', 0, 0, '2010-06-17 13:34:15', 0, '2010-06-17 13:34:15'),
(153, '', '12 cây/ hộp', 0, 0, '2010-06-17 13:34:15', 0, '2010-06-17 13:34:15'),
(154, '', '10 tép', 0, 0, '2010-06-17 13:34:16', 0, '2010-06-17 13:34:16'),
(155, '', '36 tép', 0, 0, '2010-06-17 13:34:16', 0, '2010-06-17 13:34:16'),
(156, '', '12 tép', 0, 0, '2010-06-17 13:34:16', 0, '2010-06-17 13:34:16'),
(157, '', '30 viên', 0, 0, '2010-06-17 13:34:16', 0, '2010-06-17 13:34:16'),
(158, '', '20 viên', 0, 0, '2010-06-17 13:34:16', 0, '2010-06-17 13:34:16'),
(159, '', '60 viên', 0, 0, '2010-06-17 13:34:16', 0, '2010-06-17 13:34:16'),
(160, '', '48 viên', 0, 0, '2010-06-17 13:34:16', 0, '2010-06-17 13:34:16'),
(161, '', '36 viên', 0, 0, '2010-06-17 13:34:16', 0, '2010-06-17 13:34:16'),
(162, '', '40 viên', 0, 0, '2010-06-17 13:34:17', 0, '2010-06-17 13:34:17'),
(163, '', '45 viên', 0, 0, '2010-06-17 13:34:17', 0, '2010-06-17 13:34:17'),
(164, '', '24 viên', 0, 0, '2010-06-17 13:34:17', 0, '2010-06-17 13:34:17'),
(165, '', '40 cái/hộp', 0, 0, '2010-06-17 13:34:17', 0, '2010-06-17 13:34:17'),
(166, '', '100 cái', 0, 0, '2010-06-17 13:34:17', 0, '2010-06-17 13:34:17'),
(167, '', '10 cây/ hộp', 0, 0, '2010-06-17 13:34:18', 0, '2010-06-17 13:34:18'),
(168, '', '5 cây/ vỉ', 0, 0, '2010-06-17 13:34:20', 0, '2010-06-17 13:34:20'),
(169, '', '12 cây / hộp', 0, 0, '2010-06-17 13:34:21', 0, '2010-06-17 13:34:21'),
(170, '', '12 cây', 0, 0, '2010-06-17 13:34:23', 0, '2010-06-17 13:34:23'),
(171, '', '10 xấp/ bao', 0, 0, '2010-06-17 13:34:25', 0, '2010-06-17 13:34:25'),
(172, '', '12 cái/ hộp', 0, 0, '2010-06-17 13:34:26', 0, '2010-06-17 13:34:26'),
(173, '', '10 cây/ bó', 0, 0, '2010-06-17 13:34:26', 0, '2010-06-17 13:34:26'),
(174, '', '5 cái/ lốc', 0, 0, '2010-06-17 13:34:26', 0, '2010-06-17 13:34:26'),
(175, '', '12 lọ/ lốc', 0, 0, '2010-06-17 13:34:26', 0, '2010-06-17 13:34:26'),
(176, '', '6 lọ/ lốc', 0, 0, '2010-06-17 13:34:26', 0, '2010-06-17 13:34:26'),
(177, '', '12 lọ/ khay', 0, 0, '2010-06-17 13:34:26', 0, '2010-06-17 13:34:26'),
(178, '', '30 thỏi/ hộp', 0, 0, '2010-06-17 13:34:26', 0, '2010-06-17 13:34:26'),
(179, '', '10 thỏi/ hộp', 0, 0, '2010-06-17 13:34:27', 0, '2010-06-17 13:34:27'),
(180, '', 'thùng / 12 cuộn', 0, 0, '2010-06-17 13:34:27', 0, '2010-06-17 13:34:27'),
(181, '', 'thùng / 48 cuộn', 0, 0, '2010-06-17 13:34:27', 0, '2010-06-17 13:34:27'),
(182, '', 'thùng / 50 cuộn', 0, 0, '2010-06-17 13:34:27', 0, '2010-06-17 13:34:27'),
(183, '', '50 con/ hộp', 0, 0, '2010-06-17 13:34:27', 0, '2010-06-17 13:34:27'),
(184, '', 'thùng/ 25 bóng', 0, 0, '2010-06-17 13:34:27', 0, '2010-06-17 13:34:27'),
(185, '', '4 cuộn', 0, 0, '2010-06-17 13:34:27', 0, '2010-06-17 13:34:27'),
(186, '', '96m', 0, 0, '2010-06-17 13:34:27', 0, '2010-06-17 13:34:27'),
(187, '', '50m', 0, 0, '2010-06-17 13:34:28', 0, '2010-06-17 13:34:28'),
(188, '', '1', 0, 0, '2010-06-17 13:34:28', 0, '2010-06-17 13:34:28');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_user`
--

DROP TABLE IF EXISTS `definition_list_user`;
CREATE TABLE IF NOT EXISTS `definition_list_user` (
  `user_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `staff_id` bigint(30) unsigned NOT NULL,
  `role_id` bigint(30) unsigned NOT NULL,
  `user_name` varchar(20) NOT NULL,
  `password` varchar(32) NOT NULL,
  `inactive` tinyint(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  `date_last_logined` datetime NOT NULL,
  `theme_type` varchar(20) NOT NULL,
  `screen_type` varchar(20) NOT NULL,
  PRIMARY KEY (`user_id`),
  KEY `fk_definition_list_user_definition_list_staff1` (`staff_id`),
  KEY `fk_definition_list_user_definition_list_role1` (`role_id`),
  KEY `fk_user_modified_user` (`last_modified_by_userid`),
  KEY `fk_user_created_user` (`created_by_userid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `definition_list_user`
--

INSERT INTO `definition_list_user` (`user_id`, `staff_id`, `role_id`, `user_name`, `password`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`, `date_last_logined`, `theme_type`, `screen_type`) VALUES
(0, 0, 0, 'nguoi_dung', '', 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00', '0000-00-00 00:00:00', '', ''),
(1, 3, 8, 'weberp', 'e10adc3949ba59abbe56e057f20f883e', 0, 0, '2010-07-13 20:54:01', 0, '2010-07-13 20:54:01', '2010-09-14 20:42:17', 'professional', 'horizontal'),
(2, 0, 0, '', '', 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', '0000-00-00 00:00:00', '', ''),
(3, 0, 0, '', '', 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', '0000-00-00 00:00:00', '', ''),
(4, 0, 0, '', '', 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00', '0000-00-00 00:00:00', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `definition_list_warehouse`
--

DROP TABLE IF EXISTS `definition_list_warehouse`;
CREATE TABLE IF NOT EXISTS `definition_list_warehouse` (
  `warehouse_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `warehouse_code` varchar(10) NOT NULL,
  `warehouse_name` varchar(100) NOT NULL,
  `warehouse_address` varchar(100) NOT NULL,
  `department_id` bigint(30) unsigned NOT NULL,
  `warehouse_type_id` bigint(30) unsigned NOT NULL,
  `inactive` tinyint(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`warehouse_id`),
  KEY `fk_warehouse_type` (`warehouse_type_id`),
  KEY `fk_warehouse_created_user` (`created_by_userid`),
  KEY `fk_warehouse_department` (`department_id`),
  KEY `fk_warehouse_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `definition_list_warehouse`
--

INSERT INTO `definition_list_warehouse` (`warehouse_id`, `warehouse_code`, `warehouse_name`, `warehouse_address`, `department_id`, `warehouse_type_id`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, '', '', '', 0, 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(1, 'THUDUC', 'Thủ Đức', 'Thủ Đức', 4, 1, 0, 0, '2010-06-29 16:36:21', 0, '2010-06-29 16:36:21'),
(2, 'HCM', 'Quận 1', 'Quận 1', 4, 1, 0, 0, '2010-06-29 16:38:23', 0, '2010-06-29 16:38:23');

-- --------------------------------------------------------

--
-- Table structure for table `definition_relation_product_unit`
--

DROP TABLE IF EXISTS `definition_relation_product_unit`;
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
(0, 187, '', '1.0000', '480000.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:56:08', 0, '2010-06-29 15:56:08'),
(1, 1, '', '1.0000', '15000.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:11', 0, '2010-06-29 15:52:11'),
(1, 3, '', '4.0000', '34500.0000', '23700.0000', '24900.0000', 1, '2010-08-09 09:14:38', 1, '2010-08-09 09:15:09'),
(2, 1, '', '1.0000', '15000.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:12', 0, '2010-06-29 15:52:12'),
(2, 12, '', '10.0000', '26100.0000', '29863.2200', '15600.0000', 1, '2010-08-09 09:15:20', 1, '2010-08-09 09:15:44'),
(3, 1, '', '1.0000', '23000.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:12', 0, '2010-06-29 15:52:12'),
(3, 8, '', '7.0000', '23900.0000', '35250.0000', '12030.0000', 1, '2010-08-09 09:16:00', 1, '2010-08-09 09:16:23'),
(4, 1, '', '1.0000', '23000.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:12', 0, '2010-06-29 15:52:12'),
(5, 1, '', '1.0000', '42000.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:12', 0, '2010-06-29 15:52:12'),
(6, 1, '', '1.0000', '42000.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:12', 0, '2010-06-29 15:52:12'),
(7, 4, '', '1.0000', '0.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:12', 0, '2010-06-29 15:52:12'),
(8, 4, '', '1.0000', '17700.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:12', 0, '2010-06-29 15:52:12'),
(9, 4, '', '1.0000', '8400.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:12', 0, '2010-06-29 15:52:12'),
(10, 4, '', '1.0000', '7300.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:12', 0, '2010-06-29 15:52:12'),
(11, 3, '', '5.0000', '0.0000', '35600.0000', '0.0000', 1, '2010-08-12 10:47:35', 1, '2010-08-12 10:47:51'),
(11, 4, '', '1.0000', '9700.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:12', 0, '2010-06-29 15:52:12'),
(12, 4, '', '1.0000', '9700.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:13', 0, '2010-06-29 15:52:13'),
(13, 4, '', '1.0000', '9700.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:13', 0, '2010-06-29 15:52:13'),
(14, 4, '', '1.0000', '9700.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:13', 0, '2010-06-29 15:52:13'),
(15, 4, '', '1.0000', '9700.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:13', 0, '2010-06-29 15:52:13'),
(16, 4, '', '1.0000', '9700.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:13', 0, '2010-06-29 15:52:13'),
(17, 4, '', '1.0000', '9700.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:13', 0, '2010-06-29 15:52:13'),
(18, 4, '', '1.0000', '2700.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:13', 0, '2010-06-29 15:52:13'),
(19, 4, '', '1.0000', '4700.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:13', 0, '2010-06-29 15:52:13'),
(20, 4, '', '1.0000', '2400.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:13', 0, '2010-06-29 15:52:13'),
(21, 5, '', '1.0000', '4500.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:13', 0, '2010-06-29 15:52:13'),
(22, 6, '', '1.0000', '11500.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:13', 0, '2010-06-29 15:52:13'),
(23, 4, '', '1.0000', '0.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:13', 0, '2010-06-29 15:52:13'),
(24, 4, '', '1.0000', '8200.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:14', 0, '2010-06-29 15:52:14'),
(25, 4, '', '1.0000', '8500.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:14', 0, '2010-06-29 15:52:14'),
(26, 4, '', '1.0000', '20000.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:14', 0, '2010-06-29 15:52:14'),
(27, 4, '', '1.0000', '0.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:14', 0, '2010-06-29 15:52:14'),
(28, 4, '', '1.0000', '17500.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:14', 0, '2010-06-29 15:52:14'),
(29, 4, '', '1.0000', '1000.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:14', 0, '2010-06-29 15:52:14'),
(30, 4, '', '1.0000', '3500.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:14', 0, '2010-06-29 15:52:14'),
(31, 4, '', '1.0000', '5300.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:14', 0, '2010-06-29 15:52:14'),
(32, 4, '', '1.0000', '1200.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:14', 0, '2010-06-29 15:52:14'),
(33, 4, '', '1.0000', '9500.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:14', 0, '2010-06-29 15:52:14'),
(34, 4, '', '1.0000', '8700.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:14', 0, '2010-06-29 15:52:14'),
(35, 4, '', '1.0000', '10500.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:14', 0, '2010-06-29 15:52:14'),
(36, 4, '', '1.0000', '10500.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:15', 0, '2010-06-29 15:52:15'),
(37, 4, '', '1.0000', '10500.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:15', 0, '2010-06-29 15:52:15'),
(38, 4, '', '1.0000', '15500.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:15', 0, '2010-06-29 15:52:15'),
(39, 4, '', '1.0000', '18000.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:15', 0, '2010-06-29 15:52:15'),
(40, 4, '', '1.0000', '10500.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:15', 0, '2010-06-29 15:52:15'),
(41, 4, '', '1.0000', '11700.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:15', 0, '2010-06-29 15:52:15'),
(42, 4, '', '1.0000', '10500.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:15', 0, '2010-06-29 15:52:15'),
(43, 4, '', '1.0000', '9500.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:15', 0, '2010-06-29 15:52:15'),
(44, 4, '', '1.0000', '9000.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:15', 0, '2010-06-29 15:52:15'),
(45, 4, '', '1.0000', '0.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:15', 0, '2010-06-29 15:52:15'),
(46, 1, '', '1.0000', '4800.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:15', 0, '2010-06-29 15:52:15'),
(47, 1, '', '1.0000', '28600.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:15', 0, '2010-06-29 15:52:15'),
(48, 1, '', '1.0000', '19000.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:16', 0, '2010-06-29 15:52:16'),
(49, 1, '', '1.0000', '23900.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:16', 0, '2010-06-29 15:52:16'),
(50, 4, '', '1.0000', '4300.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:16', 0, '2010-06-29 15:52:16'),
(51, 4, '', '1.0000', '6200.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:16', 0, '2010-06-29 15:52:16'),
(52, 4, '', '1.0000', '3000.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:16', 0, '2010-06-29 15:52:16'),
(53, 4, '', '1.0000', '30600.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:16', 0, '2010-06-29 15:52:16'),
(54, 4, '', '1.0000', '3000.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:16', 0, '2010-06-29 15:52:16'),
(55, 4, '', '1.0000', '1200.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:17', 0, '2010-06-29 15:52:17'),
(56, 4, '', '1.0000', '50200.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:17', 0, '2010-06-29 15:52:17'),
(57, 4, '', '1.0000', '16500.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:17', 0, '2010-06-29 15:52:17'),
(58, 4, '', '1.0000', '18800.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:17', 0, '2010-06-29 15:52:17'),
(59, 4, '', '1.0000', '19800.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:17', 0, '2010-06-29 15:52:17'),
(60, 4, '', '1.0000', '19800.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:17', 0, '2010-06-29 15:52:17'),
(61, 4, '', '1.0000', '2400.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:17', 0, '2010-06-29 15:52:17'),
(62, 4, '', '1.0000', '4500.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:17', 0, '2010-06-29 15:52:17'),
(63, 4, '', '1.0000', '4200.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:17', 0, '2010-06-29 15:52:17'),
(64, 4, '', '1.0000', '9000.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:17', 0, '2010-06-29 15:52:17'),
(65, 4, '', '1.0000', '6500.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:17', 0, '2010-06-29 15:52:17'),
(66, 4, '', '1.0000', '3000.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:17', 0, '2010-06-29 15:52:17'),
(67, 4, '', '1.0000', '1600.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:18', 0, '2010-06-29 15:52:18'),
(68, 4, '', '1.0000', '19800.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:18', 0, '2010-06-29 15:52:18'),
(69, 4, '', '1.0000', '8300.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:18', 0, '2010-06-29 15:52:18'),
(70, 4, '', '1.0000', '16500.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:18', 0, '2010-06-29 15:52:18'),
(71, 4, '', '1.0000', '6500.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:18', 0, '2010-06-29 15:52:18'),
(72, 4, '', '1.0000', '69400.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:18', 0, '2010-06-29 15:52:18'),
(73, 4, '', '1.0000', '9000.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:18', 0, '2010-06-29 15:52:18'),
(74, 4, '', '1.0000', '31000.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:18', 0, '2010-06-29 15:52:18'),
(75, 4, '', '1.0000', '11000.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:18', 0, '2010-06-29 15:52:18'),
(76, 4, '', '1.0000', '10000.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:18', 0, '2010-06-29 15:52:18'),
(77, 4, '', '1.0000', '0.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:18', 0, '2010-06-29 15:52:18'),
(78, 4, '', '1.0000', '11000.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:19', 0, '2010-06-29 15:52:19'),
(79, 4, '', '1.0000', '14200.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:19', 0, '2010-06-29 15:52:19'),
(80, 4, '', '1.0000', '11200.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:19', 0, '2010-06-29 15:52:19'),
(81, 4, '', '1.0000', '4800.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:19', 0, '2010-06-29 15:52:19'),
(82, 4, '', '1.0000', '19000.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:19', 0, '2010-06-29 15:52:19'),
(83, 4, '', '1.0000', '17700.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:19', 0, '2010-06-29 15:52:19'),
(84, 4, '', '1.0000', '0.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:19', 0, '2010-06-29 15:52:19'),
(85, 4, '', '1.0000', '0.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:19', 0, '2010-06-29 15:52:19'),
(86, 1, '', '1.0000', '28000.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:19', 0, '2010-06-29 15:52:19'),
(87, 1, '', '1.0000', '16800.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:19', 0, '2010-06-29 15:52:19'),
(88, 7, '', '1.0000', '1700.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:20', 0, '2010-06-29 15:52:20'),
(89, 8, '', '1.0000', '3100.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:20', 0, '2010-06-29 15:52:20'),
(90, 8, '', '1.0000', '7500.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:20', 0, '2010-06-29 15:52:20'),
(91, 9, '', '1.0000', '4700.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:20', 0, '2010-06-29 15:52:20'),
(92, 9, '', '1.0000', '0.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:20', 0, '2010-06-29 15:52:20'),
(93, 9, '', '1.0000', '0.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:20', 0, '2010-06-29 15:52:20'),
(94, 9, '', '1.0000', '1900.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:20', 0, '2010-06-29 15:52:20'),
(95, 10, '', '1.0000', '3800.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:20', 0, '2010-06-29 15:52:20'),
(96, 8, '', '1.0000', '9700.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:20', 0, '2010-06-29 15:52:20'),
(97, 10, '', '1.0000', '6000.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:21', 0, '2010-06-29 15:52:21'),
(98, 11, '', '1.0000', '1700.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:21', 0, '2010-06-29 15:52:21'),
(99, 11, '', '1.0000', '1400.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:21', 0, '2010-06-29 15:52:21'),
(100, 11, '', '1.0000', '23000.0000', '25500.2500', '90500.0000', 0, '2010-06-29 15:52:21', 0, '2010-06-29 15:52:21');

-- --------------------------------------------------------

--
-- Table structure for table `definition_relation_role_function`
--

DROP TABLE IF EXISTS `definition_relation_role_function`;
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
(0, 9, 'allow', 1, 1, 1, 1, 1, 1, 1, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(8, 2, 'allow', 1, 1, 1, 1, 1, 0, 0, 1, '2010-07-28 15:14:05', 1, '2010-07-28 15:14:10'),
(8, 4, 'allow', 0, 0, 0, 0, 0, 0, 0, 1, '2010-07-28 15:13:05', 1, '2010-07-30 13:54:03'),
(8, 5, 'allow', 0, 0, 0, 0, 0, 0, 0, 1, '2010-07-28 15:12:58', 1, '2010-07-28 15:13:02'),
(8, 11, 'allow', 0, 0, 0, 0, 0, 0, 0, 1, '2010-07-28 15:11:50', 1, '2010-07-28 15:11:50'),
(8, 14, 'allow', 0, 0, 0, 0, 0, 0, 0, 0, '2010-07-13 20:52:23', 0, '2010-07-13 20:52:23'),
(8, 22, 'allow', 0, 0, 0, 0, 0, 0, 0, 0, '2010-07-13 20:51:34', 0, '2010-07-13 20:51:34'),
(8, 23, 'allow', 1, 1, 1, 1, 1, 1, 1, 0, '2010-07-05 09:50:14', 1, '2010-07-14 13:08:22'),
(8, 24, 'allow', 1, 1, 1, 1, 1, 1, 1, 0, '2010-07-05 09:50:06', 1, '2010-07-14 13:08:23'),
(8, 25, 'allow', 1, 1, 1, 1, 1, 1, 1, 0, '2010-07-05 09:50:04', 1, '2010-07-14 13:08:25'),
(8, 26, 'allow', 0, 0, 0, 0, 0, 0, 0, 0, '2010-07-13 20:51:29', 0, '2010-07-13 20:51:29'),
(8, 27, 'deny', 0, 0, 0, 0, 0, 0, 0, 0, '2010-07-05 09:50:02', 1, '2010-07-21 21:46:11'),
(8, 29, 'allow', 0, 0, 0, 0, 0, 0, 0, 0, '2010-07-13 20:51:20', 1, '2010-08-17 17:03:53'),
(8, 32, 'allow', 0, 0, 0, 0, 0, 0, 0, 0, '2010-07-13 20:51:48', 0, '2010-07-13 20:51:48'),
(8, 34, 'allow', 0, 0, 0, 0, 0, 0, 0, 1, '2010-08-23 10:10:14', 1, '2010-08-23 10:10:14'),
(8, 35, 'allow', 1, 1, 1, 1, 1, 0, 1, 0, '2010-07-05 11:34:26', 1, '2010-07-23 11:09:13'),
(8, 36, 'allow', 0, 0, 0, 0, 0, 0, 0, 1, '2010-07-22 14:37:48', 1, '2010-07-22 14:37:48'),
(8, 37, 'allow', 1, 1, 1, 1, 1, 1, 1, 0, '2010-07-05 09:50:16', 1, '2010-07-30 13:54:00'),
(8, 38, 'allow', 0, 0, 0, 0, 0, 0, 0, 0, '2010-07-13 20:52:03', 0, '2010-07-13 20:52:03'),
(8, 39, 'allow', 0, 0, 0, 0, 0, 0, 0, 1, '2010-07-22 08:22:01', 1, '2010-07-22 08:22:01'),
(8, 40, 'allow', 0, 0, 0, 0, 0, 0, 0, 1, '2010-07-22 09:50:08', 1, '2010-07-22 09:50:08'),
(8, 41, 'allow', 1, 1, 1, 0, 1, 1, 1, 0, '2010-07-05 11:34:24', 1, '2010-07-16 16:49:01'),
(8, 42, 'deny', 1, 1, 0, 1, 1, 1, 1, 0, '2010-07-05 11:34:22', 0, '2010-07-13 20:51:54'),
(8, 43, 'allow', 0, 0, 0, 0, 0, 0, 0, 0, '2010-07-13 20:51:38', 0, '2010-07-13 20:51:38'),
(8, 44, 'allow', 1, 1, 1, 1, 1, 1, 1, 0, '2010-07-05 09:50:00', 1, '2010-07-21 21:45:58'),
(8, 45, 'allow', 1, 1, 1, 1, 1, 1, 1, 1, '2010-07-21 21:40:32', 1, '2010-07-21 21:40:40'),
(8, 46, 'deny', 1, 1, 0, 0, 0, 0, 0, 0, '2010-07-05 09:49:35', 0, '2010-07-13 20:50:46'),
(8, 47, 'deny', 1, 1, 0, 0, 0, 0, 0, 0, '2010-07-05 09:49:21', 0, '2010-07-13 20:50:36'),
(8, 48, 'deny', 1, 1, 0, 0, 0, 0, 0, 0, '2010-07-05 09:49:33', 0, '2010-07-13 20:50:43'),
(8, 49, 'allow', 1, 1, 0, 0, 0, 0, 0, 0, '2010-07-05 09:45:25', 1, '2010-07-28 15:14:03'),
(8, 50, 'deny', 1, 1, 0, 0, 0, 0, 0, 0, '2010-07-05 09:45:07', 0, '2010-07-05 15:48:43'),
(8, 51, 'allow', 1, 1, 0, 0, 0, 0, 0, 0, '2010-07-05 09:44:56', 1, '2010-07-28 15:13:35'),
(8, 52, 'deny', 1, 1, 0, 0, 0, 0, 0, 0, '2010-07-05 09:49:26', 0, '2010-07-13 20:49:31'),
(8, 53, 'deny', 1, 1, 0, 0, 0, 0, 0, 0, '2010-07-05 09:49:28', 0, '2010-07-13 20:50:40'),
(8, 54, 'deny', 1, 1, 0, 0, 0, 0, 0, 0, '2010-07-05 09:49:31', 0, '2010-07-05 09:50:40'),
(8, 55, 'allow', 1, 1, 0, 0, 0, 0, 0, 0, '2010-07-05 09:49:40', 1, '2010-07-28 15:11:42'),
(8, 56, 'deny', 1, 1, 0, 0, 0, 0, 0, 0, '2010-07-05 09:49:37', 0, '2010-07-13 20:50:48'),
(8, 57, 'deny', 1, 1, 0, 0, 0, 0, 0, 0, '2010-07-05 09:49:24', 0, '2010-07-13 20:50:38'),
(8, 58, 'deny', 1, 1, 0, 0, 0, 0, 0, 0, '2010-07-05 09:49:22', 0, '2010-07-05 11:34:49'),
(8, 59, 'allow', 0, 0, 0, 0, 0, 0, 0, 0, '2010-07-13 20:52:33', 0, '2010-07-13 20:52:33'),
(8, 60, 'allow', 0, 0, 0, 0, 0, 0, 0, 0, '2010-07-13 20:52:28', 0, '2010-07-13 20:52:28'),
(8, 61, 'allow', 0, 0, 0, 0, 0, 0, 0, 0, '2010-07-13 20:52:35', 0, '2010-07-13 20:52:35'),
(8, 62, 'allow', 1, 1, 1, 1, 1, 1, 1, 0, '2010-07-13 20:52:30', 1, '2010-07-28 15:13:16'),
(8, 77, 'allow', 0, 0, 0, 0, 0, 0, 0, 0, '2010-07-13 20:52:06', 0, '2010-07-13 20:52:06'),
(8, 78, 'allow', 0, 0, 0, 0, 0, 0, 0, 0, '2010-07-13 20:52:10', 0, '2010-07-13 20:52:10'),
(8, 79, 'allow', 1, 1, 1, 1, 1, 1, 1, 0, '2010-07-05 09:50:13', 1, '2010-07-14 13:08:23'),
(8, 80, 'allow', 0, 0, 0, 0, 0, 0, 0, 0, '2010-07-13 20:52:08', 0, '2010-07-13 20:52:08'),
(8, 82, 'allow', 1, 1, 1, 1, 1, 1, 1, 0, '2010-07-05 09:50:09', 1, '2010-07-14 13:08:26'),
(8, 83, 'allow', 1, 1, 1, 1, 1, 1, 1, 0, '2010-07-05 09:50:08', 0, '2010-07-05 09:50:52'),
(8, 84, 'deny', 0, 0, 0, 0, 0, 0, 0, 0, '2010-07-13 20:52:39', 1, '2010-07-13 21:03:05'),
(8, 85, 'deny', 0, 0, 0, 0, 0, 0, 0, 0, '2010-07-13 20:52:42', 1, '2010-07-13 21:03:10'),
(8, 88, 'allow', 0, 0, 0, 0, 0, 0, 0, 1, '2010-07-28 15:11:34', 1, '2010-07-28 15:11:34'),
(8, 89, 'allow', 0, 0, 0, 0, 0, 0, 0, 1, '2010-07-28 15:11:08', 1, '2010-07-28 15:11:25'),
(8, 90, 'allow', 0, 0, 0, 0, 0, 0, 0, 0, '2010-07-13 20:52:52', 0, '2010-07-13 20:52:52'),
(8, 92, 'allow', 0, 0, 0, 0, 0, 0, 0, 0, '2010-07-13 20:52:50', 0, '2010-07-13 20:52:50'),
(8, 93, 'allow', 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(8, 105, 'allow', 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(8, 107, 'allow', 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(8, 109, 'allow', 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(8, 111, 'allow', 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(8, 113, 'allow', 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(8, 116, 'allow', 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00'),
(8, 117, 'allow', 0, 1, 1, 1, 1, 1, 1, 1, '2010-07-21 16:04:35', 1, '2010-07-21 21:31:34'),
(8, 119, 'allow', 0, 0, 0, 0, 0, 0, 0, 0, '0000-00-00 00:00:00', 1, '2010-07-28 15:13:55'),
(8, 120, 'allow', 0, 0, 0, 0, 0, 0, 0, 1, '2010-07-28 15:13:29', 1, '2010-07-28 15:13:29'),
(8, 121, 'allow', 0, 0, 0, 0, 0, 0, 0, 1, '2010-07-21 16:04:56', 1, '2010-07-21 16:04:56'),
(8, 122, 'allow', 0, 0, 0, 0, 0, 0, 0, 1, '2010-07-23 13:18:17', 1, '2010-07-23 13:18:17'),
(8, 123, 'allow', 0, 0, 0, 0, 0, 0, 0, 1, '2010-07-23 13:18:19', 1, '2010-07-23 13:18:19'),
(8, 135, 'allow', 0, 0, 0, 0, 0, 0, 0, 1, '2010-08-27 16:39:21', 1, '2010-08-27 16:39:21'),
(8, 138, 'allow', 0, 0, 0, 0, 0, 0, 0, 1, '2010-08-23 09:05:58', 1, '2010-08-23 09:05:58'),
(8, 140, 'allow', 0, 0, 0, 0, 0, 0, 0, 1, '2010-08-24 16:33:38', 1, '2010-08-24 16:33:38'),
(8, 141, 'allow', 0, 0, 0, 0, 0, 0, 0, 1, '2010-08-27 09:08:18', 1, '2010-08-27 09:08:18');

-- --------------------------------------------------------

--
-- Table structure for table `definition_voucher_type`
--

DROP TABLE IF EXISTS `definition_voucher_type`;
CREATE TABLE IF NOT EXISTS `definition_voucher_type` (
  `voucher_type_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `module_id` bigint(30) unsigned NOT NULL,
  `execution_id` bigint(30) unsigned NOT NULL,
  `voucher_type_name` varchar(100) NOT NULL,
  `first_type` tinyint(1) unsigned NOT NULL COMMENT 'Nhóm ký tự đầu chuỗi. 0: đơn vị; 1: tháng; 2: năm; 3: tự nhập.',
  `first_text` varchar(5) NOT NULL COMMENT 'nhóm ký tự đầu chuỗi tự nhập',
  `middle_type` tinyint(1) unsigned NOT NULL COMMENT 'Nhóm ký tự giữa chuỗi. 0: đơn vị; 1: tháng; 2: năm; 3: tự nhập.',
  `middle_text` varchar(5) NOT NULL COMMENT 'nhóm ký tự giữa chuỗi tự nhập',
  `last_type` tinyint(1) unsigned NOT NULL COMMENT 'Nhóm ký tự cuối chuỗi. 0: đơn vị; 1: tháng; 2: năm; 3: tự nhập.',
  `last_text` varchar(5) NOT NULL COMMENT 'nhóm ký tự cuối chuỗi tự nhập',
  `separation_sign` varchar(1) NOT NULL,
  `prefix_suffix` tinyint(1) unsigned NOT NULL COMMENT '0: chuỗi nằm trước số tự động; 1: chuỗi nằm sau số tự động;',
  `auto_number` mediumint(6) unsigned NOT NULL COMMENT 'phần số tăng tự động của chứng từ',
  `number_length` tinyint(1) unsigned NOT NULL COMMENT 'Xác định độ dài phần số tự động trong chuỗi hiển thị',
  `report_purpose` tinyint(1) unsigned NOT NULL COMMENT '0: báo cáo hiệu quả kinh doanh; 1: báo cáo thuế;',
  `inc_dec` tinyint(1) unsigned NOT NULL COMMENT '1: tăng; 2: giảm; 3: luân chuyển',
  `have_location` tinyint(1) unsigned NOT NULL COMMENT '0: không xác định nơi tăng giảm, nhận chuyển; 1: có xác định nơi tăng giảm, nhận chuyển',
  `inactive` tinyint(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`voucher_type_id`),
  KEY `fk_voucher_type_created_user` (`created_by_userid`),
  KEY `fk_voucher_type_modified_user` (`last_modified_by_userid`),
  KEY `fk_voucher_type_module` (`module_id`),
  KEY `fk_voucher_type_execution` (`execution_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `definition_voucher_type`
--

INSERT INTO `definition_voucher_type` (`voucher_type_id`, `module_id`, `execution_id`, `voucher_type_name`, `first_type`, `first_text`, `middle_type`, `middle_text`, `last_type`, `last_text`, `separation_sign`, `prefix_suffix`, `auto_number`, `number_length`, `report_purpose`, `inc_dec`, `have_location`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(1, 4, 15, 'tự nhập-tự nhập-tự nhập', 3, 'PN', 1, '', 2, '', '/', 0, 19, 4, 0, 1, 1, 0, 0, '0000-00-00 00:00:00', 1, '2010-08-30 15:04:56'),
(2, 4, 15, 'phieu xuat ma dv-thang-nam', 0, '', 1, '', 2, '', '', 0, 7, 5, 1, 2, 1, 0, 0, '0000-00-00 00:00:00', 1, '2010-08-27 17:19:59'),
(3, 4, 15, 'van chuyen thang-nam-VC', 1, '', 2, '', 3, 'NB', '-', 0, 0, 4, 1, 3, 1, 0, 0, '0000-00-00 00:00:00', 0, '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `definition_warehouse_type`
--

DROP TABLE IF EXISTS `definition_warehouse_type`;
CREATE TABLE IF NOT EXISTS `definition_warehouse_type` (
  `warehouse_type_id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `warehouse_type_name` varchar(100) NOT NULL,
  `warehouse_conditioning` tinyint(1) unsigned NOT NULL COMMENT 'biểu hiện đặc tính của kho: 0 là thông thường, 1 là kho lạnh',
  `inactive` tinyint(1) NOT NULL,
  `created_by_userid` bigint(30) unsigned NOT NULL,
  `date_entered` datetime NOT NULL,
  `last_modified_by_userid` bigint(30) unsigned NOT NULL,
  `date_last_modified` datetime NOT NULL,
  PRIMARY KEY (`warehouse_type_id`),
  KEY `fk_warehouse_type_created_user` (`created_by_userid`),
  KEY `fk_warehouse_type_modified_user` (`last_modified_by_userid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `definition_warehouse_type`
--

INSERT INTO `definition_warehouse_type` (`warehouse_type_id`, `warehouse_type_name`, `warehouse_conditioning`, `inactive`, `created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`) VALUES
(0, '', 0, 0, 0, '1900-01-01 00:00:00', 0, '1900-01-01 00:00:00'),
(1, 'Kho loại 1', 0, 0, 0, '2010-06-29 16:35:38', 0, '2010-06-29 16:35:38');

-- --------------------------------------------------------

--
-- Table structure for table `purchase_detail_order`
--

DROP TABLE IF EXISTS `purchase_detail_order`;
CREATE TABLE IF NOT EXISTS `purchase_detail_order` (
  `purchase_order_id` bigint(30) unsigned NOT NULL,
  `product_id` bigint(30) unsigned NOT NULL,
  `unit_id` bigint(30) unsigned NOT NULL,
  `quantity` decimal(18,4) NOT NULL,
  `converted_quantity` decimal(18,4) NOT NULL,
  `price` decimal(18,4) NOT NULL,
  `amount` decimal(18,4) NOT NULL,
  `converted_amount` decimal(18,4) NOT NULL,
  `note` varchar(100) NOT NULL,
  PRIMARY KEY (`purchase_order_id`,`product_id`,`unit_id`),
  KEY `fk_purchase_order_product` (`product_id`),
  KEY `fk_purchase_order_unit` (`unit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `purchase_detail_order`
--


-- --------------------------------------------------------

--
-- Table structure for table `purchase_transaction_order`
--

DROP TABLE IF EXISTS `purchase_transaction_order`;
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


-- --------------------------------------------------------

--
-- Table structure for table `warehousing_product_balance`
--

DROP TABLE IF EXISTS `warehousing_product_balance`;
CREATE TABLE IF NOT EXISTS `warehousing_product_balance` (
  `period_id` bigint(30) unsigned NOT NULL,
  `warehouse_id` bigint(30) unsigned NOT NULL,
  `product_id` bigint(30) unsigned NOT NULL,
  `unit_id` bigint(30) unsigned NOT NULL,
  `quantity` decimal(18,4) NOT NULL,
  `converted_quantity` decimal(18,4) NOT NULL,
  `converted_amount` decimal(18,4) NOT NULL,
  PRIMARY KEY (`period_id`,`warehouse_id`,`product_id`,`unit_id`),
  KEY `fk_inventory_balance_product` (`product_id`),
  KEY `fk_inventory_balance_unit` (`unit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `warehousing_product_balance`
--

INSERT INTO `warehousing_product_balance` (`period_id`, `warehouse_id`, `product_id`, `unit_id`, `quantity`, `converted_quantity`, `converted_amount`) VALUES
(0, 0, 1, 1, '500.0000', '500.0000', '5660000.0000'),
(0, 0, 1, 3, '210.0000', '210.0000', '3900500.0000'),
(0, 0, 2, 1, '5000.0000', '5000.0000', '10590000.0000'),
(0, 0, 2, 12, '659.0000', '659.0000', '2533333.0000'),
(0, 0, 3, 1, '300.0000', '300.0000', '1569996.0000'),
(0, 0, 3, 8, '244.0000', '244.0000', '2566669.0000'),
(0, 0, 4, 1, '120.0000', '120.0000', '3562222.0000'),
(0, 0, 30, 1, '250.0000', '250.0000', '2569999.0000'),
(0, 0, 31, 1, '256.0000', '256.0000', '2544411.0000');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `accountant_account_balance`
--
ALTER TABLE `accountant_account_balance`
  ADD CONSTRAINT `fk_account_balance_account` FOREIGN KEY (`account_id`) REFERENCES `definition_list_account` (`account_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_account_balance_currency` FOREIGN KEY (`currency_id`) REFERENCES `definition_list_currency` (`currency_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_account_balance_period` FOREIGN KEY (`period_id`) REFERENCES `definition_list_period` (`period_id`) ON UPDATE CASCADE;

--
-- Constraints for table `accountant_assets_depreciation`
--
ALTER TABLE `accountant_assets_depreciation`
  ADD CONSTRAINT `fk_depreciation_assets` FOREIGN KEY (`assets_voucher_id`) REFERENCES `accountant_assets_voucher` (`assets_voucher_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_depreciation_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_depreciation_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_depreciation_voucher` FOREIGN KEY (`voucher_id`) REFERENCES `accountant_transaction_voucher` (`voucher_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_assets_voucher`
--
ALTER TABLE `accountant_assets_voucher`
  ADD CONSTRAINT `fk_assets_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_assets_currency` FOREIGN KEY (`currency_id`) REFERENCES `definition_list_currency` (`currency_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_assets_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_assets_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `definition_list_subject` (`subject_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_assets_voucher` FOREIGN KEY (`voucher_id`) REFERENCES `accountant_transaction_voucher` (`voucher_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_auto_batch`
--
ALTER TABLE `accountant_auto_batch`
  ADD CONSTRAINT `fk_auto_bath_execution` FOREIGN KEY (`execution_id`) REFERENCES `definition_list_execution` (`execution_id`) ON UPDATE CASCADE;

--
-- Constraints for table `accountant_auto_correspondence`
--
ALTER TABLE `accountant_auto_correspondence`
  ADD CONSTRAINT `fk_auto_correspondence_account` FOREIGN KEY (`detail_account_id`) REFERENCES `definition_list_account` (`account_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_auto_correspondence_entry` FOREIGN KEY (`auto_entry_id`) REFERENCES `accountant_auto_entry` (`auto_entry_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_auto_entry`
--
ALTER TABLE `accountant_auto_entry`
  ADD CONSTRAINT `fk_auto_entry_account` FOREIGN KEY (`master_account_id`) REFERENCES `definition_list_account` (`account_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_auto_entry_batch` FOREIGN KEY (`auto_batch_id`) REFERENCES `accountant_auto_batch` (`auto_batch_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_auto_entry_currency` FOREIGN KEY (`currency_id`) REFERENCES `definition_list_currency` (`currency_id`) ON UPDATE CASCADE;

--
-- Constraints for table `accountant_bank_account`
--
ALTER TABLE `accountant_bank_account`
  ADD CONSTRAINT `fk_bank_account_bank` FOREIGN KEY (`bank_id`) REFERENCES `definition_list_subject` (`subject_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_bank_account_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_bank_account_currency` FOREIGN KEY (`currency_id`) REFERENCES `definition_list_currency` (`currency_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_bank_account_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `accountant_cash_voucher`
--
ALTER TABLE `accountant_cash_voucher`
  ADD CONSTRAINT `fk_cash_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cash_currency` FOREIGN KEY (`currency_id`) REFERENCES `definition_list_currency` (`currency_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cash_in_bank` FOREIGN KEY (`in_bank_id`) REFERENCES `definition_list_subject` (`subject_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cash_in_bank_account` FOREIGN KEY (`in_bank_account_id`) REFERENCES `accountant_bank_account` (`bank_account_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cash_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cash_out_bank` FOREIGN KEY (`out_bank_id`) REFERENCES `definition_list_subject` (`subject_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cash_out_bank_account` FOREIGN KEY (`out_bank_account_id`) REFERENCES `accountant_bank_account` (`bank_account_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cash_staff` FOREIGN KEY (`staff_id`) REFERENCES `definition_list_staff` (`staff_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cash_subject` FOREIGN KEY (`subject_id`) REFERENCES `definition_list_subject` (`subject_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cash_voucher` FOREIGN KEY (`voucher_id`) REFERENCES `accountant_transaction_voucher` (`voucher_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_detail_correspondence`
--
ALTER TABLE `accountant_detail_correspondence`
  ADD CONSTRAINT `fk_detail_correspondence` FOREIGN KEY (`correspondence_id`) REFERENCES `accountant_transaction_correspondence` (`correspondence_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_correspondence_table` FOREIGN KEY (`table_id`) REFERENCES `definition_list_table` (`table_id`) ON UPDATE CASCADE;

--
-- Constraints for table `accountant_detail_entry`
--
ALTER TABLE `accountant_detail_entry`
  ADD CONSTRAINT `fk_detail_entry` FOREIGN KEY (`entry_id`) REFERENCES `accountant_transaction_entry` (`entry_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_entry_table` FOREIGN KEY (`table_id`) REFERENCES `definition_list_table` (`table_id`) ON UPDATE CASCADE;

--
-- Constraints for table `accountant_detail_inventory`
--
ALTER TABLE `accountant_detail_inventory`
  ADD CONSTRAINT `fk_detail_inventory` FOREIGN KEY (`inventory_voucher_id`) REFERENCES `accountant_inventory_voucher` (`inventory_voucher_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_inventory_product` FOREIGN KEY (`product_id`) REFERENCES `definition_list_product` (`product_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_inventory_source_voucher` FOREIGN KEY (`in_voucher_id`) REFERENCES `accountant_inventory_voucher` (`inventory_voucher_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_inventory_unit` FOREIGN KEY (`unit_id`) REFERENCES `definition_list_unit` (`unit_id`) ON UPDATE CASCADE;

--
-- Constraints for table `accountant_detail_purchase`
--
ALTER TABLE `accountant_detail_purchase`
  ADD CONSTRAINT `fk_detail_purchase` FOREIGN KEY (`purchase_invoice_id`) REFERENCES `accountant_purchase_invoice` (`purchase_invoice_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_purchase_excise_rate` FOREIGN KEY (`excise_rate_id`) REFERENCES `accountant_tax_rate` (`tax_rate_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_purchase_import_rate` FOREIGN KEY (`import_rate_id`) REFERENCES `accountant_tax_rate` (`tax_rate_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_purchase_product` FOREIGN KEY (`product_id`) REFERENCES `definition_list_product` (`product_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_purchase_service` FOREIGN KEY (`service_id`) REFERENCES `definition_list_service` (`service_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_purchase_specificity` FOREIGN KEY (`purchase_specificity_id`) REFERENCES `accountant_purchase_specificity` (`purchase_specificity_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_purchase_unit` FOREIGN KEY (`unit_id`) REFERENCES `definition_list_unit` (`unit_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_purchase_vat_rate` FOREIGN KEY (`vat_rate_id`) REFERENCES `accountant_tax_rate` (`tax_rate_id`) ON UPDATE CASCADE;

--
-- Constraints for table `accountant_detail_sales`
--
ALTER TABLE `accountant_detail_sales`
  ADD CONSTRAINT `fk_detail_sales` FOREIGN KEY (`sales_invoice_id`) REFERENCES `accountant_sales_invoice` (`sales_invoice_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_sales_export_rate` FOREIGN KEY (`export_rate_id`) REFERENCES `accountant_tax_rate` (`tax_rate_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_sales_product` FOREIGN KEY (`product_id`) REFERENCES `definition_list_product` (`product_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_sales_service` FOREIGN KEY (`service_id`) REFERENCES `definition_list_service` (`service_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_sales_unit` FOREIGN KEY (`unit_id`) REFERENCES `definition_list_unit` (`unit_id`) ON UPDATE CASCADE;

--
-- Constraints for table `accountant_entry_credit`
--
ALTER TABLE `accountant_entry_credit`
  ADD CONSTRAINT `fk_entry_credit_account` FOREIGN KEY (`account_id`) REFERENCES `definition_list_account` (`account_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_entry_credit_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_entry_credit_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_entry_credit_type` FOREIGN KEY (`entry_type_id`) REFERENCES `accountant_entry_type` (`entry_type_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_entry_debit`
--
ALTER TABLE `accountant_entry_debit`
  ADD CONSTRAINT `fk_entry_debit_account` FOREIGN KEY (`account_id`) REFERENCES `definition_list_account` (`account_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_entry_debit_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_entry_debit_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_entry_debit_type` FOREIGN KEY (`entry_type_id`) REFERENCES `accountant_entry_type` (`entry_type_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_inventory_purchase`
--
ALTER TABLE `accountant_inventory_purchase`
  ADD CONSTRAINT `fk_inventory_purchase_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_inventory_purchase_inventory` FOREIGN KEY (`inventory_voucher_id`) REFERENCES `accountant_inventory_voucher` (`inventory_voucher_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_inventory_purchase_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_inventory_purchase_purchase` FOREIGN KEY (`purchase_invoice_id`) REFERENCES `accountant_purchase_invoice` (`purchase_invoice_id`) ON UPDATE CASCADE;

--
-- Constraints for table `accountant_inventory_sales`
--
ALTER TABLE `accountant_inventory_sales`
  ADD CONSTRAINT `fk_inventory_sales_batch` FOREIGN KEY (`batch_id`) REFERENCES `accountant_transaction_batch` (`batch_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_inventory_sales_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_inventory_sales_inventory` FOREIGN KEY (`inventory_voucher_id`) REFERENCES `accountant_inventory_voucher` (`inventory_voucher_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_inventory_sales_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_inventory_sales_sales` FOREIGN KEY (`sales_invoice_id`) REFERENCES `accountant_sales_invoice` (`sales_invoice_id`) ON UPDATE CASCADE;

--
-- Constraints for table `accountant_inventory_voucher`
--
ALTER TABLE `accountant_inventory_voucher`
  ADD CONSTRAINT `fk_inventory_voucher_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_inventory_voucher_currency` FOREIGN KEY (`currency_id`) REFERENCES `definition_list_currency` (`currency_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_inventory_voucher_department` FOREIGN KEY (`department_id`) REFERENCES `definition_list_department` (`department_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_inventory_voucher_in_warehouse` FOREIGN KEY (`in_warehouse_id`) REFERENCES `definition_list_warehouse` (`warehouse_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_inventory_voucher_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_inventory_voucher_out_warehouse` FOREIGN KEY (`out_warehouse_id`) REFERENCES `definition_list_warehouse` (`warehouse_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_inventory_voucher_subject` FOREIGN KEY (`subject_id`) REFERENCES `definition_list_subject` (`subject_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_inventory_voucher_transaction_voucher` FOREIGN KEY (`voucher_id`) REFERENCES `accountant_transaction_voucher` (`voucher_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_invoice_detail`
--
ALTER TABLE `accountant_invoice_detail`
  ADD CONSTRAINT `fk_invoice_detail_cash` FOREIGN KEY (`cash_voucher_id`) REFERENCES `accountant_cash_voucher` (`cash_voucher_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_invoice_detail_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_invoice_detail_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `accountant_list_expense`
--
ALTER TABLE `accountant_list_expense`
  ADD CONSTRAINT `fk_expense_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_expense_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `accountant_list_revenue`
--
ALTER TABLE `accountant_list_revenue`
  ADD CONSTRAINT `fk_revenue_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_revenue_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `accountant_list_specification`
--
ALTER TABLE `accountant_list_specification`
  ADD CONSTRAINT `fk_specification_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_specification_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `accountant_list_turnover`
--
ALTER TABLE `accountant_list_turnover`
  ADD CONSTRAINT `fk_turnover_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_turnover_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `accountant_payable_cash`
--
ALTER TABLE `accountant_payable_cash`
  ADD CONSTRAINT `fk_payable_cash_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_payable_cash_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_relation_payable_cash_voucher` FOREIGN KEY (`cash_voucher_id`) REFERENCES `accountant_cash_voucher` (`cash_voucher_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_relation_payable_voucher` FOREIGN KEY (`payable_voucher_id`) REFERENCES `accountant_payable_voucher` (`payable_voucher_id`) ON UPDATE CASCADE;

--
-- Constraints for table `accountant_payable_mapping`
--
ALTER TABLE `accountant_payable_mapping`
  ADD CONSTRAINT `fk_dec_payable_voucher` FOREIGN KEY (`dec_payable_voucher_id`) REFERENCES `accountant_payable_voucher` (`payable_voucher_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_inc_payable_voucher` FOREIGN KEY (`inc_payable_voucher_id`) REFERENCES `accountant_payable_voucher` (`payable_voucher_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_payable_mapping_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_payable_mapping_currency` FOREIGN KEY (`currency_id`) REFERENCES `definition_list_currency` (`currency_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_payable_mapping_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `accountant_payable_type`
--
ALTER TABLE `accountant_payable_type`
  ADD CONSTRAINT `fk_payable_type_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_payable_type_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `accountant_payable_voucher`
--
ALTER TABLE `accountant_payable_voucher`
  ADD CONSTRAINT `fk_payable_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_payable_currency` FOREIGN KEY (`currency_id`) REFERENCES `definition_list_currency` (`currency_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_payable_dec_staff` FOREIGN KEY (`dec_staff_id`) REFERENCES `definition_list_staff` (`staff_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_payable_dec_subject` FOREIGN KEY (`dec_subject_id`) REFERENCES `definition_list_subject` (`subject_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_payable_inc_staff` FOREIGN KEY (`inc_staff_id`) REFERENCES `definition_list_staff` (`staff_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_payable_inc_subject` FOREIGN KEY (`inc_subject_id`) REFERENCES `definition_list_subject` (`subject_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_payable_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_payable_tax` FOREIGN KEY (`tax_id`) REFERENCES `accountant_list_tax` (`tax_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_payable_type` FOREIGN KEY (`payable_type_id`) REFERENCES `accountant_payable_type` (`payable_type_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_payable_voucher` FOREIGN KEY (`voucher_id`) REFERENCES `accountant_transaction_voucher` (`voucher_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_prepaid_allocation`
--
ALTER TABLE `accountant_prepaid_allocation`
  ADD CONSTRAINT `fk_prepaid_allocation` FOREIGN KEY (`prepaid_expense_id`) REFERENCES `accountant_prepaid_expense` (`prepaid_expense_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_prepaid_allocation_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_prepaid_allocation_currency` FOREIGN KEY (`currency_id`) REFERENCES `definition_list_currency` (`currency_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_prepaid_allocation_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_prepaid_allocation_voucher` FOREIGN KEY (`voucher_id`) REFERENCES `accountant_transaction_voucher` (`voucher_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_prepaid_expense`
--
ALTER TABLE `accountant_prepaid_expense`
  ADD CONSTRAINT `fk_prepaid_assets` FOREIGN KEY (`assets_id`) REFERENCES `accountant_assets_voucher` (`assets_voucher_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_prepaid_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_prepaid_currency` FOREIGN KEY (`currency_id`) REFERENCES `definition_list_currency` (`currency_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_prepaid_expense` FOREIGN KEY (`expense_id`) REFERENCES `accountant_list_expense` (`expense_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_prepaid_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_prepaid_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `definition_list_subject` (`subject_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_prepaid_voucher` FOREIGN KEY (`voucher_id`) REFERENCES `accountant_transaction_voucher` (`voucher_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_purchase_cost`
--
ALTER TABLE `accountant_purchase_cost`
  ADD CONSTRAINT `fk_purchase_cost_cash` FOREIGN KEY (`cash_voucher_id`) REFERENCES `accountant_cash_voucher` (`cash_voucher_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_cost_cost_invoice` FOREIGN KEY (`cost_invoice_id`) REFERENCES `accountant_purchase_invoice` (`purchase_invoice_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_cost_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_cost_currency` FOREIGN KEY (`currency_id`) REFERENCES `definition_list_currency` (`currency_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_cost_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_cost_product` FOREIGN KEY (`product_id`) REFERENCES `definition_list_product` (`product_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_cost_purchase_invoice` FOREIGN KEY (`purchase_invoice_id`) REFERENCES `accountant_purchase_invoice` (`purchase_invoice_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_cost_service` FOREIGN KEY (`service_id`) REFERENCES `definition_list_service` (`service_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_cost_unit` FOREIGN KEY (`unit_id`) REFERENCES `definition_list_unit` (`unit_id`) ON UPDATE CASCADE;

--
-- Constraints for table `accountant_purchase_invoice`
--
ALTER TABLE `accountant_purchase_invoice`
  ADD CONSTRAINT `fk_purchase_invoice_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_invoice_currency` FOREIGN KEY (`currency_id`) REFERENCES `definition_list_currency` (`currency_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_invoice_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_invoice_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `definition_list_subject` (`subject_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_invoice_voucher` FOREIGN KEY (`voucher_id`) REFERENCES `accountant_transaction_voucher` (`voucher_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_purchase_payable`
--
ALTER TABLE `accountant_purchase_payable`
  ADD CONSTRAINT `fk_purchase_payable_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_payable_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_payable_payable` FOREIGN KEY (`payable_voucher_id`) REFERENCES `accountant_payable_voucher` (`payable_voucher_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_payable_purchase` FOREIGN KEY (`purchase_invoice_id`) REFERENCES `accountant_purchase_invoice` (`purchase_invoice_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_purchase_receivable`
--
ALTER TABLE `accountant_purchase_receivable`
  ADD CONSTRAINT `fk_purchase_receivable_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_receivable_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_receivable_purchase` FOREIGN KEY (`purchase_invoice_id`) REFERENCES `accountant_purchase_invoice` (`purchase_invoice_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_receivable_receivable` FOREIGN KEY (`receivable_voucher_id`) REFERENCES `accountant_receivable_voucher` (`receivable_voucher_id`) ON UPDATE CASCADE;

--
-- Constraints for table `accountant_receivable_cash`
--
ALTER TABLE `accountant_receivable_cash`
  ADD CONSTRAINT `fk_receivable_cash_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_receivable_cash_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_relation_receivable_cash_voucher` FOREIGN KEY (`cash_voucher_id`) REFERENCES `accountant_cash_voucher` (`cash_voucher_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_relation_receivable_voucher` FOREIGN KEY (`receivable_voucher_id`) REFERENCES `accountant_receivable_voucher` (`receivable_voucher_id`) ON UPDATE CASCADE;

--
-- Constraints for table `accountant_receivable_mapping`
--
ALTER TABLE `accountant_receivable_mapping`
  ADD CONSTRAINT `fk_dec_receivable_voucher` FOREIGN KEY (`dec_receivable_voucher_id`) REFERENCES `accountant_receivable_voucher` (`receivable_voucher_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_inc_receivable_voucher` FOREIGN KEY (`inc_receivable_voucher_id`) REFERENCES `accountant_receivable_voucher` (`receivable_voucher_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_receivable_mapping_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_receivable_mapping_currency` FOREIGN KEY (`currency_id`) REFERENCES `definition_list_currency` (`currency_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_receivable_mapping_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `accountant_receivable_type`
--
ALTER TABLE `accountant_receivable_type`
  ADD CONSTRAINT `fk_receivable_type_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_receivable_type_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `accountant_receivable_voucher`
--
ALTER TABLE `accountant_receivable_voucher`
  ADD CONSTRAINT `fk_receivable_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_receivable_currency` FOREIGN KEY (`currency_id`) REFERENCES `definition_list_currency` (`currency_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_receivable_dec_staff` FOREIGN KEY (`dec_staff_id`) REFERENCES `definition_list_staff` (`staff_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_receivable_dec_subject` FOREIGN KEY (`dec_subject_id`) REFERENCES `definition_list_subject` (`subject_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_receivable_inc_staff` FOREIGN KEY (`inc_staff_id`) REFERENCES `definition_list_staff` (`staff_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_receivable_inc_subject` FOREIGN KEY (`inc_subject_id`) REFERENCES `definition_list_subject` (`subject_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_receivable_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_receivable_tax` FOREIGN KEY (`tax_id`) REFERENCES `accountant_list_tax` (`tax_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_receivable_type` FOREIGN KEY (`receivable_type_id`) REFERENCES `accountant_receivable_type` (`receivable_type_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_receivable_voucher` FOREIGN KEY (`voucher_id`) REFERENCES `accountant_transaction_voucher` (`voucher_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_relation_tax`
--
ALTER TABLE `accountant_relation_tax`
  ADD CONSTRAINT `fk_realtion_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_relation_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_relation_tax_product` FOREIGN KEY (`product_id`) REFERENCES `definition_list_product` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_relation_tax_rate` FOREIGN KEY (`tax_rate_id`) REFERENCES `accountant_tax_rate` (`tax_rate_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_relation_tax_specification` FOREIGN KEY (`specification_id`) REFERENCES `accountant_list_specification` (`specification_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_relation_tax_tax` FOREIGN KEY (`tax_id`) REFERENCES `accountant_list_tax` (`tax_id`) ON UPDATE CASCADE;

--
-- Constraints for table `accountant_sales_invoice`
--
ALTER TABLE `accountant_sales_invoice`
  ADD CONSTRAINT `fk_sales_invoice_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_sales_invoice_currency` FOREIGN KEY (`currency_id`) REFERENCES `definition_list_currency` (`currency_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_sales_invoice_customer` FOREIGN KEY (`customer_id`) REFERENCES `definition_list_subject` (`subject_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_sales_invoice_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_sales_invoice_voucher` FOREIGN KEY (`voucher_id`) REFERENCES `accountant_transaction_voucher` (`voucher_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_sales_payable`
--
ALTER TABLE `accountant_sales_payable`
  ADD CONSTRAINT `fk_sales_payable_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_sales_payable_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_sales_payable_payable` FOREIGN KEY (`payable_voucher_id`) REFERENCES `accountant_payable_voucher` (`payable_voucher_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_sales_payable_sales` FOREIGN KEY (`sales_invoice_id`) REFERENCES `accountant_sales_invoice` (`sales_invoice_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_sales_receivable`
--
ALTER TABLE `accountant_sales_receivable`
  ADD CONSTRAINT `fk_sales_receivable_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_sales_receivable_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_sales_receivable_receivable` FOREIGN KEY (`receivable_voucher_id`) REFERENCES `accountant_receivable_voucher` (`receivable_voucher_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_sales_receivable_sales` FOREIGN KEY (`sales_invoice_id`) REFERENCES `accountant_sales_invoice` (`sales_invoice_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_sales_reissue`
--
ALTER TABLE `accountant_sales_reissue`
  ADD CONSTRAINT `fk_reissue_primary` FOREIGN KEY (`primary_sales_invoice_id`) REFERENCES `accountant_sales_invoice` (`sales_invoice_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_reissue_secondary` FOREIGN KEY (`secondary_sales_invoice_id`) REFERENCES `accountant_sales_invoice` (`sales_invoice_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_sales_returns`
--
ALTER TABLE `accountant_sales_returns`
  ADD CONSTRAINT `fk_returns_sales_returns` FOREIGN KEY (`returns_invoice_id`) REFERENCES `accountant_sales_invoice` (`sales_invoice_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_returns_sales_sales` FOREIGN KEY (`sales_invoice_id`) REFERENCES `accountant_sales_invoice` (`sales_invoice_id`) ON UPDATE CASCADE;

--
-- Constraints for table `accountant_tax_rate`
--
ALTER TABLE `accountant_tax_rate`
  ADD CONSTRAINT `fk_tax_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tax_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tax_rate` FOREIGN KEY (`tax_id`) REFERENCES `accountant_list_tax` (`tax_id`) ON UPDATE CASCADE;

--
-- Constraints for table `accountant_transaction_arising`
--
ALTER TABLE `accountant_transaction_arising`
  ADD CONSTRAINT `fk_transaction_arising_currency` FOREIGN KEY (`currency_id`) REFERENCES `definition_list_currency` (`currency_id`),
  ADD CONSTRAINT `fk_transaction_arising_batch` FOREIGN KEY (`batch_id`) REFERENCES `accountant_transaction_batch` (`batch_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_transaction_arising_corresponding_account` FOREIGN KEY (`corresponding_account_id`) REFERENCES `definition_list_account` (`account_id`),
  ADD CONSTRAINT `fk_transaction_arising_entry_account` FOREIGN KEY (`entry_account_id`) REFERENCES `definition_list_account` (`account_id`),
  ADD CONSTRAINT `fk_transaction_arising_subject` FOREIGN KEY (`subject_id`) REFERENCES `definition_list_subject` (`subject_id`);

--
-- Constraints for table `accountant_transaction_batch`
--
ALTER TABLE `accountant_transaction_batch`
  ADD CONSTRAINT `fk_accountant_batch_execution` FOREIGN KEY (`execution_id`) REFERENCES `definition_list_execution` (`execution_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_accountant_batch_voucher` FOREIGN KEY (`voucher_id`) REFERENCES `accountant_transaction_voucher` (`voucher_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_transaction_correspondence`
--
ALTER TABLE `accountant_transaction_correspondence`
  ADD CONSTRAINT `fk_accountant_correspondence_account` FOREIGN KEY (`detail_account_id`) REFERENCES `definition_list_account` (`account_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_accountant_correspondence_currency` FOREIGN KEY (`currency_id`) REFERENCES `definition_list_currency` (`currency_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_accountant_correspondence_entry` FOREIGN KEY (`entry_id`) REFERENCES `accountant_transaction_entry` (`entry_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `accountant_transaction_entry`
--
ALTER TABLE `accountant_transaction_entry`
  ADD CONSTRAINT `fk_accountant_entry_account` FOREIGN KEY (`master_account_id`) REFERENCES `definition_list_account` (`account_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_accountant_entry_batch` FOREIGN KEY (`batch_id`) REFERENCES `accountant_transaction_batch` (`batch_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_accountant_entry_currency` FOREIGN KEY (`currency_id`) REFERENCES `definition_list_currency` (`currency_id`) ON UPDATE CASCADE;

--
-- Constraints for table `accountant_transaction_voucher`
--
ALTER TABLE `accountant_transaction_voucher`
  ADD CONSTRAINT `fk_accountant_voucher_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_accountant_voucher_execution` FOREIGN KEY (`execution_id`) REFERENCES `definition_list_execution` (`execution_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_accountant_voucher_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `core_acl_role_parent`
--
ALTER TABLE `core_acl_role_parent`
  ADD CONSTRAINT `fk_core_acl_role_id` FOREIGN KEY (`role_id`) REFERENCES `definition_list_role` (`role_id`),
  ADD CONSTRAINT `fk_core_acl_role_parent_id` FOREIGN KEY (`role_parent_id`) REFERENCES `definition_list_role` (`role_id`);

--
-- Constraints for table `core_config_value`
--
ALTER TABLE `core_config_value`
  ADD CONSTRAINT `FK_config_field_id` FOREIGN KEY (`config_field_id`) REFERENCES `core_config_field` (`id`);

--
-- Constraints for table `core_module_language`
--
ALTER TABLE `core_module_language`
  ADD CONSTRAINT `fk_module_language_id` FOREIGN KEY (`language_id`) REFERENCES `core_language` (`id`);

--
-- Constraints for table `definition_detail_account`
--
ALTER TABLE `definition_detail_account`
  ADD CONSTRAINT `fk_detail_account` FOREIGN KEY (`account_id`) REFERENCES `definition_list_account` (`account_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_account_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_account_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_account_table` FOREIGN KEY (`table_id`) REFERENCES `definition_list_table` (`table_id`) ON UPDATE CASCADE;

--
-- Constraints for table `definition_detail_currency`
--
ALTER TABLE `definition_detail_currency`
  ADD CONSTRAINT `fk_detail_currency_base` FOREIGN KEY (`base_currency_id`) REFERENCES `definition_list_currency` (`currency_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_currency_convert` FOREIGN KEY (`convert_currency_id`) REFERENCES `definition_list_currency` (`currency_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_currency_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_currency_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `definition_detail_group`
--
ALTER TABLE `definition_detail_group`
  ADD CONSTRAINT `fk_detail_group` FOREIGN KEY (`group_id`) REFERENCES `definition_list_group` (`group_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_group_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_group_criteria` FOREIGN KEY (`criteria_id`) REFERENCES `definition_list_criteria` (`criteria_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_group_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_group_product` FOREIGN KEY (`product_id`) REFERENCES `definition_list_product` (`product_id`) ON UPDATE CASCADE;

--
-- Constraints for table `definition_detail_property`
--
ALTER TABLE `definition_detail_property`
  ADD CONSTRAINT `fk_detail_property` FOREIGN KEY (`property_id`) REFERENCES `definition_list_property` (`property_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_property_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_property_factor` FOREIGN KEY (`factor_id`) REFERENCES `definition_list_factor` (`factor_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_property_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_property_product` FOREIGN KEY (`product_id`) REFERENCES `definition_list_product` (`product_id`) ON UPDATE CASCADE;

--
-- Constraints for table `definition_detail_rank`
--
ALTER TABLE `definition_detail_rank`
  ADD CONSTRAINT `fk_detail_rank` FOREIGN KEY (`rank_id`) REFERENCES `definition_list_rank` (`rank_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_rank_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_rank_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_rank_subject` FOREIGN KEY (`subject_id`) REFERENCES `definition_list_subject` (`subject_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_rank_term` FOREIGN KEY (`term_id`) REFERENCES `definition_list_term` (`term_id`) ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_account`
--
ALTER TABLE `definition_list_account`
  ADD CONSTRAINT `fk_account_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_account_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_account_path`
--
ALTER TABLE `definition_list_account_path`
  ADD CONSTRAINT `definition_list_account_path_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `definition_list_account` (`account_id`) ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_criteria`
--
ALTER TABLE `definition_list_criteria`
  ADD CONSTRAINT `fk_criteria_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_criteria_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_criteria_module` FOREIGN KEY (`module_id`) REFERENCES `definition_list_module` (`module_id`) ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_currency`
--
ALTER TABLE `definition_list_currency`
  ADD CONSTRAINT `fk_currency_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_currency_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_department`
--
ALTER TABLE `definition_list_department`
  ADD CONSTRAINT `fk_department_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_department_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_department_subject` FOREIGN KEY (`subject_id`) REFERENCES `definition_list_subject` (`subject_id`) ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_execution`
--
ALTER TABLE `definition_list_execution`
  ADD CONSTRAINT `fk_execution_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_execution_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_execution_module` FOREIGN KEY (`module_id`) REFERENCES `definition_list_module` (`module_id`) ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_factor`
--
ALTER TABLE `definition_list_factor`
  ADD CONSTRAINT `fk_factor_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_factor_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_function`
--
ALTER TABLE `definition_list_function`
  ADD CONSTRAINT `fk_function_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_function_execution` FOREIGN KEY (`execution_id`) REFERENCES `definition_list_execution` (`execution_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_function_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_group`
--
ALTER TABLE `definition_list_group`
  ADD CONSTRAINT `fk_group_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_group_criteria` FOREIGN KEY (`criteria_id`) REFERENCES `definition_list_criteria` (`criteria_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_group_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_group_path`
--
ALTER TABLE `definition_list_group_path`
  ADD CONSTRAINT `fk_group_path` FOREIGN KEY (`group_id`) REFERENCES `definition_list_group` (`group_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_module`
--
ALTER TABLE `definition_list_module`
  ADD CONSTRAINT `fk_module_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_module_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_product`
--
ALTER TABLE `definition_list_product`
  ADD CONSTRAINT `fk_product_base_unit` FOREIGN KEY (`base_unit_id`) REFERENCES `definition_list_unit` (`unit_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_product_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_product_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_product_producer` FOREIGN KEY (`producer_id`) REFERENCES `definition_list_subject` (`subject_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_product_regular_unit` FOREIGN KEY (`regular_unit_id`) REFERENCES `definition_list_unit` (`unit_id`) ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_property`
--
ALTER TABLE `definition_list_property`
  ADD CONSTRAINT `fk_property_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_property_factor` FOREIGN KEY (`factor_id`) REFERENCES `definition_list_factor` (`factor_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_property_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_rank`
--
ALTER TABLE `definition_list_rank`
  ADD CONSTRAINT `fk_rank_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_rank_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_rank_term` FOREIGN KEY (`term_id`) REFERENCES `definition_list_term` (`term_id`) ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_rank_path`
--
ALTER TABLE `definition_list_rank_path`
  ADD CONSTRAINT `fk_rank_path` FOREIGN KEY (`rank_id`) REFERENCES `definition_list_rank` (`rank_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_role`
--
ALTER TABLE `definition_list_role`
  ADD CONSTRAINT `fk_role_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_role_department` FOREIGN KEY (`department_id`) REFERENCES `definition_list_department` (`department_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_role_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_service`
--
ALTER TABLE `definition_list_service`
  ADD CONSTRAINT `fk_service_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_service_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_service_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `definition_list_subject` (`subject_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_service_unit` FOREIGN KEY (`unit_id`) REFERENCES `definition_list_unit` (`unit_id`) ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_staff`
--
ALTER TABLE `definition_list_staff`
  ADD CONSTRAINT `fk_staff_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_staff_department` FOREIGN KEY (`department_id`) REFERENCES `definition_list_department` (`department_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_staff_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_subject`
--
ALTER TABLE `definition_list_subject`
  ADD CONSTRAINT `fk_subject_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_subject_currency` FOREIGN KEY (`currency_id`) REFERENCES `definition_list_currency` (`currency_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_subject_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_term`
--
ALTER TABLE `definition_list_term`
  ADD CONSTRAINT `fk_term_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_term_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_unit`
--
ALTER TABLE `definition_list_unit`
  ADD CONSTRAINT `fk_unit_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_unit_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_user`
--
ALTER TABLE `definition_list_user`
  ADD CONSTRAINT `fk_user_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_role` FOREIGN KEY (`role_id`) REFERENCES `definition_list_role` (`role_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_staff` FOREIGN KEY (`staff_id`) REFERENCES `definition_list_staff` (`staff_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_list_warehouse`
--
ALTER TABLE `definition_list_warehouse`
  ADD CONSTRAINT `fk_warehouse_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_warehouse_department` FOREIGN KEY (`department_id`) REFERENCES `definition_list_department` (`department_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_warehouse_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_warehouse_type` FOREIGN KEY (`warehouse_type_id`) REFERENCES `definition_warehouse_type` (`warehouse_type_id`) ON UPDATE CASCADE;

--
-- Constraints for table `definition_relation_product_unit`
--
ALTER TABLE `definition_relation_product_unit`
  ADD CONSTRAINT `fk_product_unit_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_product_unit_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_relation_product` FOREIGN KEY (`product_id`) REFERENCES `definition_list_product` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_relation_unit` FOREIGN KEY (`unit_id`) REFERENCES `definition_list_unit` (`unit_id`) ON UPDATE CASCADE;

--
-- Constraints for table `definition_relation_role_function`
--
ALTER TABLE `definition_relation_role_function`
  ADD CONSTRAINT `fk_function_role_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_function_role_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_relation_function` FOREIGN KEY (`function_id`) REFERENCES `definition_list_function` (`function_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_relation_role` FOREIGN KEY (`role_id`) REFERENCES `definition_list_role` (`role_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `definition_voucher_type`
--
ALTER TABLE `definition_voucher_type`
  ADD CONSTRAINT `fk_voucher_type_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_voucher_type_execution` FOREIGN KEY (`execution_id`) REFERENCES `definition_list_execution` (`execution_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_voucher_type_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_voucher_type_module` FOREIGN KEY (`module_id`) REFERENCES `definition_list_module` (`module_id`) ON UPDATE CASCADE;

--
-- Constraints for table `definition_warehouse_type`
--
ALTER TABLE `definition_warehouse_type`
  ADD CONSTRAINT `fk_warehouse_type_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_warehouse_type_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `purchase_detail_order`
--
ALTER TABLE `purchase_detail_order`
  ADD CONSTRAINT `fk_detail_purchase_order` FOREIGN KEY (`purchase_order_id`) REFERENCES `purchase_transaction_order` (`purchase_order_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_order_product` FOREIGN KEY (`product_id`) REFERENCES `definition_list_product` (`product_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_order_unit` FOREIGN KEY (`unit_id`) REFERENCES `definition_list_unit` (`unit_id`) ON UPDATE CASCADE;

--
-- Constraints for table `purchase_transaction_order`
--
ALTER TABLE `purchase_transaction_order`
  ADD CONSTRAINT `fk_purchase_order_created_user` FOREIGN KEY (`created_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_order_currency` FOREIGN KEY (`currency_id`) REFERENCES `definition_list_currency` (`currency_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_order_modified_user` FOREIGN KEY (`last_modified_by_userid`) REFERENCES `definition_list_user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_order_period` FOREIGN KEY (`period_id`) REFERENCES `definition_list_period` (`period_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_purchase_order_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `definition_list_subject` (`subject_id`) ON UPDATE CASCADE;

--
-- Constraints for table `warehousing_product_balance`
--
ALTER TABLE `warehousing_product_balance`
  ADD CONSTRAINT `fk_inventory_balance_period` FOREIGN KEY (`period_id`) REFERENCES `definition_list_period` (`period_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_inventory_balance_product` FOREIGN KEY (`product_id`) REFERENCES `definition_list_product` (`product_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_inventory_balance_unit` FOREIGN KEY (`unit_id`) REFERENCES `definition_list_unit` (`unit_id`) ON UPDATE CASCADE;

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `st_auto_accounting_purchase`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `st_auto_accounting_purchase`(IN `batchId` bigint)
BEGIN
	#Routine body goes here...

	INSERT INTO `definition_list_user` (`user_id`, `staff_id`, `role_id`, `user_name`, `password`, `inactive`, 
	`created_by_userid`, `date_entered`, `last_modified_by_userid`, `date_last_modified`, `date_last_logined`, `theme_type`, 
	`screen_type`) VALUES (NULL, '', '', '', '', '', '', '', '', '', '', '', '');

END$$

DROP PROCEDURE IF EXISTS `st_calc_ending_balance`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `st_calc_ending_balance`()
BEGIN
	#Routine body goes here...
	DECLARE currentPeriod INT;
	DECLARE accountId BIGINT(30);
	DECLARE currencyId BIGINT(30);
	DECLARE debitCreditBalance TINYINT(1);
	
	DECLARE PSNTN BIGINT(30);
	DECLARE PSQDN BIGINT(30);
	DECLARE PSNTC BIGINT(30);
	DECLARE PSQDC BIGINT(30);
	DECLARE sum_original_amount BIGINT(30);
	DECLARE sum_onverted_amount BIGINT(30);

	DECLARE SDNT BIGINT(30);
	DECLARE SDQD BIGINT(30);
	DECLARE BDKT TINYINT(1);
	DECLARE first_original_amount BIGINT(30);
	DECLARE first_converted_amount BIGINT(30);
	DECLARE first_debit_credit TINYINT(1);
	
	DECLARE checkOfNewAccount BIGINT(30);	
	DECLARE newConvertedAmount BIGINT(30);
	DECLARE newOriginalAmount BIGINT(30);
	DECLARE newDebitCredit TINYINT(1);
	DECLARE checkOfExistedAccount INT(11);	

	DECLARE done_allAccount VARCHAR(5) DEFAULT 'START';
	DECLARE curAllAccount CURSOR FOR 
		select dacc.account_id, dacc.currency_id, dla.debit_credit_balance 
		from (
			select distinct detail_account_id as account_id, currency_id from accountant_transaction_correspondence union 
			select distinct master_account_id  as account_id, currency_id from accountant_transaction_entry) as dacc
			left join definition_list_account as dla on dacc.account_id = dla.account_id
		order by dacc.account_id;
	
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done_allAccount = 'END';

	SET currentPeriod = (select period_id from definition_list_period where current = 1 limit 1);

	OPEN curAllAccount;  
	allAccount: LOOP
	
				FETCH curAllAccount INTO accountId, currencyId, debitCreditBalance;
				IF done_allAccount = 'END' THEN        
						LEAVE allAccount;
				END IF;
				
				SET PSNTN = 0;
				SET PSQDN = 0;
				SET PSNTC = 0;
				SET PSQDC = 0;
				CALL st_sum_transaction_entry(currentPeriod, currencyId, -1, accountId, sum_original_amount, sum_onverted_amount);				
				SET PSNTN = PSNTN + sum_original_amount;
				SET PSQDN = PSQDN + sum_onverted_amount;
				CALL st_sum_transaction_correspondence(currentPeriod, currencyId, -1, accountId, sum_original_amount, sum_onverted_amount);				
				SET PSNTN = PSNTN + sum_original_amount;
				SET PSQDN = PSQDN + sum_onverted_amount;
				
				CALL st_sum_transaction_entry(currentPeriod, currencyId, 1, accountId, sum_original_amount, sum_onverted_amount);				
				SET PSNTC = PSNTC + sum_original_amount;
				SET PSQDC = PSQDC + sum_onverted_amount;
				CALL st_sum_transaction_correspondence(currentPeriod, currencyId, 1, accountId, sum_original_amount, sum_onverted_amount) ;				
				SET PSNTC = PSNTC + sum_original_amount;
				SET PSQDC = PSQDC + sum_onverted_amount;
				
				SET SDNT = 0;
				SET SDQD = 0;
				SET BDKT = 1;
				CALL st_get_account_balance(currentPeriod - 1, currencyId, accountId, first_debit_credit, first_original_amount, first_converted_amount);				
				SET SDNT = first_original_amount;
				SET SDQD = first_converted_amount;
				SET BDKT = first_debit_credit;
				
				IF debitCreditBalance = -1 OR debitCreditBalance = 1 THEN 
					SET newDebitCredit = debitCreditBalance;
					SET newOriginalAmount = SDNT + PSNTN - PSNTC;
					SET newConvertedAmount = SDQD + PSQDN - PSQDC;
				ELSEIF debitCreditBalance =2 THEN
					SET checkOfNewAccount = SDNT + (PSNTC - PSNTN) * BDKT;
					IF checkOfNewAccount >= 0 THEN 
						SET newDebitCredit = 1;
						SET newOriginalAmount = SDNT + (PSNTC - PSNTN) * BDKT;
						SET newConvertedAmount = SDQD + (PSQDC - PSQDN) * BDKT;
					ELSE
						SET newDebitCredit = -1;
						SET newOriginalAmount = -SDNT - (PSNTC - PSNTN) * BDKT;
						SET newConvertedAmount = -SDQD - (PSQDC - PSQDN) * BDKT;
					END IF;
				END IF;
				
				SET checkOfExistedAccount =  (select count(account_id) 
								from accountant_account_balance 
								where period_id = currentPeriod and 
									account_id = accountId and 
									currency_id = currencyId limit 1);
				
				IF checkOfExistedAccount is null OR checkOfExistedAccount = 0 THEN
					INSERT INTO accountant_account_balance (period_id, account_id, currency_id, debit_credit, original_amount, converted_amount)
					VALUES (currentPeriod, accountId, currencyId, newDebitCredit, newOriginalAmount, newConvertedAmount);
				ELSE 
					UPDATE accountant_account_balance SET debit_credit = newDebitCredit, original_amount = newOriginalAmount, converted_amount = newConvertedAmount
					WHERE period_id = currentPeriod AND account_id = accountId AND currency_id = currencyId LIMIT 1 ;
				END IF;
				
	END LOOP allAccount;
  CLOSE curAllAccount;

	
END$$

DROP PROCEDURE IF EXISTS `st_forward_final_entry`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `st_forward_final_entry`()
BEGIN
	
	DECLARE currentPeriod INT;
	
	DECLARE autoBatchId BIGINT(30);	
	DECLARE autoBatchNote VARCHAR(300);
	DECLARE autoBatchExecutionId INT;
	DECLARE autoEntryId BIGINT(30);
	DECLARE autoEntryBatchId BIGINT(30);	
	DECLARE autoEntryMasterAccount BIGINT(30);	
	DECLARE autoEntryDebitCredit TINYINT(1);
	DECLARE autoEntryCurrencyId BIGINT(30);

	DECLARE autoCorresId BIGINT(30);
	DECLARE autoCorresEntryId BIGINT(30);	
	DECLARE autoCorresDetailAccount BIGINT(30);	
	DECLARE autoCorresDebitCredit TINYINT(1);
	
	DECLARE forexRate DECIMAL(18,4);
	DECLARE sum_original_amount BIGINT(30);
	DECLARE sum_onverted_amount BIGINT(30);

	DECLARE GTNTKC BIGINT(30);
	DECLARE GTQDKC BIGINT(30);
	DECLARE TNTKC	BIGINT(30);
	DECLARE TQDKC	BIGINT(30);

	DECLARE lastInsertIdOfVoucher BIGINT(30);
	DECLARE lastInsertIdOfBatch BIGINT(30);
	DECLARE lastInsertIdOfEntry BIGINT(30);
	
	DECLARE done_autoBatch VARCHAR(5) DEFAULT 'START';
	DECLARE done_autoEntry VARCHAR(5) DEFAULT 'START';
	DECLARE done_autoCorres VARCHAR(5) DEFAULT 'START';

	DECLARE curAutoBatch CURSOR FOR 
		SELECT auto_batch_id, execution_id, batch_note FROM accountant_auto_batch 
		WHERE is_closing_batch = 1 ORDER BY batch_order;
	DECLARE curAutoEntry CURSOR FOR SELECT auto_entry_id, auto_batch_id, master_account_id, debit_credit, currency_id FROM accountant_auto_entry;
	DECLARE curAutoCorres CURSOR FOR SELECT auto_correspondence_id, auto_entry_id, detail_account_id, debit_credit FROM accountant_auto_correspondence;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done_autoBatch = 'END';

	SET currentPeriod = (select period_id from definition_list_period where current = 1 limit 1);
	INSERT INTO accountant_transaction_voucher 
	(from_transference, execution_id, period_id, voucher_number, voucher_date) 
		VALUES (0, 21, currentPeriod, 'KCCK', CURDATE());
	SET lastInsertIdOfVoucher = LAST_INSERT_ID();
	
	OPEN curAutoBatch;  
	allAutoAutoBatch: LOOP
	
				FETCH curAutoBatch INTO autoBatchId, autoBatchExecutionId, autoBatchNote;
				IF done_autoBatch = 'END' THEN        
						LEAVE allAutoAutoBatch;
				END IF;

				INSERT INTO accountant_transaction_batch 
				(voucher_id, execution_id, batch_note) 
				VALUES (lastInsertIdOfVoucher, autoBatchExecutionId, autoBatchNote);		
				SET lastInsertIdOfBatch = LAST_INSERT_ID();
						
				OPEN curAutoEntry;
					SET done_autoEntry = done_autoBatch;
					WHILE done_autoBatch <> 'END' DO
						FETCH curAutoEntry INTO autoEntryId, autoEntryBatchId, autoEntryMasterAccount, autoEntryDebitCredit, autoEntryCurrencyId;
						IF done_autoBatch <> 'END' AND autoEntryBatchId = autoBatchId THEN
							
							SET TNTKC = 0;
							SET TQDKC = 0;

							INSERT INTO accountant_transaction_entry (entry_type_id, batch_id, master_account_id, debit_credit, currency_id) 
							VALUES (0, lastInsertIdOfBatch, autoEntryMasterAccount, autoEntryDebitCredit, autoEntryCurrencyId);
							SET lastInsertIdOfEntry = LAST_INSERT_ID();
								
							OPEN curAutoCorres;		
								SET done_autoCorres = done_autoBatch;
								WHILE done_autoBatch <> 'END' DO	
									FETCH curAutoCorres INTO autoCorresId, autoCorresEntryId, autoCorresDetailAccount, autoCorresDebitCredit;
									
									IF done_autoBatch <> 'END' AND autoCorresEntryId = autoEntryId THEN															
										
										SET GTNTKC = 0;
										SET GTQDKC = 0;
													
										CALL st_sum_transaction_entry(1, autoEntryCurrencyId, -autoCorresDebitCredit, autoCorresDetailAccount, sum_original_amount, sum_onverted_amount);
										SET GTNTKC = GTNTKC + sum_original_amount;
										SET GTQDKC = GTQDKC + sum_onverted_amount;
										CALL st_sum_transaction_correspondence(1, autoEntryCurrencyId, -autoCorresDebitCredit, autoCorresDetailAccount, sum_original_amount, sum_onverted_amount);
										SET GTNTKC = GTNTKC + sum_original_amount;
										SET GTQDKC = GTQDKC + sum_onverted_amount;
										CALL st_sum_transaction_entry(1, autoEntryCurrencyId, autoCorresDebitCredit, autoCorresDetailAccount, sum_original_amount, sum_onverted_amount);
										SET GTNTKC = GTNTKC - sum_original_amount;
										SET GTQDKC = GTQDKC - sum_onverted_amount;
										CALL st_sum_transaction_correspondence(1, autoEntryCurrencyId, autoCorresDebitCredit, autoCorresDetailAccount, sum_original_amount, sum_onverted_amount);
										SET GTNTKC = GTNTKC - sum_original_amount;
										SET GTQDKC = GTQDKC - sum_onverted_amount;

										SET TNTKC = TNTKC + GTNTKC;
										SET TQDKC = TQDKC + GTQDKC;
										SET forexRate = GTQDKC/GTNTKC;
										IF forexRate IS NULL THEN 
											SET forexRate = 0;
										END IF;
										
										INSERT INTO accountant_transaction_correspondence (
											entry_id, detail_account_id, debit_credit, currency_id, original_amount, converted_amount, forex_rate) 
										VALUES (lastInsertIdOfEntry, autoCorresDetailAccount, autoCorresDebitCredit, autoEntryCurrencyId, GTNTKC, GTQDKC, forexRate);												
																		
									END IF;

								END WHILE;
							CLOSE curAutoCorres;
														
							
							UPDATE accountant_transaction_entry 
							SET original_amount = TNTKC, converted_amount = TQDKC, forex_rate = TQDKC/TNTKC
							WHERE accountant_transaction_entry.entry_id = lastInsertIdOfEntry;

							SET done_autoBatch = done_autoCorres;
						END IF;
					END WHILE;
				CLOSE curAutoEntry;


				SET done_autoBatch = done_autoEntry;
	END LOOP allAutoAutoBatch;
  CLOSE curAutoBatch;

	

END$$

DROP PROCEDURE IF EXISTS `st_get_account_balance`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `st_get_account_balance`(IN `periodId` bigint,IN `currencyId` bigint,IN `accountId` bigint,OUT `first_debit_credit` tinyint, OUT `first_original_amount` bigint, OUT `first_converted_amount` bigint)
BEGIN
	DECLARE c_done INT DEFAULT 0;
	DECLARE originalAmount BIGINT(30);
	DECLARE convertedAmount BIGINT(30);
	DECLARE debitCredit TINYINT(1);
	
	declare curBalance cursor for 
				select debit_credit, original_amount, converted_amount 
				from accountant_account_balance
				where period_id = periodId and account_id = accountId and currency_id = currencyId limit 1;	
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET c_done = 1;
	open curBalance;
	WHILE c_done = 0 DO
		fetch curBalance into debitCredit, originalAmount, convertedAmount;
	END WHILE;
	close curBalance; 
	
	IF originalAmount IS NULL THEN 
		SET originalAmount = 0;
	END IF;
	IF convertedAmount IS NULL THEN 
		SET convertedAmount = 0;
	END IF;
	IF debitCredit IS NULL THEN 
		SET debitCredit = 1;
	END IF;
	
	SET first_original_amount = originalAmount;
	SET first_converted_amount = convertedAmount;
	SET first_debit_credit = debitCredit;
END$$

DROP PROCEDURE IF EXISTS `st_sum_transaction_correspondence`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `st_sum_transaction_correspondence`(IN `periodId` bigint,IN `currencyId` bigint,IN `debitCredit` tinyint,IN `detailAccountId` bigint, OUT `sum_original_amount` bigint, OUT `sum_onverted_amount` bigint)
BEGIN
	
	DECLARE sumOriginalValue BIGINT(30);
	DECLARE sumConvertedValue BIGINT(30);
	declare sum_cur cursor for 
				select SUM(atc.original_amount), SUM(atc.converted_amount)
				
				from accountant_transaction_correspondence as atc
				left join accountant_transaction_entry as ate
				on ate.entry_id = atc.entry_id
				left join accountant_transaction_batch as atb
				on atb.batch_id = ate.batch_id
				left join accountant_transaction_voucher as atv
				on atb.voucher_id = atv.voucher_id

				where atv.period_id = periodId 
				and atc.currency_id = currencyId 
				and atc.debit_credit = debitCredit
				and atc.detail_account_id = detailAccountId;
	open sum_cur;
	fetch sum_cur into sumOriginalValue, sumConvertedValue;
	close sum_cur; 

	IF sumOriginalValue IS NULL THEN 
		SET sumOriginalValue = 0;
	END IF;
	IF sumConvertedValue IS NULL THEN 
		SET sumConvertedValue = 0;
	END IF;
	
	SET sum_original_amount = sumOriginalValue;
	SET sum_onverted_amount = sumConvertedValue;
END$$

DROP PROCEDURE IF EXISTS `st_sum_transaction_entry`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `st_sum_transaction_entry`(IN `periodId` bigint,IN `currencyId` bigint,IN `debitCredit` tinyint,IN `masterAccountId` bigint, OUT `sum_original_amount` bigint, OUT `sum_onverted_amount` bigint)
BEGIN
	
	DECLARE sumOriginalValue BIGINT(30);
	DECLARE sumConvertedValue BIGINT(30);
	declare sum_cur cursor for 
	select SUM(ate.original_amount), SUM(ate.converted_amount)

				from accountant_transaction_entry as ate
				left join accountant_transaction_batch as atb
				on atb.batch_id = ate.batch_id
				left join accountant_transaction_voucher as atv
				on atb.voucher_id = atv.voucher_id

				where atv.period_id = periodId 
				and ate.currency_id = currencyId 
				and ate.debit_credit = debitCredit
				and ate.master_account_id = masterAccountId;
	open sum_cur;
	fetch sum_cur into sumOriginalValue, sumConvertedValue;
	close sum_cur; 

	IF sumOriginalValue IS NULL THEN 
		SET sumOriginalValue = 0;
	END IF;
	IF sumConvertedValue IS NULL THEN 
		SET sumConvertedValue = 0;
	END IF;
	
	SET sum_original_amount = sumOriginalValue;
	SET sum_onverted_amount = sumConvertedValue;
END$$

DELIMITER ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
