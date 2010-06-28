<?php
/**
 *
 * @category    Quick
 * @package     Quick_Core
 * @author      trungpm
 */
class Quick_Accountant_Remoter_RevenueCatalog {
	
	/*
	 * @desc get list turnover
	 * 
	 * @author: bichttn
	 */
	public static function getListTurnover($limit, $start, &$total) 
	{

		return Quick::single('accountant/list_turnover')->cache()->getListTurnover($limit, $start, &$total);
	}

	
	/**
	 * Insert list turnover by data array
	 * @author	bichttn
	 * @return array
	 */
	public static function insertListTurnover($turnoverName)
	{
		$turnover = array(
			'turnover_name'=> $turnoverName,
			'inactive' => 0,
			'created_by_userid' => Quick::session()->userId,
			'date_entered' => Quick_Date::now()->toSQLString(),
			'last_modified_by_userid' => Quick::session()->userId,
			'date_last_modified' => Quick_Date::now()->toSQLString()
		);
		$newId = Quick::single('accountant/list_turnover')->cache()->insertListTurnover($turnover);
		if ($newId) {
			$aryTurnover = array(
				'turnover_id' => $newId,
				'turnover_name' => $turnoverName
			); 
			return $aryTurnover;
		} 
		return false;
	}
	/*
	 * @desc get list turnover
	 * 
	 * @author: bichttn
	 */
	public static function updateListTurnove($turnover, $field, $value) 
	{

		return Quick::single('accountant/list_turnover')->cache()->updateListTurnove($turnover, $field, $value);
	}
	
	/*
	 * @desc delete turnover
	 * 
	 * @author: bichttn
	 */
	public static function deleteTurnover($turnoverId) 
	{

		return Quick::single('accountant/list_turnover')->cache()->deleteTurnover($turnoverId);
	}
}
