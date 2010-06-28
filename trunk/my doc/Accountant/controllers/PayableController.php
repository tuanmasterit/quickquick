<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Controller
 * @author      trungpm
 */
class Quick_Accountant_PayableController extends Quick_Core_Controller_Back
{
	public function init()
	{
		parent::init();
	}

	/**
	 * @desc	Payment Manage Action
	 * @author	trungpm
	 */
	public function paymentManageAction()
	{
		$this->view->decimalSeparator = Quick_Number::getDecimalSeparator();
		$this->view->thousandSeparator = Quick_Number::getThousandSeparator();
		$currentPeriod = Quick::single('core/definition_period')->cache()->getPeriodCurrent();
		$this->view->convertedCurrencyId = 0;
		if(!empty($currentPeriod)){
			$this->view->convertedCurrencyId =  $currentPeriod['currency_id'];
			$this->view->currentPeriodId =  $currentPeriod['period_id'];
		}
		
		// action in here
		if($this->_hasParam('getListPayableVoucher')){
			$data = $this->getData();	
			$total = 0;
			$result = Quick_Accountant_Remoter_PaymentManage::getListPayableVoucher($data, &$total);
			return $this->_helper->json->sendSuccess(array(
	            'data' => $result,
				'count' => $total
			));
		}elseif($this->_hasParam('getListPayableType')){
			$result = Quick_Accountant_Remoter_PaymentManage::getListPayableType();
			return $this->_helper->json->sendSuccess(array(
	            'data' => $result
			));
		}elseif($this->_hasParam('getListTaxType')){
			$result = Quick_Accountant_Remoter_PaymentManage::getListTaxType();
			return $this->_helper->json->sendSuccess(array(
	            'data' => $result
			));
		}elseif($this->_hasParam('getListCurrencyWithForexRate')) {
			$result = Quick_Accountant_Remoter_BuyBilling::getCurrencyWithForexRate(null, $this->_getParam('convertCurrency'));
			return $this->_helper->json->sendSuccess(array(
	            'data' => $result
			));
		}elseif($this->_hasParam('getSubjectList')){
			$result = Quick_Accountant_Remoter_PaymentManage::getIncListSubject();
			return $this->_helper->json->sendSuccess(array(
	            'data' => $result
			));
		}elseif($this->_hasParam('getStaffList')){
			$result = Quick_Accountant_Remoter_PaymentManage::getStaffList();
			return $this->_helper->json->sendSuccess(array(
	            'data' => $result
			));
		}elseif($this->_hasParam('savePayableVoucher')) {
			$data = $this->getData();
			$data['currentPeriodId'] = $this->view->currentPeriodId;
			$result = null;
			if(isset($data['payable_voucher_id']) && $data['payable_voucher_id'] > 0){
				$result = Quick_Accountant_Remoter_PaymentManage::updatePayableVoucher($data);						
			}else{
				$result = Quick_Accountant_Remoter_PaymentManage::insertPayableVoucher($data);						
			}
			if($result){
				return $this->_helper->json->sendSuccess(array(
		            'data' => $result
				));
			}
			return $this->_helper->json->sendFailure();
		}elseif($this->_hasParam('updateFieldOfPayableVoucher')) {
			$data = $this->getData();
			if(!isset($data['payable_voucher_id'])) return $this->_helper->json->sendFailure();
			
			$data['currentPeriodId'] = $this->view->currentPeriodId;
			$result = Quick_Accountant_Remoter_PaymentManage::updateFieldOfPayableVoucher($data);			
			if($result){
				return $this->_helper->json->sendSuccess(array(
		            'data' => $result
				));
			}
			return $this->_helper->json->sendFailure();
		}
		
		$this->render();
	}
	
	/**
	 * Get all data from request and decode
	 * @author datnh
	 */
	private function getData() {
		$params = $this->_getAllParams();
		$data = array();		
		while (list($key, $value) = each($params)) {
		    if($key != 'controller' && $key != 'action' && $key != 'module') {
		    	$data[$key] = Zend_Json_Decoder::decode($value);
		    }
		}
		return $data;
	}
}
