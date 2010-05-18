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
VALUES (
NULL , '12', 'DKTD', 'Thiết lập định khoản tự động', 'accountant/maintenance/auto-to-account', '0', '6', '0', '1900-01-01 00:00:00', '0', '1900-01-01 00:00:00'
);

INSERT INTO `core_module_language` (
`language_id` ,
`table_name` ,
`field_name` ,
`record_id` ,
`value`
)
VALUES (
'2', 'definition_list_function', '', '78', 'Thiết lập định khoản tự động'
);

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
VALUES (
NULL , '12', 'DMT', 'Danh mục thuế', 'accountant/maintenance/tax-catalog', '0', '7', '0', '1900-01-01 00:00:00', '0', '1900-01-01 00:00:00'
);

INSERT INTO `core_module_language` (
`language_id` ,
`table_name` ,
`field_name` ,
`record_id` ,
`value`
)
VALUES (
'2', 'definition_list_function', '', '79', 'Danh mục thuế'
);