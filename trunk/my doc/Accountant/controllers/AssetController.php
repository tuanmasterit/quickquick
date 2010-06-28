<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Controller
 * @author      trungpm
 */
class Quick_Accountant_AssetController extends Quick_Core_Controller_Back
{
	public function init()
	{
		parent::init();
	}

	/**
	 * @desc	Buy Billing Action
	 * @author	datnh
	 */
	public function amortizePropertyAction()
	{
		$this->view->decimalSeparator = Quick_Number::getDecimalSeparator();
		$this->view->thousandSeparator = Quick_Number::getThousandSeparator();
		$currentPeriod = Quick::single('core/definition_period')->cache()->getPeriodCurrent();
		$this->view->convertedCurrencyId = 0;
		if(!empty($currentPeriod)){
			$this->view->convertedCurrencyId =  $currentPeriod['currency_id'];
			$this->view->currentPeriodId =  $currentPeriod['period_id'];
		}
				
		// actions in here
		if($this->_hasParam('getListAssetVoucher')){
			$data = $this->getData();	
			$total = 0;
			$result = Quick_Accountant_Remoter_AmortizeProperty::getListAssetVoucher($data, &$total);
			return $this->_helper->json->sendSuccess(array(
	            'data' => $result,
				'count' => $total
			));
		}elseif($this->_hasParam('getListSubjectWithForexRate')){
			$result = Quick_Accountant_Remoter_BuyBilling::getSupplierWithForexRate(null, $this->_getParam('convertCurrency'));
			return $this->_helper->json->sendSuccess(array(
	            'data' => $result
			));
		}elseif($this->_hasParam('getListCurrencyWithForexRate')){
			$result = Quick_Accountant_Remoter_BuyBilling::getCurrencyWithForexRate(null, $this->_getParam('convertCurrency'));
			return $this->_helper->json->sendSuccess(array(
	            'data' => $result
			));
		}elseif($this->_hasParam('saveAsset')){
			$data = $this->getData();
			$data['currentPeriodId'] = $this->view->currentPeriodId;
			$result = null;
			if(isset($data['assets_voucher_id']) && $data['assets_voucher_id'] > 0){
				$result = Quick_Accountant_Remoter_AmortizeProperty::updateAssetVoucher($data);						
			}else{
				$result = Quick_Accountant_Remoter_AmortizeProperty::insertAssetVoucher($data);						
			}
			if($result){
				return $this->_helper->json->sendSuccess(array(
		            'data' => $result
				));
			}
			return $this->_helper->json->sendFailure();
		}elseif($this->_hasParam('getAssetsDepreciationById')) {
			$data = $this->getData();	
			$total = 0;
			$result = Quick_Accountant_Remoter_AmortizeProperty::getAssetsDepreciationById($data, &$total);
			return $this->_helper->json->sendSuccess(array(
	            'data' => $result,
				'count' => $total
			));
		}elseif($this->_hasParam('updateAssetVoucher')) {
			$data = $this->getData();			
			$result = Quick_Accountant_Remoter_AmortizeProperty::updateFieldOfAssetVoucher($data);			
			if($result){
				return $this->_helper->json->sendSuccess(array(
		            'data' => $result
				));
			}			
			return $this->_helper->json->sendFailure();
		}elseif($this->_hasParam('saveAssetsDepreciation')) {
			$data = $this->getData();
			$result = null;
			if(isset($data['is_insert'])){
				if($data['is_insert'] == 0){
					$result = Quick_Accountant_Remoter_AmortizeProperty::updateAssetsDepreciation($data);						
				}else{
					$result = Quick_Accountant_Remoter_AmortizeProperty::insertAssetsDepreciation($data);	
				}
			}
			//errs=1: record existed
			if(isset($result['errs'])){
				return $this->_helper->json->sendFailure(array('data' => $result));
			}else{
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}	

		}elseif($this->_hasParam('getEntryDebitOfAssetVoucher')) {
			$data = $this->getData();	
			$total = 0;
			$result = Quick_Accountant_Remoter_AmortizeProperty::getEntryDebitOfAssetVoucher($data, &$total);
			return $this->_helper->json->sendSuccess(array(
	            'data' => $result,
				'count' => $total
			));
		}elseif($this->_hasParam('getEntryDebitOfDepreciation')){
			$result = Quick_Accountant_Remoter_AmortizeProperty::getEntryDebitOfDepreciation(Zend_Json_Decoder::decode($this->_getParam('assets_voucher_id')));
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
		}elseif($this->_hasParam('saveForCorrespondence')){
			$data = $this->getData();
			if(isset($data['correspondence_id'])){
				if($data['correspondence_id'] == 0){
					$result = Quick_Accountant_Remoter_AmortizeProperty::insertCorrespondenceForAssetVoucher($data);						
				}else{
					$result = Quick_Accountant_Remoter_AmortizeProperty::updateCorrespondenceForAssetVoucher($data);	
				}
			}
			if($result){
				return $this->_helper->json->sendSuccess(array(
		            'data' => $result
				));
			}
			return $this->_helper->json->sendFailure();			
		}elseif($this->_hasParam('saveForTransactionEntry')){
			$data = $this->getData();
			$result = Quick_Accountant_Remoter_AmortizeProperty::updateTransactionEntryForAssetVoucher($data);
			if($result){
				return $this->_helper->json->sendSuccess(array(
		            'data' => $result
				));
			}
			return $this->_helper->json->sendFailure();			
		}elseif($this->_hasParam('deleteTransactionEntry')){
			$result = Quick_Accountant_Remoter_AmortizeProperty::deleteTransactionEntry(
			Zend_Json_Decoder::decode($this->_getParam('arrEntryId')),
			Zend_Json_Decoder::decode($this->_getParam('arrCorrespondenceId')));
			if($result){
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
			return $this->_helper->json->sendFailure(array('data' => $result));
		}elseif($this->_hasParam('deleteDepreciation')) {
			$result = Quick_Accountant_Remoter_AmortizeProperty::deleteDepreciation(			
				Zend_Json_Decoder::decode($this->_getParam('arrRecordDepreciation')));
			if($result){
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
			return $this->_helper->json->sendFailure(array('data' => $result));
		}elseif($this->_hasParam('deleteAssetVoucher')) {
			$result = Quick_Accountant_Remoter_AmortizeProperty::deleteAssetVoucher(			
				Zend_Json_Decoder::decode($this->_getParam('arrRecordAssetVoucher')));
			if($result){
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
			return $this->_helper->json->sendFailure(array('data' => $result));
		}
		
		$this->render();
	}
	
	/**
	 * Get all data and decode from request
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
