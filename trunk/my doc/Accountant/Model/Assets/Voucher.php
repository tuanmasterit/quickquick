<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Model
 * @author      datnh
 */
class Quick_Accountant_Model_Assets_Voucher extends Quick_Db_Table {
	
	protected $_name = 'accountant_assets_voucher';
	
	/**
	 * Insert asset voucher
	 * @author	datnh
	 * @return array
	 */
	public function insertAssetVoucher($assetVoucher = array())
	{
		if(!empty($assetVoucher)){
			return $this->insert($assetVoucher);
		}
		return null;
	}
	
	/**
	 * 	Update Asset voucher
	 *	@author datnh
	 */
	public function updateAssetVoucher($data) {
		$gross_cost = isset($data['gross_cost']) ? $data['gross_cost'] : 0;
		$forex_rate = isset($data['forex_rate']) ? $data['forex_rate'] : 0;
		$converted_gross_cost = $gross_cost * $forex_rate;
		
		$db = $this->getAdapter();
		$row = $this->fetchRow(array($db->quoteInto('assets_voucher_id = ?', $data['assets_voucher_id'])));		
		if (isset($row)) {			
			$row = array(
				$data['field'] => $data['value'],
				'gross_cost' => $gross_cost,
				'forex_rate' => $forex_rate,
				'converted_gross_cost' => $converted_gross_cost,
				'last_modified_by_userid' => Quick::session()->userId,
				'date_last_modified' => Quick_Date::now()->toSQLString()
			);			
			return $this->update($row, $db->quoteInto('assets_voucher_id = ?', $data['assets_voucher_id']));
		}
	}
	
/**
	 * Get list asset voucher
	 * @author datnh
	 */
	public function getListAssetVoucher($data, &$total) {			
		$total = $this->getAssetVoucherSize($data);				
		return $this->getAssetVoucherList($data);
	}
	
	/**
	 * Get size of list
	 * @author datnh
	 */
	private function getAssetVoucherSize($data) {
		$select = $this->getAdapter()->select();
		$select->from(array('aav' => $this->_name), array('count(*)'));
		if(isset($data['srch_assets_code']) && $data['srch_assets_code'] != null && $data['srch_assets_code'] != ''){
			$select->where("aav.assets_code LIKE(?)", '%'. $data['srch_assets_code'] .'%');
		}	
		if(isset($data['srch_from_date']) && $data['srch_from_date'] != null && $data['srch_from_date'] != ''){
			$select->where("DATE(aav.purchase_date) >=(?)", $data['srch_from_date']);
		}
		if(isset($data['srch_to_date']) && $data['srch_to_date'] != null && $data['srch_to_date'] != ''){
			$select->where("DATE(aav.purchase_date) <=(?)", $data['srch_to_date']);	
		}	
		if(isset($data['srch_supplier']) && $data['srch_supplier'] != null && $data['srch_supplier'] != ''){
			$select->where("aav.supplier_id =(?)", $data['srch_supplier']);
		}
		
		return $this->getAdapter()->fetchOne($select->__toString());
	}
	/**
	 * Get assetvoucher list
	 * @author datnh
	 */
	private function getAssetVoucherList($data) {
		$limit = isset($data['limit']) ? $data['limit'] : $this->pageSize;
		$start = isset($data['start']) ? $data['start'] : 0;
		if ($start == '') {
			$start = 0;
		}				
		//Get records
		$select = $this->getAdapter()->select();
		$select->from(array('aav' => $this->_name),
					array('aav.assets_voucher_id',
							'aav.voucher_id',
							'aav.assets_code',
							'aav.assets_name',
							'aav.assets_description',
							'DATE_FORMAT(aav.purchase_date, \'%Y/%m/%d\') purchase_date',
							'aav.supplier_id',
							'aav.gross_cost',
							'aav.currency_id',
							'aav.forex_rate',
							'aav.converted_gross_cost',
							'aav.net_book_value',
							'aav.estimated_useful_lifetime',
							'aav.depreciation_periods'));

		if(isset($data['srch_assets_code']) && $data['srch_assets_code'] != null && $data['srch_assets_code'] != ''){
			$select->where("aav.assets_code LIKE(?)", '%'. $data['srch_assets_code'] .'%');
		}	
		if(isset($data['srch_from_date']) && $data['srch_from_date'] != null && $data['srch_from_date'] != ''){
			$select->where("DATE(aav.purchase_date) >=(?)", $data['srch_from_date']);
		}
		if(isset($data['srch_to_date']) && $data['srch_to_date'] != null && $data['srch_to_date'] != ''){
			$select->where("DATE(aav.purchase_date) <=(?)", $data['srch_to_date']);	
		}	
		if(isset($data['srch_supplier']) && $data['srch_supplier'] != null && $data['srch_supplier'] != ''){
			$select->where("aav.supplier_id =(?)", $data['srch_supplier']);
		}
		$select->limit($limit, $start);
				
		return $this->getAdapter()->fetchAll($select->__toString());
	}
	
	/**
	 * Update a field for asset voucher
	 * @author datnh
	 */
	public function updateFieldOfAssetVoucher($data) {
		$assets_voucher_id = isset($data['assets_voucher_id']) ? $data['assets_voucher_id'] : 0;
		$convertCurrency = isset($data['convertCurrency']) ? $data['convertCurrency'] : 0;
		$field = $data['field'];
		$value = $data['value'];
		if(!isset($field) || $field == null || $field == '') return false;
		
		$db = $this->getAdapter();
		$row = $this->fetchRow(array($db->quoteInto('assets_voucher_id  = ?', $assets_voucher_id)));
		
		if(isset($row)) {
			$row = array();
			if($field == 'purchase_date'){
				$row[$field] = $value.' '.date("H:i:s");
			}elseif($field == 'supplier_id'){
				$forex_rate = isset($data['forex_rate']) ? $data['forex_rate'] : 0;
				$gross_cost = isset($data['gross_cost']) ? $data['gross_cost'] : 0;
				$currency_id = isset($data['currency_id']) ? $data['currency_id'] : 0;				
				$row[$field] = $value;				
				$row['forex_rate'] = $forex_rate;
				$row['gross_cost'] = $gross_cost;
				$row['currency_id'] = $currency_id;				
				$row['converted_gross_cost'] = $forex_rate * $gross_cost;	

				$transactionEntry = Quick::single('accountant/transaction_entry')->cache()->getTransactionEntryByAssetsVoucherId($assets_voucher_id);
				foreach($transactionEntry as $item){										
					if($item['from_assets_voucher'] == 1) {
						//Entry got from assets_voucher						
						$item['original_amount'] = $forex_rate;
						$item['converted_amount'] = $forex_rate * $gross_cost;
						$item['currency_id'] = $currency_id;	
					}else{
						//Entries got from assets_depreciation
						$item['original_amount'] = 0.0;
						$item['converted_amount'] = 0.0;
						$item['currency_id'] = $currency_id;	
						//Update amount for depreciation
						$depreciations['depreciation_amount'] = 0.0;
						Quick::single('accountant/assets_depreciation')->cache()->updateRecordAssetsDepreciationByAssetVoucherId($depreciations, $assets_voucher_id);						
					}
					unset($item['from_assets_voucher']);  //remove 'is_assets_voucher' item
					//Update entry:
					Quick::single('accountant/transaction_entry')->cache()->updateRecordTransactionEntry($item, $item['entry_id']);
						
					//Update correspondences:
					$transactionCorrespondence = Quick::single('accountant/transaction_correspondence')->cache()->getTransactionCorrespondenceByEntryId($item['entry_id']);
					foreach($transactionCorrespondence as $itemCorr){
						$itemCorr['original_amount'] = 0.0;
						$itemCorr['converted_amount'] = 0.0;
						$itemCorr['currency_id'] = $currency_id;	
						Quick::single('accountant/transaction_correspondence')->cache()->updateRecordTransactionCorrespondence($itemCorr, $itemCorr['correspondence_id']);
					}		
				}
			}elseif($field == 'gross_cost'){
				$forex_rate = isset($data['forex_rate']) ? $data['forex_rate'] : 0;
				$row[$field] = $value;	
				$row['forex_rate'] = $forex_rate;
				$row['converted_gross_cost'] = $forex_rate * $value;
				$gross_cost = $value;
				
				Quick::single('accountant/assets_voucher')->cache()->updateTransactionEntriesListByAssetVoucher($assets_voucher_id, $forex_rate, $gross_cost);
			}elseif($field == 'currency_id'){
				$forex_rate = isset($data['forex_rate']) ? $data['forex_rate'] : 0;
				$gross_cost = isset($data['gross_cost']) ? $data['gross_cost'] : 0;
				$row[$field] = $value;				
				$row['forex_rate'] = $forex_rate;
				$row['gross_cost'] = $gross_cost;
				$row['converted_gross_cost'] = $forex_rate * $gross_cost;	

				Quick::single('accountant/assets_voucher')->cache()->updateTransactionEntriesListByAssetVoucher($assets_voucher_id, $forex_rate, $gross_cost);
			}elseif($field == 'forex_rate'){
				$gross_cost = isset($data['gross_cost']) ? $data['gross_cost'] : 0;
				$row[$field] = $value;	
				$row['gross_cost'] = $gross_cost;
				$row['converted_gross_cost'] = $gross_cost * $value;
				$forex_rate = $value;				

				Quick::single('accountant/assets_voucher')->cache()->updateTransactionEntriesListByAssetVoucher($assets_voucher_id, $forex_rate, $gross_cost);
			}elseif($field == 'depreciation_periods') {
				$row[$field] = $value;
				$deperciationList = Quick::single('accountant/assets_depreciation')->cache()->getAssetsDepreciationByAssetVoucherId($assets_voucher_id);
				foreach($deperciationList as $item){	
					Quick::single('accountant/transaction_voucher')->cache()->deleteTransactionVoucherById($item['voucher_id']);	
				}
			}else{
				$row[$field] = $value;
			}
			
			$updateAssetVoucherResult = $this->update($row, $db->quoteInto('assets_voucher_id = ?', $assets_voucher_id));
			if($updateAssetVoucherResult) {
				$dataResult[$field] = $value;
			   	if($field == 'supplier_id') {
			   		$dataResult['forex_rate'] = Quick_Number::formatNumber($row['forex_rate']);
			   		$dataResult['currency_id'] = $row['currency_id'];
			   		$dataResult['converted_gross_cost'] = Quick_Number::formatNumber($row['converted_gross_cost']);			   					   		
    			}else if($field == 'gross_cost') {
    				$dataResult['forex_rate'] = Quick_Number::formatNumber($row['forex_rate']);
    				$dataResult['converted_gross_cost'] = Quick_Number::formatNumber($row['converted_gross_cost']);	
    			}else if($field == 'currency_id') {
    				$dataResult['forex_rate'] = Quick_Number::formatNumber($row['forex_rate']);
    				$dataResult['converted_gross_cost'] = Quick_Number::formatNumber($row['converted_gross_cost']);		    				
    			}else if($field == 'forex_rate'){
	    			$dataResult['forex_rate'] = Quick_Number::formatNumber($row['forex_rate']);
    				$dataResult['converted_gross_cost'] = Quick_Number::formatNumber($row['converted_gross_cost']);		
    			}
    			return $dataResult;
			}
		}		
		return false;
	}
	
	/**
	 * Update Transaction entries list by asset_voucher_id
	 * @author datnh
	 */
	public function updateTransactionEntriesListByAssetVoucher($assets_voucher_id, $forex_rate, $gross_cost) {
		// update transaction entry of assets_voucher and assets_depreciation
		$transactionEntry = Quick::single('accountant/transaction_entry')->cache()->getTransactionEntryByAssetsVoucherId($assets_voucher_id);
		foreach($transactionEntry as $item){										
			if($item['from_assets_voucher'] == 1) {
				//Entry got from assets_voucher						
				$item['original_amount'] = $forex_rate;
				$item['converted_amount'] = $forex_rate * $gross_cost;
			}else{
				//Entries got from assets_depreciation
				$item['original_amount'] = 0.0;
				$item['converted_amount'] = 0.0;
				//Update amount for depreciation
				$depreciations['depreciation_amount'] = 0.0;
				Quick::single('accountant/assets_depreciation')->cache()->updateRecordAssetsDepreciationByAssetVoucherId($depreciations, $assets_voucher_id);						
			}
			unset($item['from_assets_voucher']);  //remove 'is_assets_voucher' item
			//Update entry:
			Quick::single('accountant/transaction_entry')->cache()->updateRecordTransactionEntry($item, $item['entry_id']);
				
			//Update correspondences:
			$transactionCorrespondence = Quick::single('accountant/transaction_correspondence')->cache()->getTransactionCorrespondenceByEntryId($item['entry_id']);
			foreach($transactionCorrespondence as $itemCorr){
				$itemCorr['original_amount'] = 0.0;
				$itemCorr['converted_amount'] = 0.0;
				Quick::single('accountant/transaction_correspondence')->cache()->updateRecordTransactionCorrespondence($itemCorr, $itemCorr['correspondence_id']);
			}		
		}
	}
		
	/*
	 * @desc get combo list assets 
	 * @author: tuvv
	 * @return array
	 */
	public function getAssets()
	{
		$select = $this->getAdapter()->select();
        $select->from(array('asv' => $this->_name), 
        			  array('assets_voucher_id', 'assets_name'));
        	   
     	return $this->getAdapter()->fetchAll($select->__toString());
	}
}

