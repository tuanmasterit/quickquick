<?php
/**
 *
 * @category    Quick
 * @package     Quick_General
 * @author      bichttn
 */
class Quick_Accountant_Remoter_AccountLetter {
	
	/*
	 * @desc get list execution
	 * 
	 * @author: bichttn
	 */
	public static function getListExecution() 
	{
		
		return Quick::single('core/execution')->cache()->getListExecution();
	}
	
	/*
	 * @desc get period current
	 * 
	 * @author: bichttn
	 */
	public static function getPeriodCurrent() 
	{
		
		return Quick::single('core/definition_period')->cache()->getPeriodCurrent();
	}
	
	/*
	 * @desc get transaction voucher
	 * 
	 * @author: bichttn
	 */
	public static function insertTransactionVoucher($executionId, $periodId, $voucherNumber, $voucherDate) 
	{	
		$voucher = array(
			'execution_id'=> $executionId,
			'period_id' => $periodId,
			'voucher_number' => $voucherNumber,
			'voucher_date'	 => $voucherDate,	
			'created_by_userid' => Quick::session()->userId,
			'date_entered' => Quick_Date::now()->toSQLString(),
			'last_modified_by_userid' => Quick::session()->userId,
			'date_last_modified' => Quick_Date::now()->toSQLString()
		);
		$newId = Quick::single('accountant/transaction_voucher')->cache()->insertTransactionVoucher($voucher);
		if ($newId) return $newId;
		
		return null;
		
	}
	
	/**
	 * update transaction_voucher
	 * @author	bichttn
	 * @return array Functions|mixed
	 */
	public static function updateListVoucher($voucherId, $field, $value)
	{
		
		return Quick::single('accountant/transaction_voucher')->cache()->updateListVoucher($voucherId, $field, $value);
	}	
	
	/**
	 * @desc search voucher
	 *
	 * @author bichttn	
	 * @return array
	 */
	public static function getTransactionVoucher($executionId, $voucherNumber, $dateFrom, $dateTo, $limit, $start, &$total)
	{
		
		return Quick::single('accountant/transaction_voucher')->cache()->getTransactionVoucher($executionId, $voucherNumber, $dateFrom, $dateTo, $limit, $start, &$total);
	}	
	
	/**
	 * @desc search batch
	 *
	 * @author bichttn	
	 * @return array
	 */
	public static function getBatch($voucherId, $executionId, $batchNote, $limit, $start, &$total)
	{
		
		return Quick::single('accountant/transaction_batch')->cache()->getBatch($voucherId, $executionId, $batchNote, $limit, $start, &$total);
	}	
	
	/*
	 * @desc get list voucher
	 * 
	 * @author: bichttn
	 */
	public static function insertBatch($voucherId, $executionId, $batchNode) 
	{	
		$voucher = array(
			'voucher_id'=> $voucherId,
			'execution_id' => $executionId,
			'batch_note'	 => $batchNode
		);
		$newId = Quick::single('accountant/transaction_batch')->cache()->insertBatch($voucher);
		if ($newId) {
			
			return $newId;
		} else {
			return null;
		}
	}
	
	/**
	 * update transaction_batch
	 * @author	bichttn
	 * @return array Functions|mixed
	 */
	public static function updateBatch($batchId, $field, $value)
	{
		
		return Quick::single('accountant/transaction_batch')->cache()->updateBatch($batchId, $field, $value);
	}	
	
	
	/*
	 * @desc get list account
	 * 
	 * @author: bichttn
	 */
	public static function getListAccount() 
	{

		return Quick::single('core/definition_account')->cache()->getAccount();
	}
	
	/*
	 * @desc 
	 * 
	 * @author: bichttn
	 */
	public static function getDetailCurByBaseIdAndCurId($baseCurId, $curId)
	{

		return Quick::single('core/definition_detail_currency')->cache()->getDetailCurByBaseIdAndCurId($baseCurId, $curId);
	}
	
	/*
	 * @desc get list entry
	 * 
	 * @author: bichttn
	 */
	public static function insertEntry($batchId, $masterAccountId, $debitCredit, $originalAmount, $currencyId, $forexRate, $convertedAmount) 
	{	
		$entry = array(
			'batch_id'=> $batchId,
			'master_account_id' => $masterAccountId,
			'debit_credit'	 => $debitCredit,
			'original_amount' => $originalAmount,
			'currency_id' => $currencyId,
			'forex_rate' => $forexRate,
			'converted_amount' => $convertedAmount 
		
		);
		$newId = Quick::single('accountant/transaction_entry')->cache()->insertEntry($entry);
		if ($newId) {
			
			return $newId;
		} else {
			return null;
		}
	}
	
	/*
	 * @desc get list Correspondence
	 * 
	 * @author: bichttn
	 */
	public static function insertCorrespondence($entryId, $detailAccountId, $debitCredit, $originalAmount, $currencyId, $forexRate, $convertedAmount) 
	{	
		$correspondence = array(
			'entry_id' => $entryId,
			'detail_account_id'=> $detailAccountId,
			'debit_credit'	 => $debitCredit,
			'original_amount' => $originalAmount,
			'currency_id' => $currencyId,
			'forex_rate' => $forexRate,
			'converted_amount' => $convertedAmount 
		
		);
		$newId = Quick::single('accountant/transaction_correspondence')->cache()->insertCorrespondence($correspondence);
		if ($newId) {
			
			return $newId;
		} else {
			return null;
		}
	}
	
	/*
	 * @desc get list account
	 * 
	 * @author: bichttn
	 */
	public static function getEntry($batchId, $limit, $start, &$total) 
	{

		return Quick::single('accountant/transaction_entry')->cache()->getEntry($batchId, $limit, $start, &$total);
	}
	
	/*
	 * @desc get list account
	 * 
	 * @author: bichttn
	 */
	public static function getEntryById($entryId) 
	{

		return Quick::single('accountant/transaction_entry')->cache()->getEntryById($entryId);
	}
	/*
	 * @desc get list account
	 * 
	 * @author: bichttn
	 */
	public static function getCorrespondenceByEntryId($entryId) 
	{

		return Quick::single('accountant/transaction_entry')->cache()->getCorrespondenceByEntryId($entryId);
	}
	
	/*
	 * @desc update list account
	 * 
	 * @author: bichttn
	 */
	public static function updateEntry($entryId, $masterAccountId, $debitCredit, $originalAmount, $currencyId, $forexRate, $convertedAmount) 
	{

		return Quick::single('accountant/transaction_entry')->cache()->updateEntry($entryId, $masterAccountId, $debitCredit, $originalAmount, $currencyId, $forexRate, $convertedAmount);
	}
	
	/*
	 * @desc update list account
	 * 
	 * @author: bichttn
	 */
	public static function updateCorrespondence($correspondenceId, $detailAccountId, $debitCredit, $originalAmount, $currencyId, $forexRate, $convertedAmount)
	{

		return Quick::single('accountant/transaction_correspondence')->cache()->updateCorrespondence($correspondenceId, $detailAccountId, $debitCredit, $originalAmount, $currencyId, $forexRate, $convertedAmount);
	}
}
