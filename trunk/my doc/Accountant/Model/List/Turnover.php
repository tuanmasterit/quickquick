<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Accountant_Model_List_Turnover extends Quick_Db_Table
{
	protected $_name = 'accountant_list_turnover';

	/*
	 * @desc get all list turnover
	 * 
	 * @author: bichttn
	 */
	public function getListTurnover($limit, $start, &$total)
	{
		$select = $this->getAdapter()->select();
        $select->from(array('dlt' => $this->_name), 
        			  array('turnover_id', 'turnover_name', 'is_normal', 'is_internal', 'is_financial',
        			  		'is_discounted', 'is_returned', 'is_devalued', 'from_goods', 'from_products',
        			  		'from_services', 'from_subsidy', 'from_real_estate', 'from_rest'))
        	   ->where('dlt.inactive = ?', 0)
        	   ->where('dlt.turnover_id <> ?', 0)
			   ->limit($limit, $start);
			   
		$query = "SELECT COUNT(turnover_id) FROM $this->_name";
        $total = $this->getAdapter()->fetchOne($query);
        
        return $this->getAdapter()->fetchAll($select->__toString());
	}

	/**
	 * Insert list turnover by data array
	 * @author	bichttn
	 * @return array
	 */
	public function insertListTurnover($listTurnover = array())
	{
		if(!empty($listTurnover)){
			
			return $this->insert($listTurnover);
		}
		
		return 0;
	}
	
	/**
	 * @desc updateListTurnove
	 *
	 * @author bichttn	
	 * @return array
	 */
	public function updateListTurnove($turnover, $field, $value)
	{
		$db = $this->getAdapter();
		$row = $this->fetchRow(array($db->quoteInto('turnover_id = ?', $turnover)));

		if (isset($row)) {
			$row = array(
				$field => $value,
				'last_modified_by_userid' => Quick::session()->userId,
				'date_last_modified' => Quick_Date::now()->toSQLString()
			);
			
			return $this->update($row, array($db->quoteInto('turnover_id = ?', $turnover)));
								
		}
		
		return false;
	}
	
	/**
	 * delete turn over
	 * @author bichttn
	 */
	public function deleteTurnover($turnoverId)
	{
		$db = $this->getAdapter();	
		return $this->delete(array(
			$db->quoteInto('turnover_id = ?', $turnoverId)));

		return false;
	}
}