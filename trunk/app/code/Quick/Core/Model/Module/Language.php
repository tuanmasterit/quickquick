<?php
/**
 *
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Core_Model_Module_Language extends Quick_Db_Table
{
	protected $_name 						= 'core_module_language';
	protected $_TABLE_CORE_LANGUAGE			= 'core_language';
	protected $_TABLE_DEFINITION_FUNCTION 	= 'definition_list_function';
	protected $_rowClass 					= 'Quick_Db_Table_Row';

	/**
	 * Retrieve the value for translation
	 *
	 * @param string $module
	 * @param string $locale
	 * @param string $key
	 * @return translated value
	 */
	public function getTranslatedValue($table, $locale, $key){
		$select = $this->getAdapter()->select();
		$select->from(
			array('cf' => $this->_TABLE_DEFINITION_FUNCTION),
			array('cf.function_action'))
		->joinLeft(
			array('cml' => $this->_name),
					"cml.record_id = cf.function_id", 
			array('cml.value'))
		->joinLeft(
			array('cl' => 'core_language'),
					"cl.id = cml.language_id", 
			array())
		->where('cf.function_action = ?', $key)
		->where('cl.locale = ?', $locale)
		->where('cml.table_name = ?', $table)
		->order('cf.display_order');
		$rows = $select->query()->fetch();
		return $rows['value'];
	}
}