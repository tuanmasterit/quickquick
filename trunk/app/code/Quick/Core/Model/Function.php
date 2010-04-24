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
				array('cl' => 'core_language'), 
				"cl.id = cml.language_id", 
				array())
		->where('cm.execution_id = ?', $executionId)
		->where('cm.inactive = ?', 0)
		->where('cl.locale = ?', $locale)
		->where('cml.table_name = ?', $this->_name)
		->order('cm.display_order');

		return $this->getAdapter()->fetchAll($select->__toString());
    }
}