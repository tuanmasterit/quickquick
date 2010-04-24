<?php
/**
 *
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Core_Model_Execution extends Quick_Db_Table
{
	protected $_name 						= 'definition_list_execution';
	protected $_TABLE_CORE_MODULE_LANGUAGE 	= 'core_module_language';
	protected $_TABLE_CORE_LANGUAGE 		= 'core_language';

	/**
	 * Retrieve array of Execution of Module ID
	 *
	 * @return array
	 */
	public function getListExecutions($moduleId, $locale)
	{
		$select = $this->getAdapter()->select();
		$select->from(
			array('cm' => $this->_name),
			array('cm.execution_id', 'cm.image_file'))
		->joinLeft(
			array('cml' => $this->_TABLE_CORE_MODULE_LANGUAGE),
					"cml.record_id = cm.execution_id", 
			array('cml.language_id', 'cml.value'))
		->joinLeft(
			array('cl' => 'core_language'),
					"cl.id = cml.language_id", 
			array())
		->where('cm.module_id = ?', $moduleId)
		->where('cm.inactive = ?', 0)
		->where('cl.locale = ?', $locale)
		->where('cml.table_name = ?', $this->_name)
		->order('cm.display_order');
		$result = $this->getAdapter()->fetchAll($select->__toString());
		$i=0;
		$longest_module_name = 0;
		while ($i < count($result)){
			$result[$i]['functions'] = Quick::single('core/function')->getListFunctions($result[$i]['execution_id'], $locale);
			$i++;
		}
		return $result;
	}
}