<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @author      tuvv
 */
class Quick_Accountant_Remoter_ExpenditurePay {
	
	/**
	 * Retrieve list prepaid expense
	 * @author	tuvv
	 * @return array Functions|mixed
	 */
	public static function getListPrepaidExpense($limit, $start, $expenseCode, $fromDate, $toDate, &$total)
	{
		return Quick::single('accountant/prepaid_expense')->cache()->getListPrepaidExpense($limit, $start, $expenseCode, $fromDate, $toDate, &$total);
	}
	
	/**
	 * Retrieve list Expense
	 * @author	tuvv
	 * @return array
	 */
	public static function getExpense()
	{
		return Quick::single('accountant/list_expense')->cache()->getExpense();
	}
	
	/**
	 * Retrieve list Expense
	 * @author	tuvv
	 * @return array
	 */
	public static function getAssets()
	{
		return Quick::single('accountant/assets_voucher')->cache()->getAssets();
	}
	
	/**
	 * Retrieve list Tool
	 * @author	tuvv
	 * @return array
	 */
	public static function getTool()
	{
		return Quick::single('core/definition_product')->cache()->getTool();
	}
	
	/**
	 * Update Prepaid Expense
	 * @author	tuvv
	 * @return true||false
	 */
	public static function updateExpense($id, $field, $value, $convertCurrency)
	{
		return Quick::single('accountant/prepaid_expense')->cache()->updateExpense($id, $field, $value, $convertCurrency);
	}
	
	/**
	 * Insert prepaid expense
	 * @author	tuvv
	 * @return true||false
	 */
	public static function insertPrepaidExpense($expenseCode, $expenseName, $expenseDate, $supplierId, $expenseId, $assetsId, $toolId, $allocationPeriods, $currencyId, $forexRate, $currentPeriodId)
	{
		return Quick::single('accountant/prepaid_expense')->cache()->insertPrepaidExpense($expenseCode, $expenseName, $expenseDate, $supplierId, $expenseId, $assetsId, $toolId, $allocationPeriods, $currencyId, $forexRate, $currentPeriodId);
	}
	/**
	 * Retrieve update field of prepaid expense
	 * @author	tuvv
	 * @return array Functions|mixed
	 */
	public static function updateFieldOfPrepaidExpense($prepaidExpenseId, $field, $value, $convertCurrency)
	{
		return Quick::single('accountant/prepaid_expense')->cache()->updateFieldOfPrepaidExpense($prepaidExpenseId, $field, $value, $convertCurrency);
	}
	
	/**
	 * Retrieve list Prepaid Allocation by id
	 * @author	tuvv
	 * @return array Functions|mixed
	 */
	public static function getDetailPrepaidAllocationById($prepaidExpenseId)
	{
		return Quick::single('accountant/prepaid_allocation')->cache()->getDetailPrepaidAllocationById($prepaidExpenseId);
	}
	
	/**
	 * Update Prepaid Allocation by id
	 * @author	tuvv
	 * @return true||false
	 */
	public static function updatePrepaidAllocation($prepaidAllocationId, $field, $value)
	{	
		return Quick::single('accountant/prepaid_allocation')->cache()->updatePrepaidAllocation($prepaidAllocationId, $field, $value);
	}
	
	/**
	 * Insert Prepaid Allocation
	 * @author	tuvv
	 * @return true||false
	 */
	public static function insertPrepaidAllocation($prepaidExpenseId, $currencyId, $forexRate, $field, $value, $prepaidExpenseName, $currentPeriodId)
	{	
		return Quick::single('accountant/prepaid_allocation')->cache()->insertPrepaidAllocation($prepaidExpenseId, $currencyId, $forexRate, $field, $value, $prepaidExpenseName, $currentPeriodId);
	}
	/**
	 * Delete prepaid expense with id
	 * @author	tuvv
	 * @return array Functions|mixed
	 */
	public static function deletePrepaidExpense($arrRecord)
	{
		foreach($arrRecord as $record){
			Quick::single('accountant/prepaid_expense')->cache()->deletePrepaidExpense($record['prepaid_expense_id']);
		}
		return true;
	}
}
?>