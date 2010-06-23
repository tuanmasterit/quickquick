/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

INSERT INTO `definition_list_function` (
`function_id` ,
`execution_id` ,
`function_code` ,
`function_name` ,
`function_action` ,
`inactive` ,
`display_order` ,
`created_by_userid` ,
`date_entered` ,
`last_modified_by_userid` ,
`date_last_modified`
)
VALUES 
(NULL , '21', 'KSCK', 'Khóa sổ cuối kỳ', 'accountant/general/ending-period', '0', '2', '0', '1900-01-01 00:00:00', '0', '1900-01-01 00:00:00'),
(NULL , '21', 'ABTD', 'Định khoản bán tự động', 'accountant/general/accounting-semiauto', '0', '3', '0', '1900-01-01 00:00:00', '0', '1900-01-01 00:00:00');

INSERT INTO `core_module_language` (
`language_id` ,
`table_name` ,
`field_name` ,
`record_id` ,
`value`
)
VALUES 
('1', 'definition_list_function', '', '87', 'Ending of accouting period'),
('2', 'definition_list_function', '', '87', 'Khóa sổ cuối kỳ'),
('1', 'definition_list_function', '', '88', 'Accounting Semiautomatic'),
('2', 'definition_list_function', '', '88', 'Định khoản bán tự động');