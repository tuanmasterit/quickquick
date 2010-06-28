<?php
/**
 *
 * @category    Quick
 * @package     Quick_Core
 * @author      khoatx
 */
class Quick_Accountant_Remoter_ReceivableCatalog {
	
	/*
	 * @desc getg list receivable type
	 * 
	 * @author: khoatx
	 */
	public static function getReceivableType($limit, $start, &$total) 
	{
			
		return Quick::single('accountant/receivable_type')->cache()->getReceivableType($limit, $start, &$total);
	}
	
	/*
	 * updates Receivable type
	 * 
	 * @author: khoatx
	 */
	public static function updateReceivableType($receivableTypeId, $field, $value) 
	{
		
		return Quick::single('accountant/receivable_type')->cache()->updateReceivableType($receivableTypeId, $field, $value);
	}
	/**
	 * Insert Receivable type
	 * @author	khoatx
	 * @return array
	 */
	public static function insertReceivableType($receivableTypeName)
	{
		$receivableType = array(
			'receivable_type_name'=> $receivableTypeName,
			'inactive' => 0,
			'created_by_userid' => Quick::session()->userId,
			'date_entered' => Quick_Date::now()->toSQLString(),
			'last_modified_by_userid' => Quick::session()->userId,
			'date_last_modified' => Quick_Date::now()->toSQLString()
		);
		$newId = Quick::single('accountant/receivable_type')->cache()->insertReceivableType($receivableType);
		if ($newId) {
			return $newId;
		} else {
			return null;
		}
	}
	
	/**
	 * Delete receivable type with array id
	 * @author	khoatx
	 * @return array Functions|mixed
	 */
	public static function deleteReceivableTypes($arrRecord)
	{
		$affectedRow = '';
		$failedRow = '';
		foreach($arrRecord as $record){
			if(!Quick::single('accountant/receivable_type')->cache()->deleteReceivableType($record['receivable_type_id'])){
				$failedRow .= $record['receivable_type_name'] . '-';
			}else{
				$affectedRow .= $record['receivable_type_id'] . '-';
			}
		}
		$content = array(
			'affectedRow' => $affectedRow,
			'failedRow' => $failedRow
		);
		return $content;
	}
	
}
