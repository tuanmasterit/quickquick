<?php
/**
 *
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Core_Model_Definition_Unit extends Quick_Db_Table
{
	protected $_name = 'definition_list_unit';

	/**
	 * @desc get list unit
	 * @author trungpm
	 * @return array
	 */
	public function getListUnit()
	{

		$select = $this->getAdapter()->select();
		$select->from(
		array('lnu' => $this->_name), 
		array('lnu.unit_id', 'lnu.unit_name'))
		->where('lnu.inactive = ?', 0);

		return $this->getAdapter()->fetchAll($select->__toString());
	}
}
