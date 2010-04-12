<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Core_Model_Acl_Role extends Quick_Db_Table
{
	protected $_name = 'admin_acl_role';
	protected $_rolesTree = null;
	
	private function _initTree()
    {
        if (null !== $this->_rolesTree)
            return;
        $result = $this->getAdapter()->query(
            "SELECT ar.*, arp.role_id as child_id FROM {$this->_name} ar "
          . "LEFT JOIN " . self::$_db_prefix . "admin_acl_role_parent arp ON arp.role_parent_id = ar.id"
        );
        
        $rolesTree = array();

        while (($row = $result->fetch())) {
            if (!isset($rolesTree[$row['id']]))
                $rolesTree[$row['id']] = $row;
            if ($row['child_id']) {
                $rolesTree[$row['id']]['childs'][] = $row['child_id'];
            }
        }
        
        foreach ($rolesTree as $id => $item) {
            if (!isset($item['childs']))
                continue;
            foreach ($item['childs'] as  $child) {
                if (!isset($rolesTree[$child]['parents']))
                    $rolesTree[$child]['parents'] = array();
                $rolesTree[$child]['parents'][] = $id;
            }
        }
        
        $this->_rolesTree = $rolesTree;
    }
    
	public function getAllParents($id)
    {
        $this->_initTree();
        if (isset($this->_rolesTree[$id]['parents']) && sizeof($this->_rolesTree[$id]['parents'])) {
            $parents = $this->_rolesTree[$id]['parents'];
            $subparents = array();
            foreach ($parents as $parentId) {            	
                $subparents = array_merge($subparents, $this->getAllParents($parentId));
            }
            return array_merge($parents, $subparents);
        }
        
        return array();
    }
    
	public function getRolesTree()
    {
        $this->_initTree();
        return $this->_rolesTree;
    }
}