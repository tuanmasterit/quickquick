<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Accountant_Model_Transaction_Voucher extends Quick_Db_Table
{
	protected $_name								= 'accountant_transaction_voucher';
	protected $_TABLE_ACCOUNTANT_TRANSACTION_BATCH	= 'accountant_transaction_batch';
	protected $_TABLE_ACCOUNTANT_TRANSACTION_ENTRY	= 'accountant_transaction_entry';

	/**
	 * @desc insertListVoucher
	 *
	 * @author bichttn
	 * @return array
	 */
	public function insertTransactionVoucher($voucher = array())
	{
		if(!empty($voucher)){

			return $this->insert($voucher);
		}

		return 0;
	}

	/**
	 * @desc updateListVoucher
	 *
	 * @author bichttn
	 * @return array
	 */
	public function updateTransactionVoucher($voucherId, $field, $value)
	{
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('voucher_id = ?', $voucherId)));

		if (isset($row)) {
			$row = array(
			$field => $value,
				'last_modified_by_userid' => Quick::session()->userId,
				'date_last_modified' => Quick_Date::now()->toSQLString()
			);

			return $this->update($row, $db->quoteInto('voucher_id = ?', $voucherId));
		}

		return false;
	}

	/**
	 * @desc search voucher
	 *
	 * @author bichttn
	 * @return array
	 */
	public function getTransactionVoucher($executionId, $voucherNumber, $dateFrom, $dateTo, $limit, $start, &$total)
	{
		$query = "SELECT
						atv.voucher_id AS voucher_id, 
						atv.from_transference,
						atv.execution_id AS execution_id,  
						atv.period_id As period_id,
						atv.voucher_number As voucher_number,
						DATE_FORMAT(atv.voucher_date, '%Y/%m/%d') AS voucher_date
				  FROM  ". $this->_name ." AS atv "; 
		$where = ($executionId) ? "WHERE atv.voucher_id <> 0 AND atv.execution_id = ".$executionId : "WHERE atv.voucher_id <> 0";
		$where .= ($voucherNumber) ? (($where) ? " AND atv.voucher_number LIKE '%".$voucherNumber."%'" : " WHERE atv.voucher_id <> 0 AND atv.voucher_number LIKE '%". $voucherNumber."%'") : "";
		$where .= ($dateFrom) ? (($where) ? " AND atv.voucher_date >= '".$dateFrom."'" : " WHERE atv.voucher_id <> 0 AND atv.voucher_date >= '". $dateFrom."'") : "";
		$where .= ($dateTo) ? (($where) ? " AND atv.voucher_date <= '".$dateTo."'" : " WHERE atv.voucher_id <> 0 AND atv.voucher_date <= '". $dateTo. "'") : "";

		$query_data= $query." ". $where. " LIMIT $start, $limit";

		$query_total = "SELECT COUNT(voucher_id) FROM  ". $this->_name ." AS atv ". $where;
		$total = $this->getAdapter()->fetchOne($query_total);
		
		return $this->getAdapter()->fetchAll($query_data);
	}

	/**
	 * Delete transaction voucher with id
	 * @author trungpm
	 */
	public function deleteTransactionVoucherById($voucherId)
	{
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('voucher_id = ?', $voucherId)));
		if (isset($row)) {
			return $this->delete(array(
			$db->quoteInto('voucher_id = ?', $voucherId)));
		}
		return false;
	}
	
	/**
	 * Delete transaction voucher by voucher_id
	 * @author datnh
	 */
	public function deleteTransactionVoucherByVoucherId($voucher_id)
	{
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('voucher_id = ?', $voucher_id)));
		if (isset($row)) {
			return $this->delete(array(
			$db->quoteInto('voucher_id = ?', $voucher_id)));
		}
		return false;
	}

}
