<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @author      bichttn
 */
class Quick_Accountant_Remoter_CurrencyCatalog {

	/**
	 * definition_list_currency
	 * @author	bichttn
	 * @return array Functions|mixed
	 */
	public static function getListCurrency($limit, $start, &$total)
	{
		
		return Quick::single('core/definition_currency')->cache()->getCurrency($limit, $start, &$total);
	}
	
	/**
	 * 
	 * @author	bichttn
	 * @return array Functions|mixed
	 */
	public static function getCurrencyCombo()
	{
		
		return Quick::single('core/definition_currency')->cache()->getCurrencyCombo();
	}
	/**
	 * update definition_list_currency
	 * @author	bichttn
	 * @return array Functions|mixed
	 */
	public static function updateListCurrency($currencyId, $field, $value)
	{
		
		return Quick::single('core/definition_currency')->cache()->updateListCurrency($currencyId, $field, $value);
	}
	
	/**
	 * delete definition_list_currency
	 * @author	bichttn
	 * @return array Functions|mixed
	 */
	public static function deleteCurrency($currencyId)
	{
		
		return Quick::single('core/definition_currency')->cache()->deleteCurrency($currencyId);
	}
	/**
	 * Insert List Currency by data array
	 * @author	bichttn
	 * @return array
	 */
	public static function insertListCurrency($currencyCode, $currencyName)
	{
		$currency = array(
			'currency_code'=> $currencyCode,
			'currency_name' => $currencyName,
			'inactive' => 0,
			'created_by_userid' => Quick::session()->userId,
			'date_entered' => Quick_Date::now()->toSQLString(),
			'last_modified_by_userid' => Quick::session()->userId,
			'date_last_modified' => Quick_Date::now()->toSQLString()
		);
		$newId = Quick::single('core/definition_currency')->cache()->insertCurrency($currency);
		if ($newId) {
			$newCurrency = array(
                    'currency_code' => $currencyCode,
                    'currency_id' => $newId,
                    'currency_name' => $currencyName                 
			);
			return $newCurrency;
		} else {
			return null;
		}
	}
	
	/*
	 * get detail currency by currency_id
	 * @auhor: bichttn
	 */
	public static function getDetailCurByBaseCurId($baseCurId, $limit, $start, &$total)
	{
		
		return Quick::single('core/definition_detail_currency')->cache()->getDetailCurByBaseCurId($baseCurId, $limit, $start, &$total);
	}
	
/**
	 * Insert List Currency by data array
	 * @author	bichttn
	 * @return array
	 */
	public static function insertDetailCurrency($baseCurId, $convCurId, $timePoint, $forexRate)
	{
		
		$detailCurrency = array(
			'base_currency_id'=> $baseCurId,
			'convert_currency_id' => $convCurId,
			'time_point' => $timePoint,
			'forex_rate' => $forexRate,
			'created_by_userid' => Quick::session()->userId,
			'date_entered' => Quick_Date::now()->toSQLString(),
			'last_modified_by_userid' => Quick::session()->userId,
			'date_last_modified' => Quick_Date::now()->toSQLString()
		);
		$newId = Quick::single('core/definition_detail_currency')->cache()->insertDetailCurrency($detailCurrency);
		if ($newId) {
			$newCurrency = array(
                  	'base_currency_id'=> $baseCurId,
					'convert_currency_id' => $convCurId,
					'time_point' => $timePoint,
					'forex_rate' => $forexRate             
			);
			return $newCurrency;
		} else {
			return null;
		}
	}
	
	/**
	 * update definition_detail_currency
	 * @author	bichttn
	 * @return array Functions|mixed
	 */
	public static function updateDetailCurrency($baseCurId, $convCurId, $timePoint, $field, $value)
	{
		return Quick::single('core/definition_detail_currency')->cache()->updateDetailCurrency($baseCurId, $convCurId, $timePoint, $field, $value);
	}
	
	/* delete detail currency
	 * @auhor bichttn
	 */
	
	public static function deleteDetailCurrency($baseCurId, $curId, $time)
	{
		return Quick::single('core/definition_detail_currency')->cache()->deleteDetailCurrency($baseCurId, $curId, $time);
	}
}
