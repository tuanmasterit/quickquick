<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Controller
 * @author      trungpm
 */
class Quick_Accountant_MaintenanceController extends Quick_Core_Controller_Back
{
	public function init()
	{
		parent::init();
	}

	/**
	 * @desc	Accounting System Action
	 * @author	trungpm
	 */
	public function accountSystemAction()
	{
		if ($this->_hasParam('getLoadTreeData')){
			$accounts = Quick_Accountant_Remoter_AccountSystem::getAccountOfNode(
			Zend_Json_Decoder::decode($this->_getParam('node')));
			return $this->_helper->json->sendJson($accounts, false, false);
		}elseif($this->_hasParam('getDetailOfNode')){
			$detail = Quick_Accountant_Remoter_AccountSystem::getDetailOfNode(
			Zend_Json_Decoder::decode($this->_getParam('nodeId')));
			return $this->_helper->json->sendSuccess(array(
            'data' => $detail
			));
		}elseif($this->_hasParam('getDetailFor')){
			$tables = Quick_Accountant_Remoter_AccountSystem::getListTables();
			return $this->_helper->json->sendSuccess(array(
            'data' => $tables
			));
		}elseif($this->_hasParam('getLoadDetail')){
			$total = 0;
			$detail = Quick_Accountant_Remoter_AccountSystem::getDetailAccountByTable(
			Zend_Json_Decoder::decode($this->_getParam('selectedDetailFor')),
			Zend_Json_Decoder::decode($this->_getParam('selectedNode')),
			Zend_Json_Decoder::decode($this->_getParam('limit')),
			Zend_Json_Decoder::decode($this->_getParam('start')),
			&$total);
			return $this->_helper->json->sendSuccess(array(
            'data' => $detail,
			'count' => $total
			));
		}elseif($this->_hasParam('updateDetailFor')){

			$result = Quick_Accountant_Remoter_AccountSystem::updateDetailAccount(
			Zend_Json_Decoder::decode($this->_getParam('accountId')),
			Zend_Json_Decoder::decode($this->_getParam('tableId')),
			Zend_Json_Decoder::decode($this->_getParam('detailId')),
			Zend_Json_Decoder::decode($this->_getParam('value')));
			if($result){
				return $this->_helper->json->sendSuccess();
			}
			return $this->_helper->json->sendFailure();
		}elseif($this->_hasParam('updateAccount')){
			$result = Quick_Accountant_Remoter_AccountSystem::updateFieldOfAccount(
			Zend_Json_Decoder::decode($this->_getParam('accountId')),
			Zend_Json_Decoder::decode($this->_getParam('field')),
			Zend_Json_Decoder::decode($this->_getParam('value')));
			if($result){
				return $this->_helper->json->sendSuccess();
			}
			return $this->_helper->json->sendFailure();
		}elseif($this->_hasParam('insertAccount')){
			$result = Quick_Accountant_Remoter_AccountSystem::insertAccount(
			'[Empty]', 'New Accounting Account', '', 
			Zend_Json_Decoder::decode($this->_getParam('parentId')));
			if(!empty($result)){
				$result['icon'] = $this->view->skinUrl('/images/icons/Paper.ico');
				return $this->_helper->json->sendSuccess(array(
            		'data' => $result
				));
			}
			return $this->_helper->json->sendFailure();
		}elseif($this->_hasParam('updateAccountNode')){
			$result = Quick_Accountant_Remoter_AccountSystem::updateAccountNode(
			Zend_Json_Decoder::decode($this->_getParam('sourceId')),
			Zend_Json_Decoder::decode($this->_getParam('targetId')));
			if($result){
				return $this->_helper->json->sendSuccess();
			}
			return $this->_helper->json->sendFailure();
		}elseif($this->_hasParam('deleteNode')){
			$result = Quick_Accountant_Remoter_AccountSystem::deleteNode($this->_getParam('deleteNode'));
			if($result){
				return $this->_helper->json->sendSuccess();
			}
			return $this->_helper->json->sendFailure();
		}
		$this->render();
	}

	/**
	 * @desc	Currency Catalog Action
	 * @author	bichttn
	 */
	public function currencyCatalogAction()
	{
		if ($this->_hasParam('getListCurrency')) {
			$total = 0;
			$curency = Quick_Accountant_Remoter_CurrencyCatalog::getListCurrency(
			Zend_Json_Decoder::decode($this->_getParam('limit')),
			Zend_Json_Decoder::decode($this->_getParam('start')),
			&$total);
			return $this->_helper->json->sendSuccess(array(
            	'data' => $curency,
				'count' => $total
			));
		} else if ($this->_hasParam('getListCurrencyCombo')) {
			$curency = Quick_Accountant_Remoter_CurrencyCatalog::getCurrencyCombo();
			$curency_new = array();
			if (Zend_Json_Decoder::decode($this->_getParam('currencyId'))) {
				if ($curency) {
					foreach($curency as $c) {
						if ($c['currency_id'] == Zend_Json_Decoder::decode($this->_getParam('currencyId'))) continue;
						$curency_new[] = $c;
					}
				}
			} else {
				$curency_new = $curency;
			}
			return $this->_helper->json->sendSuccess(array(
            		'data' => $curency_new
			));
		} elseif ($this->_hasParam('updateListCurrency')) {
			$result = Quick_Accountant_Remoter_CurrencyCatalog::updateListCurrency(
			Zend_Json_Decoder::decode($this->_getParam('currencyId')),
			Zend_Json_Decoder::decode($this->_getParam('field')),
			Zend_Json_Decoder::decode($this->_getParam('value')));
			if ($result) {
				return $this->_helper->json->sendSuccess();
			}
			return $this->_helper->json->sendFailure();
		} elseif ($this->_hasParam('insertListCurrency')) {
			$result = Quick_Accountant_Remoter_CurrencyCatalog::insertListCurrency(
			Zend_Json_Decoder::decode($this->_getParam('currency_code')),
			Zend_Json_Decoder::decode($this->_getParam('currency_name')));
			if(!empty($result)) {
				return $this->_helper->json->sendSuccess(array(
            		'data' => $result
				));
			}
			return $this->_helper->json->sendFailure();
		} elseif ($this->_hasParam('getDetailCurrency')) {
			$total = 0;
			$detailCurency = Quick_Accountant_Remoter_CurrencyCatalog::getDetailCurByBaseCurId(
			Zend_Json_Decoder::decode($this->_getParam('baseCurId')),
			Zend_Json_Decoder::decode($this->_getParam('limit')),
			Zend_Json_Decoder::decode($this->_getParam('start')),
			&$total);
			$detailCurency_new = array();
			if ($detailCurency) {
				foreach ($detailCurency as $dc) {
					//$dc['time_point'] = date('d-m-Y H:i:s', strtotime($dc['time_point']));
					$dc['forex_rate'] = number_format($dc['forex_rate'],2);
					$dc['currency_id'] = $dc['convert_currency_id'];
					$detailCurency_new[] = $dc;
				}
			}
			return $this->_helper->json->sendSuccess(array(
            	'data' => $detailCurency_new,
				'count' => $total
			));
		} elseif ($this->_hasParam('insertDetailCurrency')) {
			$detailCurency = Quick_Accountant_Remoter_CurrencyCatalog::insertDetailCurrency(
			Zend_Json_Decoder::decode($this->_getParam('base_currency_id')),
			Zend_Json_Decoder::decode($this->_getParam('convert_currency_id')),
			Zend_Json_Decoder::decode($this->_getParam('time_point')),
			Zend_Json_Decoder::decode($this->_getParam('forex_rate')));
			return $this->_helper->json->sendSuccess(array(
            	'data' => $detailCurency
			));
		} elseif ($this->_hasParam('updateDetailCurrency')) {
			$updateDetailCurency = Quick_Accountant_Remoter_CurrencyCatalog::updateDetailCurrency(
			Zend_Json_Decoder::decode($this->_getParam('base_currency_id')),
			Zend_Json_Decoder::decode($this->_getParam('convert_currency_id')),
			Zend_Json_Decoder::decode($this->_getParam('time_point')),
			Zend_Json_Decoder::decode($this->_getParam('field')),
			Zend_Json_Decoder::decode($this->_getParam('value')));

			return $this->_helper->json->sendSuccess();
		}
		// delete list currency
		elseif ($this->_hasParam('deleteCurrency')) {
			$delete = Quick_Accountant_Remoter_CurrencyCatalog::deleteCurrency(
			Zend_Json_Decoder::decode($this->_getParam('currency_id')));

			if($delete){
				return $this->_helper->json->sendSuccess(array('data' => $delete));
			}
			return $this->_helper->json->sendFailure(array('data' => $delete));
		}
		// delete detail currency
		elseif ($this->_hasParam('deleteDetailCurrency')) {
			$delete = Quick_Accountant_Remoter_CurrencyCatalog::deleteDetailCurrency(
				Zend_Json_Decoder::decode($this->_getParam('base_currency_id')),
				Zend_Json_Decoder::decode($this->_getParam('currency_id')),
				Zend_Json_Decoder::decode($this->_getParam('time')));

			if($delete){
				return $this->_helper->json->sendSuccess(array('data' => $delete));
			}
			return $this->_helper->json->sendFailure(array('data' => $delete));
		}
		
		$this->render();
	}

	/**
	 * @desc	Period Accounting Action
	 *
	 * @author	bichttn
	 */
	public function periodAccountingAction()
	{
		if ($this->_hasParam('getListPeriod')) {
			$total = 0;
			$period = Quick_Accountant_Remoter_PeriodAccounting::getListPeriod(
			Zend_Json_Decoder::decode($this->_getParam('limit')),
			Zend_Json_Decoder::decode($this->_getParam('start')),
			&$total);
			$period_new = array();
			foreach ($period as $p) {
				$p['lock'] = ($p['lock'] == 0)? "" : $p['lock'];
				$p['current'] = ($p['current'] == 0)? "": $p['current'];
				$period_new[] = $p;
			}

			return $this->_helper->json->sendSuccess(array(
            	'data' => $period_new,
				'count' => $total
			));
		} else if ($this->_hasParam('getListSubject')) {
			$subject = Quick_Accountant_Remoter_PeriodAccounting::getListSubject();
			$period = Quick_Accountant_Remoter_PeriodAccounting::getListPeriodCombo();
			$subject_new = array();
			if ($period) {
				foreach ($subject as $s) {
					$check = false;
					foreach ($period as $p) {
						if ($s['subject_id'] == $p['subject_id']) {
							$check = true;
							break;
						}
					}
					if (!$check) {
						$subject_new[] = $s;
					}
				}
			} else {
				$subject_new = $subject;
			}
			return $this->_helper->json->sendSuccess(array(
            	'data' => $subject_new
			));
		} else if ($this->_hasParam("insertPeriod")) {
			$insertPeriod = Quick_Accountant_Remoter_PeriodAccounting::insertPeriod(
			Zend_Json_Decoder::decode($this->_getParam('subject_id')),
			Zend_Json_Decoder::decode($this->_getParam('length')),
			Zend_Json_Decoder::decode($this->_getParam('month')),
			Zend_Json_Decoder::decode($this->_getParam('year')),
			Zend_Json_Decoder::decode($this->_getParam('current'))
			);
			return $this->_helper->json->sendSuccess(array());
		} else if ($this->_hasParam('updatePeriod')) {
			$updatePeriod = Quick_Accountant_Remoter_PeriodAccounting::updatePeriodById(
			Zend_Json_Decoder::decode($this->_getParam('period_id')),
			Zend_Json_Decoder::decode($this->_getParam('length')),
			Zend_Json_Decoder::decode($this->_getParam('current'))
			);
			return $this->_helper->json->sendSuccess(array());
		}
		
		// delete period
		elseif ($this->_hasParam('deletePeriod')) {
			$delete = Quick_Accountant_Remoter_PeriodAccounting::deletePeriod(
				Zend_Json_Decoder::decode($this->_getParam('period_id')));

			if($delete){
				return $this->_helper->json->sendSuccess(array('data' => $delete));
			}
			return $this->_helper->json->sendFailure(array('data' => $delete));
		}

		$this->render();
	}

	/**
	 * @desc	Revenue Catalog Action
	 * @author	bichttn
	 */
	public function revenueCatalogAction()
	{
		if ($this->_hasParam('getListTurnover')) {
			$total = 0;
			$result = Quick_Accountant_Remoter_RevenueCatalog::getListTurnover(
			Zend_Json_Decoder::decode($this->_getParam('limit')),
			Zend_Json_Decoder::decode($this->_getParam('start')),
			&$total);
			return $this->_helper->json->sendSuccess(array(
            	'data' => $result,
				'count' => $total
			));
		} else if ($this->_hasParam('insertTurnover')) {
			$result = Quick_Accountant_Remoter_RevenueCatalog::insertListTurnover(Zend_Json_Decoder::decode($this->_getParam('turnover_name')));
			return $this->_helper->json->sendSuccess(array(
            	'data' => $result
			));
		} else if ($this->_hasParam('updateTurnover')) {
			$result = Quick_Accountant_Remoter_RevenueCatalog::updateListTurnove(
			Zend_Json_Decoder::decode($this->_getParam('turnover_id')),
			Zend_Json_Decoder::decode($this->_getParam('field')),
			Zend_Json_Decoder::decode($this->_getParam('value'))
			);
			return $this->_helper->json->sendSuccess(array(
            	'data' => $result
			));
		}
		// delete cash voucher 
		elseif($this->_hasParam('deleteTurnover')){
			$result = Quick_Accountant_Remoter_RevenueCatalog::deleteTurnover(
				Zend_Json_Decoder::decode($this->_getParam('turnoverId')));
			if($result){
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
			return $this->_helper->json->sendFailure(array('data' => $result));
		}

		$this->render();
	}

	/**
	 * @desc	Expenditure Catalog Action
	 * @author	bichttn
	 */
	public function expenditureCatalogAction()
	{
		if ($this->_hasParam('getListExpense')) {
			$total = 0;
			$result = Quick_Accountant_Remoter_ExpenditureCatalog::getListExpense(
			Zend_Json_Decoder::decode($this->_getParam('limit')),
			Zend_Json_Decoder::decode($this->_getParam('start')),
			&$total);
			return $this->_helper->json->sendSuccess(array(
            	'data' => $result,
				'count' => $total
			));
		} else if ($this->_hasParam('countListExpense')) {
			$result = Quick_Accountant_Remoter_ExpenditureCatalog::countListExpense();
			return $this->_helper->json->sendSuccess(array(
            	'data' => $result
			));
		} else if ($this->_hasParam('insertExpense')) {
			$result = Quick_Accountant_Remoter_ExpenditureCatalog::insertListExpense(Zend_Json_Decoder::decode($this->_getParam('expense_name')));
			return $this->_helper->json->sendSuccess(array(
            	'data' => $result
			));
		} else if ($this->_hasParam('updateExpense')) {
			$result = Quick_Accountant_Remoter_ExpenditureCatalog::updateListExpense(
			Zend_Json_Decoder::decode($this->_getParam('expense_id')),
			Zend_Json_Decoder::decode($this->_getParam('field')),
			Zend_Json_Decoder::decode($this->_getParam('value'))
			);
			return $this->_helper->json->sendSuccess(array(
            	'data' => $result
			));
		}
		// delete cash voucher 
		elseif($this->_hasParam('deleteExpense')){
			$result = Quick_Accountant_Remoter_ExpenditureCatalog::deleteExpense(
				Zend_Json_Decoder::decode($this->_getParam('expenseId')));
			if($result){
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
			return $this->_helper->json->sendFailure(array('data' => $result));
		}
		
		
		$this->render();
	}

	/**
	 * @desc	Tax Catalog Action
	 * @author	datnh
	 */
	public function taxCatalogAction()
	{
		if($this->_hasParam("getListTax")) {
			$result = Quick_Accountant_Remoter_TaxCatalog::getListTax();

			return $this->_helper->json->sendSuccess(array('data' => $result));
		} elseif ($this->_hasParam("getListTaxRate")) {
			$total = 0;
			$limit = (null == $this->_getParam('limit'))? _getParam('limit') : Zend_Json_Decoder::decode($this->_getParam('limit'));
			$start = (null == $this->_getParam('start'))? _getParam('start') : Zend_Json_Decoder::decode($this->_getParam('start'));
			$tax_id = Zend_Json_Decoder::decode($this->_getParam('tax_id_search'));
			$result = Quick_Accountant_Remoter_TaxCatalog::getListTaxRate($tax_id, $limit, $start, &$total);

			return $this->_helper->json->sendSuccess(array('data' => $result, 'count' => $total));
		} elseif ($this->_hasParam("saveTaxRate")) {
			$tax_rate_id = Zend_Json_Decoder::decode($this->_getParam('tax_rate_id'));
			$tax_id = Zend_Json_Decoder::decode($this->_getParam('tax_id'));
			$rate = Zend_Json_Decoder::decode($this->_getParam('rate'));
			$field = Zend_Json_Decoder::decode($this->_getParam('field'));
			$value = Zend_Json_Decoder::decode($this->_getParam('value'));

			$result = null;
			if($tax_rate_id != -1) {
				//Update
				$result = Quick_Accountant_Remoter_TaxCatalog::updateTaxRate($tax_rate_id, $field, $value, $tax_id, $rate);
			}else{
				//Insert
				$result = Quick_Accountant_Remoter_TaxCatalog::insertTaxRate($value, $tax_id);											
			}
			if(isset($result['errs'])){
				return $this->_helper->json->sendFailure(array('data' => $result));
			}else{
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
		}elseif ($this->_hasParam("getListSpecification")) {
			$total = 0;
			$limit = Zend_Json_Decoder::decode($this->_getParam('limit'));
			$start = Zend_Json_Decoder::decode($this->_getParam('start'));
			$result = Quick_Accountant_Remoter_TaxCatalog::getListSpecification($limit, $start, &$total);

			return $this->_helper->json->sendSuccess(array('data' => $result, 'count' => $total));
		}elseif ($this->_hasParam("saveSpecification")) {
			$specification_id = Zend_Json_Decoder::decode($this->_getParam('specification_id'));
			$field = Zend_Json_Decoder::decode($this->_getParam('field'));
			$value = Zend_Json_Decoder::decode($this->_getParam('value'));
			if($specification_id != -1) {
				//Update
				$result = Quick_Accountant_Remoter_TaxCatalog::updateSpecification($specification_id, $field, $value);
				if($result)	return $this->_helper->json->sendSuccess();
			}else{
				//Insert
				$result = Quick_Accountant_Remoter_TaxCatalog::insertSpecification($value);
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}

			return $this->_helper->json->sendFailure();
		}elseif($this->_hasParam("getListTaxRateProduct") && $this->_hasParam("tax_id")){
			$tax_id = Zend_Json_Decoder::decode($this->_getParam('tax_id'));
			$result = Quick_Accountant_Remoter_TaxCatalog::getListTaxRateByTaxId($tax_id);

			return $this->_helper->json->sendSuccess(array('data' => $result));
		}elseif ($this->_hasParam("getListSpecForProduct")) {
			$result = Quick_Accountant_Remoter_TaxCatalog::getListSpecForProduct();

			return $this->_helper->json->sendSuccess(array('data' => $result));
		}elseif ($this->_hasParam("getListProduct")) {
			$data = array();
			$total = 0;
			if(!$this->_hasParam('tax_id') || !$this->_hasParam('tax_rate_id') || !$this->_hasParam('specification_id')) {
				return $this->_helper->json->sendSuccess(array('data' => $data, 'count' => $total));
			}
			$data = $this->getDataDecode();
				
			$result = Quick_Accountant_Remoter_TaxCatalog::getListProduct($data, &$total);
			return $this->_helper->json->sendSuccess(array('data' => $result, 'count' => $total));
		}elseif ($this->_hasParam("executeRelationTax")) {
			$data = $this->getDataDecode();
			if(isset($data['check_value']) && $data['check_value']==0) {
				//Delete
				$result = Quick_Accountant_Remoter_TaxCatalog::deleteRelationTax($data);

				return $this->_helper->json->sendSuccess(array('data' => $result));
			}else{
				//Insert
				$result = Quick_Accountant_Remoter_TaxCatalog::insertRelationTax($data);
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
		}elseif($this->_hasParam("executeAllRelationTax")) {
			$data = $this->getDataDecode();
			if($this->_hasParam('checkedAll') && $this->_getParam('checkedAll') == 1) {
				//Insert
				$result = Quick_Accountant_Remoter_TaxCatalog::insertRelationTaxByArr(Zend_Json_Decoder::decode($this->_getParam('arrRelationTax')));
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}elseif($this->_hasParam('deCheckedAll') && $this->_getParam('deCheckedAll') == 1) {
				//Delete
				$result = Quick_Accountant_Remoter_TaxCatalog::deleteRelationTaxByArr(Zend_Json_Decoder::decode($this->_getParam('arrRelationTax')));
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
		}elseif($this->_hasParam("deleteTaxRates")) {
			$result = Quick_Accountant_Remoter_TaxCatalog::deleteTaxRateByArr(Zend_Json_Decoder::decode($this->_getParam('arrTaxRateId')));
			if($result){
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
			return $this->_helper->json->sendFailure(array('data' => $result));
		}elseif($this->_hasParam("deleteSpecifications")) {
			$result = Quick_Accountant_Remoter_TaxCatalog::deleteSpecificationByArr(Zend_Json_Decoder::decode($this->_getParam('arrSpecificationId')));
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
	private function getDataDecode() {
		$params = $this->_getAllParams();
		$data = array();		
		while (list($key, $value) = each($params)) {
		    if($key != 'controller' && $key != 'action' && $key != 'module') {
		    	$data[$key] = Zend_Json_Decoder::decode($value);
		    }
		}
		return $data;
	}

	/**
	 * @desc	Tax Catalog Action
	 * @author	datnh
	 */
	public function toAccountingAction()
	{
		if($this->_hasParam('getListEntryType')){
			$result = Quick_Accountant_Remoter_ToAccounting::getListEntryType();
			return $this->_helper->json->sendSuccess(array(
	            'data' => $result
			));
		}elseif($this->_hasParam('getListEntryDebit')){
			$total = 0;
			$result = Quick_Accountant_Remoter_ToAccounting::getListEntryDebit(
			Zend_Json_Decoder::decode($this->_getParam('limit')),
			Zend_Json_Decoder::decode($this->_getParam('start')),
			Zend_Json_Decoder::decode($this->_getParam('type_id')),
			&$total
			);
			return $this->_helper->json->sendSuccess(array(
	            'data' => $result,
				'count' => $total
			));
		}elseif($this->_hasParam('updateFieldDebit')){
			$result = Quick_Accountant_Remoter_ToAccounting::updateFieldDebit(
			Zend_Json_Decoder::decode($this->_getParam('debitId')),
			Zend_Json_Decoder::decode($this->_getParam('accountId')),
			Zend_Json_Decoder::decode($this->_getParam('typeId')),
			Zend_Json_Decoder::decode($this->_getParam('debitField')),
			Zend_Json_Decoder::decode($this->_getParam('debitValue')));
			if($result){
				return $this->_helper->json->sendSuccess(array(
		            'recordId' => $result
				));
			}
			return $this->_helper->json->sendFailure();
		}elseif($this->_hasParam('getListEntryCredit')){
			$total = 0;
			$result = Quick_Accountant_Remoter_ToAccounting::getListEntryCredit(
			Zend_Json_Decoder::decode($this->_getParam('limit')),
			Zend_Json_Decoder::decode($this->_getParam('start')),
			Zend_Json_Decoder::decode($this->_getParam('type_id')),
			&$total
			);

			return $this->_helper->json->sendSuccess(array(
	            'data' => $result,
				'count' => $total
			));
		}elseif($this->_hasParam('updateFieldCredit')){
			$result = Quick_Accountant_Remoter_ToAccounting::updateFieldCredit(
			Zend_Json_Decoder::decode($this->_getParam('creditId')),
			Zend_Json_Decoder::decode($this->_getParam('accountId')),
			Zend_Json_Decoder::decode($this->_getParam('typeId')),
			Zend_Json_Decoder::decode($this->_getParam('creditField')),
			Zend_Json_Decoder::decode($this->_getParam('creditValue')));
			if($result){
				return $this->_helper->json->sendSuccess(array(
		            'recordId' => $result
				));
			}
			return $this->_helper->json->sendFailure();
		}elseif($this->_hasParam('getListAccount')){
			$result = Quick_Accountant_Remoter_ToAccounting::getListAccount();
			if($result){
				return $this->_helper->json->sendSuccess(array(
		            'data' => $result
				));
			}
		}elseif($this->_hasParam('updateDebitCredit')){
			$result = Quick_Accountant_Remoter_ToAccounting::updateDebitCredit(
			Zend_Json_Decoder::decode($this->_getParam('typeId')),
			Zend_Json_Decoder::decode($this->_getParam('arrDebit')),
			Zend_Json_Decoder::decode($this->_getParam('arrCredit')));
			if($result){
				return $this->_helper->json->sendSuccess(array(
		            'recordId' => $result
				));
			}
			return $this->_helper->json->sendFailure();
		}elseif($this->_hasParam('deleteCredit')){
			$result = Quick_Accountant_Remoter_ToAccounting::deleteCredit(
				Zend_Json_Decoder::decode($this->_getParam('records')));
			return $this->_helper->json->sendSuccess(array(
            	'data' => $result
			));
		}elseif($this->_hasParam('deleteDebit')){
			$result = Quick_Accountant_Remoter_ToAccounting::deleteDebit(
				Zend_Json_Decoder::decode($this->_getParam('records')));
			return $this->_helper->json->sendSuccess(array(
            	'data' => $result
			));
		}

		$this->render();
	}

	/**
	 * @desc	Expenditure Pay Action
	 * @author	datnh
	 */
	public function expenditurePayAction()
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

		if($this->_hasParam('getListPrepaidExpense')){
			$total = 0;
			$result = Quick_Accountant_Remoter_ExpenditurePay::getListPrepaidExpense(
			$this->_getParam('limit'), $this->_getParam('start'), $this->_getParam('expenseCode'),
			$this->_getParam('fromDate'), $this->_getParam('toDate'), &$total);
			return $this->_helper->json->sendSuccess(array(
	            'data' => $result,
				'count' => $total
			));
		}elseif($this->_hasParam('getExpense')){
			$result = Quick_Accountant_Remoter_ExpenditurePay::getExpense();
			return $this->_helper->json->sendSuccess(array(
	            'data' => $result
			));
		}elseif($this->_hasParam('getAssets')){
			$result = Quick_Accountant_Remoter_ExpenditurePay::getAssets();
			return $this->_helper->json->sendSuccess(array(
	            'data' => $result
			));
		}elseif($this->_hasParam('getTool')){
			$result = Quick_Accountant_Remoter_ExpenditurePay::getTool();
			return $this->_helper->json->sendSuccess(array(
	            'data' => $result
			));
		}elseif($this->_hasParam('getListSubjectWithForexRate')){
			$result = Quick_Accountant_Remoter_BuyBilling::getSupplierWithForexRate(null, $this->_getParam('convertCurrency'));
			return $this->_helper->json->sendSuccess(array(
	            'data' => $result
			));
		}elseif($this->_hasParam('updateExpense')){
			$result = Quick_Accountant_Remoter_ExpenditurePay::updateExpense(
			$this->_getParam('updateExpense'),
			Zend_Json_Decoder::decode($this->_getParam('field')),
			Zend_Json_Decoder::decode($this->_getParam('value')),
			Zend_Json_Decoder::decode($this->_getParam('convertCurrency')));
			if($result){
				return $this->_helper->json->sendSuccess(array(
		            'data' => $result
				));
			}
			return $this->_helper->json->sendFailure();
		}elseif($this->_hasParam('insertPrepaidExpense')){
			$result = Quick_Accountant_Remoter_ExpenditurePay::insertPrepaidExpense(
			Zend_Json_Decoder::decode($this->_getParam('expenseCode')),
			Zend_Json_Decoder::decode($this->_getParam('expenseName')),
			Zend_Json_Decoder::decode($this->_getParam('expenseDate')),
			Zend_Json_Decoder::decode($this->_getParam('supplierId')),
			Zend_Json_Decoder::decode($this->_getParam('expenseId')),
			Zend_Json_Decoder::decode($this->_getParam('assetsId')),
			Zend_Json_Decoder::decode($this->_getParam('toolId')),
			Zend_Json_Decoder::decode($this->_getParam('allocationPeriods')),
			Zend_Json_Decoder::decode($this->_getParam('currencyId')),
			Zend_Json_Decoder::decode($this->_getParam('forexRate')),
			$this->view->currentPeriodId);
			if($result){
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
			return $this->_helper->json->sendFailure();
		}elseif($this->_hasParam('getListCurrencyWithForexRate')){
			$result = Quick_Accountant_Remoter_BuyBilling::getCurrencyWithForexRate(null, $this->_getParam('convertCurrency'));
			return $this->_helper->json->sendSuccess(array('data' => $result));
		}elseif($this->_hasParam('getDetailPrepaidExpensesById')){
			$result = Quick_Accountant_Remoter_ExpenditurePay::getDetailPrepaidAllocationById($this->_getParam('prepaidExpenseId'));
			return $this->_helper->json->sendSuccess(array('data' => $result));
		}elseif($this->_hasParam('updatePrepaidAllocation')){
			$result = Quick_Accountant_Remoter_ExpenditurePay::updatePrepaidAllocation(
				Zend_Json_Decoder::decode($this->_getParam('updateId')),
				Zend_Json_Decoder::decode($this->_getParam('field')),
				Zend_Json_Decoder::decode($this->_getParam('value')));
			return $this->_helper->json->sendSuccess(array('data' => $result));
		}elseif($this->_hasParam('insertPrepaidAllocation')){
			$result = Quick_Accountant_Remoter_ExpenditurePay::insertPrepaidAllocation(
				Zend_Json_Decoder::decode($this->_getParam('prepaidExpenseId')),
				Zend_Json_Decoder::decode($this->_getParam('currencyId')),
				Zend_Json_Decoder::decode($this->_getParam('forexRate')),
				Zend_Json_Decoder::decode($this->_getParam('field')),
				Zend_Json_Decoder::decode($this->_getParam('value')),
				Zend_Json_Decoder::decode($this->_getParam('prepaidExpenseName')),
				$this->view->currentPeriodId);
			return $this->_helper->json->sendSuccess(array('data' => $result));
		}elseif($this->_hasParam('deletePrepaidExpense')){
			$result = Quick_Accountant_Remoter_ExpenditurePay::deletePrepaidExpense(
			Zend_Json_Decoder::decode($this->_getParam('arrRecord')));
			if($result){
				return $this->_helper->json->sendSuccess(array('data' => $result));
			}
			return $this->_helper->json->sendFailure(array('data' => $result));
		}

		$this->render();
	}

	/**
	 * @desc	Payable Catalog Action
	 * @author	trungpm
	 */
	public function payableCatalogAction()
	{
		if ($this->_hasParam('getListPayable')) {
			$total = 0;
			$result = Quick_Accountant_Remoter_PayableCatalog::getPayableType(
			Zend_Json_Decoder::decode($this->_getParam('limit')),
			Zend_Json_Decoder::decode($this->_getParam('start')),
			&$total);
			return $this->_helper->json->sendSuccess(array(
            	'data' => $result,
				'count' => $total
			));
		} else if ($this->_hasParam('updatePayableType')) {
			$result = Quick_Accountant_Remoter_PayableCatalog::updatePayableType(
			Zend_Json_Decoder::decode($this->_getParam('payable_type_id')),
			Zend_Json_Decoder::decode($this->_getParam('field')),
			Zend_Json_Decoder::decode($this->_getParam('value'))
			);
			return $this->_helper->json->sendSuccess(array(
            	'data' => $result
			));
		} else if ($this->_hasParam('insertPayableType')) {
			$result = Quick_Accountant_Remoter_PayableCatalog::insertPayableType(Zend_Json_Decoder::decode($this->_getParam('payable_type_name')));
			return $this->_helper->json->sendSuccess(array(
            	'data' => $result
			));
		} else if ($this->_hasParam('deletePayableTypes')) {
			$result = Quick_Accountant_Remoter_PayableCatalog::deletePayableTypes(Zend_Json_Decoder::decode($this->_getParam('records')));
			return $this->_helper->json->sendSuccess(array(
            	'data' => $result
			));
		}
		$this->render();
	}
	
	/**
	 * @desc	Receivable Catalog Action
	 * @author	khoatx
	 */
	public function receivableCatalogAction()
	{
		if ($this->_hasParam('getListReceivable')) {
			$total = 0;
			$result = Quick_Accountant_Remoter_ReceivableCatalog::getReceivableType(
			Zend_Json_Decoder::decode($this->_getParam('limit')),
			Zend_Json_Decoder::decode($this->_getParam('start')),
			&$total);
			return $this->_helper->json->sendSuccess(array(
            	'data' => $result,
				'count' => $total
			));
		} else if ($this->_hasParam('updateReceivableType')) {
			$result = Quick_Accountant_Remoter_ReceivableCatalog::updateReceivableType(
			Zend_Json_Decoder::decode($this->_getParam('receivable_type_id')),
			Zend_Json_Decoder::decode($this->_getParam('field')),
			Zend_Json_Decoder::decode($this->_getParam('value'))
			);
			return $this->_helper->json->sendSuccess(array(
            	'data' => $result
			));
		} else if ($this->_hasParam('insertReceivableType')) {
			$result = Quick_Accountant_Remoter_ReceivableCatalog::insertReceivableType(Zend_Json_Decoder::decode($this->_getParam('receivable_type_name')));
			return $this->_helper->json->sendSuccess(array(
            	'data' => $result
			));
		} else if ($this->_hasParam('deleteReceivableTypes')) {
			$result = Quick_Accountant_Remoter_ReceivableCatalog::deleteReceivableTypes(Zend_Json_Decoder::decode($this->_getParam('records')));
			return $this->_helper->json->sendSuccess(array(
            	'data' => $result
			));
		}
		$this->render();
	}
	
	/**
	 * @desc	Auto To Account Action
	 * @author	khoatx
	 */
	public function autoToAccountAction()
	{
		$this->render();
	}
}