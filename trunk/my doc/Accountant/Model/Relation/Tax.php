<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Accountant_Model_Relation_Tax extends Quick_Db_Table {
	protected $_name 						= 'accountant_relation_tax';
	protected $_TABLE_ACCOUNTANT_TAX_RATE 	= 'accountant_tax_rate';
	protected $_TABLE_ACCOUNTTANT_LIST_SPEC = 'accountant_list_specification';

	/**
	 * Retrieve relation tax of product with specification
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public function getRelationTaxOfProduct($productId, $taxId)
	{
		$select = $this->getAdapter()->select();
		$select->from(array('art' => $this->_name),
		array('art.tax_rate_id'))
		->joinLeft(
		array('als'=> $this->_TABLE_ACCOUNTTANT_LIST_SPEC),
				'als.specification_id = art.specification_id',
		array('als.specification_name'))
		->joinLeft(
		array('atr'=> $this->_TABLE_ACCOUNTANT_TAX_RATE),
				'atr.tax_rate_id = art.tax_rate_id',
		array('atr.rate'))
		->where('art.tax_id = ?', $taxId)
		->where('art.product_id = ?', $productId)
		->order('atr.rate');

		return $this->getAdapter()->fetchAll($select->__toString());
	}
	/**
	 * Insert or update relation_tax
	 * @author datnh
	 */
	public function insertRelationTax($relationTax) {
		if(empty($relationTax)) return 0;
		
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(		
		$db->quoteInto('product_id = ?', $relationTax['product_id']),
		$db->quoteInto('tax_id = ?', $relationTax['tax_id']),
		$db->quoteInto('specification_id = ?', $relationTax['specification_id'])));

		if (isset($row)) {
			//update
			$row = array(
				'tax_rate_id' => $relationTax['tax_rate_id'],				
				'last_modified_by_userid' => Quick::session()->userId,
				'date_last_modified' => Quick_Date::now()->toSQLString()
			);
			return $this->update($row, array(
				$db->quoteInto('product_id = ?', $relationTax['product_id']),
				$db->quoteInto('tax_id = ?', $relationTax['tax_id']),
				$db->quoteInto('specification_id = ?', $relationTax['specification_id'])));			
		}else{
			//Insert
			return $this->insert($relationTax);
		}		
	}
	
	/**
	 * Delete relation_tax
	 * @author datnh
	 */
	public function deleteRelationTax($data) {
		$result = true;
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('product_id = ?', $data['product_id']),
		$db->quoteInto('tax_id = ?', $data['tax_id']),
		$db->quoteInto('specification_id = ?', $data['specification_id'])));
		if (isset($row)) {
			$result &= $this->delete(array(
						$db->quoteInto('product_id = ?', $data['product_id']),
						$db->quoteInto('tax_id = ?', $data['tax_id']),
						$db->quoteInto('specification_id = ?', $data['specification_id'])));
		}
		return $result;
	}
	
	/**
	 * Delete relation_tax by tax_rate_id
	 * @author datnh
	 */
	public function deleteRelationTaxByField($field, $value) {
		$select = $this->getAdapter()->select();
		$select->from(array('art' => $this->_name),'count(*)')		
		->where($field.' = ?', $value);
		$recordNum = $this->getAdapter()->fetchAll($select->__toString());
		
		$result = true;
		$db = $this->getAdapter();		
		if ($recordNum > 0) {
			$result &= $this->delete(array($db->quoteInto($field.' = ?', $value)));
		}
		return $result;
	}

}



