<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Accountant_Model_Tax_Rate extends Quick_Db_Table
{
	protected $_name = 'accountant_tax_rate';
	
	/**
	 * 	Update for TaxRate
	 *	@author datnh
	 */
	public function updateTaxRate($tax_rate_id, $field, $value, $tax_id, $rate) {
		$db = $this->getAdapter();
		$row = $this->fetchRow(array($db->quoteInto('tax_rate_id = ?', $tax_rate_id)));			
		if (isset($row)) {
			//Check existed:
			$row = $this->fetchRow(array($db->quoteInto('tax_id = ?', $tax_id),	$db->quoteInto('rate = ?', $rate)));										
			if(isset($row)) {
				$result['errs'] = 1;
				return $result;
			}				
			//Update
			$row = array(
				$field => $value,
				'last_modified_by_userid' => Quick::session()->userId,
				'date_last_modified' => Quick_Date::now()->toSQLString()
			);			
			return $this->update($row, $db->quoteInto('tax_rate_id = ?', $tax_rate_id));
		}
	}
	
	/**
	 * Insert for TaxRate
	 * @author datnh
	 */
	public function insertTaxRate($taxRate = array()) {
		$result = array();
	
		$db = $this->getAdapter();
		$row = $this->fetchRow(array($db->quoteInto('tax_id = ?', $taxRate['tax_id']),
						$db->quoteInto('rate = ?', $taxRate['rate'])));		
		if (isset($row)) {	
			//existed			
			$result['errs'] = 1;
		}else{
			//Not existed					
			$result['result'] = $this->insert($taxRate);			
		}			
		return $result;
			
		
		
//		if(!empty($taxRate)){			
//			return $this->insert($taxRate);
//		}		
//		return 0;
	}
	
	/**
	 * Retrieve list tax rate by tax id
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public function getTaxRateByTaxId($taxId)
	{
		return $this->getAdapter()->fetchAll("SELECT * FROM  `". $this->_name ."` WHERE `inactive` = 0 AND `tax_id` = $taxId");
	}
	
	/**
	 * Delete tax rate by tax_rate_id
	 * @author datnh
	 *
	 */
	public function deleteTaxRateByTaxRateId($tax_rate_id) {
		$result = true;
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('tax_rate_id = ?', $tax_rate_id)));
		if (isset($row)) {
			$result &= $this->delete(array($db->quoteInto('tax_rate_id = ?', $tax_rate_id)));
		}
		return $result;
	}
}


