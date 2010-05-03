<?php
/**
 *
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Core_Model_Definition_Table extends Quick_Db_Table
{
	protected $_name = 'definition_list_table';
	
	/**
	 * Retrieve array of Execution of Module ID
	 *
	 * @return array
	 */
	public function getTables()
	{
		
		$select = $this->getAdapter()->select();
        $select->from(array('dlt' => $this->_name), array('table_id', 'description'))
        ->where('dlt.inactive = ?', 0);

        return $this->getAdapter()->fetchAll($select->__toString());
	}
	
}