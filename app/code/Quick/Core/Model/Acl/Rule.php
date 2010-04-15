<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Core_Model_Acl_Rule extends Quick_Db_Table
{
	protected $_name = 'core_acl_rule';
	
	public function getRules(){
		$select = $this->getAdapter()->select();
		$select->from(
					array('cr' => $this->_name), 
					array('cr.resource_id', 'cr.title_key'))
				->joinLeft(
					array('cm' => 'core_module'), 
					"cm.id = cr.module_id", 
					array('cm.package'))
				->order('cm.package');
		return $this->getAdapter()->fetchAll($select->__toString());
	}
	
	public function getRulesWithRoles(){
		$select = $this->getAdapter()->select();
		$select->from(
					array('cr' => $this->_name), 
					array('cr.resource_id', 'permission'))
				->joinLeft(
					array('crl' => 'core_acl_role'), 
					"crl.id = cr.role_id", 
					array('crl.role_name'));
		return $this->getAdapter()->fetchAll($select->__toString());
	}
}