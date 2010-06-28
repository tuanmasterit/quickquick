<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Accountant_Model_Cash_Voucher extends Quick_Db_Table
{
	protected $_name = 'accountant_cash_voucher';

	/**
	 * @desc insertListVoucher
	 *
	 * @author bichttn	
	 * @return array
	 */
	public function insertCashVoucher($cashVoucher = array())
	{
		if(!empty($cashVoucher)){
			
			return $this->insert($cashVoucher);
		}
		
		return 0;
	}
	
	/**
	 * @desc updateListVoucher
	 *
	 * @author bichttn	
	 * @return array
	 */
	public function updateCashVoucher($cashVoucherId, $field, $value)
	{
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('cash_voucher_id = ?', $cashVoucherId)));

		if (isset($row)) {
			$row = array(
				$field => $value,
				'last_modified_by_userid' => Quick::session()->userId,
				'date_last_modified' => Quick_Date::now()->toSQLString()
			);
			
			return $this->update($row, $db->quoteInto('cash_voucher_id = ?', $cashVoucherId));
		}
		
		return false;
	}
	
	/**
	 * Delete purchase invoice with purchase id
	 * @author trungpm
	 */
	public function deleteCashVoucher($cashVoucherId)
	{
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('cash_voucher_id = ?', $cashVoucherId)));
		$voucherID = $row['voucher_id'];
		if (isset($row)) {
			if($this->delete(array(
			$db->quoteInto('cash_voucher_id = ?', $cashVoucherId)))){
				return Quick::single('accountant/transaction_voucher')->cache()->deleteTransactionVoucherById($voucherID);
			}
		}
		return false;
	}
    /**
	 * @desc search voucher
	 *
	 * @author bichttn	
	 * @return array
	 */
	public function getCashVoucher($cashVoucherNumber, $dateFrom, $dateTo, $limit, $start, &$total)
	{
        $query = "SELECT
						acv.cash_voucher_id AS cash_voucher_id,
        				acv.voucher_id AS voucher_id, 
        				acv.cash_voucher_number AS cash_voucher_number,
        				DATE_FORMAT(acv.cash_voucher_date, '%Y/%m/%d') AS cash_voucher_date,
        				acv.subject_id AS subject_id,
        				acv.subject_name AS subject_name,
        				acv.subject_address AS subject_address,
        				acv.subject_contact AS subject_contact,
        				acv.in_bank_id AS in_bank_id,
        				acv.in_bank_account_id AS in_bank_account_id,
        				acv.out_bank_id AS out_bank_id,
        				acv.out_bank_account_id AS out_bank_account_id,
        				acv.amount AS amount,
        				acv.currency_id AS currency_id,
        				acv.forex_rate AS forex_rate,
        				acv.converted_amount AS converted_amount,
        				acv.in_out AS in_out,
        				acv.description AS description
				  FROM  ". $this->_name ." AS acv "; 
        $where = ($cashVoucherNumber) ?  " WHERE acv.cash_voucher_number LIKE '%". $cashVoucherNumber."%'" : "";
        $where .= ($dateFrom) ? (($where) ? " AND acv.cash_voucher_date >= '".$dateFrom."'" : " WHERE acv.cash_voucher_date >= '". $dateFrom."'") : "";
        $where .= ($dateTo) ? (($where) ? " AND acv.cash_voucher_date <= '".$dateTo."'" : " WHERE acv.cash_voucher_date <= '". $dateTo. "'") : "";

        $query_data= $query." ". $where. " LIMIT $start, $limit";

        $query_total = "SELECT COUNT(cash_voucher_id) FROM  ". $this->_name ." AS acv ". $where;
        $total = $this->getAdapter()->fetchOne($query_total);
        
        return $this->getAdapter()->fetchAll($query_data);
	}
}

