<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Controller
 * @author      trungpm
 */
class Quick_Accountant_InventoryController extends Quick_Core_Controller_Back
{
	public function init()
	{
		parent::init();
	}

	/**
	 *
	 * @insert a new array member at a given index
	 * @param array $array
	 * @param mixed $new_element
	 * @param int $index
	 * @return array
	 */
	function insertArrayIndex($array, $new_element, $index) {
		/*** get the start of the array ***/
		$start = array_slice($array, 0, $index);
		/*** get the end of the array ***/
		$end = array_slice($array, $index);
		/*** add the new element to the array ***/
		$start[] = $new_element;
		/*** glue them back together and return ***/
		return array_merge($start, $end);
	}

	/**
	 * @desc	Stock Manage Action
	 * @author	trungpm
	 */
	public function stockManageAction()
	{
		$this->view->decimalSeparator = Quick_Number::getDecimalSeparator();
		$this->view->thousandSeparator = Quick_Number::getThousandSeparator();
		$currentPeriod = Quick::single('core/definition_period')->cache()->getPeriodCurrent();
		$this->view->convertedCurrencyId = 0;
		if(!empty($currentPeriod)){
			$this->view->convertedCurrencyId =  $currentPeriod['currency_id'];
			$this->view->currentPeriodId =  $currentPeriod['period_id'];
		}
		if($this->_hasParam('getListWarehouse')){
			$result = Quick_Accountant_Remoter_StockManage::getListWarehouse();
			return $this->_helper->json->sendSuccess(array('data' => $result));
		}elseif($this->_hasParam('getListInventoryVoucher')){
			$total = 0;
			$result = Quick_Accountant_Remoter_StockManage::getListInventoryVoucher(
			$this->_getParam('limit'), $this->_getParam('start'), $this->_getParam('invoiceNumber'),
			$this->_getParam('fromDate'), $this->_getParam('toDate'), $this->_getParam('typeVote'),
			&$total);
			return $this->_helper->json->sendSuccess(array(
	            'data' => $result,
				'count' => $total
			));
		}elseif($this->_hasParam('getListCurrencyWithForexRate')){
			$result = Quick_Accountant_Remoter_BuyBilling::getCurrencyWithForexRate(null, $this->_getParam('convertCurrency'));
			$result = self::insertArrayIndex($result, array(
				'currency_id' => 0, 
				'currency_name' => '', 
				'forex_rate' => Quick_Number::formatNumber('0.00')), 0);
			return $this->_helper->json->sendSuccess(array('data' => $result));
		}elseif($this->_hasParam('insertInventoryVoucher')){
			$result = Quick_Accountant_Remoter_StockManage::insertInventoryVoucher(
			$this->_getParam('insertInventoryVoucher'),
			Zend_Json_Decoder::decode($this->_getParam('inventoryDate')),
			Zend_Json_Decoder::decode($this->_getParam('typeVote')),
			Zend_Json_Decoder::decode($this->_getParam('inWarehouse')),
			Zend_Json_Decoder::decode($this->_getParam('outWarehouse')),
			Zend_Json_Decoder::decode($this->_getParam('currencyId')),
			Zend_Json_Decoder::decode($this->_getParam('forexrate')),
			$this->view->currentPeriodId);
			if($result){
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
			return $this->_helper->json->sendFailure();
		}elseif($this->_hasParam('deleteInventoryVoucher')){
			$result = Quick_Accountant_Remoter_StockManage::deleteInventoryVoucher(
			Zend_Json_Decoder::decode($this->_getParam('arrRecord')));
			if($result){
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
			return $this->_helper->json->sendFailure(array('data' => $result));
		}elseif($this->_hasParam('getListProduct')){
			$total = 0;
			$result = Quick_Accountant_Remoter_BuyBilling::getListProduct(
			$this->_getParam('limit'),
			$this->_getParam('start'),
			$this->_getParam('productName'),
			&$total,
			$this->_getParam('productCode'));
			return $this->_helper->json->sendSuccess(array('data' => $result,'count' => $total
			));
		}elseif($this->_hasParam('getListUnit')){
			$result = Quick_Core_Remoter_ProductCatalog::getListUnit();
			return $this->_helper->json->sendSuccess(array('data' => $result));
		}elseif($this->_hasParam('getListDepartment')){
			$result = Quick_Inventory_Remoter_StockCatalog::getListDepartment();
			return $this->_helper->json->sendSuccess(array('data' => $result));
		}elseif($this->_hasParam('getListSubject')){
			$result = Quick_Accountant_Remoter_StockManage::getListSubject($this->_getParam('getListSubject'));
			return $this->_helper->json->sendSuccess(array('data' => $result));
		}elseif($this->_hasParam('insertDetailInventory')){
			$result = Quick_Accountant_Remoter_StockManage::insertDetailInventory(
			$this->_getParam('insertDetailInventory'),
			Zend_Json_Decoder::decode($this->_getParam('records')),
			Zend_Json_Decoder::decode($this->_getParam('typeVote')));
			if($result){
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
			return $this->_helper->json->sendFailure(array('data' => $result));
		}elseif($this->_hasParam('getDetailInventoryVoucher')){
			$result = Quick_Accountant_Remoter_StockManage::getDetailInventoryVoucher($this->_getParam('inventoryVoucherId'));
			return $this->_helper->json->sendSuccess(array('data' => $result));
		}elseif($this->_hasParam('deleteDetailInventory')){
			$result = Quick_Accountant_Remoter_StockManage::deleteDetailInventory($this->_getParam('deleteDetailInventory'),
			Zend_Json_Decoder::decode($this->_getParam('voucherId')),
			Zend_Json_Decoder::decode($this->_getParam('records')));
			if($result){
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
			return $this->_helper->json->sendFailure(array('data' => $result));
		}elseif($this->_hasParam('getDebitAccount')){
			$result = Quick_Accountant_Remoter_BuyBilling::getDebitAccount(Zend_Json_Decoder::decode($this->_getParam('accountTypeId')));
			return $this->_helper->json->sendSuccess(array('data' => $result));
		}elseif($this->_hasParam('getCreditAccount')){
			$result = Quick_Accountant_Remoter_BuyBilling::getCreditAccount(Zend_Json_Decoder::decode($this->_getParam('accountTypeId')));
			return $this->_helper->json->sendSuccess(array('data' => $result));
		}elseif($this->_hasParam('getEntryDebitOfPurchase')){
			$result = Quick_Accountant_Remoter_BuyBilling::getEntryDebitOfPurchase(
			Zend_Json_Decoder::decode($this->_getParam('batchId')));
			if($result){
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
			return $this->_helper->json->sendFailure(array('data' => $result));
		}elseif($this->_hasParam('updateFieldOfTransactionEntry')){
			$result = Quick_Accountant_Remoter_StockManage::updateFieldOfTransactionEntry(
			Zend_Json_Decoder::decode($this->_getParam('batchId')),
			Zend_Json_Decoder::decode($this->_getParam('entryId')),
			Zend_Json_Decoder::decode($this->_getParam('field')),
			Zend_Json_Decoder::decode($this->_getParam('value')),
			Zend_Json_Decoder::decode($this->_getParam('debitOrCredit')),
			Zend_Json_Decoder::decode($this->_getParam('originalAmount')),
			Zend_Json_Decoder::decode($this->_getParam('currencyId')),
			Zend_Json_Decoder::decode($this->_getParam('forexRate')),
			Zend_Json_Decoder::decode($this->_getParam('productId')),
			Zend_Json_Decoder::decode($this->_getParam('unitId')),
			Zend_Json_Decoder::decode($this->_getParam('inWarehouseId')),
			Zend_Json_Decoder::decode($this->_getParam('outWarehouseId')),
			Zend_Json_Decoder::decode($this->_getParam('subjectId')),
			Zend_Json_Decoder::decode($this->_getParam('departmentId')));
			return $this->_helper->json->sendSuccess(array('data' => $result));
		}elseif($this->_hasParam('updateFieldOfTransactionCorrespondence')){
			$result = Quick_Accountant_Remoter_StockManage::updateFieldOfTransactionCorrespondence(
			Zend_Json_Decoder::decode($this->_getParam('correspondenceId')),
			Zend_Json_Decoder::decode($this->_getParam('entryId')),
			Zend_Json_Decoder::decode($this->_getParam('field')),
			Zend_Json_Decoder::decode($this->_getParam('value')),
			Zend_Json_Decoder::decode($this->_getParam('debitOrCredit')),
			Zend_Json_Decoder::decode($this->_getParam('originalAmount')),
			Zend_Json_Decoder::decode($this->_getParam('currencyId')),
			Zend_Json_Decoder::decode($this->_getParam('forexRate')),
			Zend_Json_Decoder::decode($this->_getParam('productId')),
			Zend_Json_Decoder::decode($this->_getParam('unitId')),
			Zend_Json_Decoder::decode($this->_getParam('inWarehouseId')),
			Zend_Json_Decoder::decode($this->_getParam('outWarehouseId')),
			Zend_Json_Decoder::decode($this->_getParam('subjectId')),
			Zend_Json_Decoder::decode($this->_getParam('departmentId')));
			return $this->_helper->json->sendSuccess(array('data' => $result));
		}elseif($this->_hasParam('deleteTransactionEntry')){
			$result = Quick_Accountant_Remoter_BuyBilling::deleteTransactionEntry(
			Zend_Json_Decoder::decode($this->_getParam('arrEntryId')),
			Zend_Json_Decoder::decode($this->_getParam('arrCorrespondenceId')));
			if($result){
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
			return $this->_helper->json->sendFailure(array('data' => $result));
		}elseif($this->_hasParam('updateTypeVoteOfPurchase')){
			$result = Quick_Accountant_Remoter_StockManage::updateTypeVoteOfPurchase(
			$this->_getParam('updateTypeVoteOfPurchase'),
			Zend_Json_Decoder::decode($this->_getParam('voucherId')),
			Zend_Json_Decoder::decode($this->_getParam('batchId')),
			Zend_Json_Decoder::decode($this->_getParam('field')),
			Zend_Json_Decoder::decode($this->_getParam('value')));
			if($result){
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
			return $this->_helper->json->sendFailure(array('data' => $result));
		}elseif($this->_hasParam('updateInventoryVoucher')){
			$result = Quick_Accountant_Remoter_StockManage::updateFieldOfInventoryVoucher($this->_getParam('updateInventoryVoucher'),
			Zend_Json_Decoder::decode($this->_getParam('batchId')),
			Zend_Json_Decoder::decode($this->_getParam('field')),
			Zend_Json_Decoder::decode($this->_getParam('value')),
			Zend_Json_Decoder::decode($this->_getParam('convertCurrency')));
			if($result){
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
			return $this->_helper->json->sendFailure();
		}elseif($this->_hasParam('updateDetailInventory')){
			$result = Quick_Accountant_Remoter_StockManage::updateFieldOfDetailInventory($this->_getParam('updateDetailInventory'),
			Zend_Json_Decoder::decode($this->_getParam('voucherId')),
			Zend_Json_Decoder::decode($this->_getParam('recordId')),	
			Zend_Json_Decoder::decode($this->_getParam('field')),
			Zend_Json_Decoder::decode($this->_getParam('value')),
			Zend_Json_Decoder::decode($this->_getParam('forexRate')));
			if($result){
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
			return $this->_helper->json->sendFailure();
		}

		$this->render();
	}
}
