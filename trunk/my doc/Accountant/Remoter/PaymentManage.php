<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @author      datnh
 */
class Quick_Accountant_Remoter_PaymentManage {
	
	const DEFAULT_EXECUTION_PAYABLE_VOUCHER_TYPE = 17;
		
	/**
	 * Get list of payable voucher
	 * @author datnh
	 */	 
	public static function getListPayableVoucher($data, &$total) {
		$result = Quick::single('accountant/payable_voucher')->cache()->getListPayableVoucher($data, &$total);
		$i = 0;
		foreach($result as $item){
			$result[$i]['due_rate'] 		= Quick_Number::formatNumber($item['due_rate']);
			$result[$i]['discount_rate'] 	= Quick_Number::formatNumber($item['discount_rate']);
			$result[$i]['amount'] 			= Quick_Number::formatNumber($item['amount']);
			$result[$i]['forex_rate'] 		= Quick_Number::formatNumber($item['forex_rate']);
			$result[$i]['converted_amount'] = Quick_Number::formatNumber($item['converted_amount']);
			
			$i++;
		}		
		return $result;
	}
	
	/**
	 * Insert payable voucher
	 * @author datnh
	 */
	public static function insertPayableVoucher($data) {
		$amount = isset($data['amount']) ? $data['amount'] : 0;
		$forex_rate = isset($data['forex_rate']) ? $data['forex_rate'] : 0;
		$converted_amount = $amount * $forex_rate;
		$data['amount'] = $amount;
		$data['forex_rate'] = $forex_rate;
		$data['converted_amount'] = $converted_amount;
				
		// insert accountant_transaction_voucher
		$newVoucherId = self::insertTransactionVoucher($data);
		if(!$newVoucherId) return false;
		
		$newPayableVoucherId = self::insertPayableVoucherInfo($data, $newVoucherId);
		if(!$newPayableVoucherId) return false;
		
		$result['payable_voucher_id'] 		= $newPayableVoucherId;
		$result['voucher_id'] 				= $newVoucherId;
		$result['payable_voucher_number'] 	= $data['payable_voucher_number'];
		$result['payable_voucher_date'] 	= $data['payable_voucher_date'];
		$result['payable_type_id'] 			= $data['payable_type_id'];
		$result['inc_dec'] 					= $data['inc_dec'];
//		$result['inc_subject_id'] = $data[''];
//		$result['dec_subject_id'] = $data[''];
//		$result['inc_staff_id'] = $data[''];
//		$result['dec_staff_id'] = $data[''];
		$result['tax_id'] 					= $data['tax_id'];
		$result['discount_date'] 			= $data['discount_date'];
		$result['discount_rate'] 			= Quick_Number::formatNumber($data['discount_rate']);
		$result['due_date'] 				= $data['due_date'];
		$result['due_rate'] 				= Quick_Number::formatNumber($data['due_rate']);
		$result['amount'] 					= Quick_Number::formatNumber($amount);
		$result['currency_id'] 				= $data['currency_id'];
		$result['forex_rate'] 				= Quick_Number::formatNumber($forex_rate);
		$result['converted_amount'] 		= Quick_Number::formatNumber($converted_amount);	
//		$result['description'] = $data[''];
				
		return $result;
	}
	
	/**
	 * Insert Payable voucher
	 * @author datnh
	 */
	
	public static function insertPayableVoucherInfo($data, $voucherId) {
		$payableVoucher = array(				
			'voucher_id' => $voucherId,
			'payable_voucher_number' => $data['payable_voucher_number'],
			'payable_voucher_date' => $data['payable_voucher_date'],
			'payable_type_id' => $data['payable_type_id'],
			'inc_dec' => $data['inc_dec'],
			'tax_id' => $data['tax_id'],
			'due_date' => $data['due_date'],
			'due_rate' => $data['due_rate'],
			'discount_date' => $data['discount_date'],
			'discount_rate' => $data['discount_rate'],
			'currency_id' => $data['currency_id'],
			'amount' => $data['amount'],
			'forex_rate' => $data['forex_rate'],
			'converted_amount' => $data['converted_amount'],
							
			'created_by_userid' => Quick::session()->userId,
			'date_entered' => Quick_Date::now()->toSQLString(),
			'last_modified_by_userid' => Quick::session()->userId,
			'date_last_modified' => Quick_Date::now()->toSQLString()
		);
		return Quick::single('accountant/payable_voucher')->cache()->insertPayableVoucher($payableVoucher);			
	}
	
	/**
	 * Insert TransactionVoucher
	 * @author datnh
	 */	 
	public static function insertTransactionVoucher($data) {
		$voucher = array(
			'execution_id' => self::DEFAULT_EXECUTION_PAYABLE_VOUCHER_TYPE,
			'period_id' => $data['currentPeriodId'],
			'voucher_number' => $data['payable_voucher_number'],
			'voucher_date' => $data['payable_voucher_date'].' '.date('H:i:s'),
			'created_by_userid' => Quick::session()->userId,
			'date_entered' => Quick_Date::now()->toSQLString(),
			'last_modified_by_userid' => Quick::session()->userId,
			'date_last_modified' => Quick_Date::now()->toSQLString()
		);
		return Quick::single('accountant/transaction_voucher')->cache()->insertTransactionVoucher($voucher);
	}
	
	/**
	 * Get list payable type
	 * @author datnh
	 */
	public static function getListPayableType() {
		return Quick::single('accountant/payable_type')->cache()->getListPayableType();
	}
	
	/**
	 * Get list tax_type
	 * @author datnh
	 */
	public static function getListTaxType() {
		return Quick::single('accountant/list_tax')->cache()->getListTax();
	}
	
	/**
	 * Get list subject
	 * @author datnh 
	 */
	public static function getIncListSubject() {
		return Quick::single('core/definition_subject')->cache()->getAllSubject();
	}
	
	/**
	 * Get list of staff
	 * @author datnh
	 */
	public static function getStaffList() {
		return Quick::single('core/definition_staff')->cache()->getAllStaff();
	}
	
	/**
	 * Update payable voucher
	 * @author datnh
	 */
	public static function updatePayableVoucher($data) {
		if($data['field'] == 'amount' || $data['field'] == 'currency_id' || $data['field'] == 'forex_rate') {
			$amount = isset($data['amount']) ? $data['amount'] : 0;
			$forex_rate = isset($data['forex_rate']) ? $data['forex_rate'] : 0;
			$converted_amount = $amount * $forex_rate;
			$data['forex_rate'] = $forex_rate;
			$data['amount'] = $amount;
			$data['converted_amount'] = $converted_amount;
			
			$updateRs = Quick::single('accountant/payable_voucher')->cache()->updatePayableVoucher($data);
			if($updateRs) {
				$result['forex_rate'] = Quick_Number::formatNumber($forex_rate);
				$result['amount'] = Quick_Number::formatNumber($amount);
				$result['converted_amount'] = Quick_Number::formatNumber($converted_amount);
				return $result;
			}
			return false;
		}elseif($data['field'] == 'inc_dec' || $data['field'] == 'payable_type_id'){			
			$updateRs = Quick::single('accountant/payable_voucher')->cache()->updatePayableVoucher($data);
			if($updateRs) {
				$result['inc_subject_id'] 	= $data['inc_subject_id'];
				$result['inc_staff_id'] 	= $data['inc_staff_id'];
				$result['dec_subject_id'] 	= $data['dec_subject_id'];
				$result['dec_staff_id'] 	= $data['dec_staff_id'];
				return $result;
			}
			return false;
		}else{
			$updateRs = Quick::single('accountant/payable_voucher')->cache()->updatePayableVoucher($data);
			if($updateRs) {
				$result['value'] = $data['value'];				
				return $result;
			}
			return false;
		}	
	}
	
	/**
	 * Update field of PayableVoucher
	 * @author datnh
	 */
	public static function updateFieldOfPayableVoucher($data) {
		return Quick::single('accountant/payable_voucher')->cache()->updateFieldOfPayableVoucher($data);
	}
}
