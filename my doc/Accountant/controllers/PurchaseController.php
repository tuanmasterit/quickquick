<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Controller
 * @author      trungpm
 */
class Quick_Accountant_PurchaseController extends Quick_Core_Controller_Back
{
	public function init()
	{
		parent::init();
	}

	/**
	 * @desc	Buy Billing Action
	 * @author	trungpm
	 */
	public function buyBillingAction()
	{
		$this->view->decimalSeparator = Quick_Number::getDecimalSeparator();
		$this->view->thousandSeparator = Quick_Number::getThousandSeparator();
		$currentPeriod = Quick::single('core/definition_period')->cache()->getPeriodCurrent();
		$this->view->convertedCurrencyId = 0;
		if(!empty($currentPeriod)){
			$this->view->convertedCurrencyId =  $currentPeriod['currency_id'];
			$this->view->currentPeriodId =  $currentPeriod['period_id'];
		}
		if($this->_hasParam('getListProduct')){
			$total = 0;
			$result = Quick_Accountant_Remoter_BuyBilling::getListProduct(
			$this->_getParam('limit'),
			$this->_getParam('start'),
			$this->_getParam('productName'),
			&$total,
			$this->_getParam('productCode'));
			return $this->_helper->json->sendSuccess(array('data' => $result,'count' => $total
			));
		}elseif($this->_hasParam('getListSubjectWithForexRate')){
			$result = Quick_Accountant_Remoter_BuyBilling::getSupplierWithForexRate(null, $this->_getParam('convertCurrency'));
			return $this->_helper->json->sendSuccess(array(
	            'data' => $result
			));
		}elseif($this->_hasParam('getListSubject')){
			$result = Quick_Core_Remoter_ProductCatalog::getSubjectByType(
			$this->_getParam('getListSubject'));
			return $this->_helper->json->sendSuccess(array('data' => $result));
		}elseif($this->_hasParam('getListPurchaseInvoice')){
			$total = 0;
			$result = Quick_Accountant_Remoter_BuyBilling::getListPurchaseInvoice(
			$this->_getParam('limit'), $this->_getParam('start'), $this->_getParam('invoiceNumber'),
			$this->_getParam('fromDate'), $this->_getParam('toDate'), $this->_getParam('supplier'),
			&$total);
			return $this->_helper->json->sendSuccess(array(
	            'data' => $result,
				'count' => $total
			));
		}elseif($this->_hasParam('getListCurrencyWithForexRate')){
			$result = Quick_Accountant_Remoter_BuyBilling::getCurrencyWithForexRate(null, $this->_getParam('convertCurrency'));
			return $this->_helper->json->sendSuccess(array('data' => $result));
		}elseif($this->_hasParam('getDetailPurchaseInvoiceById')){
			$result = Quick_Accountant_Remoter_BuyBilling::getDetailPurchaseInvoiceById($this->_getParam('purchaseInvoiceId'));
			return $this->_helper->json->sendSuccess(array('data' => $result));
		}elseif($this->_hasParam('getTaxRate')){
			$result = Quick_Accountant_Remoter_BuyBilling::getTaxRateByTaxId($this->_getParam('getTaxRate'));
			return $this->_helper->json->sendSuccess(array('data' => $result));
		}elseif($this->_hasParam('updatePurchase')){
			$result = Quick_Accountant_Remoter_BuyBilling::updateFieldOfPurchaseInvoice($this->_getParam('updatePurchase'),
			Zend_Json_Decoder::decode($this->_getParam('field')),
			Zend_Json_Decoder::decode($this->_getParam('value')),
			Zend_Json_Decoder::decode($this->_getParam('convertCurrency')));
			if($result){
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
			return $this->_helper->json->sendFailure();
		}elseif($this->_hasParam('updateDetailPurchase')){
			$result = Quick_Accountant_Remoter_BuyBilling::updateFieldOfDetailPurchase($this->_getParam('updateDetailPurchase'),
			Zend_Json_Decoder::decode($this->_getParam('productId')),
			Zend_Json_Decoder::decode($this->_getParam('field')),
			Zend_Json_Decoder::decode($this->_getParam('value')),
			Zend_Json_Decoder::decode($this->_getParam('forexRate')));
			if($result){
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
			return $this->_helper->json->sendFailure();
		}elseif($this->_hasParam('getListUnit')){
			$result = Quick_Core_Remoter_ProductCatalog::getListUnit();
			return $this->_helper->json->sendSuccess(array('data' => $result));
		}elseif($this->_hasParam('insertPurchaseInvoice')){
			$result = Quick_Accountant_Remoter_BuyBilling::insertPurchaseInvoice(
			$this->_getParam('insertPurchaseInvoice'),
			Zend_Json_Decoder::decode($this->_getParam('invoiceDate')),
			Zend_Json_Decoder::decode($this->_getParam('suppId')),
			Zend_Json_Decoder::decode($this->_getParam('suppName')),
			Zend_Json_Decoder::decode($this->_getParam('suppAddress')),
			Zend_Json_Decoder::decode($this->_getParam('suppTaxCode')),
			Zend_Json_Decoder::decode($this->_getParam('suppContact')),
			Zend_Json_Decoder::decode($this->_getParam('currencyId')),
			Zend_Json_Decoder::decode($this->_getParam('forexrate')),
			Zend_Json_Decoder::decode($this->_getParam('byImport')),
			$this->view->currentPeriodId);
			if($result){
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
			return $this->_helper->json->sendFailure();
		}elseif($this->_hasParam('getEntryDebitOfPurchase')){
			$result = Quick_Accountant_Remoter_BuyBilling::getEntryDebitOfPurchase(
			Zend_Json_Decoder::decode($this->_getParam('batchId')));
			if($result){
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
			return $this->_helper->json->sendFailure(array('data' => $result));
		}elseif($this->_hasParam('getDebitAccount')){
			$result = Quick_Accountant_Remoter_BuyBilling::getDebitAccount($this->_getParam('getDebitAccount'));
			return $this->_helper->json->sendSuccess(array('data' => $result));
		}elseif($this->_hasParam('getCreditAccount')){
			$result = Quick_Accountant_Remoter_BuyBilling::getCreditAccount($this->_getParam('getCreditAccount'));
			return $this->_helper->json->sendSuccess(array('data' => $result));
		}elseif($this->_hasParam('updateFieldOfTransactionEntry')){
			$result = Quick_Accountant_Remoter_BuyBilling::updateFieldOfTransactionEntry(
			Zend_Json_Decoder::decode($this->_getParam('batchId')),
			Zend_Json_Decoder::decode($this->_getParam('entryId')),
			Zend_Json_Decoder::decode($this->_getParam('field')),
			Zend_Json_Decoder::decode($this->_getParam('value')),
			Zend_Json_Decoder::decode($this->_getParam('debitOrCredit')),
			Zend_Json_Decoder::decode($this->_getParam('originalAmount')),
			Zend_Json_Decoder::decode($this->_getParam('currencyId')),
			Zend_Json_Decoder::decode($this->_getParam('forexRate')),
			Zend_Json_Decoder::decode($this->_getParam('productId')),
			Zend_Json_Decoder::decode($this->_getParam('unitId'))
			);
			return $this->_helper->json->sendSuccess(array('data' => $result));
		}elseif($this->_hasParam('updateFieldOfTransactionCorrespondence')){
			$result = Quick_Accountant_Remoter_BuyBilling::updateFieldOfTransactionCorrespondence(
			Zend_Json_Decoder::decode($this->_getParam('correspondenceId')),
			Zend_Json_Decoder::decode($this->_getParam('entryId')),
			Zend_Json_Decoder::decode($this->_getParam('field')),
			Zend_Json_Decoder::decode($this->_getParam('value')),
			Zend_Json_Decoder::decode($this->_getParam('debitOrCredit')),
			Zend_Json_Decoder::decode($this->_getParam('originalAmount')),
			Zend_Json_Decoder::decode($this->_getParam('currencyId')),
			Zend_Json_Decoder::decode($this->_getParam('forexRate')),
			Zend_Json_Decoder::decode($this->_getParam('productId')),
			Zend_Json_Decoder::decode($this->_getParam('unitId'))
			);
			return $this->_helper->json->sendSuccess(array('data' => $result));
		}elseif($this->_hasParam('updateByImportOfPurchase')){
			$result = Quick_Accountant_Remoter_BuyBilling::updateByImportOfPurchase(
			$this->_getParam('updateByImportOfPurchase'),
			Zend_Json_Decoder::decode($this->_getParam('voucherId')),
			Zend_Json_Decoder::decode($this->_getParam('field')),
			Zend_Json_Decoder::decode($this->_getParam('value')));
			if($result){
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
			return $this->_helper->json->sendFailure(array('data' => $result));
		}elseif($this->_hasParam('insertDetailPurchase')){
			$result = Quick_Accountant_Remoter_BuyBilling::insertDetailPurchase(
			$this->_getParam('insertDetailPurchase'),
			Zend_Json_Decoder::decode($this->_getParam('records')));
			if($result){
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
			return $this->_helper->json->sendFailure(array('data' => $result));
		}elseif($this->_hasParam('deleteDetailPurchase')){
			$result = Quick_Accountant_Remoter_BuyBilling::deleteDetailPurchase($this->_getParam('deleteDetailPurchase'),
			Zend_Json_Decoder::decode($this->_getParam('voucherId')),
			Zend_Json_Decoder::decode($this->_getParam('records')));
			if($result){
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
			return $this->_helper->json->sendFailure(array('data' => $result));
		}elseif($this->_hasParam('deleteTransactionEntry')){
			$result = Quick_Accountant_Remoter_BuyBilling::deleteTransactionEntry(
			Zend_Json_Decoder::decode($this->_getParam('arrEntryId')),
			Zend_Json_Decoder::decode($this->_getParam('arrCorrespondenceId')));
			if($result){
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
			return $this->_helper->json->sendFailure(array('data' => $result));
		}elseif($this->_hasParam('deletePurchaseInvoice')){
			$result = Quick_Accountant_Remoter_BuyBilling::deletePurchaseInvoice(
			Zend_Json_Decoder::decode($this->_getParam('arrRecord')));
			if($result){
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
			return $this->_helper->json->sendFailure(array('data' => $result));
		}
		$this->render();
	}
}
