<?php
/**
 *
 * @category    Quick
 * @package     Quick_Core
 * @author      khoatx
 */
class Quick_Accountant_Remoter_PayableCatalog {
	
	/*
	 * @desc gets list payable type
	 * 
	 * @author: khoatx
	 */
	public static function getPayableType($limit, $start, &$total) 
	{
			
		return Quick::single('accountant/payable_type')->cache()->getPayableType($limit, $start, &$total);
	}
	
	/*
	 * updates payable type
	 * 
	 * @author: khoatx
	 */
	public static function updatePayableType($payableTypeId, $field, $value) 
	{
		
		return Quick::single('accountant/payable_type')->cache()->updatePayableType($payableTypeId, $field, $value);
	}
	/**
	 * Insert payable type
	 * @author	khoatx
	 * @return array
	 */
	public static function insertPayableType($payableTypeName)
	{
		$payableType = array(
			'payable_type_name'=> $payableTypeName,
			'inactive' => 0,
			'created_by_userid' => Quick::session()->userId,
			'date_entered' => Quick_Date::now()->toSQLString(),
			'last_modified_by_userid' => Quick::session()->userId,
			'date_last_modified' => Quick_Date::now()->toSQLString()
		);
		$newId = Quick::single('accountant/payable_type')->cache()->insertPayableType($payableType);
		if ($newId) {
			return $newId;
		} else {
			return null;
		}
	}
	
	/*
	 * deletes payable type
	 * 
	 * @author: khoatx
	 */
	public static function deletePayableType($payableTypeId) 
	{
		return Quick::single('accountant/payable_type')->cache()->deletePayableType($payableTypeId);
	}
	
	/**
	 * Delete payable type with array id
	 * @author	khoatx
	 * @return array Functions|mixed
	 */
	public static function deletePayableTypes($arrRecord)
	{
		$affectedRow = '';
		$failedRow = '';
		foreach($arrRecord as $record){
			if(!Quick::single('accountant/payable_type')->cache()->deletePayableType($record['payable_type_id'])){
				$failedRow .= $record['payable_type_name'] . '-';
			}else{
				$affectedRow .= $record['payable_type_id'] . '-';
			}
		}
		$content = array(
			'affectedRow' => $affectedRow,
			'failedRow' => $failedRow
		);
		return $content;
	}
}
