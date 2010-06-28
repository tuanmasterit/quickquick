<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Model
 * @author      tuvv
 */
class Quick_Accountant_Model_Entry_Debit extends Quick_Db_Table
{
	protected $_name 							= 'accountant_entry_debit';
	protected $_TABLE_DEFINITION_LIST_ACCOUNT	= 'definition_list_account';
	protected $arr_debit;
	protected $i = 0;
	/**
	 * @desc get list Debit
	 * @author tuvv
	 * @return array
	 */
	public function getListEntryDebit($limit, $start, $typeId, &$total)
	{
		// get all account
		$select = $this->getAdapter()->select();
		$select	->from(
		array('dla' => $this->_TABLE_DEFINITION_LIST_ACCOUNT),
		array('dla.account_id','dla.account_code', 'dla.account_name'))
		->where('dla.inactive = ?', 0);

		$result1 = $this->getAdapter()->fetchAll($select->__toString());

		// get all debit
		$select = $this->getAdapter()->select();
		$select	->from(
		array('aed' => $this->_name),
		array('aed.entry_type_id','aed.account_id', 'aed.default'))
		->where('aed.entry_type_id = ?', $typeId);

		$result2 = $this->getAdapter()->fetchAll($select->__toString());

		$query = "SELECT COUNT(entry_type_id) FROM $this->_name where entry_type_id = $typeId";
		$total = $this->getAdapter()->fetchOne($query);

		// filter data debit on account
		$result_new = array();
		$i = 0;
		foreach($result1 as $rs1){
			foreach($result2 as $rs2){
				if($rs1['account_id'] == $rs2['account_id']){
					$result_new[$i]['id'] = $rs2['entry_type_id'].'_'.$rs1['account_id'];
					$result_new[$i]['account_id'] = $rs1['account_id'];
					$result_new[$i]['account_name'] = $rs1['account_code'] .' - '. $rs1['account_name'];
					$result_new[$i]['account_code'] = $rs1['account_code'];
					$result_new[$i]['default'] = ($rs2['default'] == 0) ? '': $rs2['default'];
					$i++;
					break;
				}
			}
		}
		return $result_new;
	}

	/**
	 * Update field  default of Debit by id
	 * @author	tuvv
	 * @return true||false
	 */
	public function updateFieldDefaultDebit($arrDebit, $typeId)
	{
		$arr_debit = array();
		$i = 0;
		foreach($arrDebit as $ad){
			$db = $this->getAdapter();
			$row = $this->fetchRow(array(
			$db->quoteInto('account_id  = ?', $ad[1]),
			$db->quoteInto('entry_type_id  = ?', $ad[2])));

			if(isset($row)) {
				$row = array(
				$ad[3] => $ad[4],
					'last_modified_by_userid' => Quick::session()->userId,
					'date_last_modified' => Quick_Date::now()->toSQLString()
				);
				$this->update($row, array($db->quoteInto('account_id  = ?', $ad[1]), $db->quoteInto('entry_type_id  = ?', $ad[2])));
				$arr_debit[$i]['id'] = $ad[0];
				$i++;
			}
		}

		return $arr_debit;
	}

	/**
	 * Update field of Debit by id
	 * @author	tuvv
	 * @return array
	 */
	public function updateFieldDebit($debitId, $accountId, $typeId, $debitField, $debitValue)
	{
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('account_id  = ?', $accountId),
		$db->quoteInto('entry_type_id  = ?', $typeId)));

		if (isset($row)) {
			return false;
		}else{
			if($debitId == null){
				$row = array(
						'default' => 0,
						'entry_type_id' => $typeId,
						'account_id' => $accountId,
						'created_by_userid' => Quick::session()->userId,
						'date_entered' => Quick_Date::now()->toSQLString(),
						'last_modified_by_userid' => Quick::session()->userId,
						'date_last_modified' => Quick_Date::now()->toSQLString()
				);
				if($this->insert($row)){
					return array($accountId, $typeId, $typeId."_".$accountId);
				}
			}else{
				list($typeOldId, $accountOldId) = explode('_', $debitId, 2);

				$row = array(
				$debitField => $debitValue,
					'last_modified_by_userid' => Quick::session()->userId,
					'date_last_modified' => Quick_Date::now()->toSQLString()
				);
				$result =  $this->update($row, array($db->quoteInto('account_id  = ?', $accountOldId), $db->quoteInto('entry_type_id  = ?', $typeOldId)));
				if($result) return array($accountId, $typeId, $typeId."_".$accountId);
			}
		}
		return false;
	}

	/**
	 * Retrieve entry debit account with entry type id
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public function getDebitAccount($entryTypeId, $default = 0)
	{
		$select = $this->getAdapter()->select();
		$select->from(array('aed' => $this->_name),
		array('aed.entry_type_id', 'aed.account_id', 'aed.default'))
		->joinLeft(
		array('dla'=> $this->_TABLE_DEFINITION_LIST_ACCOUNT),
				'dla.account_id = aed.account_id',
		array('dla.account_code', 'dla.account_name'))
		->where('aed.entry_type_id = ?', $entryTypeId)
		->where('dla.inactive = ?', 0);
		if($default!=0)
			$select->where('aed.default = ?', $default);
		$select->order('dla.account_code ASC');

		return $this->getAdapter()->fetchAll($select->__toString());
	}

	/**
	 * Retrieve total debit with default = 1
	 * @author	tuvv
	 * @return number
	 */
	public function getDebitDefault($typeId)
	{
		$query = "SELECT count( `default` )FROM $this->_name WHERE `entry_type_id` = $typeId AND `default` =1";
		return $this->getAdapter()->fetchOne($query);
	}

	/**
	 * Update debit  default = 0
	 * @author	tuvv
	 * @return text
	 */
	public function defaultDebit($typeId)
	{
		$row = array(
			'default' => 0,
			'last_modified_by_userid' => Quick::session()->userId,
			'date_last_modified' => Quick_Date::now()->toSQLString()
		);
		$this->update($row, array($this->getAdapter()->quoteInto('entry_type_id  = ?', $typeId)));
	}
	/**
	 * Delete debit with id
	 * @author tuvv
	 */
	public function deletedebit($debitId)
	{	
		list($entry_type_id, $account_id) = explode('_', $debitId, 2);
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
			$db->quoteInto('entry_type_id = ?', $entry_type_id),
			$db->quoteInto('account_id = ?', $account_id)));
		if (isset($row)) {
			return $this->delete(array(
				$db->quoteInto('`default` = ?', 0),
				$db->quoteInto('entry_type_id = ?', $entry_type_id), 
				$db->quoteInto('account_id = ?', $account_id)));
		}
		return false;
	}
}
?>