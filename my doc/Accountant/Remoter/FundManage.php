<?php
/**
 *
 * @category    Quick
 * @package     Quick_FundManage
 * @author      bichttn
 */
class Quick_Accountant_Remoter_FundManage {
	
	
	/**
	 * @desc search cash voucher
	 *
	 * @author bichttn	
	 * @return array
	 */
	public static function getCashVoucher($cashVoucherNumber, $dateFrom, $dateTo, $limit, $start, &$total)
	{
		$aryCashVoucher = Quick::single('accountant/cash_voucher')->cache()->getCashVoucher($cashVoucherNumber, $dateFrom, $dateTo, $limit, $start, &$total);
		$aryCashVoucherNew = array();
		if ($aryCashVoucher) {
			foreach($aryCashVoucher as $aryCash) {
				$aryCash['amount'] = Quick_Number::formatNumber($aryCash['amount']);
				$aryCash['forex_rate'] = Quick_Number::formatNumber($aryCash['forex_rate']);
				$aryCash['converted_amount'] = Quick_Number::formatNumber($aryCash['converted_amount']);
				$aryCashVoucherNew[] = $aryCash;
			}	
		}
		
		return $aryCashVoucherNew;
	}

	/*
	 * @desc get transaction voucher
	 * 
	 * @author: bichttn
	 */
	public static function insertTransactionVoucher($periodId, $voucherNumber, $voucherDate) 
	{	
		$_EXECUTION_ID = 18;
		$voucher = array(
			'execution_id'=> $_EXECUTION_ID,
			'period_id' => $periodId,
			'from_transference' => 1,
			'voucher_number' => $voucherNumber,
			'voucher_date'	 => $voucherDate,	
			'created_by_userid' => Quick::session()->userId,
			'date_entered' => Quick_Date::now()->toSQLString(),
			'last_modified_by_userid' => Quick::session()->userId,
			'date_last_modified' => Quick_Date::now()->toSQLString()
		);
		$newId = Quick::single('accountant/transaction_voucher')->cache()->insertTransactionVoucher($voucher);
		if ($newId) {
			return $newId;
		}
		
		return null;
		
	}	
	/**
	 * @desc insert cash voucher
	 *
	 * @author bichttn	
	 * @return array
	 */
	public static function insertCashVoucher($voucherId, $cashVoucherNumber, $cashVoucherDate, $subjectId,
											 $amount, $currencyId, $forexRate, $convertedAmount, $inOut, $description)
	{
		$cashVoucher = array(
			'voucher_id'=> $voucherId,
			'cash_voucher_number' => $cashVoucherNumber,
			'cash_voucher_date' => $cashVoucherDate,
			'subject_id'	 => $subjectId,	
			'amount' => $amount,
			'currency_id'	=> $currencyId,
			'forex_rate'	=> $forexRate,
			'converted_amount'	=> $convertedAmount,
			'in_out'	=> $inOut,
			'description'	=> $description,
			'created_by_userid' => Quick::session()->userId,
			'date_entered' => Quick_Date::now()->toSQLString(),
			'last_modified_by_userid' => Quick::session()->userId,
			'date_last_modified' => Quick_Date::now()->toSQLString()
		);
		$newId = Quick::single('accountant/cash_voucher')->cache()->insertCashVoucher($cashVoucher);
		
		if ($newId) { 
			$aryVoucher = array(
				'cash_voucher_id' => $newId,
				'voucher_id'=> $voucherId,
				'cash_voucher_number' => $cashVoucherNumber,
				'cash_voucher_date' => ($cashVoucherDate)? date('d/m/Y', strtotime($cashVoucherDate)) : '',
				'subject_id'	 => $subjectId,	
				'amount' => ($amount) ? Quick_Number::formatNumber($amount): '0,00',
				'currency_id'	=> $currencyId,
				'forex_rate'	=> ($forexRate) ? Quick_Number::formatNumber($forexRate) : '0,00',
				'converted_amount'	=> ($convertedAmount) ? Quick_Number::formatNumber($convertedAmount) : '0,00',
				'in_out'	=> $inOut,
				'description'	=> $description	
			);
			
			return $aryVoucher;
		}
		else return null;
	}	
	
	/*
	 * @desc get list voucher
	 * 
	 * @author: bichttn
	 */
	public static function insertBatch($voucherId, $batchNode) 
	{	
		$_EXECUTION_ID = 18;
		$batch = array(
			'voucher_id'=> $voucherId,
			'execution_id' => $_EXECUTION_ID,
			'batch_note'	 => $batchNode
		);
		$newId = Quick::single('accountant/transaction_batch')->cache()->insertBatch($batch);
		if ($newId) return $newId;
		
		return null;
		
	}
	/**
	 * update transaction_batch
	 * @author	bichttn
	 * @return array Functions|mixed
	 */
	public static function updateBatchByVoucherId($voucherId, $field, $value)
	{
		
		return Quick::single('accountant/transaction_batch')->cache()->updateBatchByVoucherId($voucherId, $field, $value);
	}	
	/**
	 * 
	 * @author	bichttn
	 * @return array Functions|mixed
	 */
	public static function updateCashVoucher($cashVoucherId, $field, $value)
	{
		
		return Quick::single('accountant/cash_voucher')->cache()->updateCashVoucher($cashVoucherId, $field, $value);
	}
	
	/**
	 * update transaction_voucher
	 * @author	bichttn
	 * @return array Functions|mixed
	 */
	public static function updateTransactionVoucher($voucherId, $field, $value)
	{
		
		return Quick::single('accountant/transaction_voucher')->cache()->updateTransactionVoucher($voucherId, $field, $value);
	}	
	/**
	 * getListSubject
	 * @author	bichttn
	 * @return array Functions|mixed
	 */
	public static function getListSubject()
	{
		
		return Quick::single('core/definition_subject')->cache()->getListSubjectForVoucher();
	}
	
	/**
	 * get bank
	 * @author	bichttn
	 * @return array Functions|mixed
	 */
	public static function getBank()
	{
		
		$bank = Quick::single('core/definition_subject')->cache()->getBank();
		$startItem = array();
		$startItem['subject_id'] = 0;
		$startItem['subject_code'] = '';
		$startItem['subject_name'] = '';
		$account_new = array();
		$account_new[] = $startItem;
		if ($bank) foreach($bank as $a) $account_new[] = $a;
	
		return $account_new;
	}
	/**
	 * 
	 * @author	bichttn
	 * @return array Functions|mixed
	 */
	public static function getBankAccountByBankId($bankId)
	{
		
		return Quick::single('accountant/bank_account')->cache()->getBankAccountByBankId($bankId);
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
	/*
	 * @desc 
	 * 
	 * @author: bichttn
	 */
	public static function getDetailCurByBaseIdAndCurId($baseCurId, $curId)
	{

		$currency = Quick::single('core/definition_detail_currency')->cache()->getDetailCurByBaseIdAndCurId($baseCurId, $curId);
		if ($currency)
			$currency['forex_rate'] = Quick_Number::formatNumber($currency['forex_rate']);
		
		return $currency;
	}
	
	/*
	 * @desc 
	 * 
	 * @author: bichttn
	 */
	public static function getEntryByVoucherId($voucherId)
	{
		$_DEBIT = -1;
		$_CREDIT = 1;
		$entry = Quick::single('accountant/transaction_entry')->cache()->getEntryByVoucherId($voucherId);
		$entry_new = array();
		if ($entry) {
			if (!$entry['debit_credit']) {
				$entry['entry_id'] = $entry['entry_id'];
				$entry['correspondence_id'] = "";
				$entry['debit_account_id'] =  "";
				$entry['credit_account_id'] = "";	
				$entry['original_amount'] = Quick_Number::formatNumber($entry['original_amount']);
				$entry['forex_rate'] = Quick_Number::formatNumber($entry['forex_rate']);
				$entry['converted_amount'] = Quick_Number::formatNumber($entry['converted_amount']);
				$entry_new[] = $entry;
			} else {
				// get account transaction correspondence
				$correspondence = Quick_Accountant_Remoter_AccountLetter::getCorrespondenceByEntryId($entry['entry_id']);
				$aryCor = array();
				if ($correspondence) {
					foreach ($correspondence as $co) {
						$aryNew = array(); 
						$aryNew['entry_id'] = $entry['entry_id'];
						$aryNew['correspondence_id'] = $co['correspondence_id'];
						if ($co['debit_credit'] == $_DEBIT) {
							$aryNew['debit_account_id'] =  $co['detail_account_id'];
							$aryNew['credit_account_id'] = "";
						} else {
							$aryNew['debit_account_id'] =  "";
							$aryNew['credit_account_id'] = $co['detail_account_id'];
						}
						$aryNew['original_amount'] = Quick_Number::formatNumber($co['original_amount']);
						$aryNew['currency_id'] = $co['currency_id'];
						$aryNew['forex_rate'] = Quick_Number::formatNumber($co['forex_rate']);
						$aryNew['converted_amount'] = Quick_Number::formatNumber($co['converted_amount']);
						$aryCor[] = $aryNew;
					}
				}
				
				//
				$aryNew = array();
				$aryNew['entry_id'] = $entry['entry_id'];
				$aryNew['correspondence_id'] = "";
				$aryNew['original_amount'] = Quick_Number::formatNumber($entry['original_amount']);
				$aryNew['currency_id'] = $entry['currency_id'];
				$aryNew['forex_rate'] = Quick_Number::formatNumber($entry['forex_rate']);
				$aryNew['converted_amount'] = Quick_Number::formatNumber($entry['converted_amount']);

				
				if ($entry['debit_credit'] == $_DEBIT) {
					$aryNew['debit_account_id'] =  $entry['master_account_id'];
					$aryNew['credit_account_id'] = "";
					//$entry_new[] = $aryNew;
					//if ($aryCor) foreach ($aryCor as $cor) $entry_new[] = $cor;
					
					
				} else if ($entry['debit_credit'] == $_CREDIT) {
					
					$aryNew['debit_account_id'] =  "";
					$aryNew['credit_account_id'] = $entry['master_account_id'];
					//if ($aryCor) foreach ($aryCor as $cor) $entry_new[] = $cor;
					//$entry_new[] = $aryNew;
				}
				$entry_new[] = $aryNew;
				if ($aryCor) foreach ($aryCor as $cor) $entry_new[] = $cor;		
			}
		}
		
		return $entry_new;
	}
	
	/*
	 * @desc update transaction entry
	 * 
	 * @author: bichttn
	 */
	public static function updateEntryAndCorrespondence($voucherId, $field, $value){
		
		$entry = Quick::single('accountant/transaction_entry')->cache()->getEntryByVoucherId($voucherId);
		if ($entry) {
			// update transaction entry
			Quick::single('accountant/transaction_entry')->cache()->updateEntry($entry['entry_id'], $field, $value);	
			if ($field == 'forex_rate') {
				Quick::single('accountant/transaction_entry')->cache()->updateEntry($entry['entry_id'], 'converted_amount', $value*$entry['original_amount']);
			}
			if ($field == 'original_amount') {
				Quick::single('accountant/transaction_entry')->cache()->updateEntry($entry['entry_id'], 'converted_amount', $value*$entry['forex_rate']);
			}
			// update transtraction correspondence	
			$correspondence = Quick_Accountant_Remoter_AccountLetter::getCorrespondenceByEntryId($entry['entry_id']);
			
			if ($correspondence) {
				foreach ($correspondence as $co) {
					if ($field == 'forex_rate') {
						Quick::single('accountant/transaction_correspondence')->cache()->updateCorrespondence($co['correspondence_id'], 'converted_amount', $value*$co['original_amount']);
					}
					if ($field == 'forex_rate' || $field == 'currency_id')
						Quick::single('accountant/transaction_correspondence')->cache()->updateCorrespondence($co['correspondence_id'], $field, $value);
				}	
			}
			
		}
		return;
	}
	
	public static function updateEntry($entryId, $field, $value) {
		
		return Quick::single('accountant/transaction_entry')->cache()->updateEntry($entryId, $field, $value);
	}
	
	/**
	 * @desc update Correspondence
	 *
	 * @author bichttn
	 * @return array
	 */
	public static function updateCorrespondence($correspondenceId, $field, $value)
	{
		
		return Quick::single('accountant/transaction_correspondence')->cache()->updateCorrespondence($correspondenceId, $field, $value);
	}
	
	/*
	 * @desc  
	 * 
	 * @author: bichttn
	 */
	public static function getCorrespondenceByEntryId($entryId) 
	{

		return Quick::single('accountant/transaction_entry')->cache()->getCorrespondenceByEntryId($entryId);
	}
	
	/*
	 * @desc 
	 * 
	 * @author: bichttn
	 */
	public static function getAccountDebitByEntryTypeId($entryTypeId)
	{
		$account = Quick::single('core/definition_account')->cache()->getAccountDebitByEntryTypeId($entryTypeId);
		$startItem = array();
		$startItem['account_id'] = 1;
		$startItem['account_code'] = '';
		$startItem['account_name'] = '';
		$account_new = array();
		$account_new[] = $startItem;
		if ($account) foreach($account as $a) $account_new[] = $a;
		
		return $account_new;
	}
	
	/*
	 * @desc 
	 * 
	 * @author: bichttn
	 */
	public static function getAccountCreditByEntryTypeId($entryTypeId)
	{
		$account = Quick::single('core/definition_account')->cache()->getAccountCreditByEntryTypeId($entryTypeId);
		$startItem = array();
		$startItem['account_id'] = 1;
		$startItem['account_code'] = '';
		$startItem['account_name'] = '';
		$account_new = array();
		$account_new[] = $startItem;
		if ($account) foreach($account as $a) $account_new[] = $a;
		
		return $account_new;
	}
	
	/*
	 * @desc 
	 * 
	 * @author: bichttn
	 */
	public static function insertEntry($batchId) 
	{	
		$entry = array(
			'batch_id'=> $batchId,
			'master_account_id' => 1,	
			'original_amount' => 0.00,
			'forex_rate' => 0.00,
			'converted_amount' => 0.00 
		
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
			$aryCorr = array(
				'correspondence_id' => $newId,
				'entry_id' => $entryId,
				'detail_account_id'=> $detailAccountId,
				'debit_credit'	 => $debitCredit,
				'original_amount' => ($originalAmount != '0,00')? Quick_Number::formatNumber($originalAmount): '0,00',
				'currency_id' => $currencyId,
				'forex_rate' => ($forexRate > 0) ? Quick_Number::formatNumber($forexRate) : '0,00',
				'converted_amount' => ($convertedAmount != '0,00')? Quick_Number::formatNumber($convertedAmount): '0,00'	
			);
			
			return $aryCorr;
		} else {
			return false;
		}
	}
	
	public static function deleteCashVoucher($aryRecord) 
	{	
		foreach ($aryRecord as $record) {
			Quick::single('accountant/cash_voucher')->cache()->deleteCashVoucher($record['cash_voucher_id']);
		}
		return  true;
	}
	
	public static function deleteTransactionEntryById($entryId) 
	{	
		return Quick::single('accountant/transaction_entry')->cache()->deleteTransactionEntryById($entryId);
	}
	
	public static function deleteTransactionCorrespondenceById($aryRecord)
	{
		foreach ($aryRecord as $record) {
			Quick::single('accountant/transaction_correspondence')->cache()->deleteTransactionCorrespondenceById($record['correspondence_id']);
		}
		return true;
	}
	
	/*
	 * @desc insert accountant detail entry
	 * 
	 * @author: bichttn
	 */
	public static function insertDetailEntry($entryId, $tableId, $detailId) 
	{	
		$detailEntry = array(
			'entry_id'=> $entryId,
			'table_id' => $tableId,
			'detail_id' => $detailId
		);
		$newId = Quick::single('accountant/detail_entry')->cache()->insertDetailEntry($detailEntry);
		if ($newId) {
			return $newId;
		}
		
		return false;
	}	
	
	/*
	 * @desc insert accountant detail correspondence
	 * 
	 * @author: bichttn
	 */
	public static function insertDetailCorrespondence($correspondenceId, $tableId, $detailId) 
	{	
		$detailCorrespondence = array(
			'correspondence_id'=> $correspondenceId,
			'table_id' => $tableId,
			'detail_id' => $detailId
		);
		$newId = Quick::single('accountant/detail_correspondence')->cache()->insertDetailCorrespondence($detailCorrespondence);
		if ($newId) {
			return $newId;
		}
		
		return false;
	}	
}