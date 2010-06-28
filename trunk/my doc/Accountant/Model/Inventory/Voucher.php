<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Accountant_Model_Inventory_Voucher extends Quick_Db_Table
{
	protected $_name 								= 'accountant_inventory_voucher';
	protected $_TABLE_ACCOUNTANT_DETAIL_INVENTORY	= 'accountant_detail_inventory';
	protected $_TABLE_DEFINITION_LIST_CURRENCY		= 'definition_list_currency';
	protected $_TABLE_DEFINITION_LIST_UNIT			= 'definition_list_unit';
	protected $_TABLE_DEFINITION_LIST_PRODUCT		= 'definition_list_product';
	protected $_TABLE_ACCOUNTANT_TRANSACTION_VOUCHER= 'accountant_transaction_voucher';
	protected $_TABLE_ACCOUNTANT_TRANSACTION_BATCH	= 'accountant_transaction_batch';
	protected $_TABLE_ACCOUNTANT_TRANSACTION_ENTRY	= 'accountant_transaction_entry';
	protected $_TABLE_ACCOUNTANT_DETAIL_ENTRY		= 'accountant_detail_entry';

	/**
	 * Retrieve list inventory voucher
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public function getListInventoryVoucher($limit, $start, $invoiceNumber, $fromDate, $toDate, $typeVote, &$total)
	{
		$query = "SELECT COUNT(`inventory_voucher_id`) FROM `". $this->_name . "` AS aiv ";
		$where = "WHERE `inventory_voucher_number` LIKE ('%$invoiceNumber%')";
		if(isset($typeVote) && !empty($typeVote) && ($typeVote > 0)){
			$where .= " AND `supplier_id` = $typeVote";
		}
		if(isset($fromDate) && !empty($fromDate)){
			$where .= " AND `inventory_voucher_date` >= '$fromDate'";
		}
		if(isset($toDate) && !empty($toDate)){
			$where .= " AND `inventory_voucher_date` <= '$toDate'";
		}
		$where .= " AND aiv.inventory_voucher_id <> 0";
		$where .= Quick_Miscfunction::getStrPagingSize($limit, $start);
		$query .= $where;
		$total = $this->getAdapter()->fetchOne($query);

		$query = "SELECT aiv.*, dtc.currency_name,
						 DATE_FORMAT(aiv.inventory_voucher_date, '%Y/%m/%d') AS inventory_voucher_date_format,						 
						 lsb.total_inventory_amount, atv.period_id   
				  FROM `". $this->_name ."` AS aiv  
				  LEFT JOIN (SELECT inventory_voucher_id, SUM( converted_amount ) AS total_inventory_amount 
						FROM `" . $this->_TABLE_ACCOUNTANT_DETAIL_INVENTORY ."` 
						GROUP BY inventory_voucher_id) AS lsb 
				  ON lsb.inventory_voucher_id = aiv.inventory_voucher_id 
				  LEFT JOIN `". $this->_TABLE_ACCOUNTANT_TRANSACTION_VOUCHER ."` AS atv  
				  ON atv.voucher_id = aiv.voucher_id 
				  LEFT JOIN `". $this->_TABLE_DEFINITION_LIST_CURRENCY ."` AS dtc 
				  ON dtc.currency_id = aiv.currency_id ";
		$query .= $where;
		return $this->getAdapter()->fetchAll($query);
	}

	/**
	 * Insert Inventory Voucher by array
	 * @author	trungpm
	 * @return array
	 */
	public function insertInventoryVoucher($inventoryVoucher = array())
	{
		if(!empty($inventoryVoucher)){
			return $this->insert($inventoryVoucher);
		}
		return null;
	}

	/**
	 * Delete inventory voucher with purchase id
	 * @author trungpm
	 */
	public function deleteInventoryVoucher($inventoryVoucherId)
	{
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('inventory_voucher_id = ?', $inventoryVoucherId)));
		$voucherID = $row['voucher_id'];
		if (isset($row)) {
			if($this->delete(array(
			$db->quoteInto('inventory_voucher_id = ?', $inventoryVoucherId)))){
				return Quick::single('accountant/transaction_voucher')->cache()->deleteTransactionVoucherById($voucherID);
			}
		}
		return false;
	}

	/**
	 * Retrieve inventory voucher with id
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public function getInventoryVoucherById($inventoryVoucherId)
	{
		return $this->getAdapter()->fetchRow("SELECT * FROM  `". $this->_name ."` WHERE `inventory_voucher_id` = $inventoryVoucherId");
	}

	/**
	 * Retrieve list transaction entry of inventory voucher id
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public function getTransactionEntryOfInventoryVoucherId($inventoryVoucherId, $voucherId ,$productId = null, $unitId = null)
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
				  FROM `". $this->_name ."` AS aiv 				  
				  LEFT JOIN ( 
				  	SELECT atv1.voucher_id   
				  	FROM `". $this->_TABLE_ACCOUNTANT_TRANSACTION_VOUCHER ."` atv1				  
				  	WHERE atv1.voucher_id = $voucherId   
				  ) AS atv 
				  ON atv.voucher_id = aiv.voucher_id 				  
				  LEFT JOIN `". $this->_TABLE_ACCOUNTANT_TRANSACTION_BATCH ."` AS atb 
				  ON atb.voucher_id = atv.voucher_id 				  
				  LEFT JOIN `". $this->_TABLE_ACCOUNTANT_TRANSACTION_ENTRY ."` AS ate 
				  ON ate.batch_id = atb.batch_id 				  
				  RIGHT JOIN (
				  	SELECT ade1.entry_id, ade1.detail_id as product_id, ade2.unit_id  
				  	FROM `". $this->_TABLE_ACCOUNTANT_DETAIL_ENTRY ."` ade1 
				  	JOIN ( 
				  		SELECT ade3.entry_id, ade3.detail_id AS unit_id from `". $this->_TABLE_ACCOUNTANT_DETAIL_ENTRY ."` ade3
				  		WHERE ade3.table_id = " . Quick_Accountant_Remoter_BuyBilling::DEFAULT_TABLE_UNIT_TYPE ." $whereUnit) ade2
				  	ON ade1.entry_id = ade2.entry_id 
				  	WHERE ade1.table_id = " . Quick_Accountant_Remoter_BuyBilling::DEFAULT_TABLE_PRODUCT_TYPE ." $whereProduct  
				  ) AS ade 
				  ON ade.entry_id = ate.entry_id 				
				  WHERE aiv.inventory_voucher_id = $inventoryVoucherId";
		return $this->getAdapter()->fetchAll($query);
	}

	/**
	 * Update field of Inventory Voucher by id
	 * @author	trungpm
	 * @return array
	 */
	public function updateFieldOfInventoryVoucher($inventoryVoucherId, $batchId, $field, $value, $convertCurrency)
	{
		$totalAmount = 0.0;

		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('inventory_voucher_id  = ?', $inventoryVoucherId)));
		$voucherID = $row['voucher_id'];
		$typeVote = $row['in_out'];
		$currencyId = $row['currency_id'];
		$forexRate = $row['forex_rate'];
		if (isset($row)) {
			$row = array(
				'last_modified_by_userid' => Quick::session()->userId,
				'date_last_modified' => Quick_Date::now()->toSQLString()
			);
			if($field == 'in_out'){
				$row[$field] = $value;
				$row['in_warehouse_id'] = 0;
				$row['out_warehouse_id'] = 0;
				$row['subject_id'] = 0;
				$row['subject_contact'] = '';
			}elseif($field == 'subject_id'){
				$subject = Quick::single('core/definition_subject')->cache()->getSubjectById($value);
				$row[$field] = $value;
				$row['subject_contact'] = $subject['subject_contact_person'];
				$detailEntry = Quick::single('accountant/transaction_entry')->cache()->geTransactionEntryByBatchId($batchId);
				Quick::single('accountant/detail_entry')->cache()->updateDetailEntryWithBatchIdAndTableId(
				$detailEntry, Quick_Accountant_Remoter_StockManage:: DEFAULT_TABLE_SUBJECT_TYPE, $value);
				foreach($detailEntry as $entry){
					Quick::single('accountant/detail_correspondence')->cache()->updateDetailCorrespondenceWithEntryIdAndTableId(
					$entry['entry_id'], Quick_Accountant_Remoter_StockManage:: DEFAULT_TABLE_SUBJECT_TYPE, $value);
				}
			}elseif(($field == 'in_warehouse_id') || ($field == 'out_warehouse_id')){
				$row[$field] = $value;
				$row['subject_id'] = 0;
				$row['subject_contact'] = '';

				$detailEntry = Quick::single('accountant/transaction_entry')->cache()->geTransactionEntryByBatchId($batchId);
				if(($typeVote == Quick_Accountant_Remoter_StockManage:: DEFAULT_INPUT_VOTE_TYPE) ||
				($typeVote == Quick_Accountant_Remoter_StockManage:: DEFAULT_OUTPUT_VOTE_TYPE)){
					Quick::single('accountant/detail_entry')->cache()->updateDetailEntryWithBatchIdAndTableId(
					$detailEntry, Quick_Accountant_Remoter_StockManage:: DEFAULT_TABLE_WAREHOUSE_TYPE, $value);
					foreach($detailEntry as $entry){
						Quick::single('accountant/detail_correspondence')->cache()->updateDetailCorrespondenceWithEntryIdAndTableId(
						$entry['entry_id'], Quick_Accountant_Remoter_StockManage:: DEFAULT_TABLE_WAREHOUSE_TYPE, $value);
					}
				}elseif($typeVote == Quick_Accountant_Remoter_StockManage:: DEFAULT_INTERNAL_VOTE_TYPE){
					$debitOrCredit = 0;
					switch($field){
						case 'in_warehouse_id':
							$debitOrCredit = Quick_Accountant_Remoter_StockManage:: DEFAULT_DEBIT_ACCOUNT_TYPE;
							break;
						case 'out_warehouse_id':
							$debitOrCredit = Quick_Accountant_Remoter_StockManage:: DEFAULT_CREDIT_ACCOUNT_TYPE;
							break;
					}
					$arrEntryID = array();
					foreach($detailEntry as $entry){
						if($entry['debit_credit'] == $debitOrCredit){
							array_push($arrEntryID, $entry);
						}else{
							Quick::single('accountant/detail_correspondence')->cache()->updateDetailCorrespondenceWithEntryIdAndTableId(
							$entry['entry_id'], Quick_Accountant_Remoter_StockManage:: DEFAULT_TABLE_WAREHOUSE_TYPE, $value);
						}
					}
					Quick::single('accountant/detail_entry')->cache()->updateDetailEntryWithBatchIdAndTableId(
					$arrEntryID, Quick_Accountant_Remoter_StockManage:: DEFAULT_TABLE_WAREHOUSE_TYPE, $value);
				}
			}elseif($field == 'department_id'){
				$row[$field] = $value;
				$detailEntry = Quick::single('accountant/transaction_entry')->cache()->geTransactionEntryByBatchId($batchId);
				Quick::single('accountant/detail_entry')->cache()->updateDetailEntryWithBatchIdAndTableId(
				$detailEntry, Quick_Accountant_Remoter_StockManage:: DEFAULT_TABLE_DEPARTMENT_TYPE, $value);
				foreach($detailEntry as $entry){
					Quick::single('accountant/detail_correspondence')->cache()->updateDetailCorrespondenceWithEntryIdAndTableId(
					$entry['entry_id'], Quick_Accountant_Remoter_StockManage:: DEFAULT_TABLE_DEPARTMENT_TYPE, $value);
				}
			}elseif($field == 'currency_id'){
				$currency = Quick::single('core/definition_currency')->cache()->getCurrencyWithForexRate($value, $convertCurrency);
				$forex_rate = $currency['forex_rate'];
				$changeCurrency = false;

				if(isset($forex_rate) && !empty($forex_rate)){
					// update transaction entry of purchase invoice
					$detailEntry = Quick::single('accountant/transaction_entry')->cache()->geTransactionEntryByBatchId($batchId);
					foreach($detailEntry as $entry){
						$set = array(
							'currency_id' => $value,
							'forex_rate' => $forex_rate,
							'original_amount' => 0.00,
							'converted_amount' => 0.00);
						$where = array('entry_id' => $entry['entry_id']);
						Quick::single('accountant/transaction_correspondence')->cache()->updateTransactionCorrespondenceWithSetAndWhere($set, $where);
					}
					$set = array(
						'currency_id' => $value,
						'forex_rate' => $forex_rate,
						'converted_amount' => new Zend_Db_Expr("original_amount * $forex_rate"));
					$where = array('batch_id' => $batchId);
					Quick::single('accountant/transaction_entry')->cache()->updateTransactionEntryWithSetAndWhere($set, $where);

					// end update transaction entry
					$changeCurrency = true;
					$row[$field] = $value;
					$row['forex_rate'] = $forex_rate;
					$this->updateDetailWithForexRate($inventoryVoucherId, $forex_rate, &$totalAmount);
					if($this->update($row, $db->quoteInto('inventory_voucher_id = ?', $inventoryVoucherId))){
						$row['forex_rate'] = Quick_Number::formatNumber($row['forex_rate']);
						$row['total_inventory_amount'] = Quick_Number::formatNumber($totalAmount);
					}
				}else{
					$row['currency_id'] = $currencyId;
					$row['forex_rate'] = Quick_Number::formatNumber($forexRate);
				}
				$row['change_currency'] = $changeCurrency;
				return $row;
			}elseif($field == 'forex_rate'){
				$row[$field] = $value;
				// update transaction entry of purchase invoice
				$detailEntry = Quick::single('accountant/transaction_entry')->cache()->geTransactionEntryByBatchId($batchId);
				foreach($detailEntry as $entry){
					$set = array(
							'forex_rate' => $value,
							'original_amount' => 0.00,
							'converted_amount' => 0.00);
					$where = array('entry_id' => $entry['entry_id']);
					Quick::single('accountant/transaction_correspondence')->cache()->updateTransactionCorrespondenceWithSetAndWhere($set, $where);
				}
				$set = array(
						'forex_rate' => $value,
						'converted_amount' => new Zend_Db_Expr("original_amount * $value"));
				$where = array('batch_id' => $batchId);
				Quick::single('accountant/transaction_entry')->cache()->updateTransactionEntryWithSetAndWhere($set, $where);
				// end update transaction entry
				
				$this->updateDetailWithForexRate($inventoryVoucherId, $value, &$totalAmount);
				if($this->update($row, $db->quoteInto('inventory_voucher_id = ?', $inventoryVoucherId))){
					$row['change_currency'] = true;
					$row['currency_id'] = $currencyId;
					$row['forex_rate'] = Quick_Number::formatNumber($value);
					$row['total_inventory_amount'] = Quick_Number::formatNumber($totalAmount);
				}
				return $row;
			}else{
				$row[$field] = $value;
			}
			if($this->update($row, $db->quoteInto('inventory_voucher_id = ?', $inventoryVoucherId))){
				return $row;
			}
		}
		return false;
	}

	/**
	 * Update field of Inventory Voucher by id
	 * @author	trungpm
	 * @return array
	 */
	public function updateDetailWithForexRate($inventoryVoucherId, $forex_rate, &$totalAmount)
	{
		$detailInventory = Quick::single('accountant/detail_inventory')->cache()->getDetailInventoryById($inventoryVoucherId);
		foreach($detailInventory as $item){
			$totalAmount += $item['quantity'] * $item['price'] * $forex_rate;
			Quick::single('accountant/detail_inventory')->cache()->calculateFieldsOfDetail(
			$inventoryVoucherId, $item['product_id'], $item['unit_id'], $forex_rate,
			$item['quantity'], $item['price']);
		}
	}
}