<?php
/**
 *
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Core_Model_Definition_Detail_Account extends Quick_Db_Table
{
	protected $_name = 'definition_detail_account';

	/**
	 * Update detail account by table, account, value
	 *
	 * @return boolean $result
	 */
	public function updateDetailAccount($accountId, $tableId, $detailId, $value)
	{
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('account_id = ?', $accountId),
		$db->quoteInto('detail_id = ?', $detailId),
		$db->quoteInto('table_id = ?', $tableId)));

		if (isset($row) && ($value == 0)) {

			return $this->delete(array(
			$db->quoteInto('account_id = ?', $accountId),
			$db->quoteInto('detail_id = ?', $detailId),
			$db->quoteInto('table_id = ?', $tableId)));
		} elseif(!isset($row) && ($value == 1)) {
			$row = array(
				'account_id'=> $accountId,
				'detail_id' => $detailId,
				'table_id' => $tableId,
				'created_by_userid' => 0,
				'date_entered' => '1900-01-01 00:00:00',
				'last_modified_by_userid' => 0,
				'date_last_modified' => '1900-01-01 00:00:00'
			);
			return $this->insert($row);
		}
	}
}
