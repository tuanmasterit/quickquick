/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

ALTER TABLE `accountant_cash_voucher`
DROP COLUMN `turnover_id`,
MODIFY COLUMN `cash_voucher_id`  bigint(30) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Mã chứng từ' FIRST ,
MODIFY COLUMN `voucher_type_id`  bigint(30) UNSIGNED NOT NULL COMMENT 'Mã loại chứng từ' AFTER `cash_voucher_id`,
MODIFY COLUMN `cash_voucher_number`  varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'Số chứng từ' AFTER `voucher_id`,
MODIFY COLUMN `cash_voucher_date`  datetime NOT NULL COMMENT 'Ngày chứng từ' AFTER `cash_voucher_number`,
MODIFY COLUMN `subject_id`  bigint(30) UNSIGNED NOT NULL COMMENT 'Mã đơn vị' AFTER `cash_voucher_date`,
MODIFY COLUMN `subject_name`  varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'Tên đơn vị' AFTER `subject_id`,
MODIFY COLUMN `subject_address`  varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'Địa chỉ đơn vị' AFTER `subject_name`,
MODIFY COLUMN `subject_contact`  varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'Người nộp tiền trong trường hợp thu, người nhận tiền trong trường hợp chi' AFTER `subject_address`,
MODIFY COLUMN `staff_id`  bigint(30) UNSIGNED NOT NULL COMMENT 'Nhân viên' AFTER `subject_contact`,
MODIFY COLUMN `department_id`  bigint(30) UNSIGNED NOT NULL COMMENT 'Bộ phận' AFTER `staff_id`,
MODIFY COLUMN `in_bank_id`  bigint(30) UNSIGNED NOT NULL COMMENT 'Ngân hàng thu' AFTER `department_id`,
MODIFY COLUMN `in_bank_account_id`  bigint(30) UNSIGNED NOT NULL COMMENT 'Tài khoản ngân hàng thu' AFTER `in_bank_id`,
MODIFY COLUMN `out_bank_id`  bigint(30) UNSIGNED NOT NULL COMMENT 'Ngân hàng chi' AFTER `in_bank_account_id`,
MODIFY COLUMN `out_bank_account_id`  bigint(30) UNSIGNED NOT NULL COMMENT 'Tài khoản ngân hàng chi' AFTER `out_bank_id`,
MODIFY COLUMN `expense_id`  bigint(30) UNSIGNED NOT NULL COMMENT 'Loại chi phí' AFTER `out_bank_account_id`,
MODIFY COLUMN `amount`  decimal(18,4) NOT NULL COMMENT 'tổng nguyên tệ của chi tiết' AFTER `expense_id`,
MODIFY COLUMN `currency_id`  bigint(30) UNSIGNED NOT NULL COMMENT 'loại tiền tệ' AFTER `amount`,
MODIFY COLUMN `forex_rate`  decimal(18,4) NOT NULL COMMENT 'tỷ giá qui đổi' AFTER `currency_id`,
MODIFY COLUMN `converted_amount`  decimal(18,4) NOT NULL COMMENT 'Thành tiền qui đổi' AFTER `forex_rate`,
MODIFY COLUMN `in_out`  tinyint(1) UNSIGNED NOT NULL COMMENT 'Phiếu thu 1, phiếu chi 2, chuyển khoản 3' AFTER `converted_amount`,
MODIFY COLUMN `description`  varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'Lý do thu tiền' AFTER `in_out`;

ALTER TABLE `accountant_invoice_detail`
DROP COLUMN `order_number`,
MODIFY COLUMN `serial_number`  varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'số seri' AFTER `cash_voucher_id`,
MODIFY COLUMN `invoice_number`  varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'số hóa đơn' AFTER `serial_number`,
MODIFY COLUMN `invoice_date`  datetime NOT NULL COMMENT 'ngày hóa đơn' AFTER `invoice_number`,
CHANGE COLUMN `supplier_id` `subject_id`  bigint(30) UNSIGNED NOT NULL COMMENT 'mã đối tượng' AFTER `invoice_date`,
CHANGE COLUMN `supplier_name` `subject_name`  varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'tên đối tượng' AFTER `subject_id`,
CHANGE COLUMN `supplier_address` `subject_address`  varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'địa chỉ đối tượng' AFTER `subject_name`,
CHANGE COLUMN `supplier_tax_code` `subject_tax_code`  varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'mã số thuế' AFTER `subject_address`,
MODIFY COLUMN `product_name`  varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'mặt hàng' AFTER `subject_tax_code`,
ADD COLUMN `quantity`  decimal(18,4) NOT NULL COMMENT 'số lượng' AFTER `product_name`,
ADD COLUMN `price`  decimal(18,4) NOT NULL COMMENT 'đơn giá' AFTER `quantity`,
ADD COLUMN `amount`  decimal(18,4) NOT NULL COMMENT 'thành tiền' AFTER `price`,
ADD COLUMN `currency_id`  bigint(30) NOT NULL COMMENT 'loại tiền tệ' AFTER `amount`,
ADD COLUMN `forex_rate`  decimal(18,4) NOT NULL COMMENT 'tỷ giá quy đổi' AFTER `currency_id`,
MODIFY COLUMN `converted_amount`  decimal(18,4) NOT NULL COMMENT 'thành tiền quy đổi' AFTER `forex_rate`,
MODIFY COLUMN `vat_rate`  tinyint(2) UNSIGNED NOT NULL COMMENT 'vat %' AFTER `converted_amount`,
MODIFY COLUMN `vat_amount`  decimal(18,4) NOT NULL COMMENT 'tien thue' AFTER `vat_rate`,
CHANGE COLUMN `note` `note_invoice`  text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'diễn giải chứng từ' AFTER `vat_amount`,
MODIFY COLUMN `department_id`  bigint(30) UNSIGNED NOT NULL COMMENT 'bộ phận' AFTER `note_invoice`,
MODIFY COLUMN `expense_id`  bigint(30) UNSIGNED NOT NULL COMMENT 'laoi chi phí' AFTER `department_id`,
MODIFY COLUMN `debit_account_id`  bigint(30) UNSIGNED NOT NULL COMMENT 'tài khoản nợ' AFTER `expense_id`,
ADD COLUMN `note_debit_account`  text NULL COMMENT 'diễn giải bút toán nợ' AFTER `debit_account_id`,
MODIFY COLUMN `credit_account_id`  bigint(30) UNSIGNED NOT NULL COMMENT 'tài khoản có' AFTER `note_debit_account`,
ADD COLUMN `note_credit_account`  text NULL COMMENT 'diễn giải bút toán có' AFTER `credit_account_id`,
DROP PRIMARY KEY,
ADD PRIMARY KEY (`cash_voucher_id`);

ALTER TABLE `accountant_transaction_batch`
ADD COLUMN `table_id`  bigint(30) NOT NULL AFTER `batch_note`,
ADD COLUMN `detail_id`  bigint(30) NOT NULL AFTER `table_id`;

ALTER TABLE `accountant_transaction_entry`
ADD COLUMN `note`  text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER `converted_amount`;

ALTER TABLE `accountant_transaction_correspondence`
ADD COLUMN `note`  text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER `converted_amount`;

ALTER TABLE `accountant_transaction_entry`
ADD COLUMN `obj_type_id_1`  bigint(30) NOT NULL AFTER `note`,
ADD COLUMN `obj_key_id_1`  bigint(30) NOT NULL AFTER `obj_type_id_1`,
ADD COLUMN `obj_type_id_2`  bigint(30) NOT NULL AFTER `obj_key_id_1`,
ADD COLUMN `obj_key_id_2`  bigint(30) NOT NULL AFTER `obj_type_id_2`,
ADD COLUMN `obj_type_id_3`  bigint(30) NOT NULL AFTER `obj_key_id_2`,
ADD COLUMN `obj_key_id_3`  bigint(30) NOT NULL AFTER `obj_type_id_3`,
ADD COLUMN `obj_type_id_4`  bigint(30) NOT NULL AFTER `obj_key_id_3`,
ADD COLUMN `obj_key_id_4`  bigint(30) NOT NULL AFTER `obj_type_id_4`,
ADD COLUMN `obj_type_id_5`  bigint(30) NOT NULL AFTER `obj_key_id_4`,
ADD COLUMN `obj_key_id_5`  bigint(30) NOT NULL AFTER `obj_type_id_5`;

ALTER TABLE `accountant_transaction_correspondence`
ADD COLUMN `obj_type_id_1`  bigint(30) NOT NULL AFTER `note`,
ADD COLUMN `obj_key_id_1`  bigint(30) NOT NULL AFTER `obj_type_id_1`,
ADD COLUMN `obj_type_id_2`  bigint(30) NOT NULL AFTER `obj_key_id_1`,
ADD COLUMN `obj_key_id_2`  bigint(30) NOT NULL AFTER `obj_type_id_2`,
ADD COLUMN `obj_type_id_3`  bigint(30) NOT NULL AFTER `obj_key_id_2`,
ADD COLUMN `obj_key_id_3`  bigint(30) NOT NULL AFTER `obj_type_id_3`,
ADD COLUMN `obj_type_id_4`  bigint(30) NOT NULL AFTER `obj_key_id_3`,
ADD COLUMN `obj_key_id_4`  bigint(30) NOT NULL AFTER `obj_type_id_4`,
ADD COLUMN `obj_type_id_5`  bigint(30) NOT NULL AFTER `obj_key_id_4`,
ADD COLUMN `obj_key_id_5`  bigint(30) NOT NULL AFTER `obj_type_id_5`;

ALTER TABLE `accountant_transaction_batch`
CHANGE COLUMN `table_id` `obj_type_id`  bigint(30) NOT NULL AFTER `batch_note`,
CHANGE COLUMN `detail_id` `obj_key_id`  bigint(30) NOT NULL AFTER `obj_type_id`;

ALTER TABLE `accountant_sales_invoice`
ADD COLUMN `debit_account_id`  bigint(30) NOT NULL AFTER `payment_type`,
ADD COLUMN `credit_account_id_amount`  bigint(30) NOT NULL AFTER `debit_account_id`,
ADD COLUMN `credit_account_id_vat`  bigint(30) NOT NULL AFTER `credit_account_id_amount`,
ADD COLUMN `crediit_account_id_export`  bigint(30) NOT NULL AFTER `credit_account_id_vat`,
ADD COLUMN `credit_acount_id_excise`  bigint(30) NOT NULL AFTER `crediit_account_id_export`;