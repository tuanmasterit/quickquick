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
	protected $_name = 'definition_list_role';
	protected $_rolesTree = null;

	private function _initTree()
	{
		if (null !== $this->_rolesTree)
		return;
		$result = $this->getAdapter()->query(
            "SELECT ar.*, arp.role_id as child_id FROM {$this->_name} ar "
		. "LEFT JOIN " . self::$_db_prefix . "core_acl_role_parent arp ON arp.role_parent_id = ar.role_id where ar.inactive = 0"
		);

		$rolesTree = array();

		while (($row = $result->fetch())) {
			if (!isset($rolesTree[$row['role_id']]))
			$rolesTree[$row['role_id']] = $row;
			if ($row['child_id']) {
				$rolesTree[$row['role_id']]['childs'][] = $row['child_id'];
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
		$this->_initTree($this->_rolesTree);
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

	public function getRoles()
	{
		return $this->getAdapter()->fetchAll("
            SELECT cr.role_id, cr.role_name  
            FROM " . $this->_name . " AS cr WHERE cr.inactive = 0");
	}

	/**
	 *
	 * @param array $data
	 * @param int $parentId
	 * @return int
	 */
	public function save(array $data)
	{
		$db = $this->getAdapter();
		$row = $this->fetchRow(array($db->quoteInto('id = ?', $data['id'])));
		
		if (isset($row)) {
			$row = array(
                'role_name' => $data['role_name']
            );
			return $this->update($row, $db->quoteInto('id = ?', $data['id']));
		} else {
			$row = array(
				'sort_order'=> 0,
                'role_name' => $data['role_name']
            );
			return $this->insert($row);
		}
	}
}