<?php
/**
 *
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Core_Model_Definition_Subject extends Quick_Db_Table
{
	protected $_name = 'definition_list_subject';

	/**
	 * Retrieve subject by type - is_software_user, is_producer, is_supplier,...
	 * @author	trungpm
	 * @return object
	 */
	public function getSubjectByType($type)
	{
		
		return $this->getAdapter()->fetchAll("SELECT * FROM  `". $this->_name ."` WHERE `inactive` = 0 AND `$type` = 1");
	}

}
