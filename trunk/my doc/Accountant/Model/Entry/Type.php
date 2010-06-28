<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Model
 * @author      tuvv
 */
class Quick_Accountant_Model_Entry_Type extends Quick_Db_Table
{
	protected $_name = 'accountant_entry_type';
	
	/**
	 * @desc get list Type
	 * @author tuvv
	 * @return array
	 */
	public function getListEntryType()
	{
		$select = $this->getAdapter()->select();
		$select->from(
		array('aet' => $this->_name),
		array('aet.entry_type_id', 'aet.entry_type_name'));

		return $this->getAdapter()->fetchAll($select->__toString());
	}
}
?>