<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Accountant_Model_Transaction_Correspondence extends Quick_Db_Table
{
	protected $_name 							= 'accountant_transaction_correspondence';
	protected $_TABLE_DEFINITION_LIST_ACCOUNT	= 'definition_list_account';

	/**
	 * Insert accountant transaction correspondence
	 * @author	bichttn
	 * @return array
	 */
	public function insertCorrespondence($correspondence = array())
	{
		if(!empty($correspondence)) {
			return $this->insert($correspondence);
		}
		return false;
	}

	/**
	 * @desc update Correspondence
	 *
	 * @author bichttn
	 * @return array
	 */
	public function updateCorrespondence($correspondenceId, $field, $value)
	{
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('correspondence_id = ?', $correspondenceId)));

		if (isset($row)) {
			$row = array(
			$field => $value
			);
			return $this->update($row, $db->quoteInto('correspondence_id = ?', $correspondenceId));
		}

		return false;
	}

	/**
	 * @desc update Correspondence
	 *
	 * @author datnh
	 * @return array
	 */
	public function updateTransactionCorrespondence($correspondenceId, $detail_account_id, $debit_credit, $original_amount, $currency_id, $forex_rate, $converted_amount)
	{
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('correspondence_id = ?', $correspondenceId)));

		if (isset($row)) {
			$row = array(
				'detail_account_id' => $detail_account_id,
				'debit_credit' => $debit_credit,
				'original_amount' => $original_amount,
				'currency_id' => $currency_id,
				'forex_rate' => $forex_rate,
				'converted_amount' => $converted_amount
			);
			return $this->update($row, $db->quoteInto('correspondence_id = ?', $correspondenceId));
		}

		return false;
	}

	/**
	 * Retrieve detail correspondence of entry by entry id
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public function getDetailCorrespondenceByEntryId($entryId)
	{
		$select = $this->getAdapter()->select();
		$select->from(array('atc' => $this->_name),
		array('atc.correspondence_id', 'atc.detail_account_id', 'atc.currency_id', 'atc.original_amount', 'atc.converted_amount', 'atc.debit_credit'))
		->joinLeft(
		array('dla'=> $this->_TABLE_DEFINITION_LIST_ACCOUNT),
				'dla.account_id = atc.detail_account_id',
		array('dla.account_code as account_credit_code', 'dla.account_name'))
		->where('atc.entry_id = ?', $entryId);

		return $this->getAdapter()->fetchAll($select->__toString());
	}

	/**
	 * Retrieve update field of detail entry
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public function updateFieldOfCorrespondenceEntry($correspondenceId, $field, $value)
	{
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('correspondence_id = ?', $correspondenceId)));
		$forexRate = $row['forex_rate'];
		if (isset($row)) {
			$row = array($field => $value);
			if($field == 'original_amount'){
				$row['converted_amount'] = $value * $forexRate;
			}
			if($this->update($row, $db->quoteInto('correspondence_id = ?', $correspondenceId))){
				if($field == 'original_amount'){
					$row['original_amount'] = Quick_Number::formatNumber($row['original_amount']);
					$row['converted_amount'] = Quick_Number::formatNumber($row['converted_amount']);
				}
				return $row;
			}
		}
		return false;
	}

	/**
	 * Retrieve update record of transaction entry
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public function updateRecordTransactionCorrespondence($row, $correspondenceId)
	{
		$db = $this->getAdapter();
		if (isset($row)) {
			return $this->update($row, $db->quoteInto('correspondence_id = ?', $correspondenceId));
		}
		return false;
	}

	/**
	 * Retrieve transaction correspondence of entry by entry id
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public function getTransactionCorrespondenceByEntryId($entryId)
	{
		$select = $this->getAdapter()->select();
		$select->from(array('atc' => $this->_name),
		array('atc.*'))
		->where('atc.entry_id = ?', $entryId);

		return $this->getAdapter()->fetchAll($select->__toString());
	}

	/**
	 * Delete transaction correspondence with entry id
	 * @author trungpm
	 */
	public function deleteTransactionCorrespondenceById($correspondenceId)
	{
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('correspondence_id = ?', $correspondenceId)));
		if (isset($row)) {
			return $this->delete(array(
			$db->quoteInto('correspondence_id = ?', $correspondenceId)));
		}
		return false;
	}

	/**
	 * Delete transaction correspondence by entry_id
	 * @author datnh
	 */
	public function deleteTransactionCorrespondenceByEntryId($entry_id)	{
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('entry_id = ?', $entry_id)));
		if (isset($row)) {
			return $this->delete(array(	$db->quoteInto('entry_id = ?', $entry_id)));
		}
		return 1;
	}

	/**
	 * Update correspondence by asset voucher
	 * @author datnh
	 */
	public function updateCorrespondenceByAssetVoucher($data, $entry_id) {
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('entry_id = ?', $entry_id)));

		if (isset($row)) {
			if($data['field'] == 'gross_cost') {
				$row = array(
					'original_amount' => 0,
					'converted_amount' => 0
				);
			}elseif($data['field'] == 'forex_rate') {
				$row = array(
					'forex_rate' => 0,
					'converted_amount' => 0
				);
			}elseif($data['field'] == 'currency_id') {
				$row = array(
					'currency_id' => $data['value']
				);
			}
			$this->update($row, $db->quoteInto('entry_id = ?', $entry_id));
		}

		return 1;
	}

	/**
	 * Update transaction correspondence amount by entry_id
	 * @author datnh
	 */
	public function updateCorrespondenceAmountByEntryId($original_amount,$converted_amount, $entry_id) {
		$result = 1;
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('entry_id = ?', $entry_id)));

		if (isset($row)) {
			$row = array(
				'original_amount' => $original_amount,
				'converted_amount' => $converted_amount
			);

			$result = $this->update($row, $db->quoteInto('entry_id = ?', $entry_id));
		}

		return $result;
	}

	/**
	 * Update transaction entry with set, where
	 * @author	trungpm
	 * @return array
	 */
	public function updateTransactionCorrespondenceWithSetAndWhere($set, $where)
	{
		$db = $this->getAdapter();
		$db->update($this->_name, $set, $where);
	}

	/**
	 * Update transaction entry with set, where
	 * @author	trungpm
	 * @return array
	 */
	public function updateTransactionCorrespondenceWithArrayEntryIdAndSet($arrEntryId, $set)
	{
		if(count($arrEntryId)){
			$db = $this->getAdapter();
			$whereEntry = '(';
			foreach($arrEntryId as $entryId){
				if($whereEntry == '(') $whereEntry .= "entry_id = " . $entryId['entry_id'];
				else $whereEntry .= " OR entry_id = " . $entryId['entry_id'];
			}
			$whereEntry .= ')';
			return $db->update($this->_name, $set, $whereEntry);
		}
		return 0;
	}
}
