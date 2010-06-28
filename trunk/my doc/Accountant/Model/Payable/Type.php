<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Accountant_Model_Payable_Type extends Quick_Db_Table {

	protected $_name = 'accountant_payable_type';
	
	/*
	 * @desc get all list payable type
	 * 
	 * @author: khoatx
	 */
	public function getPayableType($limit, $start, &$total)
	{
		$select = $this->getAdapter()->select();
        $select->from(array('dle' => $this->_name), 
        			  array('payable_type_id', 'payable_type_name', 'short_long', 'to_supplier', 'to_government',
        			  		'to_bank', 'to_staff', 'is_expense', 'is_inside', 
        			  		'is_unknown', 'is_union_cost', 'is_social_insurance', 'is_health_insurance'))
        	   ->where('dle.inactive = ?', 0)
        	   ->limit($limit, $start);
	        $query = "SELECT COUNT(payable_type_id) FROM $this->_name";
        $total = $this->getAdapter()->fetchOne($query);
        	   
     	return $this->getAdapter()->fetchAll($select->__toString());
	}
	
	/**
	 * Get all payable type
	 * @author datnh
	 */
	public function getListPayableType() {		
		$select = $this->getAdapter()->select();
		$select->from(array('apt' => $this->_name));				
		return $this->getAdapter()->fetchAll($select->__toString());
	}

	
	/**
	 * @desc update payable type
	 *
	 * @author khoatx	
	 * @return boolean
	 */
	public function updatePayableType($payableTypeId, $field, $value)
	{
		$db = $this->getAdapter();
		$row = $this->fetchRow(array($db->quoteInto('payable_type_id = ?', $payableTypeId)));

		if (isset($row)) {
			$row = array(
				$field => $value,
				'last_modified_by_userid' => Quick::session()->userId,
				'date_last_modified' => Quick_Date::now()->toSQLString()
			);
			
			return $this->update($row, array($db->quoteInto('payable_type_id = ?', $payableTypeId)));
								
		}
		
		return false;
	}
	
	/**
	 * Insert list payable type by data array
	 * @author	khoatx
	 * @return array
	 */
	public function insertPayableType($listPayableType = array())
	{
		if(!empty($listPayableType)){
			
			return $this->insert($listPayableType);
		}
		
		return 0;
	}
	
	/**
	 * Deletes Payable Type
	 * @author khoatx
	 */
	public function deletePayableType($payableTypeId)
	{
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
								$db->quoteInto('payable_type_id = ?', 
								$payableTypeId)
							   ));
		if (isset($row)) {
			return $this->delete(array(
			$db->quoteInto('payable_type_id = ?', $payableTypeId)));
		}
		return false;
	}
	
}