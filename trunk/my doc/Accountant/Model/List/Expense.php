<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Accountant_Model_List_Expense extends Quick_Db_Table
{

	protected $_name = 'accountant_list_expense';
	
/*
	 * @desc get all list expense
	 * 
	 * @author: bichttn
	 */
	public function getListExpense($limit, $start, &$total)
	{
		$select = $this->getAdapter()->select();
        $select->from(array('dle' => $this->_name), 
        			  array('expense_id', 'expense_name', 'for_buying', 'for_material', 'for_wage',
        			  		'for_construction_equipment', 'for_tool', 'for_depreciation', 'for_services', 
        			  		'for_rest', 'for_production', 'for_sales', 'for_guarantee','for_management',
        			  		'for_fee', 'for_reserve', 'production_cost', 'sales_cost', 'finance_cost'))
        	   ->where('dle.inactive = ?', 0)
        	   ->where('dle.expense_id <> ?', 0)
        	   ->limit($limit, $start);

        $query = "SELECT COUNT(expense_id) FROM $this->_name";
        $total = $this->getAdapter()->fetchOne($query);
        	   
     	return $this->getAdapter()->fetchAll($select->__toString());
	}
	
	/*
	 * @author: bichttn
	 */
	public function countListExpense() {
		$query = "SELECT COUNT(expense_id) FROM $this->_name";
		
        return $this->getAdapter()->fetchOne($query);
	}
	/**
	 * Insert list Expense by data array
	 * @author	bichttn
	 * @return array
	 */
	public function insertListExpense($listExpense = array())
	{
		if(!empty($listExpense)){
			
			return $this->insert($listExpense);
		}
		
		return 0;
	}
	
	/**
	 * @desc updateListExpense
	 *
	 * @author bichttn	
	 * @return array
	 */
	public function updateListExpense($expenseId, $field, $value)
	{
		$db = $this->getAdapter();
		$row = $this->fetchRow(array($db->quoteInto('expense_id = ?', $expenseId)));

		if (isset($row)) {
			$row = array(
				$field => $value,
				'last_modified_by_userid' => Quick::session()->userId,
				'date_last_modified' => Quick_Date::now()->toSQLString()
			);
			
			return $this->update($row, array($db->quoteInto('expense_id = ?', $expenseId)));
								
		}
		
		return false;
	}
	
	/*
	 * @desc get combo list expense	 * 
	 * @author: tuvv
	 * @return array
	 */
	public function getExpense()
	{
		$select = $this->getAdapter()->select();
        $select->from(array('dle' => $this->_name), 
        			  array('expense_id', 'expense_name'))
        	   ->where('dle.inactive = ?', 0)
        	   ->where('dle.expense_id != ?', 0);
        	   
     	return $this->getAdapter()->fetchAll($select->__toString());
	}
	
	/**
	 * delete expense
	 * @author bichttn
	 */
	public function deleteExpense($expenseId)
	{
		$db = $this->getAdapter();	
		return $this->delete(array(
			$db->quoteInto('expense_id = ?', $expenseId)));

		return false;
	}
}
