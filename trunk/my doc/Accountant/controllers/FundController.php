<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Controller
 * @author      trungpm
 */
class Quick_Accountant_FundController extends Quick_Core_Controller_Back
{
	
	public function init()
	{
		parent::init();
	}

	/**
	 * @desc	Fund Manage Action
	 * @author	trungpm
	 */
	public function fundManageAction()
	{
		$this->view->decimalSeparator = Quick_Number::getDecimalSeparator();
		$this->view->thousandSeparator = Quick_Number::getThousandSeparator();
		$currentPeriod = Quick::single('core/definition_period')->cache()->getPeriodCurrent();
		$this->view->convertedCurrencyId = 0;
		if(!empty($currentPeriod)){
			$this->view->convertedCurrencyId =  $currentPeriod['currency_id'];
		}
		
		// get cash voucher
		if ($this->_hasParam('getCashVoucher')) {
			$total = 0;
			$aryCashVoucher = Quick_Accountant_Remoter_FundManage::getCashVoucher(
				$this->_getParam('cashVoucherNumber'),
				$this->_getParam('dateFromSearch'), $this->_getParam('dateToSearch'),	
				$this->_getParam('limit'), $this->_getParam('start'),
				&$total);
			return $this->_helper->json->sendSuccess(array(
	            'data' => $aryCashVoucher,
				'count' => $total
			));	
		} 
		//  insert transaction voucher
		else if($this->_hasParam('insertTransactionVoucher')) {
			$insert = Quick_Accountant_Remoter_FundManage::insertTransactionVoucher(
				$currentPeriod['period_id'],
				$this->_getParam('cashVoucherNumber'),
				$this->_getParam('cashVoucherDate'));
			return $this->_helper->json->sendSuccess(array('data' => $insert));		
		} 
		// insert cash voucher
		else if ($this->_hasParam('insertCashVoucher')) {
			$insert = Quick_Accountant_Remoter_FundManage::insertCashVoucher(
				$this->_getParam('voucherId'),
				$this->_getParam('cashVoucherNumber'),
				$this->_getParam('cashVoucherDate'),
				$this->_getParam('subjectId'),
				$this->_getParam('amount'),
				$this->_getParam('currencyId'),
				$this->_getParam('forexRate'),
				$this->_getParam('convertedAmount'),
				$this->_getParam('inOut'),
				$this->_getParam('description'));
			return $this->_helper->json->sendSuccess(array('data' => $insert));				 
		}
		// insert transaction batch 
		else if ($this->_hasParam('insertBatch')) {
			$insert = Quick_Accountant_Remoter_FundManage::insertBatch(
				$this->_getParam('voucherId'),
				$this->_getParam('batchNode'));
			return $this->_helper->json->sendSuccess(array('data' => $insert));	
		} 
		// insert transaction entry
		else if ($this->_hasParam('insertEntry')) {
			$insert = Quick_Accountant_Remoter_FundManage::insertEntry($this->_getParam('batchId'));
			return $this->_helper->json->sendSuccess(array('data' => $insert));	
		} 
		// insert transaction correspondence
		else if ($this->_hasParam('insertCorrespondence')) {
			$insert = Quick_Accountant_Remoter_FundManage::insertCorrespondence(
				$this->_getParam('entryId'),
				$this->_getParam('detailAccountId'),
				$this->_getParam('debitCredit'),
				$this->_getParam('originalAmount'),
				$this->_getParam('currencyId'),
				$this->_getParam('forexRate'),
				$this->_getParam('convertedAmount')
				);
			return $this->_helper->json->sendSuccess(array('data' => $insert));				 
		}
		// insert detail entry
		else if ($this->_hasParam('insertDetailEntry')) {
			$insert = Quick_Accountant_Remoter_FundManage::insertDetailEntry(
				$this->_getParam('entryId'),
				$this->_getParam('tableId'),
				$this->_getParam('detailId'));
			return $this->_helper->json->sendSuccess(array('data' => $insert));	
		} 
		// insert detail correspondence
		else if ($this->_hasParam('insertCorrespondenceEntry')) {
			$insert = Quick_Accountant_Remoter_FundManage::insertDetailCorrespondence(
				$this->_getParam('correspondenceId'),
				$this->_getParam('tableId'),
				$this->_getParam('detailId'));
			return $this->_helper->json->sendSuccess(array('data' => $insert));	
		} 
		else if ($this->_hasParam('getListSubject')) {
			$subject = Quick_Accountant_Remoter_FundManage::getListSubject();
			return $this->_helper->json->sendSuccess(array('data' => $subject));
		} else if ($this->_hasParam('getBank')) {
			$bank = Quick_Accountant_Remoter_FundManage::getBank();
			return $this->_helper->json->sendSuccess(array('data' => $bank));
		} else if ($this->_hasParam('getListCurrencyCombo')) {
			$currency = Quick_Accountant_Remoter_FundManage::getCurrencyCombo();
			return $this->_helper->json->sendSuccess(array('data' => $currency));
		}  else if ($this->_hasParam('getCurrenyById')) {
			$currency = Quick_Accountant_Remoter_FundManage::getDetailCurByBaseIdAndCurId(
					Zend_Json_Decoder::decode($this->_getParam('base_cur_id')),
					$currentPeriod['currency_id']
			);
			return $this->_helper->json->sendSuccess(array(
            	'data' => $currency
			));
		} else if ($this->_hasParam('updateCashVoucher')) {
			$update = Quick_Accountant_Remoter_FundManage::updateCashVoucher(
				Zend_Json_Decoder::decode($this->_getParam('cashVoucherId')), 
				Zend_Json_Decoder::decode($this->_getParam('field')), 
				Zend_Json_Decoder::decode($this->_getParam('value')));
			$value = "";
			if (is_numeric(Zend_Json_Decoder::decode($this->_getParam('value')))) {
				$value = Quick_Number::formatNumber(Zend_Json_Decoder::decode($this->_getParam('value')));
			}
			return $this->_helper->json->sendSuccess(
				array('data' => $update, 
				      'value' => $value));	
		} else if ($this->_hasParam('updateBatch')) {
			$update = Quick_Accountant_Remoter_FundManage::updateBatchByVoucherId(
				Zend_Json_Decoder::decode($this->_getParam('voucherId')), 
				Zend_Json_Decoder::decode($this->_getParam('field')), 
				Zend_Json_Decoder::decode($this->_getParam('value')));
				
			return $this->_helper->json->sendSuccess(array('data' => $update));
		} else if ($this->_hasParam('updateVoucher')) {
			$update = Quick_Accountant_Remoter_FundManage::updateTransactionVoucher(
				Zend_Json_Decoder::decode($this->_getParam('voucherId')), 
				Zend_Json_Decoder::decode($this->_getParam('field')), 
				Zend_Json_Decoder::decode($this->_getParam('value')));
				
			return $this->_helper->json->sendSuccess(array('data' => $update));
		} else if ($this->_hasParam('updateEntryAndCorrespondence')) {
			$update = Quick_Accountant_Remoter_FundManage::updateEntryAndCorrespondence(
				Zend_Json_Decoder::decode($this->_getParam('voucherId')), 
				Zend_Json_Decoder::decode($this->_getParam('field')), 
				Zend_Json_Decoder::decode($this->_getParam('value')));
				
			return $this->_helper->json->sendSuccess(array('data' => $update));
		}
		// update transaction entry
		else if ($this->_hasParam('updateEntry')) {
			$update = Quick_Accountant_Remoter_FundManage::updateEntry(
				Zend_Json_Decoder::decode($this->_getParam('entryId')), 
				Zend_Json_Decoder::decode($this->_getParam('field')), 
				Zend_Json_Decoder::decode($this->_getParam('value')));
				
			return $this->_helper->json->sendSuccess(array('data' => $update));
		} 
		else if ($this->_hasParam('updateCorrespondence')) {
			$update = Quick_Accountant_Remoter_FundManage::updateCorrespondence(
				Zend_Json_Decoder::decode($this->_getParam('correspondenceId')), 
				Zend_Json_Decoder::decode($this->_getParam('field')), 
				Zend_Json_Decoder::decode($this->_getParam('value')));

			$value = "";
			if (is_numeric(Zend_Json_Decoder::decode($this->_getParam('value')))) {
				$value = Quick_Number::formatNumber(Zend_Json_Decoder::decode($this->_getParam('value')));
			}	
			return $this->_helper->json->sendSuccess(array('data' => $update,
															'value' => $value));
		} else if ($this->_hasParam('getAccountByBankId')) {
			$aryAccount = Quick_Accountant_Remoter_FundManage::getBankAccountByBankId($this->_getParam('bankId'));
			return $this->_helper->json->sendSuccess(array(
            	'data' => $aryAccount
			));
		}else if ($this->_hasParam('getEntry')) {
			$entry = Quick_Accountant_Remoter_FundManage::getEntryByVoucherId($this->_getParam('voucherId'));
			return $this->_helper->json->sendSuccess(array(
            	'data' => $entry
			));
		} else if($this->_hasParam('getAccountDebit')) {
			$aryAccountDebit = Quick_Accountant_Remoter_FundManage::getAccountDebitByEntryTypeId($this->_getParam('entryTypeId'));
			return $this->_helper->json->sendSuccess(array('data' => $aryAccountDebit));
		} else if($this->_hasParam('getAccountCredit')) {
			$aryAccountCredit = Quick_Accountant_Remoter_FundManage::getAccountCreditByEntryTypeId($this->_getParam('entryTypeId'));
			return $this->_helper->json->sendSuccess(array('data' => $aryAccountCredit));
		} 
		// delete cash voucher 
		elseif($this->_hasParam('deleteCashVoucher')){
			$result = Quick_Accountant_Remoter_FundManage::deleteCashVoucher(
				Zend_Json_Decoder::decode($this->_getParam('arrRecord')));
			if($result){
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
			return $this->_helper->json->sendFailure(array('data' => $result));
		}
		// delete entry
		else if ($this->_hasParam('deleteEntry')) {
			$result = Quick_Accountant_Remoter_FundManage::deleteTransactionEntryById($this->_getParam('entryId'));
			if($result){
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
			return $this->_helper->json->sendFailure(array('data' => $result));
		}
		// deleteCorrespondence
		else if ($this->_hasParam('deleteCorrespondence')) {
			$result = Quick_Accountant_Remoter_FundManage::deleteTransactionCorrespondenceById(
				Zend_Json_Decoder::decode($this->_getParam('aryRecord')));
			if($result){
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
			return $this->_helper->json->sendFailure(array('data' => $result));
		}
		
		
		$this->render();
	}

}
