<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Accountant_Model_Detail_Entry extends Quick_Db_Table
{
	protected $_name = 'accountant_detail_entry';

	/**
	 * Insert detail entry for entry Id
	 * @author	trungpm
	 * @return array
	 */
	public function insertDetailEntryWithArray($detailEntry = array())
	{
		if(!empty($detailEntry) && (count($detailEntry) > 0)){
			foreach($detailEntry as $item){
				$this->insert($item);
			}
			return true;
		}
		return false;
	}

	/**
	 * Insert detail entry
	 * @author	datnh
	 * @return array
	 */
	public function insertDetailEntry($entry = array())
	{
		if(!empty($entry)){
			return $this->insert($entry);
		}
		return false;
	}

	/**
	 * Update detail entry with array entry Id and table Id
	 * @author	trungpm
	 * @return array
	 */
	public function updateDetailEntryWithBatchIdAndTableId($arrEntryId, $tableId, $detailId)
	{
		if(count($arrEntryId)){
			$db = $this->getAdapter();
			$whereEntry = '(';
			foreach($arrEntryId as $entryId){
				if($whereEntry == '(') $whereEntry .= "entry_id = " . $entryId['entry_id'];
				else $whereEntry .= " OR entry_id = " . $entryId['entry_id'];
			}
			$whereEntry .= ')';
			return $db->update($this->_name,
			array('detail_id' => $detailId), "$whereEntry AND `table_id` = $tableId");
		}
		return 0;
	}
}
