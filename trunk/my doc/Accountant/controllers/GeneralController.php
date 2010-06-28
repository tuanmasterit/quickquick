<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Controller
 * @author      trungpm
 */
class Quick_Accountant_GeneralController extends Quick_Core_Controller_Back
{
    public function init()
    {
    	parent::init();
    }
    
    /**
	 * @desc	Accounting System Action
	 * @author	bichttn
	 */
	public function accountLetterAction()
	{
		if ($this->_hasParam('getListExecution')) {
			$result = Quick_Accountant_Remoter_AccountLetter::getListExecution();
			return $this->_helper->json->sendSuccess(array(
            	'data' => $result
			));
		} elseif($this->_hasParam('getListVoucher')){ 
			$total = 0;
			$detail = Quick_Accountant_Remoter_AccountLetter::getTransactionVoucher(
				$this->_getParam('executionIdSearch'), $this->_getParam('voucherNumberSearch'),
				$this->_getParam('dateFromSearch'), $this->_getParam('dateToSearch'),	
				$this->_getParam('limit'), $this->_getParam('start'),
				&$total);	
		
			return $this->_helper->json->sendSuccess(array(
	            'data' => $detail,
				'count' => $total
			));
		} else if ($this->_hasParam('getPeriodCurrent')) {
			$periodCurrent = Quick_Accountant_Remoter_AccountLetter::getPeriodCurrent();
			return $this->_helper->json->sendSuccess(array(
            	'data' => $periodCurrent
			));
		} else if ($this->_hasParam('insertVoucher')) {
			$voucherId = Quick_Accountant_Remoter_AccountLetter::insertListVoucher(
				Zend_Json_Decoder::decode($this->_getParam('execution_id')),
				Zend_Json_Decoder::decode($this->_getParam('period_id')),
				Zend_Json_Decoder::decode($this->_getParam('voucher_number')),
				Zend_Json_Decoder::decode($this->_getParam('voucher_date'))
			);
			return $this->_helper->json->sendSuccess(array(
            	'data' => $voucherId
			));
		} else if ($this->_hasParam('updateVoucher')) {
			$update = Quick_Accountant_Remoter_AccountLetter::updateListVoucher(
			Zend_Json_Decoder::decode($this->_getParam('voucher_id')),
			Zend_Json_Decoder::decode($this->_getParam('field')),
			Zend_Json_Decoder::decode($this->_getParam('value')));
			
			return $this->_helper->json->sendSuccess(array());
		} else if ($this->_hasParam('getListBatch')) {
			$total = 0;
			$detail = Quick_Accountant_Remoter_AccountLetter::getBatch(
				$this->_getParam('voucherId'),
				$this->_getParam('executionId'),
				$this->_getParam('batchNode'),
				$this->_getParam('limit'),
				$this->_getParam('start'),
				&$total);	
			return $this->_helper->json->sendSuccess(array(
	            'data' => $detail,
				'count' => $total
			));
		} else if ($this->_hasParam('insertBatch')) {
			$insertBatch = Quick_Accountant_Remoter_AccountLetter::insertBatch(
				$this->_getParam('voucherId'), 
				$this->_getParam('executionId'),
				$this->_getParam('batchNode'));
			return $this->_helper->json->sendSuccess(array(
            	'data' => $insertBatch
			));
		} else if ($this->_hasParam('updateBatch')) {
			$updateBatch = Quick_Accountant_Remoter_AccountLetter::updateBatch(
				Zend_Json_Decoder::decode($this->_getParam('bacthId')),
				Zend_Json_Decoder::decode($this->_getParam('field')),
				Zend_Json_Decoder::decode($this->_getParam('value')));
			
			return $this->_helper->json->sendSuccess(array());
		} else if ($this->_hasParam('getListAccount')) {
			$accountList = Quick_Accountant_Remoter_AccountLetter::getListAccount();
			return $this->_helper->json->sendSuccess(array(
            	'data' => $accountList
			));
		} else if ($this->_hasParam('getCurrenyById')) {
			$currency = Quick_Accountant_Remoter_AccountLetter::getDetailCurByBaseIdAndCurId(
					Zend_Json_Decoder::decode($this->_getParam('base_cur_id')),
					Zend_Json_Decoder::decode($this->_getParam('conv_cur_id'))
			);
			return $this->_helper->json->sendSuccess(array(
            	'data' => $currency
			));
		} else if ($this->_hasParam('getListCurrencyCombo')) {
			$curency = Quick_Accountant_Remoter_CurrencyCatalog::getCurrencyCombo();
			return $this->_helper->json->sendSuccess(array(
            		'data' => $curency
			));
		} else if ($this->_hasParam('insertEntry')) {
			$insertEntry = Quick_Accountant_Remoter_AccountLetter::insertEntry(
				Zend_Json_Decoder::decode($this->_getParam('batchId')), 
				Zend_Json_Decoder::decode($this->_getParam('masterAccountId')),
				Zend_Json_Decoder::decode($this->_getParam('debitCredit')),
				Zend_Json_Decoder::decode($this->_getParam('originalAmount')), 
				Zend_Json_Decoder::decode($this->_getParam('currencyId')),
				Zend_Json_Decoder::decode($this->_getParam('forexRate')),
				Zend_Json_Decoder::decode($this->_getParam('convertedAmount'))
				);	
			return $this->_helper->json->sendSuccess(array(
            	'data' => $insertEntry
			));
		} else if ($this->_hasParam('insertCorrespondence')) {
			$insertCorrespondence = Quick_Accountant_Remoter_AccountLetter::insertCorrespondence(
				Zend_Json_Decoder::decode($this->_getParam('entryId')), 
				Zend_Json_Decoder::decode($this->_getParam('detailAccountId')),
				Zend_Json_Decoder::decode($this->_getParam('debitCredit')),
				Zend_Json_Decoder::decode($this->_getParam('originalAmount')), 
				Zend_Json_Decoder::decode($this->_getParam('currencyId')),
				Zend_Json_Decoder::decode($this->_getParam('forexRate')),
				Zend_Json_Decoder::decode($this->_getParam('convertedAmount'))
				);	
			return $this->_helper->json->sendSuccess(array(
            	'data' => $insertCorrespondence
			));
		} else if ($this->_hasParam('getListEntry')) {
			$total = 0;
			$entry = Quick_Accountant_Remoter_AccountLetter::getEntry(Zend_Json_Decoder::decode(
				$this->_getParam('batchId')), 
				$this->_getParam('limit'), 
				$this->_getParam('start'),
				&$total);
			$entry_new = array();
			if ($entry) {
				foreach ($entry as $en) {
					$aryCor = array();
					$correspondence = Quick_Accountant_Remoter_AccountLetter::getCorrespondenceByEntryId($en['entry_id']);
					if ($correspondence) {
						foreach ($correspondence as $co) {
							$aryNew = array(); 
							$aryNew['entry_id'] = $en['entry_id'];
							$aryNew['correspondence_id'] = $co['correspondence_id'];
							if ($co['debit_credit'] == 1) {
								$aryNew['debit_account_id'] =  $co['detail_account_id'];
								$aryNew['credit_account_id'] = "";
							} else {
								$aryNew['debit_account_id'] =  "";
								$aryNew['credit_account_id'] = $co['detail_account_id'];
							}
							$aryNew['original_amount'] = number_format($co['original_amount'], 2);
							$aryNew['currency_id'] = $co['currency_id'];
							$aryNew['forex_rate'] = number_format($co['forex_rate'], 2);
							$aryNew['converted_amount'] = number_format($co['converted_amount'], 2);
							$aryCor[] = $aryNew;
						}	
					}
					$aryNew = array();
					$aryNew['entry_id'] = $en['entry_id'];
					$aryNew['correspondence_id'] = "";
					$aryNew['original_amount'] = number_format($en['original_amount'],2);
					$aryNew['currency_id'] = $en['currency_id'];
					$aryNew['forex_rate'] = number_format($en['forex_rate'], 2);
					$aryNew['converted_amount'] = number_format($en['converted_amount'], 2);
					
					if ($en['debit_credit'] == 1) {
						$aryNew['debit_account_id'] =  $en['master_account_id'];
						$aryNew['credit_account_id'] = "";
						$entry_new[] = $aryNew;
						if ($aryCor) {
							foreach ($aryCor as $cor) {
								$entry_new[] = $cor;
							}
						}
					} else if ($en['debit_credit'] == -1) {
						$aryNew['debit_account_id'] =  "";
						$aryNew['credit_account_id'] = $en['master_account_id'];
						if ($aryCor) {
							foreach ($aryCor as $cor) {
								$entry_new[] = $cor;
							}
						}
						$entry_new[] = $aryNew;
					} 
					
				}
			}
			$entryNew = array();
			if ($entry_new) {
				$count = 1;
				foreach($entry_new as $e) {
					$e['id'] = $count;
					$count++;	
					$entryNew[] = $e; 
				}
			}
			return $this->_helper->json->sendSuccess(array(
	            'data' => $entryNew,
				'count' => $total
			));
		} else if ($this->_hasParam('getDetailEntry')) {
			$entry = Quick_Accountant_Remoter_AccountLetter::getEntryById($this->_getParam('entryId'));
			$entry_new = array();
			if ($entry) {
				$correspondence = Quick_Accountant_Remoter_AccountLetter::getCorrespondenceByEntryId($entry['entry_id']);
				if ($correspondence) {
					foreach ($correspondence as $co) {
						$aryNew = array(); 
						$aryNew['entry_id'] = $entry['entry_id'];
						$aryNew['correspondence_id'] = $co['correspondence_id'];
						if ($co['debit_credit'] == 1) {
							$aryNew['debit_account_id'] =  $co['detail_account_id'];
							$aryNew['credit_account_id'] = "";
						} else {
							$aryNew['debit_account_id'] =  "";
							$aryNew['credit_account_id'] = $co['detail_account_id'];
						}
						$aryNew['original_amount'] = number_format($co['original_amount'],2);
						$aryNew['currency_id'] = $co['currency_id'];
						$aryNew['forex_rate'] = number_format($co['forex_rate'], 2);
						$aryNew['converted_amount'] = number_format($co['converted_amount'], 2);
						$aryCor[] = $aryNew;
					}
				}
				$aryNew = array();
				$aryNew['entry_id'] = $entry['entry_id'];
				$aryNew['correspondence_id'] = "";
				$aryNew['original_amount'] = number_format($entry['original_amount'],2);
				$aryNew['currency_id'] = $entry['currency_id'];
				$aryNew['forex_rate'] = number_format($entry['forex_rate'], 2);
				$aryNew['converted_amount'] = number_format($entry['converted_amount'], 2);
				
				if ($entry['debit_credit'] == 1) {
					$aryNew['debit_account_id'] =  $entry['master_account_id'];
					$aryNew['credit_account_id'] = "";
					$entry_new[] = $aryNew;
					if ($aryCor) {
						foreach ($aryCor as $cor) {
							$entry_new[] = $cor;
						}
					}
				} else if ($entry['debit_credit'] == -1) {
					$aryNew['debit_account_id'] =  "";
					$aryNew['credit_account_id'] = $entry['master_account_id'];
					if ($aryCor) {
						foreach ($aryCor as $cor) {
							$entry_new[] = $cor;
						}
					}
					$entry_new[] = $aryNew;
				} 	
			}
			return $this->_helper->json->sendSuccess(array(
	            'data' => $entry_new
			));
		}
		
		$this->render();
	}
}
