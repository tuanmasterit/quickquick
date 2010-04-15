<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Core_Model_Acl_Resource extends Quick_Db_Table
{
	protected $_name = 'core_acl_resource';
	
	public function getResources(){
		$select = $this->getAdapter()->select();
		$select->from(
					array('cml' => $this->_name), 
					array('cml.key', 'cml.value'))
				->joinLeft(
					array('cm' => 'core_module'), 
					"cm.id = cml.module_id", 
					array('package'))
				->joinLeft(
					array('cl' => 'core_language'), 
					"cl.id = cml.language_id", 
					array('locale'))
				->where('cm.package = ?', $module)
				->where('cl.locale = ?', $locale)
				->where('cml.key = ?', $key);
	}
}