<?php
/**
 *
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Core_Model_Function extends Quick_Db_Table
{
	protected $_name 						= 'definition_list_function';
	protected $_TABLE_CORE_MODULE_LANGUAGE 	= 'core_module_language';
	protected $_TABLE_CORE_LANGUAGE 		= 'core_language';
	protected $_TABLE_DEFINITION_EXECUTION	= 'definition_list_execution';
	protected $_TABLE_DEFINITION_MODULE 	= 'definition_list_module';

	/**
	 * Retrieve array of Execution of Module ID
	 *
	 * @return array
	 */
	public function getListFunctions($executionId, $locale)
	{
		$select = $this->getAdapter()->select();
		$select->from(
		array('cm' => $this->_name),
		array('cm.function_action'))
		->joinLeft(
		array('cml' => $this->_TABLE_CORE_MODULE_LANGUAGE),
				"cml.record_id = cm.function_id", 
		array('cml.language_id', 'cml.value'))
		->joinLeft(
		array('cl' => $this->_TABLE_CORE_LANGUAGE),
				"cl.id = cml.language_id", 
		array())
		->where('cm.execution_id = ?', $executionId)
		->where('cm.inactive = ?', 0)
		->where('cl.locale = ?', $locale)
		->where('cml.table_name = ?', $this->_name)
		->order('cm.display_order');

		return $this->getAdapter()->fetchAll($select->__toString());
	}
	
	/**
	 * Retrieve array of Function
	 *
	 * @return array
	 */
	public function getFunctions($locale){
		$select = $this->getAdapter()->select();
		$select->from(
		array('cr' => $this->_name),
		array('cr.function_id', 'cr.function_action'))
		->joinLeft(
		array('ce' => $this->_TABLE_DEFINITION_EXECUTION), "ce.execution_id = cr.execution_id",
		array())
		->joinLeft(
		array('cm' => $this->_TABLE_DEFINITION_MODULE), "cm.module_id = ce.module_id",
		array('cm.package'))
		->joinLeft(
		array('cml' => $this->_TABLE_CORE_MODULE_LANGUAGE), "cml.record_id = cr.function_id",
		array('cml.value as function_value'))
		->joinLeft(
		array('cl' => $this->_TABLE_CORE_LANGUAGE),	"cl.id = cml.language_id", 
		array())
		->where('cm.inactive = ?', 0)
		->where('ce.inactive = ?', 0)
		->where('cr.inactive = ?', 0)
		->where('cml.table_name = ?', $this->_name)
		->where('cl.locale = ?', $locale)
		->order('cm.display_order')
		->order('ce.display_order')
		->order('cr.display_order');
		return $this->getAdapter()->fetchAll($select->__toString());
	}
}