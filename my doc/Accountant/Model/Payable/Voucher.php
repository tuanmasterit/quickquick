<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Accountant_Model_Payable_Voucher extends Quick_Db_Table {
	protected $pageSize = 20;
	protected $_name = 'accountant_payable_voucher';

	
	/**
	 * Get list of payable voucher
	 * @author datnh
	 */
	public function getListPayableVoucher($data, &$total) {			
		$total = $this->getListPayableVoucherSize($data);				
		return $this->getListPayableVoucherDetail($data);
	}
	
	/**
	 * Get size of payable voucher list
	 * @author datnh
	 */
	private function getListPayableVoucherSize($data) {
		$select = $this->getAdapter()->select();
		$select->from(array('apv' => $this->_name), array('count(*)'));
		if(isset($data['payable_voucher_number']) && $data['payable_voucher_number'] != ''){
			$select->where("apv.payable_voucher_number LIKE(?)", '%'. $data['payable_voucher_number'] .'%');
		}	
		if(isset($data['srch_from_date']) && $data['srch_from_date'] != ''){
			$select->where("DATE(apv.payable_voucher_date) >=(?)", $data['srch_from_date']);
		}
		if(isset($data['srch_to_date']) && $data['srch_to_date'] != null && $data['srch_to_date'] != ''){
			$select->where("DATE(apv.payable_voucher_date) <=(?)", $data['srch_to_date']);	
		}	
		if(isset($data['srch_inc_dec']) && $data['srch_inc_dec'] != ''){
			$select->where("apv.inc_dec =(?)", $data['srch_inc_dec']);
		}
		
		return $this->getAdapter()->fetchOne($select->__toString());
	}
	
	/**
	 * Get list of payable voucher
	 * @author datnh
	 */
	private function getListPayableVoucherDetail($data) {
		$limit = isset($data['limit']) ? $data['limit'] : $this->pageSize;
		$start = isset($data['start']) ? $data['start'] : 0;
		//Get records
		$select = $this->getAdapter()->select();
		$select->from(array('apv' => $this->_name),
					array('apv.payable_voucher_id',
							'apv.voucher_id',	
							'apv.payable_voucher_number',
							'DATE_FORMAT(apv.payable_voucher_date, \'%Y/%m/%d\') payable_voucher_date',
							'apv.payable_type_id',
							'apv.inc_dec',
							'if(apv.inc_subject_id = 0, null, apv.inc_subject_id) AS inc_subject_id',
							'if(apv.dec_subject_id = 0, null, apv.dec_subject_id) AS dec_subject_id',
							'if(apv.inc_staff_id = 0, null, apv.inc_staff_id) AS inc_staff_id',
							'if(apv.dec_staff_id = 0, null, apv.dec_staff_id) AS dec_staff_id',
							'apv.tax_id',
							'DATE_FORMAT(apv.discount_date, \'%Y/%m/%d\') discount_date',
							'apv.discount_rate',
							'DATE_FORMAT(apv.due_date, \'%Y/%m/%d\') due_date',
							'apv.due_rate',
							'apv.amount',
							'apv.currency_id',
							'apv.forex_rate',
							'apv.converted_amount',						
							'apv.description'));

		if(isset($data['src_payable_voucher_number']) && $data['src_payable_voucher_number'] != ''){
			$select->where("apv.payable_voucher_number LIKE(?)", '%'. $data['src_payable_voucher_number'] .'%');
		}	
		if(isset($data['srch_from_date']) && $data['srch_from_date'] != ''){
			$select->where("DATE(apv.payable_voucher_date) >=(?)", $data['srch_from_date']);
		}
		if(isset($data['srch_to_date']) && $data['srch_to_date'] != null && $data['srch_to_date'] != ''){
			$select->where("DATE(apv.payable_voucher_date) <=(?)", $data['srch_to_date']);	
		}	
		if(isset($data['srch_inc_dec']) && $data['srch_inc_dec'] != ''){
			$select->where("apv.inc_dec =(?)", $data['srch_inc_dec']);
		}
		$select->limit($limit, $start);
				
		return $this->getAdapter()->fetchAll($select->__toString());
	}
	
	/**
	 * Insert payable voucher
	 * @author datnh
	 */
	public function insertPayableVoucher($payableVoucher = array()) {
		if(!empty($payableVoucher)){
			return $this->insert($payableVoucher);
		}
		return null;
	}
	
	/**
	 * 	Update payable voucher
	 *	@author datnh
	 */
	public function updateFieldOfPayableVoucher($data) {				
		$db = $this->getAdapter();
		$row = $this->fetchRow(array($db->quoteInto('payable_voucher_id = ?', $data['payable_voucher_id'])));	

		$result = false;
		if (isset($row)) {				
			$field = $data['field'];
			$value = $data['value'];
			$amount = isset($data['amount']) ? $data['amount'] : 0;
			$forex_rate = isset($data['forex_rate']) ? $data['forex_rate'] : 0;		
			
			$dataUpdate[$field] = $value;
			if($field == 'inc_dec' || $field == 'payable_type_id'){
				$dataUpdate['inc_subject_id'] 	= isset($data['inc_subject_id']) ? $data['inc_subject_id'] : 0;
				$dataUpdate['inc_staff_id'] 	= isset($data['inc_staff_id']) ? $data['inc_staff_id'] : 0;
				$dataUpdate['dec_subject_id'] 	= isset($data['dec_subject_id']) ? $data['dec_subject_id'] : 0;
				$dataUpdate['dec_staff_id'] 	= isset($data['dec_staff_id']) ? $data['dec_staff_id'] : 0;			
			}elseif($field == 'amount' || $field == 'forex_rate') {				
				$dataUpdate['converted_amount'] = $amount * $forex_rate;
			}elseif($field == 'currency_id') {
				$dataUpdate['forex_rate'] = $forex_rate;
				$dataUpdate['converted_amount'] = $amount * $forex_rate;
			}
			$dataUpdate['last_modified_by_userid'] 	= Quick::session()->userId;
			$dataUpdate['date_last_modified'] 		= Quick_Date::now()->toSQLString();
							
			$updateRs = $this->update($dataUpdate, $db->quoteInto('payable_voucher_id = ?', $data['payable_voucher_id']));
			if($updateRs) {
				if($field == 'inc_dec' || $field == 'payable_type_id'){
					$result['inc_subject_id'] 	= $dataUpdate['inc_subject_id'];
					$result['inc_staff_id'] 	= $dataUpdate['inc_staff_id'] ;
					$result['dec_subject_id'] 	= $dataUpdate['dec_subject_id'];
					$result['dec_staff_id'] 	= $dataUpdate['dec_staff_id'];		
				}elseif($field == 'amount' || $field == 'currency_id' || $field == 'forex_rate') {
					$result['amount'] = Quick_Number::formatNumber($amount);
					$result['forex_rate'] = Quick_Number::formatNumber($forex_rate);
					$result['converted_amount'] = Quick_Number::formatNumber($dataUpdate['converted_amount']);
				}
								
				if($field == 'due_rate' || $field == 'discount_rate' || $field == 'amount' || $field == 'forex_rate') {
					$result['value'] = Quick_Number::formatNumber($value);
				}else{					
					$result['value'] = $value;
				}	
											
			}
		}
		return $result;
	}
	
	/**
	 * 	Update payable voucher
	 *	@author datnh
	 */
	public function updatePayableVoucher($data) {				
		$db = $this->getAdapter();
		$row = $this->fetchRow(array($db->quoteInto('payable_voucher_id = ?', $data['payable_voucher_id'])));		
		if (isset($row)) {				
			if($data['field'] == 'amount' || $data['field'] == 'currency_id' || $data['field'] == 'forex_rate') {
				$row = array(
					$data['field'] 				=> $data['value'],
					'amount' 					=> $data['amount'],
					'forex_rate' 				=> $data['forex_rate'],
					'converted_amount' 			=> $data['converted_amount'],
					'last_modified_by_userid' 	=> Quick::session()->userId,
					'date_last_modified' 		=> Quick_Date::now()->toSQLString()
					);
			}elseif($data['field'] == 'inc_dec' || $data['field'] == 'payable_type_id'){
				$row = array(
					$data['field'] 				=> $data['value'],
					'inc_subject_id' 			=> $data['inc_subject_id'],
					'inc_staff_id' 				=> $data['inc_staff_id'],
					'dec_subject_id' 			=> $data['dec_subject_id'],
					'dec_staff_id' 				=> $data['dec_staff_id'],
					'last_modified_by_userid' 	=> Quick::session()->userId,
					'date_last_modified' 		=> Quick_Date::now()->toSQLString()
					);
			}else{
				$row = array(
					$data['field'] 				=> $data['value'],					
					'last_modified_by_userid' 	=> Quick::session()->userId,
					'date_last_modified' 		=> Quick_Date::now()->toSQLString()
					);
			}
							
			return $this->update($row, $db->quoteInto('payable_voucher_id = ?', $data['payable_voucher_id']));
		}
	}
	
}
