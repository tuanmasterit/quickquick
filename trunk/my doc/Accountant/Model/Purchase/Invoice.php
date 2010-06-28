<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Accountant_Model_Purchase_Invoice extends Quick_Db_Table
{
	protected $_name 								= 'accountant_purchase_invoice';
	protected $_TABLE_ACCOUNTANT_DETAIL_PURCHASE	= 'accountant_detail_purchase';
	protected $_TABLE_DEFINITION_LIST_CURRENCY		= 'definition_list_currency';
	protected $_TABLE_DEFINITION_LIST_UNIT			= 'definition_list_unit';
	protected $_TABLE_DEFINITION_LIST_PRODUCT		= 'definition_list_product';
	protected $_TABLE_ACCOUNTANT_TRANSACTION_VOUCHER= 'accountant_transaction_voucher';
	protected $_TABLE_ACCOUNTANT_TRANSACTION_BATCH	= 'accountant_transaction_batch';
	protected $_TABLE_ACCOUNTANT_TRANSACTION_ENTRY	= 'accountant_transaction_entry';

	/**
	 * Retrieve list purchase invoice
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public function getListPurchaseInvoice($limit, $start, $invoiceNumber, $fromDate, $toDate, $supplier, &$total)
	{
		$query = "SELECT COUNT(`purchase_invoice_id`) FROM `". $this->_name . "` ";
		$where = "WHERE `purchase_invoice_number` LIKE ('%$invoiceNumber%')";
		if(isset($supplier) && !empty($supplier) && ($supplier > 0)){
			$where .= " AND `supplier_id` = $supplier";
		}
		if(isset($fromDate) && !empty($fromDate)){
			$where .= " AND `purchase_invoice_date` >= '$fromDate'";
		}
		if(isset($toDate) && !empty($toDate)){
			$where .= " AND `purchase_invoice_date` <= '$toDate'";
		}
		$where .= Quick_Miscfunction::getStrPagingSize($limit, $start);
		$query .= $where;
		$total = $this->getAdapter()->fetchOne($query);

		$query = "SELECT pchin.*, dtc.currency_name,
						 DATE_FORMAT(pchin.purchase_invoice_date, '%Y/%m/%d') AS purchase_invoice_date_format,
						 IF(pchin.by_import > 0, pchin.by_import, '') AS by_import_format,
						 lsb.total_purchase_amount, atv.period_id   
				  FROM `". $this->_name ."` AS pchin  
				  LEFT JOIN (SELECT purchase_invoice_id, SUM( total_amount ) AS total_purchase_amount 
						FROM `" . $this->_TABLE_ACCOUNTANT_DETAIL_PURCHASE ."` 
						GROUP BY purchase_invoice_id) AS lsb 
				  ON lsb.purchase_invoice_id = pchin.purchase_invoice_id 
				  LEFT JOIN `". $this->_TABLE_ACCOUNTANT_TRANSACTION_VOUCHER ."` AS atv  
				  ON atv.voucher_id = pchin.voucher_id 
				  LEFT JOIN `". $this->_TABLE_DEFINITION_LIST_CURRENCY ."` AS dtc 
				  ON dtc.currency_id = pchin.currency_id ";
		$query .= $where;
		return $this->getAdapter()->fetchAll($query);
	}

	/**
	 * Update field of Purchase Invoice by id
	 * @author	trungpm
	 * @return array
	 */
	public function updateFieldOfPurchaseInvoice($purchaseInvoiceId, $field, $value, $convertCurrency)
	{
		$totalAmount = 0.0;

		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('purchase_invoice_id  = ?', $purchaseInvoiceId)));
		$voucherID = $row['voucher_id'];
		$currencyId = $row['currency_id'];
		$forexRate = $row['forex_rate'];

		if (isset($row)) {
			$row = array(
				'last_modified_by_userid' => Quick::session()->userId,
				'date_last_modified' => Quick_Date::now()->toSQLString()
			);
			if($field == 'supplier_id'){
				$subject = Quick::single('core/definition_subject')->cache()->getSupplierWithForexRate($value, $convertCurrency);
				$row[$field] = $value;
				$row['supplier_name'] = $subject['subject_name'];
				$row['supplier_address'] = $subject['subject_address'];
				$row['supplier_tax_code'] = $subject['subject_tax_code'];
				$row['supplier_contact'] = '';
				$forex_rate = $subject['forex_rate'];
				$changeCurrency = false;
				if(isset($forex_rate) && !empty($forex_rate)){
					$changeCurrency = true;
					$row['currency_id'] = $subject['currency_id'];
					$row['forex_rate'] = $forex_rate;
					$this->updateDetailWithForexRate($purchaseInvoiceId, $forex_rate, &$totalAmount);
				}else{
					$row['currency_id'] = $currencyId;
					$row['forex_rate'] = $forexRate;
				}
				if($this->update($row, $db->quoteInto('purchase_invoice_id = ?', $purchaseInvoiceId))){
					$row['change_currency'] = $changeCurrency;
					$row['forex_rate'] = Quick_Number::formatNumber($row['forex_rate']);
					$row['total_purchase_amount'] = Quick_Number::formatNumber($totalAmount);
					return $row;
				}
			}elseif($field == 'purchase_invoice_date'){
				$row[$field] = $value.' '.date("H:i:s");
			}elseif($field == 'forex_rate'){
				$row[$field] = $value;

				// update transaction entry of purchase invoice
				$transactionEntry = $this->getTransactionEntryOfPurchaseInvoiceId($purchaseInvoiceId, $voucherID, null, null);
				foreach($transactionEntry as $item){
					$item[$field] = $value;
					$item['converted_amount'] = $item['original_amount'] * $value;
					Quick::single('accountant/transaction_entry')->cache()->updateRecordTransactionEntry($item, $item['entry_id']);

					$transactionCorrespondence = Quick::single('accountant/transaction_correspondence')->cache()->getTransactionCorrespondenceByEntryId($item['entry_id']);
					foreach($transactionCorrespondence as $itemCorr){
						$itemCorr[$field] = $value;
						$itemCorr['original_amount'] = 0.0;
						$itemCorr['converted_amount'] = 0.0;
						Quick::single('accountant/transaction_correspondence')->cache()->updateRecordTransactionCorrespondence($itemCorr, $itemCorr['correspondence_id']);
					}
				}
				// end update transaction entry

				$this->updateDetailWithForexRate($purchaseInvoiceId, $value, &$totalAmount);
				if($this->update($row, $db->quoteInto('purchase_invoice_id = ?', $purchaseInvoiceId))){
					$row['change_currency'] = true;
					$row['currency_id'] = $currencyId;
					$row['forex_rate'] = Quick_Number::formatNumber($value);
					$row['total_purchase_amount'] = Quick_Number::formatNumber($totalAmount);
				}
				return $row;
			}elseif($field == 'currency_id'){
				$currency = Quick::single('core/definition_currency')->cache()->getCurrencyWithForexRate($value, $convertCurrency);
				$forex_rate = $currency['forex_rate'];
				$changeCurrency = false;

				if(isset($forex_rate) && !empty($forex_rate)){
					// update transaction entry of purchase invoice
					$transactionEntry = $this->getTransactionEntryOfPurchaseInvoiceId($purchaseInvoiceId, $voucherID, null, null);
					foreach($transactionEntry as $item){
						$item[$field] = $value;
						$item['forex_rate'] = $forex_rate;
						$item['converted_amount'] = $item['original_amount'] * $forex_rate;
						Quick::single('accountant/transaction_entry')->cache()->updateRecordTransactionEntry($item, $item['entry_id']);

						$transactionCorrespondence = Quick::single('accountant/transaction_correspondence')->cache()->getTransactionCorrespondenceByEntryId($item['entry_id']);
						foreach($transactionCorrespondence as $itemCorr){
							$itemCorr[$field] = $value;
							$itemCorr['forex_rate'] = $forex_rate;
							$itemCorr['original_amount'] = 0.0;
							$itemCorr['converted_amount'] = 0.0;
							Quick::single('accountant/transaction_correspondence')->cache()->updateRecordTransactionCorrespondence($itemCorr, $itemCorr['correspondence_id']);
						}
					}
					// end update transaction entry
					$changeCurrency = true;
					$row[$field] = $value;
					$row['forex_rate'] = $forex_rate;
					$this->updateDetailWithForexRate($purchaseInvoiceId, $forex_rate, &$totalAmount);
					if($this->update($row, $db->quoteInto('purchase_invoice_id = ?', $purchaseInvoiceId))){
						$row['forex_rate'] = Quick_Number::formatNumber($row['forex_rate']);
						$row['total_purchase_amount'] = Quick_Number::formatNumber($totalAmount);
					}
				}else{
					$row['currency_id'] = $currencyId;
					$row['forex_rate'] = Quick_Number::formatNumber($forexRate);
				}
				$row['change_currency'] = $changeCurrency;
				return $row;
			}else{
				$row[$field] = $value;
			}
			return $this->update($row, $db->quoteInto('purchase_invoice_id = ?', $purchaseInvoiceId));
		}
		return false;
	}

	/**
	 * Update field of Purchase Invoice by id
	 * @author	trungpm
	 * @return array
	 */
	public function updateDetailWithForexRate($purchaseInvoiceId, $forex_rate, &$totalAmount)
	{
		$detailPurchase = Quick::single('accountant/detail_purchase')->cache()->getDetailPurchaseById($purchaseInvoiceId);
		foreach($detailPurchase as $item){
			$totalAmount += $item['quantity'] * $item['price'] * $forex_rate;
			Quick::single('accountant/detail_purchase')->cache()->calculateFieldsOfDetail(
			$purchaseInvoiceId, $item['product_id'], $item['unit_id'], $forex_rate,
			$item['quantity'], $item['price'],
			$item['import_rate_id'], $item['import_rate'], $item['excise_rate_id'], $item['excise_rate'],
			$item['vat_rate_id'], $item['vat_rate']);
		}
	}

	/**
	 * Insert Purchase Invoice by array
	 * @author	trungpm
	 * @return array
	 */
	public function insertPurchaseInvoice($purchaseInvoice = array())
	{
		if(!empty($purchaseInvoice)){
			return $this->insert($purchaseInvoice);
		}
		return null;
	}

	/**
	 * Retrieve purchase invoice with id
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public function getPurchaseInvoiceById($purchaseInvoiceId)
	{
		return $this->getAdapter()->fetchRow("SELECT * FROM  `". $this->_name ."` WHERE `purchase_invoice_id` = $purchaseInvoiceId");
	}

	/**
	 * Retrieve list transaction entry of voucher id
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public function getTransactionEntryOfPurchaseInvoiceId($purchaseInvoiceId, $voucherId, $productId = null, $unitId = null)
	{
		$whereProduct = '';
		if(isset($productId) && !empty($productId)){
			$whereProduct = " AND ade1.detail_id = $productId ";
		}
		$whereUnit = '';
		if(isset($unitId) && !empty($unitId)){
			$whereUnit = " AND ade3.detail_id = $unitId ";
		}
		$query = "SELECT ate.*
				  FROM `". $this->_name ."` AS api 				  
				  LEFT JOIN ( 
				  	SELECT atv1.voucher_id   
				  	FROM `". $this->_TABLE_ACCOUNTANT_TRANSACTION_VOUCHER ."` atv1				  
				  	WHERE atv1.voucher_id = $voucherId   
				  ) AS atv   
				  ON atv.voucher_id = api.voucher_id 				  
				  LEFT JOIN `". $this->_TABLE_ACCOUNTANT_TRANSACTION_BATCH ."` AS atb 
				  ON atb.voucher_id = atv.voucher_id 				  
				  LEFT JOIN `". $this->_TABLE_ACCOUNTANT_TRANSACTION_ENTRY ."` AS ate 
				  ON ate.batch_id = atb.batch_id 				  
				  RIGHT JOIN (
				  	SELECT ade1.entry_id, ade1.detail_id as product_id, ade2.unit_id  
				  	FROM accountant_detail_entry ade1 
				  	JOIN ( 
				  		SELECT ade3.entry_id, ade3.detail_id AS unit_id from accountant_detail_entry ade3
				  		WHERE ade3.table_id = " . Quick_Accountant_Remoter_BuyBilling::DEFAULT_TABLE_UNIT_TYPE ." $whereUnit) ade2
				  	ON ade1.entry_id = ade2.entry_id 
				  	WHERE ade1.table_id = " . Quick_Accountant_Remoter_BuyBilling::DEFAULT_TABLE_PRODUCT_TYPE ." $whereProduct  
				  ) AS ade 
				  ON ade.entry_id = ate.entry_id 				
				  WHERE api.purchase_invoice_id = $purchaseInvoiceId";

		return $this->getAdapter()->fetchAll($query);
	}

	/**
	 * Delete purchase invoice with purchase id
	 * @author trungpm
	 */
	public function deletePurchaseInvoice($purchaseInvoiceId)
	{
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('purchase_invoice_id = ?', $purchaseInvoiceId)));
		$voucherID = $row['voucher_id'];
		if (isset($row)) {
			if($this->delete(array(
			$db->quoteInto('purchase_invoice_id = ?', $purchaseInvoiceId)))){
				return Quick::single('accountant/transaction_voucher')->cache()->deleteTransactionVoucherById($voucherID);
			}
		}
		return false;
	}

}
