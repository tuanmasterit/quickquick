<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Core_Model_Acl extends Zend_Acl
{
	protected $_table;
    private $_rescs;
    
    private function _loadResources(){
    	foreach ($this->getResources() as $resource){
    		if (false !== ($pos = strrpos($resource['function_action'], '/'))) {
                $parentId = substr($resource['function_action'], 0, $pos);
            } else {
                $parentId = null;
            }
            $this->add(new Zend_Acl_Resource($resource['function_action']), $parentId);
    	}
    }
    
    public function __construct(){
    	$this->_table = Quick::single('core/acl_role');
    	$this->_loadResources();
    }
    
    public function getResources(){
    	if(null === $this->_rescs){
    		$this->_rescs = Quick::single('core/function')->fetchAll(null, 'display_order ASC')->toArray();
    	}
    	
    	return $this->_rescs;
    }
    
	/**
     * Load rules of $role and all parent roles
     * 
     * @param Zend_Acl_Role_Interface|string $role
     * @return boolean
     */
    public function loadRules($role)
    {
        if ($role instanceof Zend_Acl_Role_Interface) {
            $roleId = $role->getRoleId();
        } else {
            $roleId = (string) $role;
        }
        $this->addRoleRecursive($role);
        $rolesForLoad = $this->_table->getAllParents($roleId);
        $rolesForLoad[] = $roleId;
        
        $result = Quick::single('core/acl_rule')->getPermissionOfRules($rolesForLoad);

        while (($row = $result->fetch())) {
            if ($row['permission'] == 'allow') {
                $this->allow($row['role_id'], $row['function_action']);
            } elseif ($row['permission'] == 'deny') {
                $this->deny($row['role_id'], $row['function_action']);
            }
        }
    }
    
	/**
     * Add role with all parent roles
     * 
     * @param Zend_Acl_Role_Interface|string $role
     */
    public function addRoleRecursive($role)
    {
        if ($role instanceof Zend_Acl_Role_Interface) {
            $roleId = $role->getRoleId();
        } else {
            $roleId = (string) $role;
        }
        
        $rolesTree = $this->_table->getRolesTree();
        if (isset($rolesTree[$roleId]['parents'])) {
            foreach ($rolesTree[$roleId]['parents'] as $parentRoleId) {
                $this->addRoleRecursive($parentRoleId);
            }
        }
        if (!$this->hasRole($roleId))
            $this->addRole(
                new Zend_Acl_Role($roleId), 
                isset($rolesTree[$roleId]['parents']) ? $rolesTree[$roleId]['parents'] : null
            );
    }
}