<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Accountant_Model_List_Tax extends Quick_Db_Table {
	protected $_name = 'accountant_list_tax';
	protected $_TABLE_ACCOUNTANT_TAX_RATE = 'accountant_tax_rate';
	protected $_TABLE_ACCOUNTANT_RELATION_TAX = 'accountant_relation_tax';
	protected $pageSize = 10;

	/**
	 * @desc get all list expense
	 * 
	 * @author: datnh
	 */
	public function getListTax() {
		$select = $this->getAdapter()->select();
        $select->from(array('alt' => $this->_name), 
        			  array('tax_id', 'tax_name'));
        	   
     	return $this->getAdapter()->fetchAll($select->__toString());
	}
	
	/**
	 * Get list of TaxRate
	 * @author datnh
	 */
	public function getListTaxRate($tax_id, $limit, $start, &$total) {
		$limit = isset($limit) ? $limit : $this->pageSize;
		$start = isset($start) ? $start : 0;
		if ($start == '') {
			$start = 0;
		}
		$pagingSize = '';
		if ($limit > 0) {
			$pagingSize = " LIMIT $start, $limit";
		}

		//Get size:
		$query_size = "SELECT COUNT(*)
				  FROM  ". $this->_name ." AS alt 
				  RIGHT JOIN ".  $this->_TABLE_ACCOUNTANT_TAX_RATE ." AS atr 
				  		ON atr.tax_id = alt.tax_id";
				  if($tax_id > 0) {
				  	$query_size .= " WHERE atr.tax_id = ".$tax_id;
				  }		
		$total = $this->getAdapter()->fetchOne($query_size);
		
		//Get data with limit
		$query = "SELECT
						alt.tax_id AS tax_id, 
						alt.tax_name AS tax_name,  
						atr.tax_rate_id As tax_rate_id,
						atr.rate As rate
				  FROM  ". $this->_name ." AS alt 
				  RIGHT JOIN ".  $this->_TABLE_ACCOUNTANT_TAX_RATE ." AS atr 
				  		ON atr.tax_id = alt.tax_id";
				  if($tax_id > 0) {
				  	$query .= " WHERE atr.tax_id = ".$tax_id;
				  }
				  $query .= " ".$pagingSize;
        	   
     	return $this->getAdapter()->fetchAll($query);
	}
	
	/**
	 * Get list of tax_rate by tax_id
	 * @author datnh
	 *
	 */
	public function getListTaxRateByTaxId($tax_id) {
		$query = "SELECT * FROM ".$this->_TABLE_ACCOUNTANT_TAX_RATE." WHERE tax_id=".$tax_id;
        	   
     	return $this->getAdapter()->fetchAll($query);
	}
	/**
	 * Get list specification for product
	 * @author datnh
	 */

	public function getListSpecForProduct() {
		$query = "SELECT *  FROM accountant_list_specification";        	   
     	return $this->getAdapter()->fetchAll($query);
	}
}
