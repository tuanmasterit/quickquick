<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @author      trungpm
 */
class Quick_Accountant_Remoter_StockManage {

	const DEFAULT_DEBIT_ACCOUNT_TYPE 	= -1;
	const DEFAULT_CREDIT_ACCOUNT_TYPE 	= 1;

	const DEFAULT_INPUT_VOTE_TYPE 					= 1;
	const DEFAULT_OUTPUT_VOTE_TYPE 					= 2;
	const DEFAULT_INTERNAL_VOTE_TYPE 				= 3;
	const DEFAULT_INPUT_ENTRY_TYPE 					= 19;
	const DEFAULT_OUTPUT_ENTRY_TYPE 				= 20;
	const DEFAULT_INTERNAL_ENTRY_TYPE 				= 21;

	const DEFAULT_TABLE_PRODUCT_TYPE 				= 3;
	const DEFAULT_TABLE_UNIT_TYPE	 				= 17;
	const DEFAULT_TABLE_WAREHOUSE_TYPE	 			= 26; // kho nhap ben no, kho xuat ben co
	const DEFAULT_TABLE_SUBJECT_TYPE 				= 27;
	const DEFAULT_TABLE_DEPARTMENT_TYPE 			= 2;

	const DEFAULT_EXECUTION_ACCOUNTANT_TYPE			= 21;
	const DEFAULT_EXECUTION_INVENTORY_VOUCHER_TYPE 	= 15;
	const DEFAULT_NOT_DEFAULT_ACCOUNT_TYPE 			= 1;
	const IS_DEFAULT 								= 1;
	/**
	 * Retrieve product list, limit, start
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function getListWarehouse()
	{
		return Quick::single('core/definition_warehouse')->cache()->getAllWarehouse();
	}

	/**
	 * Retrieve list inventory voucher
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function getListInventoryVoucher($limit, $start, $invoiceNumber, $fromDate, $toDate, $typeVote, &$total)
	{
		$detail = Quick::single('accountant/inventory_voucher')->cache()->getListInventoryVoucher($limit, $start, $invoiceNumber, $fromDate, $toDate, $typeVote, &$total);
		$i = 0;
		foreach($detail as $item){
			$arrBatch = Quick_Accountant_Remoter_BuyBilling::getBatchByVoucher($detail[$i]['voucher_id']);
			$detail[$i]['batch_id'] = isset($arrBatch[0])?$arrBatch[0]['batch_id']:0;
			$detail[$i]['forex_rate'] = Quick_Number::formatNumber($item['forex_rate']);
			$detail[$i]['total_inventory_amount'] = Quick_Number::formatNumber($item['total_inventory_amount']);
			$i++;
		}
		return $detail;
	}

	/**
	 * Insert inventory voucher
	 * @author	trungpm
	 * @return array
	 */
	public static function insertInventoryVoucher($inventoryNumber, $inventoryDate, $typeVote,
	$inWarehouse, $outWarehouse, $currencyId, $forexRate, $currentPeriodId)
	{
		// insert voucher and batch to accounting for purchase invoice
		$voucher = array(
			'execution_id' => self::DEFAULT_EXECUTION_INVENTORY_VOUCHER_TYPE,
			'period_id' => $currentPeriodId,
			'voucher_number' => $inventoryNumber,
			'voucher_date' => $inventoryDate.' '.date('H:i:s'),
			'created_by_userid' => Quick::session()->userId,
			'date_entered' => Quick_Date::now()->toSQLString(),
			'last_modified_by_userid' => Quick::session()->userId,
			'date_last_modified' => Quick_Date::now()->toSQLString()
		);
		$newVoucherId = Quick::single('accountant/transaction_voucher')->cache()->insertTransactionVoucher($voucher);
		if($newVoucherId){
			$convertedDate = Quick_Date::convertSQLDateToPHP('d/m/Y', $inventoryDate);
			$entryTypeId = 0;
			$note = '';
			if($typeVote == self::DEFAULT_INPUT_VOTE_TYPE){
				$entryTypeId = self::DEFAULT_INPUT_ENTRY_TYPE;
				$note = "Phiếu nhập kho '";
			}elseif($typeVote == self::DEFAULT_OUTPUT_VOTE_TYPE){
				$entryTypeId = self::DEFAULT_OUTPUT_ENTRY_TYPE;
				$note = "Phiếu xuất kho '";
			}else{
				$entryTypeId = self::DEFAULT_INTERNAL_ENTRY_TYPE;
				$note = "Phiếu vận chuyển nội bộ '";
			}
			$batch = array(
				'voucher_id' => $newVoucherId,
				'execution_id' => self::DEFAULT_EXECUTION_ACCOUNTANT_TYPE,
				'entry_type_id' => $entryTypeId,
				'batch_note' => $note . $inventoryNumber .'", ngày "'. $convertedDate . "'");
			$newBatchId = Quick::single('accountant/transaction_batch')->cache()->insertBatch($batch);
			if($newBatchId){
				$inventory = array(
					'voucher_id' => $newVoucherId,
					'inventory_voucher_number' => $inventoryNumber,
					'inventory_voucher_date' => $inventoryDate.' '.date('H:i:s'),
					'subject_id' => 0,
					'subject_contact' => '',
					'department_id' => 0,
					'in_out' => $typeVote,
					'in_warehouse_id' => isset($inWarehouse)?$inWarehouse:0,
					'out_warehouse_id' => isset($outWarehouse)?$outWarehouse:0,
					'currency_id' => isset($currencyId)?$currencyId:0,
					'forex_rate' => isset($forexRate)?$forexRate:0.00,					
					'description' => '',
					'created_by_userid' => Quick::session()->userId,
					'date_entered' => Quick_Date::now()->toSQLString(),
					'last_modified_by_userid' => Quick::session()->userId,
					'date_last_modified' => Quick_Date::now()->toSQLString()
				);
				$newInventoryId = Quick::single('accountant/inventory_voucher')->cache()->insertInventoryVoucher($inventory);
				if($newInventoryId){
					$inventory['forex_rate'] = Quick_Number::formatNumber($inventory['forex_rate']);
					$inventory['total_inventory_amount'] = Quick_Number::formatNumber('0.00');
					$inventory['inventory_voucher_id'] = $newInventoryId;
					$inventory['period_id'] = $currentPeriodId;
					$inventory['batch_id'] = $newBatchId;
					return $inventory;
				}
				return false;
			}else
			return false;
		}else
		return false;
	}

	/**
	 * Delete inventory voucher with array id
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function deleteInventoryVoucher($arrRecord)
	{
		foreach($arrRecord as $record){
			if(!Quick::single('accountant/inventory_voucher')->cache()->deleteInventoryVoucher($record['inventory_voucher_id'])){
				return false;
			}
		}
		return true;
	}

	/**
	 * Retrieve subject list by type
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function getListSubject($type)
	{
		$arrType = array('is_software_user', 'is_government', 'is_bank');
		switch($type){
			case 1:
				array_push($arrType, 'is_supplier');
				break;
			case 2:
				array_push($arrType, 'is_customer');
				break;
			case 3:
				array_push($arrType, 'is_supplier', 'is_customer');
				break;
		}
		return Quick::single('core/definition_subject')->cache()->getListSubjectByArrayType($arrType);
	}

	/**
	 * insert detail entry with entry id, product id, unit id, warehouse, subject, department
	 * @author	trungpm
	 * @return array
	 */
	public static function insertDetailEntry(&$newEntryId, $batchId, $masterId, $debitOrCredit,
	$originalAmount, $currencyId, $forexRate, $convertedAmount, $productId, $unitId, $warehouseId, $subjectId, $departmentId)
	{
		$entry = array(
				'batch_id' => $batchId,
				'master_account_id' => $masterId,
				'debit_credit' => $debitOrCredit,
				'original_amount' => $originalAmount,
				'currency_id' => $currencyId,
				'forex_rate' => $forexRate,
				'converted_amount' => $convertedAmount
		);
		$newEntryId = Quick::single('accountant/transaction_entry')->cache()->insertEntry($entry);
		if($newEntryId){
			$product = array(
				'entry_id' => $newEntryId,
				'table_id' => self::DEFAULT_TABLE_PRODUCT_TYPE,					
				'detail_id' => $productId  		
			);
			$unit = array(
				'entry_id' => $newEntryId,
				'table_id' => self::DEFAULT_TABLE_UNIT_TYPE,					
				'detail_id' => $unitId	
			);
			$warehouse = array(
				'entry_id' => $newEntryId,
				'table_id' => self::DEFAULT_TABLE_WAREHOUSE_TYPE,					
				'detail_id' => $warehouseId	
			);
			$subject = array(
				'entry_id' => $newEntryId,
				'table_id' => self::DEFAULT_TABLE_SUBJECT_TYPE,					
				'detail_id' => $subjectId	
			);
			$department = array(
				'entry_id' => $newEntryId,
				'table_id' => self::DEFAULT_TABLE_DEPARTMENT_TYPE,					
				'detail_id' => $departmentId	
			);
			if(Quick::single('accountant/detail_entry')->cache()->insertDetailEntryWithArray(array($product, $unit, $warehouse, $subject, $department))){
				$entry['entry_id'] = $newEntryId;
				return $entry;
			}
			return false;
		}
		else return false;
	}

	/**
	 * insert detail correspondence with entry id, product id, unit id, warehouse id, subject id, department id
	 * @author	trungpm
	 * @return array
	 */
	public static function insertDetailCorrespondence($entryId, $detailId, $debitOrCredit,
	$originalAmount, $currencyId, $forexRate, $convertedAmount, $productId, $unitId, $warehouseId, $subjectId, $departmentId)
	{
		$correspondence = array(
				'entry_id' => $entryId,
				'detail_account_id' => $detailId,
				'debit_credit' => $debitOrCredit,
				'original_amount' => $originalAmount,
				'currency_id' => $currencyId,
				'forex_rate' => $forexRate,
				'converted_amount' => $convertedAmount
		);
		$newCorrespondenceId = Quick::single('accountant/transaction_correspondence')->cache()->insertCorrespondence($correspondence);
		if($newCorrespondenceId){
			$product = array(
				'correspondence_id' => $newCorrespondenceId,
				'table_id' => self::DEFAULT_TABLE_PRODUCT_TYPE,					
				'detail_id' => $productId  		
			);
			$unit = array(
				'correspondence_id' => $newCorrespondenceId,
				'table_id' => self::DEFAULT_TABLE_UNIT_TYPE,					
				'detail_id' => $unitId	
			);
			$warehouse = array(
				'correspondence_id' => $newCorrespondenceId,
				'table_id' => self::DEFAULT_TABLE_WAREHOUSE_TYPE,					
				'detail_id' => $warehouseId	
			);
			$subject = array(
				'correspondence_id' => $newCorrespondenceId,
				'table_id' => self::DEFAULT_TABLE_SUBJECT_TYPE,					
				'detail_id' => $subjectId	
			);
			$department = array(
				'correspondence_id' => $newCorrespondenceId,
				'table_id' => self::DEFAULT_TABLE_DEPARTMENT_TYPE,					
				'detail_id' => $departmentId	
			);
			if(Quick::single('accountant/detail_correspondence')->cache()->insertDetailCorrespondenceWithArray(array($product, $unit, $warehouse, $subject, $department))){
				$correspondence['correspondence_id'] = $newCorrespondenceId;
				$correspondence['original_amount'] = Quick_Number::formatNumber($correspondence['original_amount']);
				$correspondence['converted_amount'] = Quick_Number::formatNumber($correspondence['converted_amount']);
				return $correspondence;
			}
			return false;
		}
		else return false;
	}

	/**
	 * Auto accounting for record of detail inventory voucher
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function autoAccountingForInventory($entryTypeId, $batchId, $record,
	$currencyId, $forexRate, $debitWarehouseId, $creditWarehouseId)
	{
		$listDefaultDebit = Quick::single('accountant/entry_debit')->cache()->getDebitAccount($entryTypeId, self::IS_DEFAULT);
		$listDefaultCredit = Quick::single('accountant/entry_credit')->cache()->getCreditAccount($entryTypeId, self::IS_DEFAULT);

		if((count($listDefaultCredit) > 1) && (count($listDefaultDebit) == 1)){
			// truong hop 1 no , nhieu co
			$newEntryId = 0;
			self::insertDetailEntry(&$newEntryId, $batchId, $listDefaultDebit[0]['account_id'],
			self::DEFAULT_DEBIT_ACCOUNT_TYPE, $record['amount'], $currencyId, $forexRate,
			$record['converted_amount'], $record['product_id'], $record['unit_id'], $debitWarehouseId, $record['subject_id'], $record['department_id']);

			foreach($listDefaultCredit as $item){
				self::insertDetailCorrespondence($newEntryId, $item['account_id'],
				self::DEFAULT_CREDIT_ACCOUNT_TYPE, 0.00, $currencyId, $forexRate,
				0.00, $record['product_id'], $record['unit_id'], $creditWarehouseId, $record['subject_id'], $record['department_id']);
			}
		}elseif((count($listDefaultDebit) > 1) && (count($listDefaultCredit) == 1)){
			// truong hop 1 co , nhieu no
			$newEntryId = 0;
			self::insertDetailEntry(&$newEntryId, $batchId, $listDefaultCredit[0]['account_id'],
			self::DEFAULT_CREDIT_ACCOUNT_TYPE, $record['amount'], $currencyId, $forexRate,
			$record['converted_amount'], $record['product_id'], $record['unit_id'], $creditWarehouseId, $record['subject_id'], $record['department_id']);

			foreach($listDefaultDebit as $item){
				self::insertDetailCorrespondence($newEntryId, $item['account_id'],
				self::DEFAULT_DEBIT_ACCOUNT_TYPE, 0.00, $currencyId, $forexRate,
				0.00, $record['product_id'], $record['unit_id'], $debitWarehouseId, $record['subject_id'], $record['department_id']);
			}
		}elseif((count($listDefaultDebit) == 1) && (count($listDefaultCredit) == 1)){
			// truong hop 1 co , 1 no
			$newEntryId = 0;
			self::insertDetailEntry(&$newEntryId, $batchId, $listDefaultDebit[0]['account_id'],
			self::DEFAULT_DEBIT_ACCOUNT_TYPE, $record['amount'], $currencyId, $forexRate,
			$record['converted_amount'], $record['product_id'], $record['unit_id'], $debitWarehouseId, $record['subject_id'], $record['department_id']);

			self::insertDetailCorrespondence($newEntryId, $listDefaultCredit[0]['account_id'],
			self::DEFAULT_CREDIT_ACCOUNT_TYPE, 0.00, $currencyId, $forexRate,
			0.00, $record['product_id'], $record['unit_id'], $creditWarehouseId, $record['subject_id'], $record['department_id']);
		}else{
			// khong co gia tri mac dinh
			$newEntryId = 0;
			return self::insertDetailEntry(&$newEntryId, $batchId, self::DEFAULT_NOT_DEFAULT_ACCOUNT_TYPE,
			self::DEFAULT_DEBIT_ACCOUNT_TYPE, $record['amount'], $currencyId, $forexRate,
			$record['converted_amount'], $record['product_id'], $record['unit_id'], $debitWarehouseId, $record['subject_id'], $record['department_id']);
		}
	}

	/**
	 * Insert list product into detail inventory voucher
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function insertDetailInventory($inventoryVoucherId, $records, $typeVote)
	{
		$inventoryVoucher = Quick::single('accountant/inventory_voucher')->cache()->getInventoryVoucherById($inventoryVoucherId);
		$arrBatch = Quick_Accountant_Remoter_BuyBilling::getBatchByVoucher($inventoryVoucher['voucher_id']);
		$batchId = $arrBatch[0]['batch_id'];

		$arrProduct = array();
		foreach($records as $record){
			// get default for product, don't accounting to this product
			$item = array();
			$item['inventory_voucher_id'] = $inventoryVoucherId;
			$item['product_id'] = $record['product_id'];
			$item['unit_id'] = $record['unit_id'];
			$item['price'] = $record['price'];
			$item['amount'] = 0.0;
			$item['converted_amount'] = 0.0;
			$item['in_voucher_id'] = 0;
			$arrProduct[] = $item;

			$entryTypeId = 0;
			$debitWarehouseId = 0;
			$creditWarehouseId = 0;
			if($typeVote == self::DEFAULT_INPUT_VOTE_TYPE){
				$entryTypeId = self::DEFAULT_INPUT_ENTRY_TYPE;
				$debitWarehouseId = $creditWarehouseId = $record['in_warehouse_id'];
			}elseif($typeVote == self::DEFAULT_OUTPUT_VOTE_TYPE){
				$entryTypeId = self::DEFAULT_OUTPUT_ENTRY_TYPE;
				$debitWarehouseId = $creditWarehouseId = $record['out_warehouse_id'];
			}else{
				$entryTypeId = self::DEFAULT_INTERNAL_ENTRY_TYPE;
				$debitWarehouseId = $record['in_warehouse_id'];
				$creditWarehouseId = $record['out_warehouse_id'];
			}
			$item['subject_id'] = $record['subject_id'];
			$item['department_id'] = $record['department_id'];
			self::autoAccountingForInventory($entryTypeId, $batchId, $item, $inventoryVoucher['currency_id'], $inventoryVoucher['forex_rate'], $debitWarehouseId, $creditWarehouseId);
		}
		return Quick::single('accountant/detail_inventory')->cache()->insertListProduct($arrProduct);
	}

	/**
	 * Retrieve detail inventory voucher by id
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function getDetailInventoryVoucher($inventoryVoucherId)
	{
		$detail = Quick::single('accountant/detail_inventory')->cache()->getDetailInventoryVoucherById($inventoryVoucherId);
		$i = 0;
		foreach($detail as $item){
			$detail[$i]['forex_rate'] = Quick_Number::formatNumber($item['forex_rate']);
			$detail[$i]['price'] = Quick_Number::formatNumber($item['price']);
			$detail[$i]['quantity'] = Quick_Number::formatNumber($item['quantity']);
			$detail[$i]['amount'] = Quick_Number::formatNumber($item['amount']);
			$detail[$i]['converted_amount'] = Quick_Number::formatNumber($item['converted_amount']);
			$detail[$i]['arr_unit_id'] = Quick::single('core/definition_relation_product_unit')->cache()->getOnlyUnitOfProduct($item['product_id']);
			$i++;
		}
		return $detail;
	}

	/**
	 * Delete list product of inventory voucher
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function deleteDetailInventory($inventoryVoucherId, $voucherId, $records)
	{
		return Quick::single('accountant/detail_inventory')->cache()->deleteListProduct($inventoryVoucherId, $voucherId, $records);
	}

	/**
	 * update/insert transaction entry
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function updateFieldOfTransactionEntry($batchId, $entryId, $field, $value,
	$debitOrCredit, $originalAmount, $currencyId, $forexRate, $productId, $unitId,
	$inWarehouseId, $outWarehouseId, $subjectId, $departmentId)
	{
		if(isset($entryId) && !empty($entryId)){
			if(($field == 'credit_account_id') ||
			($field == 'debit_account_id')){
				$field = 'master_account_id';
			}
			// update entry
			return Quick::single('accountant/transaction_entry')->cache()->updateFieldOfEntry($entryId, $field, $value);
		}else{
			// insert entry
			$warehouseId = 0;
			if($field == 'debit_account_id') {
				$debitOrCredit = self::DEFAULT_DEBIT_ACCOUNT_TYPE;
				$warehouseId = $inWarehouseId;
			}
			else if($field == 'credit_account_id') {
				$debitOrCredit = self::DEFAULT_CREDIT_ACCOUNT_TYPE;
				$warehouseId = $outWarehouseId;
			}

			$newEntryId = 0;
			return self::insertDetailEntry(&$newEntryId, $batchId, $value,
			$debitOrCredit, $originalAmount, $currencyId, $forexRate,
			$originalAmount * $forexRate, $productId, $unitId, $warehouseId, $subjectId, $departmentId);
		}
	}

	/**
	 * update/insert detail entry
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function updateFieldOfTransactionCorrespondence($correspondenceId, $entryId, $field, $value,
	$debitOrCredit, $originalAmount, $currencyId, $forexRate, $productId, $unitId,
	$inWarehouseId, $outWarehouseId, $subjectId, $departmentId)
	{
		if(isset($correspondenceId) && !empty($correspondenceId)){
			if(($field == 'credit_account_id') ||
			($field == 'debit_account_id')){
				$field = 'detail_account_id';
			}
			// update entry
			return Quick::single('accountant/transaction_correspondence')->cache()->updateFieldOfCorrespondenceEntry($correspondenceId, $field, $value);
		}else{
			// insert entry
			$warehouseId = 0;
			if($field == 'debit_account_id') {
				$debitOrCredit = self::DEFAULT_DEBIT_ACCOUNT_TYPE;
				$warehouseId = $inWarehouseId;
			}
			else if($field == 'credit_account_id') {
				$debitOrCredit = self::DEFAULT_CREDIT_ACCOUNT_TYPE;
				$warehouseId = $outWarehouseId;
			}

			return self::insertDetailCorrespondence($entryId, $value,
			$debitOrCredit, $originalAmount, $currencyId, $forexRate,
			$originalAmount * $forexRate, $productId, $unitId, $warehouseId, $subjectId, $departmentId);
		}
	}

	/**
	 * Retrieve update field by in_out of inventory voucher and auto accounting for detail
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function updateTypeVoteOfPurchase($inventoryVoucherId, $voucherId, $batchId, $field, $value)
	{
		// su dung rollback tai day
		//delete batch
		if(Quick::single('accountant/transaction_entry')->cache()->deleteTransactionEntryByBatchId($batchId)){
			// auto accounting for detail of inventory voucher
			$detail = array();
			$inventoryVoucher = Quick::single('accountant/inventory_voucher')->cache()->getInventoryVoucherById($inventoryVoucherId);
			$detail = Quick::single('accountant/detail_inventory')->cache()->getDetailInventoryVoucherById($inventoryVoucherId);
			$entryTypeId = 0;
			switch($value){
				case self::DEFAULT_INPUT_VOTE_TYPE:
					$entryTypeId = self::DEFAULT_INPUT_ENTRY_TYPE;
					break;
				case self::DEFAULT_OUTPUT_VOTE_TYPE:
					$entryTypeId = self::DEFAULT_OUTPUT_ENTRY_TYPE;
					break;
				case self::DEFAULT_INTERNAL_VOTE_TYPE:
					$entryTypeId = self::DEFAULT_INTERNAL_ENTRY_TYPE;
					break;
			}
			foreach($detail as $item){
				$item['subject_id'] = $inventoryVoucher['subject_id'];
				$item['department_id'] = $inventoryVoucher['department_id'];
				self::autoAccountingForInventory($entryTypeId, $batchId, $item, $inventoryVoucher['currency_id'], $inventoryVoucher['forex_rate'], 0, 0);
			}
			return Quick::single('accountant/inventory_voucher')->cache()->updateFieldOfInventoryVoucher($inventoryVoucherId, $batchId, $field, $value, null);
		}
		return false;
	}

	/**
	 * Retrieve update field of inventory voucher
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function updateFieldOfInventoryVoucher($inventoryVoucherId, $batchId, $field, $value, $convertCurrency)
	{
		return Quick::single('accountant/inventory_voucher')->cache()->updateFieldOfInventoryVoucher($inventoryVoucherId, $batchId, $field, $value, $convertCurrency);
	}

	/**
	 * Update field of detail inventory voucher
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function updateFieldOfDetailInventory($inventoryVoucherId, $voucherId, $recordId, $field, $value, $forexRate)
	{
		return Quick::single('accountant/detail_inventory')->cache()->updateFieldOfDetailInventory($inventoryVoucherId, $voucherId, $recordId, $field, $value, $forexRate);
	}
}