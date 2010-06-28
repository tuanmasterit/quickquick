<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Accountant_Model_Receivable_Type extends Quick_Db_Table {

	protected $_name = 'accountant_receivable_type';
	
	/*
	 * @desc get all list receivable type
	 * 
	 * @author: khoatx
	 */
	public function getReceivableType($limit, $start, &$total)
	{
		$select = $this->getAdapter()->select();
        $select->from(array('dle' => $this->_name), 
        			  array('receivable_type_id', 'receivable_type_name', 'from_customer', 'from_government', 'from_staff',
        			  		'is_inside'))
        	   ->where('dle.inactive = ?', 0)
        	   ->limit($limit, $start);

        $query = "SELECT COUNT(receivable_type_id) FROM $this->_name";
        $total = $this->getAdapter()->fetchOne($query);
        	   
     	return $this->getAdapter()->fetchAll($select->__toString());
	}
	
	/**
	 * @desc update receivable type
	 *
	 * @author khoatx	
	 * @return boolean
	 */
	public function updateReceivableType($receivableTypeId, $field, $value)
	{
		$db = $this->getAdapter();
		$row = $this->fetchRow(array($db->quoteInto('receivable_type_id = ?', $receivableTypeId)));

		if (isset($row)) {
			$row = array(
				$field => $value,
				'last_modified_by_userid' => Quick::session()->userId,
				'date_last_modified' => Quick_Date::now()->toSQLString()
			);
			
			return $this->update($row, array($db->quoteInto('receivable_type_id = ?', $receivableTypeId)));
								
		}
		
		return false;
	}
	
	/**
	 * Insert list receivable type by data array
	 * @author	khoatx
	 * @return array
	 */
	public function insertReceivableType($listReceivableType = array())
	{
		if(!empty($listReceivableType)){
			
			return $this->insert($listReceivableType);
		}
		
		return 0;
	}
	
	/**
	 * Deletes Receivable Type
	 * @author khoatx
	 */
	public function deleteReceivableType($receivableTypeId)
	{
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
								$db->quoteInto('receivable_type_id = ?', 
								$receivableTypeId)
							   ));
		if (isset($row)) {
			return $this->delete(array(
			$db->quoteInto('receivable_type_id = ?', $receivableTypeId)));
		}
		return false;
	}
}