<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @author      datnh
 */
class Quick_Accountant_Remoter_AmortizeProperty {
	
	const DEFAULT_TABLE_SUPPLIER_TYPE = 6;
	
	const DEFAULT_DEBIT_ACCOUNT_TYPE 	= -1;
	const DEFAULT_CREDIT_ACCOUNT_TYPE 	= 1;
	const DEFAULT_NOT_DEFAULT_ACCOUNT_TYPE = 1;
	
	const DEFAULT_EXECUTION_ASSETS_VOUCHER_TYPE	= 19;//execution_id
	const DEFAULT_FORMATION_OF_FIXED_ASSET = 6;//entry_type_id of batch for formation_of_fixed_asset screen
	const DEFAULT_DEPRECIATION_OF_FIXED_ASSETS = 7;//entry_type_id of batch for depreciation_of_fixed_asset screen
	
	
	/**
	 * Get list of asset voucher
	 * @author datnh
	 */
	 
	public static function getListAssetVoucher($data, &$total) {
		$detail = Quick::single('accountant/assets_voucher')->cache()->getListAssetVoucher($data, &$total);
		$i = 0;
		foreach($detail as $item){
			$detail[$i]['forex_rate'] = Quick_Number::formatNumber($item['forex_rate']);
			$detail[$i]['converted_gross_cost'] = Quick_Number::formatNumber($item['converted_gross_cost']);
			$i++;
		}
		
		return $detail;
	}
	
	/**
	 * Get list entry_debit of asset voucher
	 * @author datnh
	 */
	public static function getEntryDebitOfAssetVoucher($data, &$total) {
		if(!isset($data['voucher_id']) || $data['voucher_id'] == 0) return false;
		$result = array();
		$entries = Quick::single('accountant/transaction_entry')->cache()->getTransactionEntryByVoucherId($data['voucher_id']);
		$i=0;
		for(; $i < count($entries) ; $i++){
			if($entries[$i]['account_id'] == 1) $entries[$i]['account_id'] = null;
			if($entries[$i]['debit_credit'] == 1){
				$entries[$i]['credit_account_id'] = ($entries[$i]['master_account_id']==1) ? null : $entries[$i]['master_account_id'];
				$entries[$i]['debit_account_id'] = null;
			}elseif($entries[$i]['debit_credit'] == -1){
				$entries[$i]['debit_account_id'] = ($entries[$i]['master_account_id']==1) ? null : $entries[$i]['master_account_id'];
				$entries[$i]['credit_account_id'] = null;
			}
			$entries[$i]['original_amount'] = Quick_Number::formatNumber($entries[$i]['original_amount']);
			$entries[$i]['forex_rate'] = Quick_Number::formatNumber($entries[$i]['forex_rate']);
			$entries[$i]['converted_amount'] = Quick_Number::formatNumber($entries[$i]['converted_amount']);
			$entries[$i]['correspondence_id'] = null;
			$entries[$i]['is_master'] = 1;
			$result[] = $entries[$i];
			//Get correspondences
			$correspondences = Quick::single('accountant/transaction_correspondence')->cache()->getDetailCorrespondenceByEntryId($entries[$i]['entry_id']);
			$j = 0;
			for(; $j < count($correspondences) ; $j++){
				if($correspondences[$j]['debit_credit'] == 1){
					$correspondences[$j]['credit_account_id'] = $correspondences[$j]['detail_account_id'];
					$correspondences[$j]['debit_account_id'] = null;
				}elseif($correspondences[$j]['debit_credit'] == -1){
					$correspondences[$j]['debit_account_id'] = $correspondences[$j]['detail_account_id'];
					$correspondences[$j]['credit_account_id'] = null;
				}
				$correspondences[$j]['original_amount'] = Quick_Number::formatNumber($correspondences[$j]['original_amount']);
				$correspondences[$j]['converted_amount'] = Quick_Number::formatNumber($correspondences[$j]['converted_amount']);
				$correspondences[$i]['is_master'] = 0;
				$result[] = $correspondences[$j];
			}			
		}

		return $result;
	}
	
	/**
	 * Insert asset record
	 * @author datnh
	 */
	 
	public static function insertAssetVoucher($data) {
		$gross_cost = isset($data['gross_cost']) ? $data['gross_cost'] : 0;
		$forex_rate = isset($data['forex_rate']) ? $data['forex_rate'] : 0;
		$converted_gross_cost = $gross_cost * $forex_rate;
		$data['gross_cost'] = $gross_cost;
		$data['forex_rate'] = $forex_rate;
		$data['converted_gross_cost'] = $converted_gross_cost;
				
		// insert accountant_transaction_voucher
		$newVoucherId = self::insertTransactionVoucher($data);
		if(!$newVoucherId) return false;
		// insert accountant_transaction_batch
		$newBatchId = self::insertBatch($data, $newVoucherId, self::DEFAULT_FORMATION_OF_FIXED_ASSET);
		if(!$newBatchId) return false;
		// insert accountant_transaction_entry
		$newEntryId = self::insertTransactionEntry($data, $newBatchId, self::DEFAULT_NOT_DEFAULT_ACCOUNT_TYPE, self::DEFAULT_DEBIT_ACCOUNT_TYPE);
		if(!$newEntryId) return false;
		// insert accountant_detail_entry
		$newDetailEntryId = self::insertDetailEntry($data, $newEntryId);
		if(!$newDetailEntryId) return false;
		// insert accountant_assets_voucher
		$newAssetVoucherId = self::insertAssetsVoucher($data, $newVoucherId);
		if(!$newAssetVoucherId) return false;
		
		//Get new record of asset voucher and response to client
		$assetVoucher['assets_voucher_id'] 			= $newAssetVoucherId;
		$assetVoucher['voucher_id'] 				= $newVoucherId;
		$assetVoucher['assets_code'] 				= $data['assets_code'];
		$assetVoucher['assets_name'] 				= $data['assets_name'];
		$assetVoucher['assets_description'] 		= '';
		$assetVoucher['purchase_date'] 				= $data['purchase_date'];
		$assetVoucher['supplier_id'] 				= $data['supplier_id'];
		$assetVoucher['gross_cost'] 				= Quick_Number::formatNumber($data['gross_cost']);
		$assetVoucher['currency_id'] 				= $data['currency_id'];
		$assetVoucher['forex_rate'] 				= Quick_Number::formatNumber($data['forex_rate']);
		$assetVoucher['converted_gross_cost'] 		= Quick_Number::formatNumber($data['converted_gross_cost']);
		$assetVoucher['net_book_value'] 			= $data['net_book_value'];
		$assetVoucher['estimated_useful_lifetime'] 	= $data['estimated_useful_lifetime'];
		$assetVoucher['depreciation_periods'] 		= $data['depreciation_periods'];	
		
		return $assetVoucher;	
	}
	
	/**
	 * Insert assets voucher
	 * @author datnh
	 */
	public static function insertAssetsVoucher($data, $voucherId) {
		
		$assetVoucher = array(				
			'voucher_id' => $voucherId,
			'assets_code' => $data['assets_code'],
			'assets_name' => $data['assets_name'],
			'purchase_date' => $data['purchase_date'],
			'supplier_id' => $data['supplier_id'],
			'gross_cost' => $data['gross_cost'],
			'currency_id' => $data['currency_id'],
			'forex_rate' => $data['forex_rate'],
			'converted_gross_cost' => $data['converted_gross_cost'],
			'net_book_value' => $data['net_book_value'],
			'estimated_useful_lifetime' => $data['estimated_useful_lifetime'],
			'depreciation_periods' => $data['depreciation_periods'],
				
			'created_by_userid' => Quick::session()->userId,
			'date_entered' => Quick_Date::now()->toSQLString(),
			'last_modified_by_userid' => Quick::session()->userId,
			'date_last_modified' => Quick_Date::now()->toSQLString()
		);
		return Quick::single('accountant/assets_voucher')->cache()->insertAssetVoucher($assetVoucher);			
	}
	
	/**
	 * Insert transaction entry
	 * @author	datnh
	 */
	public static function insertTransactionEntry($data, $batchId, $master_account_id, $debit_credit) {
		$entry = array(
				'batch_id' => $batchId,
				'master_account_id' => $master_account_id,
				'debit_credit' => $debit_credit,
				'original_amount' => $data['gross_cost'],
				'currency_id' => $data['currency_id'],
				'forex_rate' => $data['forex_rate'],
				'converted_amount' => $data['converted_gross_cost']
		);
		return Quick::single('accountant/transaction_entry')->cache()->insertEntry($entry);		
	}
	
	/**
	 * Insert detail entry
	 * @author datnh
	 */
	public static function insertDetailEntry($data, $entryId) {
		$detailEntry = array(
			'entry_id' => $entryId,
			'table_id' => self::DEFAULT_TABLE_SUPPLIER_TYPE,					
			'detail_id' => $data['supplier_id']  		
		);			
		return Quick::single('accountant/detail_entry')->cache()->insertDetailEntry($detailEntry);		
	}
	
	
	/**
	 * Insert Batch
	 * @author datnh
	 */	 
	public static function insertBatch($data, $newVoucherId, $entry_type_id) {
		$convertedDate = '';
		$batch_note = '';
		if($entry_type_id == self::DEFAULT_FORMATION_OF_FIXED_ASSET) {
			$convertedDate = Quick_Date::convertSQLDateToPHP('d/m/Y', $data['purchase_date']);
			$batch_note = 'Hình thành tài sản cố định "'. $data['assets_name'] .'", ngày '. $convertedDate;			
		}elseif($entry_type_id == self::DEFAULT_DEPRECIATION_OF_FIXED_ASSETS) {
			$convertedDate = Quick_Date::convertSQLDateToPHP('d/m/Y', $data['depreciation_date']);
			$batch_note = 'Khấu hao tài sản cố định "'. $data['depreciation_note'] .'", ngày '. $convertedDate;			
		}
		$batch = array(
					'voucher_id' => $newVoucherId,
					'execution_id' => self::DEFAULT_EXECUTION_ASSETS_VOUCHER_TYPE,
					'entry_type_id' => $entry_type_id,
					'batch_note' => $batch_note
					);
		return Quick::single('accountant/transaction_batch')->cache()->insertBatch($batch);
	}
	
	/**
	 * Insert TransactionVoucher
	 * @author datnh
	 */	 
	public static function insertTransactionVoucher($data) {
		$voucher = array(
			'execution_id' => self::DEFAULT_EXECUTION_ASSETS_VOUCHER_TYPE,
			'period_id' => $data['currentPeriodId'],
			'voucher_number' => $data['assets_code'] . $data['purchase_date'],
			'voucher_date' => $data['purchase_date'].' '.date('H:i:s'),
			'created_by_userid' => Quick::session()->userId,
			'date_entered' => Quick_Date::now()->toSQLString(),
			'last_modified_by_userid' => Quick::session()->userId,
			'date_last_modified' => Quick_Date::now()->toSQLString()
		);
		return Quick::single('accountant/transaction_voucher')->cache()->insertTransactionVoucher($voucher);
	}
	
	/**
	 * Update asset voucher
	 * @author datnh
	 */
	public static function updateAssetVoucher($data) {
		return Quick::single('accountant/assets_voucher')->cache()->updateAssetVoucher($data);
	}
	
	/**
	 * Get list of asset depreciation
	 * @author datnh
	 */
	public static function getAssetsDepreciationById($data, &$total) {
		$detail = Quick::single('accountant/assets_depreciation')->cache()->getAssetsDepreciationById($data, &$total);		
		$i = 0;
		foreach($detail as $item){
			$detail[$i]['depreciation_amount'] = Quick_Number::formatNumber($item['depreciation_amount']);
			$i++;
		}
		return $detail;
	}
	
	/**
	 * Update a field on assetVoucher
	 * @author datnh
	 */
	public static function updateFieldOfAssetVoucher($data) {
		return Quick::single('accountant/assets_voucher')->cache()->updateFieldOfAssetVoucher($data);
	}
	
	/**
	 * Update constrains table of asset voucher
	 * @author datnh
	 */
	 
	public static function updateConstrainsOfAssetVoucher($data) {
		//Get entry_id by assets_voucher_id
		$entry = Quick::single('accountant/transaction_entry')->cache()->getEntryIdByAssetVoucherId($data['assets_voucher_id']);
		if(!$entry) return false;
		//Update transaction_correspondence by entry_id (set: original_amount = 0, converted_amount=0, currency_id, forex_rate)		
		$updateCorrespondenceRs = Quick::single('accountant/transaction_correspondence')->cache()->updateCorrespondenceByAssetVoucher($data, $entry['entry_id']);
		if(!$updateCorrespondenceRs) return false;		
		//Update transaction_entry
		$updateEntryRs = Quick::single('accountant/transaction_entry')->cache()->updateEntryByAssetVoucher($data, $entry['entry_id']);
		if(!$updateEntryRs) return false;
		
		return true;
	}
	
	/**
	 * Insert AssetsDepreciation
	 * @author datnh
	 */
	public static function insertAssetsDepreciation($data) {
		$gross_cost = isset($data['gross_cost']) ? $data['gross_cost'] : 0;
		$forex_rate = isset($data['forex_rate']) ? $data['forex_rate'] : 0;
		$converted_gross_cost = $gross_cost * $forex_rate;
		$data['gross_cost'] = $gross_cost;
		$data['forex_rate'] = $forex_rate;
		$data['converted_gross_cost'] = $converted_gross_cost;
		
		$result = array();
		//Check primary key existed
		$depreciationExisted = Quick::single('accountant/assets_depreciation')->cache()->checkAssetDepreciationExisted($data);
		if($depreciationExisted) {
			$result['errs'] = 1;
			return $result;
		}
		// insert accountant_transaction_voucher
		$newVoucherId = self::insertTransactionVoucher($data);
		if(!$newVoucherId) return false;
		// insert accountant_transaction_batch
		$newBatchId = self::insertBatch($data, $newVoucherId, self::DEFAULT_DEPRECIATION_OF_FIXED_ASSETS);
		if(!$newBatchId) return false;
		// insert accountant_transaction_entry
		$newEntryId = self::insertTransactionEntry($data, $newBatchId, self::DEFAULT_NOT_DEFAULT_ACCOUNT_TYPE, self::DEFAULT_DEBIT_ACCOUNT_TYPE);
		if(!$newEntryId) return false;
		// insert accountant_detail_entry
		$newDetailEntryId = self::insertDetailEntry($data, $newEntryId);
		if(!$newDetailEntryId) return false;
		// insert accountant_assets_voucher
		$newAssetVoucherId = self::insertAssetsDepreciationWithVoucherId($data, $newVoucherId);
		if(!$newAssetVoucherId) return false;
		
		return true;		
	}
	
	/**
	 * Insert AssetsDepreciation when voucher_id existed
	 * @author datnh
	 */
	public static function insertAssetsDepreciationWithVoucherId($data, $newVoucherId) {
		$assetsDepreciation = array(	
			'assets_voucher_id' => $data['assets_voucher_id'],
			'depreciation_date' => $data['depreciation_date'].' '.date('H:i:s'),
			'voucher_id' => $newVoucherId,
			'depreciation_note' => $data['depreciation_note'],
			'depreciation_amount' => $data['depreciation_amount'],				
			'created_by_userid' => Quick::session()->userId,
			'date_entered' => Quick_Date::now()->toSQLString(),
			'last_modified_by_userid' => Quick::session()->userId,
			'date_last_modified' => Quick_Date::now()->toSQLString()
		);
		return Quick::single('accountant/assets_depreciation')->cache()->insertAssetsDepreciation($assetsDepreciation);	
	}
	
	/**
	 * Update AssetsDepreciation
	 * @author datnh
	 */
	public static function updateAssetsDepreciation($data) {	
		$update_result = true;
		if($data['field'] == 'depreciation_amount') {
			//Get entry_id:
			$entry = self::getEntryByVoucherId($data['voucher_id']);
			//Update transaction_correspondence:
			Quick::single('accountant/transaction_correspondence')->cache()->updateCorrespondenceAmountByEntryId(0.0,0.0, $entry['entry_id']);					
		}
		return 	Quick::single('accountant/assets_depreciation')->cache()->updateAssetsDepreciation($data);
	}
	
	/**
	 * Get entry by voucher_id
	 * @author datnh
	 */
	public static function getEntryByVoucherId($voucher_id) {
		return Quick::single('accountant/transaction_entry')->cache()->getEntryByVoucherId($voucher_id);
	}
	
	/**
	 * Insert transaction_correspondence
	 * @author datnh
	 */
	public static function insertCorrespondenceForAssetVoucher($data) {
		$original_amount = isset($data['original_amount']) ? $data['original_amount'] : 0;
		$forex_rate = isset($data['forex_rate']) ? $data['forex_rate'] : 0;
		$converted_amount = $original_amount * $forex_rate;
		$correspondences = array(	
			'entry_id' => $data['entry_id'],
			'detail_account_id' => $data['detail_account_id'],
			'debit_credit' => $data['debit_credit'],
			'original_amount' => $original_amount,				
			'currency_id' => $data['currency_id'],
			'forex_rate' => $forex_rate,
			'converted_amount' => $converted_amount
		);
		$insert_correspondence_rs = Quick::single('accountant/transaction_correspondence')->cache()->insertCorrespondence($correspondences);				
		if(!$insert_correspondence_rs) return false;
		// insert accountant_detail_correspondence
		$insert_detailCorrespondence_rs = self::insertDetailCorrespondence($data, $insert_correspondence_rs);
		if(!$insert_detailCorrespondence_rs) return false;
		
		return $insert_correspondence_rs;
	}
	
	/**
	 * Insert detail correspondence
	 * @author datnh
	 */
	public static function insertDetailCorrespondence($data, $correspondence_id) {
		$detailCorrespondence['correspondence_id'] = $correspondence_id;
		$detailCorrespondence['table_id'] = self::DEFAULT_TABLE_SUPPLIER_TYPE;
		$detailCorrespondence['detail_id'] = $data['detail_id'];
		return Quick::single('accountant/detail_correspondence')->cache()->insertDetailCorrespondence($detailCorrespondence);	
	}
	
	/**
	 * Update transaction_correspondence
	 * @author datnh
	 */
	public static function updateCorrespondenceForAssetVoucher($data) {
		$original_amount = isset($data['original_amount']) ? $data['original_amount'] : 0;
		$forex_rate = isset($data['forex_rate']) ? $data['forex_rate'] : 0;
		$converted_amount = $original_amount * $forex_rate;

		return Quick::single('accountant/transaction_correspondence')->cache()->updateTransactionCorrespondence($data['correspondence_id'], $data['detail_account_id'], 
				$data['debit_credit'], $original_amount, $data['currency_id'], $forex_rate, $converted_amount);		
	}
	
	/**
	 * Update transaction_entry for asset_voucher
	 * @author datnh
	 */
	public static function updateTransactionEntryForAssetVoucher($data) {
		$master_debit_credit = $data['master_debit_credit'];
		if($master_debit_credit == -1) {
			if(isset($data['credit_account_id']) && $data['credit_account_id'] != '') {
//				//Update Entry and Delete Correspondence
				$deleteCorrespondenceResult = self::deleteTransactionCorrespondenceByEntryId($data['entry_id']);
				if(!$deleteCorrespondenceResult) return false;
				return Quick::single('accountant/transaction_entry')->cache()->updateTransactionEntry($data['entry_id'], $data['credit_account_id'], 1);
			}else{
				//Update Entry only
				return Quick::single('accountant/transaction_entry')->cache()->updateTransactionEntry($data['entry_id'], $data['debit_account_id'], -1);
			}
		}elseif($master_debit_credit == 1) {
			if(isset($data['debit_account_id']) && $data['debit_account_id'] != '') {
				//Update Entry and Delete Correspondence
				$deleteCorrespondenceResult = self::deleteTransactionCorrespondenceByEntryId($data['entry_id']);
				if(!$deleteCorrespondenceResult) return false;
				return Quick::single('accountant/transaction_entry')->cache()->updateTransactionEntry($data['entry_id'], $data['debit_account_id'], -1);
			}else{
				//Update Entry only
				return Quick::single('accountant/transaction_entry')->cache()->updateTransactionEntry($data['entry_id'], $data['credit_account_id'], 1);
			}
		}
		return false;	
	}
	
	/**
	 * Delete Correspondence by entry_id
	 * @author datnh
	 */
	public static function deleteTransactionCorrespondenceByEntryId($entry_id) {	
		return Quick::single('accountant/transaction_correspondence')->cache()->deleteTransactionCorrespondenceByEntryId($entry_id);	
	}
	
	/**
	 * Load data for depreciation fixed asset grid by assets_voucher_id
	 * @author datnh
	 */
	public static function getEntryDebitOfDepreciation($assets_voucher_id) {
		$detailEntry = Quick::single('accountant/transaction_entry')->cache()->getEntryDebitOfDepreciationByAssetVoucherId($assets_voucher_id);
		$i = 0;
		for(; $i < count($detailEntry) ; $i++){			
			$detailEntry[$i]['original_amount'] = Quick_Number::formatNumber($detailEntry[$i]['original_amount']);
			$detailEntry[$i]['forex_rate'] = Quick_Number::formatNumber($detailEntry[$i]['forex_rate']);
			$detailEntry[$i]['converted_amount'] = Quick_Number::formatNumber($detailEntry[$i]['converted_amount']);
		}
		return $detailEntry;
	}

	/**
	 * Delete transaction entry with id
	 * @author	datnh
	 * @return array Functions|mixed
	 */
	public static function deleteTransactionEntry($arrEntryId, $arrCorrespondenceId)
	{
		foreach($arrEntryId as $entry){
			Quick::single('accountant/transaction_voucher')->cache()->deleteTransactionVoucherByVoucherId($entry['voucher_id']);
		}
		foreach($arrCorrespondenceId as $correspondence){
			Quick::single('accountant/transaction_correspondence')->cache()->deleteTransactionCorrespondenceById($correspondence['correspondenceId']);
		}
		return true;
	}
	
	/**
	 * Delete Depreciation
	 * @author datnh
	 */
	public static function deleteDepreciation($arrRecordDepreciation) {
		foreach($arrRecordDepreciation as $entry){
			Quick::single('accountant/transaction_voucher')->cache()->deleteTransactionVoucherByVoucherId($entry['voucher_id']);
		}
		return true;
	}
	
	/**
	 * Delete asset voucher
	 * @author datnh
	 */
	public static function deleteAssetVoucher($arrRecordAssetVoucher) {
		foreach($arrRecordAssetVoucher as $entry){
			Quick::single('accountant/transaction_voucher')->cache()->deleteTransactionVoucherByVoucherId($entry['voucher_id']);
		}
		return true;
	}
}
