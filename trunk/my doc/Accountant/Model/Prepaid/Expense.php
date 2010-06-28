<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Model
 * @author      tuvv
 */
class Quick_Accountant_Model_Prepaid_Expense extends Quick_Db_Table
{
	protected $_name = 'accountant_prepaid_expense';
	protected $_TABLE_DEFINITION_LIST_CURRENCY		= 'definition_list_currency';
	protected $_TABLE_ACCOUNTANT_TRANSACTION_VOUCHER= 'accountant_transaction_voucher';
	const DEFAULT_EXECUTION_TYPE_PREPAID_EXPENSE	= 20;
	const DEFAULT_FORM_TRANSFERENCE	= 1;
	const DEFAULT_TYPE_EMTRY_PREPAID_EXPENSE = 4;
	
	/**
	 * Retrieve list prepaid expense
	 * @author	tuvv
	 * @return array Functions|mixed
	 */
	public function getListPrepaidExpense($limit, $start, $expenseCode, $fromDate, $toDate, &$total)
	{
		$query = "SELECT COUNT(`prepaid_expense_id`) FROM `". $this->_name . "` ";
		$where = "WHERE `prepaid_expense_code` LIKE ('%$expenseCode%')";
		
		if(isset($fromDate) && !empty($fromDate)){
			$where .= " AND `prepaid_expense_date` >= '$fromDate'";
		}
		if(isset($toDate) && !empty($toDate)){
			$where .= " AND `prepaid_expense_date` <= '$toDate'";
		}
		$where .= Quick_Miscfunction::getStrPagingSize($limit, $start);
		$query .= $where;
		$total = $this->getAdapter()->fetchOne($query);

		$query = "SELECT ape.*, DATE_FORMAT(ape.prepaid_expense_date, '%Y/%m/%d') AS prepaid_expense_date_format, atv.period_id
				  FROM `". $this->_name ."` AS ape  
				  LEFT JOIN `". $this->_TABLE_ACCOUNTANT_TRANSACTION_VOUCHER ."` AS atv  
				  ON atv.voucher_id = ape.voucher_id 
				  LEFT JOIN `". $this->_TABLE_DEFINITION_LIST_CURRENCY ."` AS dtc 
				  ON dtc.currency_id = ape.currency_id ";
		
		$query .= $where;
		
		$detail = $this->getAdapter()->fetchAll($query);
		$i = 0;
		foreach($detail as $item){
			$detail[$i]['forex_rate'] = Quick_Number::formatNumber($item['forex_rate']);
			$detail[$i]['amount'] = Quick_Number::formatNumber($item['amount']);
			$detail[$i]['converted_amount'] = Quick_Number::formatNumber($item['converted_amount']);
			$i++;
		}
		return $detail;
	}
	
	/**
	 * Insert prepaid expense
	 * @author	tuvv
	 * @return true||false
	 */
	public function insertPrepaidExpense($expenseCode, $expenseName, $expenseDate, $supplierId, 
						$expenseId, $assetsId, $toolId, $allocationPeriods, $currencyId, $forexRate, $currentPeriodId)
	{
		// insert voucher and batch to accounting for prepaid expense
		$voucher = array(
			'execution_id' => self::DEFAULT_EXECUTION_TYPE_PREPAID_EXPENSE,
			'period_id' => $currentPeriodId,
			'voucher_number' => $expenseCode.' '.$expenseDate,
			'voucher_date' => $expenseDate.' '.date('H:i:s'),
			'from_transference' => self::DEFAULT_FORM_TRANSFERENCE,
			'created_by_userid' => Quick::session()->userId,
			'date_entered' => Quick_Date::now()->toSQLString(),
			'last_modified_by_userid' => Quick::session()->userId,
			'date_last_modified' => Quick_Date::now()->toSQLString()
		);
		$newVoucherId = Quick::single('accountant/transaction_voucher')->cache()->insertTransactionVoucher($voucher);
		
		if($newVoucherId){
			$convertedDate = Quick_Date::convertSQLDateToPHP('d/m/Y', $expenseDate);
			$batch = array(
				'voucher_id' => $newVoucherId,
				'execution_id' => self::DEFAULT_EXECUTION_TYPE_PREPAID_EXPENSE,
				'entry_type_id' => self::DEFAULT_TYPE_EMTRY_PREPAID_EXPENSE,
				'batch_note' => 'Phát sinh chi phí trả trước "'. $expenseName .'", ngày "'. $convertedDate .'"'
				);
			$newBatchId = Quick::single('accountant/transaction_batch')->cache()->insertBatch($batch);
			if($newBatchId){
				if($supplierId == null ){
					$supplierId = 0;
					$currencyId = 0;
					$forexRate = 0;
				}		
				if($assetsId == null){
					$assetsId = 0;
				}
				if($toolId == null){
					$toolId = 0;
				}
				if($expenseId == null){
					$expenseId = 0;
				}
				if($allocationPeriods == null){
					$allocationPeriods = '';
				}
				
				$row = array(
					'voucher_id' 					=> $newVoucherId,
					'prepaid_expense_code' 			=> $expenseCode,
					'prepaid_expense_name' 			=> $expenseName,
					'prepaid_expense_date' 			=> $expenseDate,
					'prepaid_expense_description' 	=> '',
					'supplier_id' 					=> $supplierId,
					'expense_id' 					=> $expenseId,
					'assets_id'						=> $assetsId,
					'tool_id'						=> $toolId,
					'amount'						=> 0,
					'currency_id'					=> $currencyId,
					'forex_rate'					=> $forexRate,
					'converted_amount'				=> 0,
					'allocation_periods'     		=> $allocationPeriods,
					'created_by_userid' => Quick::session()->userId,
					'date_entered' => Quick_Date::now()->toSQLString(),
					'last_modified_by_userid' => Quick::session()->userId,
					'date_last_modified' => Quick_Date::now()->toSQLString()
				);
				if(!empty($row)){
					return $this->insert($row);
				}
				return false;
				
			}
		} else {
			return false;
		}
	}
	
	/**
	 * Update field of Prepaid Expense by id
	 * @author	tuvv
	 * @return array
	 */
	public function updateExpense($prepaidExpenseId, $field, $value, $convertCurrency)
	{	
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('prepaid_expense_id  = ?', $prepaidExpenseId)));
		$voucherID = $row['voucher_id'];
		$amount = $row['amount'];
		$forex_rate = $row['forex_rate'];
		$converted_amount = Quick_Number::formatNumber($row['converted_amount']);
		if (isset($row)) {
			$row = array(
				'last_modified_by_userid' => Quick::session()->userId,
				'date_last_modified' => Quick_Date::now()->toSQLString()
			);
			if($field == 'supplier_id'){
				$subject = Quick::single('core/definition_subject')->cache()->getSupplierWithForexRate($value, $convertCurrency);
				$row[$field] = $value;
				$forex_rate = $subject['forex_rate'];				
				$row['currency_id'] = $subject['currency_id'];
				$row['forex_rate'] = $forex_rate;
				$row['converted_amount'] = $amount * $row['forex_rate'];
				$this->updatePrepaidAllocationWithSupplier($prepaidExpenseId, $row['currency_id'], $row['forex_rate']);
			}elseif($field == 'prepaid_expense_date'){
				$row[$field] = $value.' '.date("H:i:s");
			}elseif($field == 'forex_rate'){
				$row[$field] = $value;
				$prepaidAllocation = $this->getPrepaidAllocationById($prepaidExpenseId);
				$row['converted_amount'] = $prepaidAllocation[0]['amount'] * $value;
				$this->updatePrepaidAllocationWithForexRate($prepaidExpenseId, $value);
			}elseif($field == 'currency_id'){
				$currency = Quick::single('core/definition_currency')->cache()->getCurrencyWithForexRate($value, $convertCurrency);
				$forex_rate = $currency['forex_rate'];
				if(isset($forex_rate) && !empty($forex_rate)){
					$row[$field] = $value;
					$row['forex_rate'] = $forex_rate;
					$prepaidAllocation = $this->getPrepaidAllocationById($prepaidExpenseId);
					$row['converted_amount'] = $prepaidAllocation[0]['amount'] * $row['forex_rate'];
					$this->updatePrepaidAllocationWithSupplier($prepaidExpenseId, $row['currency_id'], $row['forex_rate']);
				}
			}elseif($field == 'amount'){
				$row[$field] = $value;
				$row['converted_amount'] = $value * $forex_rate;
			}else{
				$row[$field] = $value;
			}
			
			if(isset($row['converted_amount']) && !empty($row['converted_amount'])){
				$converted_amount = Quick_Number::formatNumber($row['converted_amount']);
			}
			return array($this->update($row, $db->quoteInto('prepaid_expense_id = ?', $prepaidExpenseId)), $converted_amount);
		}
		return false;
	}
	
	/**
	 * Update list of Prepaid Expense by id
	 * @author	tuvv
	 * @return 
	 */
	public function updatePrepaidAllocationWithSupplier($prepaidExpenseId, $currencyId, $forexRate)
	{	
		return Quick::single('accountant/prepaid_allocation')->cache()->updatePrepaidAllocationWithSupplier($prepaidExpenseId, $currencyId, $forexRate);		
	}
	
	/**
	 * Update field of Prepaid Expense by id
	 * @author	tuvv
	 * @return 
	 */
	public function updatePrepaidAllocationWithForexRate($prepaidExpenseId, $value)
	{	
		return Quick::single('accountant/prepaid_allocation')->cache()->updatePrepaidAllocationWithForexRate($prepaidExpenseId, $value);		
	}
	
	/**
	 * Get Prepaid Expense by id
	 * @author	tuvv
	 * @return array
	 */
	public function getPrepaidAllocationById($prepaidExpenseId)
	{	
		return $this->getAdapter()->fetchAll("SELECT * FROM  `". $this->_name ."` WHERE `prepaid_expense_id` = $prepaidExpenseId");		
	}
	
	/**
	 * get amount by  prepaid_expense_id
	 * @author	tuvv
	 * @return array
	 */
	public function getAmountById($prepaid_expense_id)
	{
		return $this->getAdapter()->fetchOne("SELECT sum(`amount`) FROM  `". $this->_name ."` WHERE `prepaid_expense_id` = $prepaid_expense_id");
	}
	
	/**
	 * Delete prepaid expense with prepaid id
	 * @author trungpm
	 */
	public function deletePrepaidExpense($prepaidExpenseId)
	{
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('prepaid_expense_id = ?', $prepaidExpenseId)));
		$voucherID = $row['voucher_id'];
		if (isset($row)) {
			if($this->delete(array(
			$db->quoteInto('prepaid_expense_id = ?', $prepaidExpenseId)))){
				return Quick::single('accountant/transaction_voucher')->cache()->deleteTransactionVoucherById($voucherID);
			}
		}
		return false;
	}

}
?>