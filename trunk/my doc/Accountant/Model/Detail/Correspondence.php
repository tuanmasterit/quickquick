<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Accountant_Model_Detail_Correspondence extends Quick_Db_Table
{
	protected $_name = 'accountant_detail_correspondence';

	/**
	 * Insert detail entry for correspondence Id
	 * @author	trungpm
	 * @return array
	 */
	public function insertDetailCorrespondenceWithArray($detailCorrespondence = array())
	{
		if(!empty($detailCorrespondence) && (count($detailCorrespondence) > 0)){
			foreach($detailCorrespondence as $item){
				$this->insert($item);
			}
			return true;
		}
		return false;
	}

	/**
	 * Insert detail correspondence
	 * @author	datnh
	 * @return array
	 */
	public function insertDetailCorrespondence($detailCorrespondence = array())
	{
		if(!empty($detailCorrespondence)){
			return $this->insert($detailCorrespondence);
		}
		return false;
	}

	/**
	 * Update detail correspondence with entry Id and table Id
	 * @author	trungpm
	 * @return array
	 */
	public function updateDetailCorrespondenceWithEntryIdAndTableId($entryId, $tableId, $detailId)
	{
		$detailCorrespondence = Quick::single('accountant/transaction_correspondence')->cache()->getTransactionCorrespondenceByEntryId($entryId);
		if(count($detailCorrespondence)){
			$db = $this->getAdapter();
			$whereCorrespondence = '(';
			foreach($detailCorrespondence as $correspondenceId){
				if($whereCorrespondence == '(') $whereCorrespondence .= "correspondence_id = " . $correspondenceId['correspondence_id'];
				else $whereCorrespondence .= " OR correspondence_id = " . $correspondenceId['correspondence_id'];
			}
			$whereCorrespondence .= ')';
			return $db->update($this->_name,
			array('detail_id' => $detailId), "$whereCorrespondence AND `table_id` = $tableId");
		}
		return 0;
	}
}
