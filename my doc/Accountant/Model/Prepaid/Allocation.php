<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Model
 * @author      tuvv
 */
class Quick_Accountant_Model_Prepaid_Allocation extends Quick_Db_Table
{
	protected $_name = 'accountant_prepaid_allocation';
	const DEFAULT_EXECUTION_TYPE_PREPAID_EXPENSE	= 20;
	const DEFAULT_FORM_TRANSFERENCE	= 1;
	const DEFAULT_TYPE_EMTRY_PREPAID_ALLOCATION = 5;
	
	/**
	 * Update list prepaid expense
	 * @author	tuvv
	 * @return array Functions|mixed
	 */
	public function updatePrepaidAllocationWithSupplier($prepaidExpenseId, $currencyId, $forexRate)
	{
		$listPrepaidAllocation = $this->getPrepaidAllocationById($prepaidExpenseId);
		foreach ($listPrepaidAllocation as $item){
			$allocationDate = $item['allocation_date'];
			$db = $this->getAdapter();		
			$amount = $item['amount'] * $forexRate;
			$row = array(
				'last_modified_by_userid' 	=> Quick::session()->userId,
				'date_last_modified' 		=> Quick_Date::now()->toSQLString(),
				'currency_id'				=> $currencyId,
				'forex_rate'				=> $forexRate,
				'converted_amount'			=> $amount
			);
			$this->update($row, array($db->quoteInto('prepaid_expense_id = ?', $prepaidExpenseId),
													$db->quoteInto('allocation_date = ?', $allocationDate)));			
		}
	}
	
	/**
	 * Update field prepaid expense
	 * @author	tuvv
	 * @return array Functions|mixed
	 */
	public function updatePrepaidAllocationWithForexRate($prepaidExpenseId, $value)
	{
		$listPrepaidAllocation = $this->getPrepaidAllocationById($prepaidExpenseId);
		$db = $this->getAdapter();
		foreach ($listPrepaidAllocation as $item){
			$allocationDate = $item['allocation_date'];
			$amount = $item['amount'] * $value;
			$row = array(
				'last_modified_by_userid' 	=> Quick::session()->userId,
				'date_last_modified' 		=> Quick_Date::now()->toSQLString(),
				'forex_rate'				=> $value,
				'converted_amount'			=> $amount
			);
			$this->update($row, array($db->quoteInto('prepaid_expense_id = ?', $prepaidExpenseId),
													$db->quoteInto('allocation_date = ?', $allocationDate)));
		}
	}
	
	/**
	 * Get list prepaid allocation
	 * @author	tuvv
	 * @return array Functions|mixed
	 */
	public function getPrepaidAllocationById($prepaidExpenseId)
	{
		return $this->getAdapter()->fetchAll("SELECT * ,DATE_FORMAT(apa.allocation_date, '%Y/%m/%d') AS allocation_date_format FROM  `". $this->_name ."` as apa  WHERE `prepaid_expense_id` = $prepaidExpenseId");
	}	
	
	/**
	 * Get list detail prepaid allocation
	 * @author	tuvv
	 * @return array Functions|mixed
	 */
	public function getDetailPrepaidAllocationById($prepaidExpenseId)
	{
		$select = $this->getAdapter()->select();
        $select->from(array('apa' => $this->_name), 
        			array('prepaid_expense_id', 'allocation_date' => "DATE_FORMAT(allocation_date, '%d-%m-%Y %H:%i:%s')",
        				'voucher_id','allocation_note', 'amount', 'currency_id', 'forex_rate', 'converted_amount'))
	        ->where('apa.prepaid_expense_id = ?', $prepaidExpenseId);		
		$detail =  $this->getAdapter()->fetchAll($select->__toString());
		
		$i = 0;
		foreach($detail as $item){
			$detail[$i]['prepaid_allocation_id'] = $item['prepaid_expense_id']."*".$item['allocation_date'];
			$detail[$i]['amount'] = Quick_Number::formatNumber($item['amount']);
			$detail[$i]['forex_rate'] = Quick_Number::formatNumber($item['forex_rate']);
			$detail[$i]['converted_amount'] = Quick_Number::formatNumber($item['converted_amount']);			
			$i++;
		}	
		return $detail;
	}

	/**
	 * Update prepaid allocation
	 * @author	tuvv
	 * @return true||false
	 */
	public function updatePrepaidAllocation($prepaidAllocationId, $field, $value)
	{	
		//update prepaid allocation
		$row = array();
		$db = $this->getAdapter();
		list($prepaid_expense_id, $allocation_date) = explode('*', $prepaidAllocationId, 2);
		$allocation_date = date('Y-m-d H:i:s', strtotime($allocation_date));
		if($field == 'allocation_date'){
			$allocation_date = date('Y-m-d H:i:s', strtotime($value));
			$prepaidAllocationId = $prepaid_expense_id."*".$value;
		}elseif($field == 'amount'){
			$forex_rate = $this->getForexRateById($prepaid_expense_id, $allocation_date);
			$converted_amount = $forex_rate * $value;
			$row['converted_amount'] = $converted_amount;
		}
		
		$row[$field] = $value;
		$this->update($row, array($db->quoteInto('prepaid_expense_id  = ?', $prepaid_expense_id), $db->quoteInto('allocation_date  = ?', $allocation_date)));
		return array('updateId' => $prepaidAllocationId);
	}
	
	/**
	 * Insert prepaid allocation
	 * @author	tuvv
	 * @return true||false
	 */
	public function insertPrepaidAllocation($prepaidExpenseId, $currencyId, $forexRate,$field, $value, $prepaidExpenseName, $currentPeriodId)
	{
		// insert voucher and batch to accounting for prepaid expense
		$current_date = date('Y-m-d H:i:s');
		$voucher = array(
			'execution_id' => self::DEFAULT_EXECUTION_TYPE_PREPAID_EXPENSE,
			'period_id' => $currentPeriodId,
			'voucher_number' => 'Phát sinh chi phí trả trước "'.$prepaidExpenseName.'", ngày "'.$current_date.'"',
			'voucher_date' => $current_date,
			'from_transference' => self::DEFAULT_FORM_TRANSFERENCE,
			'created_by_userid' => Quick::session()->userId,
			'date_entered' => Quick_Date::now()->toSQLString(),
			'last_modified_by_userid' => Quick::session()->userId,
			'date_last_modified' => Quick_Date::now()->toSQLString()
		);
		$newVoucherId = Quick::single('accountant/transaction_voucher')->cache()->insertTransactionVoucher($voucher);
		
		if($newVoucherId){
			$convertedDate = Quick_Date::convertSQLDateToPHP('d/m/Y', $current_date);
			$batch = array(
				'voucher_id' => $newVoucherId,
				'execution_id' => self::DEFAULT_EXECUTION_TYPE_PREPAID_EXPENSE,
				'entry_type_id' => self::DEFAULT_TYPE_EMTRY_PREPAID_ALLOCATION,
				'batch_note' => 'Phân bổ chi phí trả trước "'
				);
			$newBatchId = Quick::single('accountant/transaction_batch')->cache()->insertBatch($batch);
		}
		
		
//		//insert prepaid allocation
//		$current_date = date('Y-m-d H:i:s');
//		$convertedAmount = $value * $forexRate;
//		$row = array(
//			'prepaid_expense_id' => $prepaidExpenseId,
//			'allocation_date' => $current_date,
//			'voucher_id' => 1,
//			'allocation_note' => '',
//			$field => $value,
//			'currency_id' => $currencyId,
//			'forex_rate' => $forexRate,
//			'converted_amount' => $convertedAmount,
//			'created_by_userid' => Quick::session()->userId,
//			'date_entered' => Quick_Date::now()->toSQLString(),
//			'last_modified_by_userid' => Quick::session()->userId,
//			'date_last_modified' => Quick_Date::now()->toSQLString()	
//		);
//		
//		if($this->insert($row)){
//			return (array('updateId' => $prepaidExpenseId.'*'.$current_date));
//		}else{
//			return false;
//		}
		
	}
	
	/**
	 * get total amount by  prepaid_expense_id
	 * @author	tuvv
	 * @return array
	 */
	public function getTotalAmount($prepaid_expense_id)
	{
		return $this->getAdapter()->fetchOne("SELECT sum(`amount`) FROM  `". $this->_name ."` WHERE `prepaid_expense_id` = $prepaid_expense_id");
	}
	
	/**
	 * get  amount by  prepaid_expense_id and allocation_date
	 * @author	tuvv
	 * @return array
	 */
	public function getAmountById($prepaid_expense_id, $allocation_date)
	{
		return $this->getAdapter()->fetchOne("SELECT sum(`amount`) FROM  `". $this->_name ."` WHERE `prepaid_expense_id` = $prepaid_expense_id and `allocation_date` = '$allocation_date'");
	}
	
	/**
	 * get  Forex Rate by  prepaid_expense_id and allocation_date
	 * @author	tuvv
	 * @return array
	 */
	public function getForexRateById($prepaid_expense_id, $allocation_date)
	{
		return $this->getAdapter()->fetchOne("SELECT `forex_rate` FROM  `". $this->_name ."` WHERE `prepaid_expense_id` = $prepaid_expense_id and `allocation_date` = '$allocation_date'");
	}
	
}
?>