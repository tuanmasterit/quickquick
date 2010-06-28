<?php
/**
 *
 * @category    Quick
 * @package     Quick_Core
 * @author      trungpm
 */
class Quick_Accountant_Remoter_ExpenditureCatalog {
	
/*
	 * @desc get list expense
	 * 
	 * @author: bichttn
	 */
	public static function getListExpense($limit, $start, &$total) 
	{
	
		return Quick::single('accountant/list_expense')->cache()->getListExpense($limit, $start, &$total);
	}
	
	/**
	 * Insert list expense by data array
	 * @author	bichttn
	 * @return array
	 */
	public static function insertListExpense($expenseName)
	{
		$expense = array(
			'expense_name'=> $expenseName,
			'inactive' => 0,
			'created_by_userid' => Quick::session()->userId,
			'date_entered' => Quick_Date::now()->toSQLString(),
			'last_modified_by_userid' => Quick::session()->userId,
			'date_last_modified' => Quick_Date::now()->toSQLString()
		);
		$newId = Quick::single('accountant/list_expense')->cache()->insertListExpense($expense);
		if ($newId) {
			$aryExpense = array(
				'expense_id' => $newId,	
				'expense_name' => $expenseName
			);
			return $aryExpense;
		} 
		
		return false;
	}
	/*
	 * @desc get list expense
	 * 
	 * @author: bichttn
	 */
	public static function updateListExpense($expenseId, $field, $value) 
	{
		
		return Quick::single('accountant/list_expense')->cache()->updateListExpense($expenseId, $field, $value);
	}
	
	/*
	 * @desc delete expense
	 * 
	 * @author: bichttn
	 */
	public static function deleteExpense($expenseId) 
	{
		
		return Quick::single('accountant/list_expense')->cache()->deleteExpense($expenseId);
	}
}

