<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Accountant_Model_List_Specification extends Quick_Db_Table
{
	protected $_name = 'accountant_list_specification';
	protected $pageSize = 10;

	/**
	 * Get list of specification
	 *	@author datnh
	 */
	public function getListSpecification($limit, $start, &$total) {
		$limit = isset($limit) ? $limit : $this->pageSize;
		$start = isset($start) ? $start : 0;
		if ($start == '') {
			$start = 0;
		}
		$pagingSize = '';
		if ($limit > 0) {
			$pagingSize = " LIMIT $start, $limit";
		}

		//Get size:
		$query_size = "SELECT COUNT(*)  FROM  ". $this->_name;			  	
		$total = $this->getAdapter()->fetchOne($query_size);
		
		//Get data with limit
		$query = "SELECT * FROM  ". $this->_name ." ". $pagingSize;
        	   
     	return $this->getAdapter()->fetchAll($query);
	}
	
	/**
	 * Insert specification 
	 * @author datnh
	 */
	public function insertSpecification($spec = array()) {
		if(!empty($spec)){			
			return $this->insert($spec);
		}		
		return 0;
	}
	
	/**
	 * Update specification
	 * @author datnh
	 */
	public function updateSpecification($specification_id, $field, $value) {
		$db = $this->getAdapter();
		$row = $this->fetchRow(array($db->quoteInto('specification_id = ?', $specification_id)));		
		if (isset($row)) {			
			$row = array(
				'specification_name' => $value,
				'last_modified_by_userid' => Quick::session()->userId,
				'date_last_modified' => Quick_Date::now()->toSQLString()
			);			
			return $this->update($row, $db->quoteInto('specification_id = ?', $specification_id));
		}
		return false;
	}
	
	/**
	 * Delete specification by specification_id
	 * @author datnh
	 *
	 */
	public function deleteSpecificationBySpecId($specification_id) {
		$result = true;
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('specification_id = ?', $specification_id)));
		if (isset($row)) {
			$result &= $this->delete(array($db->quoteInto('specification_id = ?', $specification_id)));
		}
		return $result;
	}
}
