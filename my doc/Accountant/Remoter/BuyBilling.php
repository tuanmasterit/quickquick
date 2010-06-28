<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @author      trungpm
 */
class Quick_Accountant_Remoter_BuyBilling {

	const DEFAULT_TABLE_PRODUCT_TYPE 	= 3;
	const DEFAULT_TABLE_UNIT_TYPE	 	= 17;
	const DEFAULT_DEBIT_ACCOUNT_TYPE 	= -1;
	const DEFAULT_CREDIT_ACCOUNT_TYPE 	= 1;

	const DEFAULT_VAT_IMPORT_TYPE		= 4;
	const DEFAULT_VAT_EXCISE_TYPE 		= 2;
	const DEFAULT_VAT_TYPE 				= 1;

	const DEFAULT_PURCHASE_IMPORT_ENTRY_TYPE		= 1;
	const DEFAULT_PURCHASE_IMPORT_VAT_ENTRY_TYPE	= 2;
	const DEFAULT_PURCHASE_NOT_IMPORT_ENTRY_TYPE	= 3;

	const DEFAULT_EXECUTION_PURCHASE_INVOICE_TYPE	= 13;
	const DEFAULT_EXECUTION_ACCOUNTANT_TYPE			= 21;

	const DEFAULT_NOT_DEFAULT_ACCOUNT_TYPE 	= 1;
	const IS_DEFAULT = 1;
	/**
	 * Retrieve product list, limit, start
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function getListProduct($limit, $start, $name, &$total, $code)
	{
		$detail = Quick::single('core/definition_product')->cache()->getListProduct($limit, $start, $name, &$total, $code);
		$i = 0;
		foreach($detail as $item){
			$arrUnit = Quick::single('core/definition_relation_product_unit')->cache()->getOnlyUnitOfProduct($item['product_id']);
			$j = 0;
			foreach($arrUnit as $unit){
				$arrUnit[$j]['default_purchase_price'] = Quick_Number::formatNumber($unit['default_purchase_price']);
				$arrUnit[$j]['default_sales_price'] = Quick_Number::formatNumber($unit['default_sales_price']);
				$arrUnit[$j]['default_inventory_price'] = Quick_Number::formatNumber($unit['default_inventory_price']);
				$j++;
			}
			$detail[$i]['arr_unit_id'] = $arrUnit;
			$i++;
		}
		return $detail;
	}

	/**
	 * Retrieve list purchase invoice
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function getListPurchaseInvoice($limit, $start, $invoiceNumber, $fromDate, $toDate, $supplier, &$total)
	{
		$detail = Quick::single('accountant/purchase_invoice')->cache()->getListPurchaseInvoice($limit, $start, $invoiceNumber, $fromDate, $toDate, $supplier, &$total);
		$i = 0;
		foreach($detail as $item){
			$detail[$i]['arr_batch'] = self::getBatchByVoucher($detail[$i]['voucher_id']);
			$detail[$i]['forex_rate'] = Quick_Number::formatNumber($item['forex_rate']);
			$detail[$i]['total_purchase_amount'] = Quick_Number::formatNumber($item['total_purchase_amount']);
			$i++;
		}
		return $detail;
	}

	/**
	 * Retrieve detail purchase invoice by id
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function getDetailPurchaseInvoiceById($purchaseInvoiceId)
	{
		$detail = Quick::single('accountant/detail_purchase')->cache()->getDetailPurchaseInvoiceById($purchaseInvoiceId);
		$totalAmount = 0.0;
		$totalConvertAmount = 0.0;
		$totalImport = 0.0;
		$totalExcise = 0.0;
		$totalVat = 0.0;
		$total = 0.0;
		$i = 0;
		foreach($detail as $item){
			$detail[$i]['forex_rate'] = Quick_Number::formatNumber($item['forex_rate']);
			$detail[$i]['price'] = Quick_Number::formatNumber($item['price']);
			$detail[$i]['quantity'] = Quick_Number::formatNumber($item['quantity']);
			$detail[$i]['amount'] = Quick_Number::formatNumber($item['amount']);
			$detail[$i]['converted_amount'] = Quick_Number::formatNumber($item['converted_amount']);
			$detail[$i]['import_amount'] = Quick_Number::formatNumber($item['import_amount']);
			$detail[$i]['excise_amount'] = Quick_Number::formatNumber($item['excise_amount']);
			$detail[$i]['vat_amount'] = Quick_Number::formatNumber($item['vat_amount']);
			$detail[$i]['total_amount'] = Quick_Number::formatNumber($item['total_amount']);
			$detail[$i]['arr_unit_id'] = Quick::single('core/definition_relation_product_unit')->cache()->getOnlyUnitOfProduct($item['product_id']);
			$detail[$i]['arr_import_rate_id'] = Quick::single('accountant/relation_tax')->cache()->getRelationTaxOfProduct($item['product_id'], self::DEFAULT_VAT_IMPORT_TYPE);
			$detail[$i]['arr_excise_rate_id'] = Quick::single('accountant/relation_tax')->cache()->getRelationTaxOfProduct($item['product_id'], self::DEFAULT_VAT_EXCISE_TYPE);
			$detail[$i]['arr_vat_rate_id'] = Quick::single('accountant/relation_tax')->cache()->getRelationTaxOfProduct($item['product_id'], self::DEFAULT_VAT_TYPE);
			$totalAmount += $item['amount'];
			$totalConvertAmount += $item['converted_amount'];
			$totalImport += $item['import_amount'];
			$totalExcise += $item['excise_amount'];
			$totalVat += $item['vat_amount'];
			$total += $item['total_amount'];
			$i++;
		}
		/*$detail[] = array(
			'product_id' => -1,
			'price' => 'Summary',
			'quantity' => 'Qty',
			'amount' => $totalAmount.'/s',
			'converted_amount' => $totalConvertAmount.'/s',
			'import_amount' => $totalImport.'/s',
			'excise_amount' => $totalExcise.'/s',
			'vat_amount' => $totalVat.'/s',
			'total_amount' => $total.'/s'
			);*/
		return $detail;
	}

	/**
	 * Retrieve list tax rate by tax id
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function getTaxRateByTaxId($taxId)
	{
		return Quick::single('accountant/tax_rate')->cache()->getTaxRateByTaxId($taxId);
	}

	/**
	 * Retrieve update field of purchase invoice
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function updateFieldOfPurchaseInvoice($purchaseInvoiceId, $field, $value, $convertCurrency)
	{
		return Quick::single('accountant/purchase_invoice')->cache()->updateFieldOfPurchaseInvoice($purchaseInvoiceId, $field, $value, $convertCurrency);
	}

	/**
	 * Retrieve update field of detail purchase invoice
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function updateFieldOfDetailPurchase($purchaseInvoiceId, $productId, $field, $value, $forexRate)
	{
		return Quick::single('accountant/detail_purchase')->cache()->updateFieldOfDetailPurchase($purchaseInvoiceId, $productId, $field, $value, $forexRate);
	}

	/**
	 * Retrieve all currency
	 * @author	trungpm
	 * @return array
	 */
	public static function getCurrencyWithForexRate($currencyId, $convertCurrency)
	{
		$detail = Quick::single('core/definition_currency')->cache()->getCurrencyWithForexRate($currencyId, $convertCurrency);
		$i = 0;
		foreach($detail as $item){
			$detail[$i]['forex_rate'] = Quick_Number::formatNumber($item['forex_rate']);
			$i++;
		}
		return $detail;
	}

	/**
	 * Retrieve subject by type with forex rate
	 * @author	trungpm
	 * @return array
	 */
	public static function getSupplierWithForexRate($supplierId, $convertCurrency)
	{
		$detail = Quick::single('core/definition_subject')->cache()->getSupplierWithForexRate($supplierId, $convertCurrency);
		$i = 0;
		foreach($detail as $item){
			$detail[$i]['forex_rate'] = Quick_Number::formatNumber($item['forex_rate']);
			$i++;
		}
		return $detail;
	}

	/**
	 * Insert purchase invoice
	 * @author	trungpm
	 * @return array
	 */
	public static function insertPurchaseInvoice($invoiceNumber, $invoiceDate,
	$suppId, $suppName, $suppAddress, $suppTaxCode, $suppContact, $currencyId, $forexRate, $byImport, $currentPeriodId)
	{
		// insert voucher and batch to accounting for purchase invoice
		$voucher = array(
			'execution_id' => self::DEFAULT_EXECUTION_PURCHASE_INVOICE_TYPE,
			'period_id' => $currentPeriodId,
			'voucher_number' => $invoiceNumber,
			'voucher_date' => $invoiceDate.' '.date('H:i:s'),
			'created_by_userid' => Quick::session()->userId,
			'date_entered' => Quick_Date::now()->toSQLString(),
			'last_modified_by_userid' => Quick::session()->userId,
			'date_last_modified' => Quick_Date::now()->toSQLString()
		);
		$newVoucherId = Quick::single('accountant/transaction_voucher')->cache()->insertTransactionVoucher($voucher);
		if($newVoucherId){
			$convertedDate = Quick_Date::convertSQLDateToPHP('d/m/Y', $invoiceDate);
			$byImport = isset($byImport) ? $byImport : 0;
			$status = false;
			$arrBatch = array();
			if($byImport){
				$batch1 = array(
					'voucher_id' => $newVoucherId,
					'execution_id' => self::DEFAULT_EXECUTION_ACCOUNTANT_TYPE,
					'entry_type_id' => self::DEFAULT_PURCHASE_IMPORT_ENTRY_TYPE,
					'batch_note' => 'Hóa đơn mua hàng nhập khẩu số "'. $invoiceNumber .'", ngày "'. $convertedDate .'", "' . $suppName . '"'
					);
					$batch2 = array(
					'voucher_id' => $newVoucherId,
					'execution_id' => self::DEFAULT_EXECUTION_ACCOUNTANT_TYPE,
					'entry_type_id' => self::DEFAULT_PURCHASE_IMPORT_VAT_ENTRY_TYPE,
					'batch_note' => 'Thuế GTGT hóa đơn mua hàng nhập khẩu số "'. $invoiceNumber .'", ngày "'. $convertedDate .'", "' . $suppName . '"'
					);
					$status = !Quick::single('accountant/transaction_batch')->cache()->insertListBatch(array($batch1, $batch2));
			}else{
				$batch = array(
					'voucher_id' => $newVoucherId,
					'execution_id' => self::DEFAULT_EXECUTION_ACCOUNTANT_TYPE,
					'entry_type_id' => self::DEFAULT_PURCHASE_NOT_IMPORT_ENTRY_TYPE,
					'batch_note' => 'Hóa đơn mua hàng nội địa số "'. $invoiceNumber .'", ngày "'. $convertedDate .'", "' . $suppName . '"'
					);
					$newBatchId = Quick::single('accountant/transaction_batch')->cache()->insertBatch($batch);
					$status = !$newBatchId;
					if($newBatchId){
						$temBatch = array();
						$temBatch['batch_id'] = $newBatchId;
						$temBatch['batch_note'] = 'Hóa đơn mua hàng nội địa số "'. $invoiceNumber .'", ngày "'. $convertedDate .'", "' . $suppName . '"';
						$temBatch['entry_type_id'] = self::DEFAULT_PURCHASE_NOT_IMPORT_ENTRY_TYPE;
						$arrBatch[] = $temBatch;
					}
			}
			if(!$status){
				$purchase = array(
					'voucher_id' => $newVoucherId,
					'purchase_invoice_number' => $invoiceNumber,
					'purchase_invoice_date' => $invoiceDate.' '.date('H:i:s'),
					'supplier_id' => $suppId,
					'supplier_name' => $suppName,
					'supplier_address' => $suppAddress,
					'supplier_tax_code' => $suppTaxCode,
					'supplier_contact' => isset($suppContact)?$suppContact:'',
					'currency_id' => $currencyId,
					'forex_rate' => $forexRate,
					'by_import' => $byImport,
					'description' => '',
					'created_by_userid' => Quick::session()->userId,
					'date_entered' => Quick_Date::now()->toSQLString(),
					'last_modified_by_userid' => Quick::session()->userId,
					'date_last_modified' => Quick_Date::now()->toSQLString()
				);
				$newPurchaseId = Quick::single('accountant/purchase_invoice')->cache()->insertPurchaseInvoice($purchase);
				if($newPurchaseId){
					$purchase['total_purchase_amount'] = Quick_Number::formatNumber('0.00');
					$purchase['purchase_invoice_id'] = $newPurchaseId;
					$purchase['period_id'] = $currentPeriodId;
					$purchase['arr_batch'] = $arrBatch;
					return $purchase;
				}
				return false;
			}else
			return false;
		}else
		return false;
	}

	/**
	 * Retrieve update field by import of purchase invoice and auto accounting for detail
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function updateByImportOfPurchase($purchaseInvoiceId, $voucherId, $field, $value)
	{
		// xoa batch voi voucher id
		$xoabatch = Quick::single('accountant/transaction_batch')->cache()->deleteBatchWithVoucherId($voucherId);

		$purchaseInvoice = Quick::single('accountant/purchase_invoice')->cache()->getPurchaseInvoiceById($purchaseInvoiceId);
		$detailPurchaseInvoice = Quick::single('accountant/detail_purchase')->cache()->getDetailPurchaseById($purchaseInvoiceId);
		$arrDate = explode(' ', $purchaseInvoice['purchase_invoice_date']);
		$convertedDate = Quick_Date::convertSQLDateToPHP('d/m/Y', $arrDate[0]);
		//print_r($purchaseInvoice);
		// them batch voi by import cua purchase invoice
		$arrBatch = array();
		if($value){
			// hach toan tu dong cho luoi thu nhat
			$note = 'Hóa đơn mua hàng nhập khẩu số "'. $purchaseInvoice['purchase_invoice_number']
			.'", ngày "'. $convertedDate .'", "' . $purchaseInvoice['supplier_name'] . '"';
			$batch = array(
				'voucher_id' => $voucherId,
				'execution_id' => self::DEFAULT_EXECUTION_ACCOUNTANT_TYPE,
				'entry_type_id' => self::DEFAULT_PURCHASE_IMPORT_ENTRY_TYPE,
				'batch_note' => $note);
			$newBatchId = Quick::single('accountant/transaction_batch')->cache()->insertBatch($batch);
			// hach toan tu dong cho tung dong
			foreach($detailPurchaseInvoice as $item){
				self::autoAccountingForPurchase(self::DEFAULT_PURCHASE_IMPORT_ENTRY_TYPE, $newBatchId, $item, $purchaseInvoice['currency_id'], $purchaseInvoice['forex_rate']);
			}
			$arrBatch[] = array(
				'batch_id' => $newBatchId,
				'batch_note' => $note,
				'entry_type_id' => self::DEFAULT_PURCHASE_IMPORT_ENTRY_TYPE
			);
			// hach toan tu dong cho luoi thu hai
			$note = 'Thuế GTGT hóa đơn mua hàng nhập khẩu số "'. $purchaseInvoice['purchase_invoice_number']
			.'", ngày "'. $convertedDate .'", "' . $purchaseInvoice['supplier_name'] . '"';
			$batch = array(
				'voucher_id' => $voucherId,
				'execution_id' => self::DEFAULT_EXECUTION_ACCOUNTANT_TYPE,
				'entry_type_id' => self::DEFAULT_PURCHASE_IMPORT_VAT_ENTRY_TYPE,
				'batch_note' => $note);
			$newBatchId = Quick::single('accountant/transaction_batch')->cache()->insertBatch($batch);
			// hach toan tu dong cho tung dong
			foreach($detailPurchaseInvoice as $item){
				self::autoAccountingForPurchase(self::DEFAULT_PURCHASE_IMPORT_VAT_ENTRY_TYPE, $newBatchId, $item, $purchaseInvoice['currency_id'], $purchaseInvoice['forex_rate']);
			}
			$arrBatch[] = array(
				'batch_id' => $newBatchId,
				'batch_note' => $note,
				'entry_type_id' => self::DEFAULT_PURCHASE_IMPORT_VAT_ENTRY_TYPE
			);
		}else{
			$note = 'Hóa đơn mua hàng nội địa số "'. $purchaseInvoice['purchase_invoice_number']
			.'", ngày "'. $convertedDate .'", "' . $purchaseInvoice['supplier_name'] . '"';
			$batch = array(
				'voucher_id' => $voucherId,
				'execution_id' => self::DEFAULT_EXECUTION_ACCOUNTANT_TYPE,
				'entry_type_id' => self::DEFAULT_PURCHASE_NOT_IMPORT_ENTRY_TYPE,
				'batch_note' => $note);
			$newBatchId = Quick::single('accountant/transaction_batch')->cache()->insertBatch($batch);
			// hach toan tu dong cho tung dong
			foreach($detailPurchaseInvoice as $item){
				Quick::single('accountant/detail_purchase')->cache()->calculateFieldsOfDetail(
				$purchaseInvoiceId, $item['product_id'], $item['unit_id'], $purchaseInvoice['forex_rate'],
				$item['quantity'], $item['price'], 0, 0.0, 0, 0.0, $item['vat_rate_id'], $item['vat_rate']);
				self::autoAccountingForPurchase(self::DEFAULT_PURCHASE_NOT_IMPORT_ENTRY_TYPE, $newBatchId, $item, $purchaseInvoice['currency_id'], $purchaseInvoice['forex_rate']);
			}
			$arrBatch[] = array(
				'batch_id' => $newBatchId,
				'batch_note' => $note,
				'entry_type_id' => self::DEFAULT_PURCHASE_NOT_IMPORT_ENTRY_TYPE
			);
		}
		// hach toan tu dong lai dua theo chi tiet cua purchse invoice va bang debit or credit

		// cap nhat lai purchase invoice
		if(Quick::single('accountant/purchase_invoice')->cache()->updateFieldOfPurchaseInvoice($purchaseInvoiceId, $field, $value, null)){
			return $arrBatch;
		}
		return false;
	}

	/**
	 * Auto accounting for record of detail purchase invoice
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function autoAccountingForPurchase($entryTypeId, $batchId, $record, $currencyId, $forexRate)
	{
		$listDefaultDebit = Quick::single('accountant/entry_debit')->cache()->getDebitAccount($entryTypeId, self::IS_DEFAULT);
		$listDefaultCredit = Quick::single('accountant/entry_credit')->cache()->getCreditAccount($entryTypeId, self::IS_DEFAULT);

		if((count($listDefaultCredit) > 1) && (count($listDefaultDebit) == 1)){
			// truong hop 1 no , nhieu co
			$newEntryId = 0;
			self::insertDetailEntry(&$newEntryId, $batchId, $listDefaultDebit[0]['account_id'],
			self::DEFAULT_DEBIT_ACCOUNT_TYPE, $record['amount'], $currencyId, $forexRate,
			$record['converted_amount'], $record['product_id'], $record['unit_id']);

			foreach($listDefaultCredit as $item){
				self::insertDetailCorrespondence($newEntryId, $item['account_id'],
				self::DEFAULT_CREDIT_ACCOUNT_TYPE, 0.00, $currencyId, $forexRate,
				0.00, $record['product_id'], $record['unit_id']);
			}
		}elseif((count($listDefaultDebit) > 1) && (count($listDefaultCredit) == 1)){
			// truong hop 1 co , nhieu no
			$newEntryId = 0;
			self::insertDetailEntry(&$newEntryId, $batchId, $listDefaultCredit[0]['account_id'],
			self::DEFAULT_CREDIT_ACCOUNT_TYPE, $record['amount'], $currencyId, $forexRate,
			$record['converted_amount'], $record['product_id'], $record['unit_id']);

			foreach($listDefaultDebit as $item){
				self::insertDetailCorrespondence($newEntryId, $item['account_id'],
				self::DEFAULT_DEBIT_ACCOUNT_TYPE, 0.00, $currencyId, $forexRate,
				0.00, $record['product_id'], $record['unit_id']);
			}
		}elseif((count($listDefaultDebit) == 1) && (count($listDefaultCredit) == 1)){
			// truong hop 1 co , 1 no
			$newEntryId = 0;
			self::insertDetailEntry(&$newEntryId, $batchId, $listDefaultDebit[0]['account_id'],
			self::DEFAULT_DEBIT_ACCOUNT_TYPE, $record['amount'], $currencyId, $forexRate,
			$record['converted_amount'], $record['product_id'], $record['unit_id']);

			self::insertDetailCorrespondence($newEntryId, $listDefaultCredit[0]['account_id'],
			self::DEFAULT_CREDIT_ACCOUNT_TYPE, 0.00, $currencyId, $forexRate,
			0.00, $record['product_id'], $record['unit_id']);
		}else{
			// khong co gia tri mac dinh
			$newEntryId = 0;
			return self::insertDetailEntry(&$newEntryId, $batchId, self::DEFAULT_NOT_DEFAULT_ACCOUNT_TYPE,
			self::DEFAULT_DEBIT_ACCOUNT_TYPE, $record['amount'], $currencyId, $forexRate,
			$record['converted_amount'], $record['product_id'], $record['unit_id']);

		}
	}

	/**
	 * insert detail entry with entry id, product id, unit id
	 * @author	trungpm
	 * @return array
	 */
	public static function insertDetailEntry(&$newEntryId, $batchId, $masterId, $debitOrCredit,
	$originalAmount, $currencyId, $forexRate, $convertedAmount, $productId, $unitId)
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
			if(Quick::single('accountant/detail_entry')->cache()->insertDetailEntryWithArray(array($product, $unit))){
				$entry['entry_id'] = $newEntryId;
				return $entry;
			}
			return false;
		}
		else return false;
	}

	/**
	 * insert detail correspondence with entry id, product id, unit id
	 * @author	trungpm
	 * @return array
	 */
	public static function insertDetailCorrespondence($entryId, $detailId, $debitOrCredit,
	$originalAmount, $currencyId, $forexRate, $convertedAmount, $productId, $unitId)
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
			if(Quick::single('accountant/detail_correspondence')->cache()->insertDetailCorrespondenceWithArray(array($product, $unit))){
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
	 * Retrieve subject by type with forex rate
	 * @author	trungpm
	 * @return array
	 */
	public static function getEntryDebitOfPurchase($batchId)
	{
		$result = array();
		$detailEntry = Quick::single('accountant/transaction_entry')->cache()->getDetailEntryByBatchId($batchId);
		$i;
		for($i = 0; $i < count($detailEntry) ; $i++){
			$detailEntry[$i]['id'] =
			$detailEntry[$i]['product_id'].'_'.
			$detailEntry[$i]['unit_id'].'_'.
			$detailEntry[$i]['entry_id'].'_0';
			if($detailEntry[$i]['debit_credit'] == 1){
				$detailEntry[$i]['credit_account_id'] = $detailEntry[$i]['master_account_id'];
				$detailEntry[$i]['debit_account_id'] = null;
			}elseif($detailEntry[$i]['debit_credit'] == -1){
				$detailEntry[$i]['debit_account_id'] = $detailEntry[$i]['master_account_id'];
				$detailEntry[$i]['credit_account_id'] = null;
			}
			$detailEntry[$i]['master_type'] = true;

			$detailEntry[$i]['original_amount'] = Quick_Number::formatNumber($detailEntry[$i]['original_amount']);
			$detailEntry[$i]['forex_rate'] = Quick_Number::formatNumber($detailEntry[$i]['forex_rate']);
			$detailEntry[$i]['converted_amount'] = Quick_Number::formatNumber($detailEntry[$i]['converted_amount']);
			//$detailEntry[$i]['correspondence_id'] = 0;
			$result[] = $detailEntry[$i];
			$detailCorrespondence = Quick::single('accountant/transaction_correspondence')->cache()
			->getDetailCorrespondenceByEntryId($detailEntry[$i]['entry_id']);
			for($j = 0; $j < count($detailCorrespondence) ; $j++){
				$detailCorrespondence[$j]['id'] =
				$detailEntry[$i]['product_id'].'_'.
				$detailEntry[$i]['unit_id'].'_'.
				$detailEntry[$i]['entry_id'].'_'.
				$detailCorrespondence[$j]['correspondence_id'];

				if($detailCorrespondence[$j]['debit_credit'] == 1){
					$detailCorrespondence[$j]['credit_account_id'] = $detailCorrespondence[$j]['detail_account_id'];
					$detailCorrespondence[$j]['debit_account_id'] = null;
				}elseif($detailCorrespondence[$j]['debit_credit'] == -1){
					$detailCorrespondence[$j]['debit_account_id'] = $detailCorrespondence[$j]['detail_account_id'];
					$detailCorrespondence[$j]['credit_account_id'] = null;
				}
				$detailCorrespondence[$j]['master_type'] = false;

				$detailCorrespondence[$j]['entry_id'] = $detailEntry[$i]['entry_id'];
				$detailCorrespondence[$j]['product_id'] = $detailEntry[$i]['product_id'];
				$detailCorrespondence[$j]['product_unit_name'] = $detailEntry[$i]['product_unit_name'];
				$detailCorrespondence[$j]['detail_purchase_id'] = $detailEntry[$i]['detail_purchase_id'];

				$detailCorrespondence[$j]['original_amount'] = Quick_Number::formatNumber($detailCorrespondence[$j]['original_amount']);
				$detailCorrespondence[$j]['converted_amount'] = Quick_Number::formatNumber($detailCorrespondence[$j]['converted_amount']);
				$result[] = $detailCorrespondence[$j];
			}
		}
		//print_r($result);
		return $result;
	}

	/**
	 * Retrieve entry debit account with entry type id
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function getDebitAccount($entryTypeId)
	{
		return Quick::single('accountant/entry_debit')->cache()->getDebitAccount($entryTypeId);
	}

	/**
	 * Retrieve entry credit account with entry type id
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function getCreditAccount($entryTypeId)
	{
		return Quick::single('accountant/entry_credit')->cache()->getCreditAccount($entryTypeId);
	}

	/**
	 * update/insert transaction entry
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function updateFieldOfTransactionEntry($batchId, $entryId, $field, $value,
	$debitOrCredit, $originalAmount, $currencyId, $forexRate, $productId, $unitId)
	{
		if(isset($entryId) && !empty($entryId)){
			if(($field == 'debit_account_id') || ($field == 'credit_account_id')){
				$field = 'master_account_id';
			}
			// update entry
			return Quick::single('accountant/transaction_entry')->cache()->updateFieldOfEntry($entryId, $field, $value);
		}else{
			// insert entry
			if($field == 'debit_account_id') $debitOrCredit = self::DEFAULT_DEBIT_ACCOUNT_TYPE;
			elseif($field == 'credit_account_id') $debitOrCredit = self::DEFAULT_CREDIT_ACCOUNT_TYPE;

			$newEntryId = 0;
			return self::insertDetailEntry(&$newEntryId, $batchId, $value,
			$debitOrCredit, $originalAmount, $currencyId, $forexRate,
			$originalAmount * $forexRate, $productId, $unitId);
		}
	}

	/**
	 * update/insert detail entry
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function updateFieldOfTransactionCorrespondence($correspondenceId, $entryId, $field, $value,
	$debitOrCredit, $originalAmount, $currencyId, $forexRate, $productId, $unitId)
	{
		if(isset($correspondenceId) && !empty($correspondenceId)){
			if(($field == 'debit_account_id') || ($field == 'credit_account_id')){
				$field = 'detail_account_id';
			}
			// update entry
			return Quick::single('accountant/transaction_correspondence')->cache()->updateFieldOfCorrespondenceEntry($correspondenceId, $field, $value);
		}else{
			// insert entry
			if($field == 'debit_account_id') $debitOrCredit = self::DEFAULT_DEBIT_ACCOUNT_TYPE;
			elseif($field == 'credit_account_id') $debitOrCredit = self::DEFAULT_CREDIT_ACCOUNT_TYPE;

			return self::insertDetailCorrespondence($entryId, $value,
			$debitOrCredit, $originalAmount, $currencyId, $forexRate,
			$originalAmount * $forexRate, $productId, $unitId);
		}
	}

	/**
	 * Retrieve transaction batch by voucher id
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function getBatchByVoucher($voucherId)
	{
		return Quick::single('accountant/transaction_batch')->cache()->getBatchByVoucher($voucherId);
	}

	/**
	 * Insert list product into detail purchase invoice
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function insertDetailPurchase($purchaseInvoiceId, $records)
	{
		$purchaseInvoice = Quick::single('accountant/purchase_invoice')->cache()->getPurchaseInvoiceById($purchaseInvoiceId);
		$arrBatch = self::getBatchByVoucher($purchaseInvoice['voucher_id']);

		$arrProduct = array();
		foreach($records as $record){
			// get default for product, don't accounting to this product
			$item = array();
			$item['purchase_invoice_id'] = $purchaseInvoiceId;
			$item['product_id'] = $record['product_id'];
			$item['unit_id'] = $record['unit_id'];
			$item['price'] = $record['price'];
			$item['amount'] = 0.0;
			$item['converted_amount'] = 0.0;
			$arrProduct[] = $item;

			// hach toan tu dong cho san pham moi
			if($purchaseInvoice['by_import'] == 1){
				foreach($arrBatch as $batch){
					if($batch['entry_type_id'] == self::DEFAULT_PURCHASE_IMPORT_ENTRY_TYPE){
						self::autoAccountingForPurchase(self::DEFAULT_PURCHASE_IMPORT_ENTRY_TYPE,
						$batch['batch_id'], $item,
						$purchaseInvoice['currency_id'], $purchaseInvoice['forex_rate']);
					}elseif($batch['entry_type_id'] == self::DEFAULT_PURCHASE_IMPORT_VAT_ENTRY_TYPE){
						self::autoAccountingForPurchase(self::DEFAULT_PURCHASE_IMPORT_VAT_ENTRY_TYPE,
						$batch['batch_id'], $item,
						$purchaseInvoice['currency_id'], $purchaseInvoice['forex_rate']);
					}
				}
			}else{
				if($arrBatch[0]['entry_type_id'] == self::DEFAULT_PURCHASE_NOT_IMPORT_ENTRY_TYPE){
					self::autoAccountingForPurchase(self::DEFAULT_PURCHASE_NOT_IMPORT_ENTRY_TYPE,
					$arrBatch[0]['batch_id'], $item,
					$purchaseInvoice['currency_id'], $purchaseInvoice['forex_rate']);
				}
			}
		}
		return Quick::single('accountant/detail_purchase')->cache()->insertListProduct($arrProduct);
	}

	/**
	 * Delete list product of detail purchase invoice
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function deleteDetailPurchase($purchaseInvoiceId, $voucherId, $records)
	{
		return Quick::single('accountant/detail_purchase')->cache()->deleteListProduct($purchaseInvoiceId, $voucherId, $records);
	}

	/**
	 * Delete transaction entry with id
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function deleteTransactionEntry($arrEntryId, $arrCorrespondenceId)
	{
		foreach($arrEntryId as $entry){
			Quick::single('accountant/transaction_entry')->cache()->deleteTransactionEntryById($entry['entryId']);
		}
		foreach($arrCorrespondenceId as $correspondence){
			Quick::single('accountant/transaction_correspondence')->cache()->deleteTransactionCorrespondenceById($correspondence['correspondenceId']);
		}
		return true;
	}

	/**
	 * Delete purchase invoice with id
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function deletePurchaseInvoice($arrRecord)
	{
		foreach($arrRecord as $record){
			Quick::single('accountant/purchase_invoice')->cache()->deletePurchaseInvoice($record['purchase_invoice_id']);
		}
		return true;
	}
}
