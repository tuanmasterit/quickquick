<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Accountant_Model_Transaction_Batch extends Quick_Db_Table
{
	protected $_name = 'accountant_transaction_batch';

	/**
	 * @desc get accountant transaction batch
	 *
	 * @author bichttn
	 * @return array
	 */
	public function getBatch($voucherId, $executionId, $batchNote, $limit, $start, &$total)
	{
		$query = "SELECT
						atb.batch_id AS batch_id, 
						atb.voucher_id AS voucher_id,  
						atb.execution_id As execution_id,
						atb.batch_note As batch_note
				  FROM  ". $this->_name ." AS atb "; 
		$where = " WHERE atb.voucher_id = ". $voucherId ." AND atb.execution_id = ". $executionId ;
		$where = ($batchNote) ? ($where. " AND atb.batch_note LIKE '%". $batchNote. "%'") : $where;

		$query_data= $query." ". $where. " LIMIT $start, $limit";

		$query_total = "SELECT COUNT(batch_id) FROM  ". $this->_name ." AS atb ". $where;
		$total = $this->getAdapter()->fetchOne($query_total);
			
		return $this->getAdapter()->fetchAll($query_data);
			
	}

	/**
	 * Insert accountant transaction batch
	 * @author	bichttn
	 * @return array
	 */
	public function insertBatch($batch = array())
	{
		if(!empty($batch)){
			return $this->insert($batch);
		}
		return false;
	}

	/**
	 * @desc updateBatch
	 *
	 * @author bichttn
	 * @return array
	 */
	public function updateBatch($batchId, $field, $value)
	{
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('batch_id = ?', $batchId)));

		if (isset($row)) {
			$row = array(
			$field => $value
			);

			return $this->update($row, $db->quoteInto('batch_id = ?', $batchId));
		}

		return false;
	}
	
	/**
	 * @desc updateBatch
	 *
	 * @author bichttn
	 * @return array
	 */
	public function updateBatchByVoucherId($voucherId, $field, $value)
	{
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('voucher_id = ?', $voucherId)));

		if (isset($row)) {
			$row = array(
			$field => $value
			);

			return $this->update($row, $db->quoteInto('voucher_id = ?', $voucherId));
		}

		return false;
	}

	/**
	 * Retrieve transaction batch by voucher id and entry type id
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public function getBatchByVoucher($voucherId)
	{
		$select = $this->getAdapter()->select();
		$select->from(array('atb' => $this->_name),
		array('atb.batch_id', 'atb.entry_type_id', 'atb.batch_note'))
		->where('atb.voucher_id = ?', $voucherId)
		->order('atb.batch_id ASC');

		return $this->getAdapter()->fetchAll($select->__toString());
	}

	/**
	 * Insert list batch with voucher id
	 * @author	trungpm
	 * @return array
	 */
	public function insertListBatch($listBatch = array())
	{
		if(!empty($listBatch) && (count($listBatch) > 0)){
			foreach($listBatch as $item){
				$this->insert($item);
			}
			return true;
		}
		return false;
	}

	/**
	 * Delete transaction batch with voucherId
	 * @author datnh
	 */
	public function deleteBatchWithVoucherId($voucherId) 
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
}