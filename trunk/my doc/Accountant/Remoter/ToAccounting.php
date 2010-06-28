<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @author      tuvv
 */
class Quick_Accountant_Remoter_ToAccounting {
	/**
	 * @desc get list Type
	 * @author tuvv
	 * @return array
	 */
	public static function getListEntryType()
	{
		return Quick::single('accountant/entry_type')->cache()->getListEntryType();
	}
	
	/**
	 * @desc get list Debit
	 * @author tuvv
	 * @return array
	 */
	public static function getListEntryDebit($limit, $start, $typeId, &$total)
	{
		return Quick::single('accountant/entry_debit')->cache()->getListEntryDebit($limit, $start, $typeId, &$total);
	}
	
	/**
	 * Update field of Debit by id
	 * @author	tuvv
	 * @return array
	 */
	public static function updateFieldDebit($debitId, $accountId, $typeId, $debitField, $debitValue)
	{
		return Quick::single('accountant/entry_debit')->cache()->updateFieldDebit($debitId, $accountId, $typeId, $debitField, $debitValue);
	}
	
		
	/**
	 * Update field of Credit by id
	 * @author	tuvv
	 * @return array
	 */
	public static function updateFieldCredit($creditId, $accountId, $typeId, $creditField, $creditValue)
	{
		return Quick::single('accountant/entry_credit')->cache()->updateFieldCredit($creditId, $accountId, $typeId, $creditField, $creditValue);
	}
	
	/**
	 * Update field default of Credit and Debit by id
	 * @author	tuvv
	 * @return array
	 */
	public static function updateDebitCredit($typeId, $arrDebit, $arrCredit)
	{
		return Quick::single('core/definition_account')->cache()->updateDebitCredit($typeId, $arrDebit, $arrCredit);
	}
	
		
	/**
	 * @desc get list Credit
	 * @author tuvv
	 * @return array
	 */
	public static function getListEntryCredit($limit, $start, $typeId, &$total)
	{
		return Quick::single('accountant/entry_credit')->cache()->getListEntryCredit($limit, $start, $typeId, &$total);
	}
	
		
	/**
	 * get account
	 * @author	tuvv
	 * @return array
	 */
	public static function getListAccount()
	{	
		return Quick::single('core/definition_account')->cache()->getListAccount();
	}
	
	/**
	 * Delete credit with array id
	 * @author	tuvv
	 * @return array Functions|mixed
	 */
	public static function deleteCredit($arrRecord)
	{	
		$affectedRow = '';
		$failedRow = 0;
		foreach($arrRecord as $record){
			if(!Quick::single('accountant/entry_credit')->cache()->deleteCredit($record['credit_id'])){
				$failedRow++;
			}else{
				$affectedRow .= $record['credit_id'] . '-';
			}
		}
		$content = array(
			'affectedRow' => $affectedRow,
			'failedRow' => $failedRow
		);
		return $content;
	}
	
	/**
	 * Delete debit with array id
	 * @author	tuvv
	 * @return array Functions|mixed
	 */
	public static function deleteDebit($arrRecord)
	{	
		$affectedRow = '';
		$failedRow = 0;
		foreach($arrRecord as $record){
			if(!Quick::single('accountant/entry_debit')->cache()->deleteDebit($record['debit_id'])){
				$failedRow++;
			}else{
				$affectedRow .= $record['debit_id'] . '-';
			}
		}
		$content = array(
			'affectedRow' => $affectedRow,
			'failedRow' => $failedRow
		);
		return $content;
	}
}
?>