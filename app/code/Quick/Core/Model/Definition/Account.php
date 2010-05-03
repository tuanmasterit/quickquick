<?php
/**
 *
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Core_Model_Definition_Account extends Quick_Db_Table
{
	protected $_name 							= 'definition_list_account';
	protected $_TABLE_DEFINITION_DETAIL_ACCOUNT = 'definition_detail_account';
	protected $_TABLE_DEFINITION_LIST_TABLE		= 'definition_list_table';
	protected $pageSize = 10;

	/**
	 * Retrieve array of Execution of Module ID
	 *
	 * @return array
	 */
	public function getAccountOfNode($node)
	{
		if($node == 0){
			$where = '`account_parent_id` IS NULL';
		}else{
			$where = $this->getAdapter()->quoteInto('account_parent_id = ?', $node);
		}
		$select = $this->getAdapter()->select();
		$select->from(array('dla' => $this->_name), array('account_id', 'account_code', 'account_name', 'account_parent_id'))
		->where($where)
		->order('dla.account_code', 'dla.account_name');

		$result = $this->getAdapter()->fetchAll($select->__toString());
		return $result;
	}

	/**
	 * Retrieve array of detail of accountant by id
	 *
	 * @return array
	 */
	public function getDetailOfNode($node)
	{
		$select = $this->getAdapter()->select();
		$select->from(array('dla' => $this->_name), array('account_id', 'account_code', 'account_name', 'account_note'))
		->where($this->getAdapter()->quoteInto('account_id = ?', $node));
			
		return $this->getAdapter()->fetchRow($select->__toString());
	}

	/**
	 * Retrieve array of detail of accountant by table id
	 *
	 * @return array
	 */
	public function getDetailAccountByTable($table, $node, $limit, $start, &$total)
	{
		$limit = isset($limit) ? $limit : $this->pageSize;
		$start = isset($start) ? $start : 0;
		if ($start == '') {
			$start = 0;
		}
		$pagingSize = '';
		if ($limit > 0) {
			$pagingSize = " LIMIT $start, $limit";
		}

		$select = $this->getAdapter()->select();
		$select->from(array('dlt' => $this->_TABLE_DEFINITION_LIST_TABLE), array('table_name', 'column_name'))
		->where($this->getAdapter()->quoteInto('table_id = ?', $table));
		//$this->getAdapter()->setFetchMode(Zend_Db::FETCH_ASSOC);
		$tableRow = $this->getAdapter()->fetchRow($select->__toString());

		switch($tableRow['table_name']){
			case 'definition_list_currency':
				$columnId = 'currency_id';
				$columnName = 'currency_name';
				break;
			case 'definition_list_department':
				$columnId = 'department_id';
				$columnName = 'department_name';
				break;
			case 'definition_list_product':
				$columnId = 'product_id';
				$columnName = 'product_name';
				break;
			case 'definition_list_staff':
				$columnId = 'staff_id';
				$columnName = 'last_name';
				break;
			case 'definition_list_subject':
				$columnId = 'subject_id';
				$columnName = 'subject_name';
				break;
			default: return null;
		}
		$columnWhere = (isset($tableRow['column_name']) && !empty($tableRow['column_name']))?"AND objTbl.`". $tableRow['column_name'] ."` = 1":"";
		$query = "SELECT COUNT(objTbl.`$columnId`) FROM `". $tableRow['table_name'] ."` AS objTbl WHERE `inactive` = 0 $columnWhere";
		$total = $this->getAdapter()->fetchOne($query);

		$query = "SELECT
						objTbl.`$columnId` AS object_id, 
						objTbl.`$columnName` AS object_name, 
						objDetail.`detail_id` AS check_value 
				  FROM  `". $tableRow['table_name'] ."` AS objTbl 
				  LEFT JOIN (
				  		SELECT  dda.`detail_id` 
				  		FROM `". $this->_TABLE_DEFINITION_DETAIL_ACCOUNT ."` AS dda 
				  		WHERE dda.`account_id` = " . $node . " AND dda.`table_id` = ". $table .") AS objDetail 
				  ON objDetail.`detail_id` = objTbl.`$columnId` WHERE objTbl.`inactive` = 0 $columnWhere $pagingSize";

		return $this->getAdapter()->fetchAll($query);
	}
}
