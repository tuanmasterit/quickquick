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
	protected $_name = 'definition_list_function';
	
	public function getResources(){
		$select = $this->getAdapter()->select();
		$select->from(
					array('cr' => $this->_name), 
					array('cr.resource_id', 'cr.title_key'))
				->joinLeft(
					array('cm' => 'core_module'), 
					"cm.id = cr.module_id", 
					array('cm.package'))
				->order('cm.package')
				->order('cr.resource_id');
		return $this->getAdapter()->fetchAll($select->__toString());
	}
}