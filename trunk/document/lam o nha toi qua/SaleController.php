<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Controller
 * @author      trungpm
 */
class Quick_Accountant_SaleController extends Quick_Core_Controller_Back
{
    public function init()
    {
    	parent::init();
		$this->view->decimals = Quick_Number::getDecimals();
        $this->view->decimalSeparator = Quick_Number::getDecimalSeparator();
        $this->view->thousandSeparator = Quick_Number::getThousandSeparator();
        $currentPeriod = Quick::single('core/definition_period')->cache()->getPeriodCurrent();
        $this->view->convertedCurrencyId = 0;
        if (! empty($currentPeriod)) {
            $this->view->convertedCurrencyId = $currentPeriod['currency_id'];
            $this->view->currentPeriodId = $currentPeriod['period_id'];
        }
    }

	/**
     * @desc	Sale Billing Action
     * @author	trungpm
     */
    public function saleBillingAction() {

		if ($this->_hasParam('getListCurrencyWithForexRate')) {
            $result = Quick_Accountant_Remoter_BuyBilling::getCurrencyWithForexRate(null,
			$this->_getParam('convertCurrency'), $this->_getParam('query'), $this->_getParam('type'));
            return $this->_helper->json->sendSuccess(array('data'=>$result));
        } elseif ($this->_hasParam('getListCustomer')) {
            $total = 0;
            if ($this->_getParam('type') == 'code') {
                $result = Quick_Accountant_Remoter_SaleBilling::getListCustomer(
				$this->_getParam('limit'), $this->_getParam('start'), $this->_getParam('query'), null, &$total, $this->view->convertedCurrencyId);
            } else {
                $result = Quick_Accountant_Remoter_SaleBilling::getListCustomer(
				$this->_getParam('limit'), $this->_getParam('start'), null, $this->_getParam('query'), &$total, $this->view->convertedCurrencyId);
            }
            return $this->_helper->json->sendSuccess(array('data'=>$result, 'count'=>$total));
        } elseif ($this->_hasParam('getSearchProduct')) {
            $total = 0;
            $result = Quick_Accountant_Remoter_StockManage::getSearchProduct($this->_getParam('limit'), $this->_getParam('start'), $this->_getParam('query'), $this->_getParam('type'), &$total);
            return $this->_helper->json->sendSuccess(array('data'=>$result, 'count'=>$total));
        } elseif ($this->_hasParam('getUnitOfProductId')) {
            $result = Quick_Accountant_Remoter_BuyBilling::getUnitOfProductId(Zend_Json_Decoder::decode($this->_getParam('getUnitOfProductId')));
            if ($result) {
                return $this->_helper->json->sendSuccess(array('data'=>$result));
            }
            return $this->_helper->json->sendFailure(array('data'=>$result));
        } elseif ($this->_hasParam('getTaxOfProductId')) {
            $result = Quick_Accountant_Remoter_BuyBilling::getTaxOfProductId(Zend_Json_Decoder::decode($this->_getParam('getTaxOfProductId')));
            if ($result) {
                return $this->_helper->json->sendSuccess(array('data'=>$result));
            }
            return $this->_helper->json->sendFailure(array('data'=>$result));
        } elseif($this->_hasParam('getListInventoryVoucherNotInheritance')){
			$total = 0;
			$result = Quick_Accountant_Remoter_SaleBilling::getListInventoryVoucherNotInheritance(
			$this->_getParam('limit'), $this->_getParam('start'), $this->_getParam('invoiceNumber'),
			$this->_getParam('fromDate'), $this->_getParam('toDate'), $this->_getParam('supplierId'),
			&$total);
			return $this->_helper->json->sendSuccess(array(
	            'data' => $result,
				'count' => $total
			));
		} elseif($this->_hasParam('getDetailOfInventoryVoucherNotInheritance')){
			$result = Quick_Accountant_Remoter_SaleBilling::getDetailOfInventoryVoucherNotInheritance(
			Zend_Json_Decoder::decode($this->_getParam('inventoryId')));
			if($result){
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
			return $this->_helper->json->sendFailure(array('data' => $result));
		} elseif ($this->_hasParam('getListSalesInvoice')) {
            $total = 0;
            $result = Quick_Accountant_Remoter_SaleBilling::getListSalesInvoice($this->_getParam('limit'), $this->_getParam('start'), $this->_getParam('invoiceNumber'), $this->_getParam('fromDate'), $this->_getParam('toDate'), $this->_getParam('customer'), &$total);
            return $this->_helper->json->sendSuccess(array('data'=>$result, 'count'=>$total));
        } elseif ($this->_hasParam('insertSaleInvoice')) {
            $result = Quick_Accountant_Remoter_SaleBilling::insertSaleInvoice(
            Zend_Json_Decoder::decode($this->_getParam('invoiceNumber')),
            Zend_Json_Decoder::decode($this->_getParam('invoiceDate')),
            Zend_Json_Decoder::decode($this->_getParam('serialNumber')),
            Zend_Json_Decoder::decode($this->_getParam('cusId')),
            Zend_Json_Decoder::decode($this->_getParam('cusName')),
            Zend_Json_Decoder::decode($this->_getParam('cusAddress')),
            Zend_Json_Decoder::decode($this->_getParam('cusTaxCode')),
            Zend_Json_Decoder::decode($this->_getParam('cusContact')),
			Zend_Json_Decoder::decode($this->_getParam('paymentType')),
            Zend_Json_Decoder::decode($this->_getParam('currencyId')),
            Zend_Json_Decoder::decode($this->_getParam('forexrate')),
            Zend_Json_Decoder::decode($this->_getParam('byExport')),
            Zend_Json_Decoder::decode($this->_getParam('forService')),
			Zend_Json_Decoder::decode($this->_getParam('description')),
			Zend_Json_Decoder::decode($this->_getParam('debitAccountId')),
			Zend_Json_Decoder::decode($this->_getParam('creditAmountId')),
			Zend_Json_Decoder::decode($this->_getParam('creditVatId')),
			Zend_Json_Decoder::decode($this->_getParam('creditExportId')),
			Zend_Json_Decoder::decode($this->_getParam('creditExciseId')),
            Zend_Json_Decoder::decode($this->_getParam('type')),
			Zend_Json_Decoder::decode($this->_getParam('inventoryInherId')),
			Zend_Json_Decoder::decode($this->_getParam('inventoryInherVoucherId')),
            Zend_Json_Decoder::decode($this->_getParam('detail')),
            $this->view->currentPeriodId);
            if ($result) {
                return $this->_helper->json->sendSuccess(array('data'=>$result));
            }
            return $this->_helper->json->sendFailure();
        } elseif ($this->_hasParam('getDetailSaleInvoiceById')) {
            $result = Quick_Accountant_Remoter_SaleBilling::getDetailSaleInvoiceById($this->_getParam('salesInvoiceId'));
            return $this->_helper->json->sendSuccess(array('data'=>$result));
        } elseif ($this->_hasParam('getSearchServiceByName')) {
            $total = 0;
            $result = Quick_Accountant_Remoter_BuyBilling::getSearchService($this->_getParam('limit'), $this->_getParam('start'), null, $this->_getParam('query'), &$total);
            return $this->_helper->json->sendSuccess(array('data'=>$result, 'count'=>$total));
        } elseif ($this->_hasParam('getSearchServiceByCode')) {
            $total = 0;
            $result = Quick_Accountant_Remoter_BuyBilling::getSearchService($this->_getParam('limit'), $this->_getParam('start'), $this->_getParam('query'), null, &$total);
            return $this->_helper->json->sendSuccess(array('data'=>$result, 'count'=>$total));
        } elseif ($this->_hasParam('updateSaleInvoice')) {
            $result = Quick_Accountant_Remoter_SaleBilling::updateFieldOfSaleInvoice(
			Zend_Json_Decoder::decode($this->_getParam('saleInvoiceId')),
			Zend_Json_Decoder::decode($this->_getParam('batchId')),
			Zend_Json_Decoder::decode($this->_getParam('field')),
			Zend_Json_Decoder::decode($this->_getParam('value')),
			Zend_Json_Decoder::decode($this->_getParam('convertCurrency')));
            if ($result) {
                return $this->_helper->json->sendSuccess(array('data'=>$result));
            }
            return $this->_helper->json->sendFailure();
        } elseif ($this->_hasParam('getArrayEntryTypeOfSale')) {
        	$byExport = Zend_Json_Decoder::decode($this->_getParam('chkByExport')) == 0 ? false : true;
        	$forService = Zend_Json_Decoder::decode($this->_getParam('chkForService')) == 0 ? false : true;
            $result = Quick_Accountant_Remoter_SaleBilling::getArrayEntryTypeOfSale($byExport, $forService);
            if ($result) {
                return $this->_helper->json->sendSuccess(array('data'=>array_values($result)));
            }
            return $this->_helper->json->sendFailure();
        } elseif ($this->_hasParam('getAccountingOfSale')) {
            $result = Quick_Accountant_Remoter_SaleBilling::getAccountingOfSale(
            $this->_getParam('batchId'), $this->_getParam('entryTypeId'), $this->_getParam('forService'));
            if ($result) {
                return $this->_helper->json->sendSuccess(array('data'=>$result));
            }
            return $this->_helper->json->sendFailure();
        } elseif ($this->_hasParam('updateDetailSale')) {
            $result = Quick_Accountant_Remoter_SaleBilling::updateFieldOfDetailSale(
			Zend_Json_Decoder::decode($this->_getParam('saleId')),
			Zend_Json_Decoder::decode($this->_getParam('batchId')),
			Zend_Json_Decoder::decode($this->_getParam('recordId')),
			Zend_Json_Decoder::decode($this->_getParam('field')),
			Zend_Json_Decoder::decode($this->_getParam('value')),
			Zend_Json_Decoder::decode($this->_getParam('coefficient')));
            if ($result) {
                return $this->_helper->json->sendSuccess(array('data'=>$result));
            }
            return $this->_helper->json->sendFailure();
        } elseif ($this->_hasParam('deleteDetail')) {
            $result = Quick_Accountant_Remoter_SaleBilling::deleteDetail(
			Zend_Json_Decoder::decode($this->_getParam('saleId')),
			Zend_Json_Decoder::decode($this->_getParam('batchId')),
			Zend_Json_Decoder::decode($this->_getParam('records')));
            if ($result) {
                return $this->_helper->json->sendSuccess(array('data'=>$result));
            }
            return $this->_helper->json->sendFailure(array('data'=>$result));
        } elseif ($this->_hasParam('deleteSaleInvoice')) {
            $result = Quick_Accountant_Remoter_SaleBilling::deleteSaleInvoice(
			Zend_Json_Decoder::decode($this->_getParam('arrRecord')));
            if ($result) {
                return $this->_helper->json->sendSuccess(array('data'=>$result));
            }
            return $this->_helper->json->sendFailure(array('data'=>$result));
        } elseif($this->_hasParam('insertRecordDetail')){
			$sale = Quick::single('accountant/sales_invoice')->cache()
			->getSaleInvoiceById(Zend_Json_Decoder::decode($this->_getParam('saleId')));
			
			$batchId = Zend_Json_Decoder::decode($this->_getParam('batchId'));
			
			$result = Quick_Accountant_Remoter_SaleBilling::insertRecordOfDetailSale(
			$sale['sales_invoice_id'], $sale['by_export'], $sale['for_service'], 
			$sale['currency_id'], $sale['forex_rate'], $batchId,
			Zend_Json_Decoder::decode($this->_getParam('record')));
			
			if($result){
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
			return $this->_helper->json->sendFailure(array('data' => $result));
		} elseif ($this->_hasParam('export')) {
            Quick_Accountant_Remoter_Report_SalesInvoice::executeExport($this->_getParam('export'), $this->_getParam('type'));
        } elseif ($this->_hasParam('getListAccount')) {
            $result = Quick_Accountant_Remoter_BuyBilling::getListAccount();
            if ($result) {
                return $this->_helper->json->sendSuccess(array('data'=>$result));
            }
            return $this->_helper->json->sendFailure(array('data'=>$result));
        } else {
            //$listService = Quick_Accountant_Remoter_BuyBilling::getListService();
	        $listTaxRate = Quick_Accountant_Remoter_BuyBilling::getTaxRateByArrayTaxId(array(1, 2, 3));
	        $listSpecificity = Quick_Accountant_Remoter_BuyBilling::getListSpecificity();
	        $listUnit = Quick_Core_Remoter_ProductCatalog::getListUnit();
	        $listSupplier = Quick_Core_Remoter_ProductCatalog::getSubjectByType('is_supplier');
	        $listCurrency = Quick_Accountant_Remoter_BuyBilling::getAllCurrency();
	        $listWarehouse = Quick_Accountant_Remoter_StockManage::getListWarehouse();
	        $this->view->listWarehouse = $listWarehouse;
	        //$this->view->listService = $listService;
	        $this->view->listTaxRate = $listTaxRate;
	        $this->view->listSpecificity = $listSpecificity;
	        $this->view->listUnit = $listUnit;
	        $this->view->listSupplier = $listSupplier;
	        $this->view->listCurrency = $listCurrency;
        }

		$this->render();
	}
}
