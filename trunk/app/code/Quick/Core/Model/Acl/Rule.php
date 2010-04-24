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
	protected $_name 				= 'definition_relation_role_function';
	protected $_TABLE_ACL_RESOURCE 	= 'definition_list_function';
	
	public function getPermissionOfRules($rolesForLoad){
		$where = $this->getAdapter()->quoteInto('role_id IN(?)', $rolesForLoad);        

		$result = $this->getAdapter()->query(
            "SELECT aru.*, arf.function_action FROM {$this->_name} aru "
		. "LEFT JOIN {$this->_TABLE_ACL_RESOURCE} arf ON arf.function_id = aru.function_id where $where"
		);
		
		return $result;
	}
	
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

	public function getRulesOfResource($resourceId){
		$select = $this->getAdapter()->select();
		$select->from(
		array('cr' => $this->_name),
		array('cr.resource_id', 'cr.is_add', 'cr.is_modify',
					'cr.is_change', 'cr.is_delete', 'cr.is_view', 'cr.is_list', 'cr.is_print'))
		->joinLeft(
		array('crole' => 'core_acl_role'),
					"crole.id  = cr.role_id", 
		array('crole.role_name', 'crole.id'))
		->where('cr.resource_id = ?', $resourceId)
		->where('cr.permission = ?', 'allow');
		return $this->getAdapter()->fetchAll($select->__toString());
	}

	public function editRule($resourceId, $roleId, $value){
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('role_id = ?', $roleId),
		$db->quoteInto('resource_id = ?', $resourceId)));

		if (isset($row)) {
			$row = array(
				'permission' => $value
			);
			return $this->update($row, array(
			$db->quoteInto('role_id = ?', $roleId),
			$db->quoteInto('resource_id = ?', $resourceId)));
		} else {
			$row = array(
				'role_id'=> $roleId,
                'resource_id' => $resourceId,
				'permission' => $value
			);
			return $this->insert($row);
		}

	}
	
	public function editRuleOfResource($resourceId, $roleId, $value, $field){
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('role_id = ?', $roleId),
		$db->quoteInto('resource_id = ?', $resourceId)));

		if (isset($row)) {
			$row = array(
				$field => $value
			);
			return $this->update($row, array(
			$db->quoteInto('role_id = ?', $roleId),
			$db->quoteInto('resource_id = ?', $resourceId)));
		}
	}
}