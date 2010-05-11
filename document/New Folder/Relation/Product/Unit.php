<?php
/**
 *
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Core_Model_Definition_Relation_Product_Unit extends Quick_Db_Table
{
	protected $_name = 'definition_relation_product_unit';

	/**
	 * Retrieve Retrieve unit of product list, limit, start
	 * @author	trungpm
	 * @return array
	 */
	public function getUnitOfProduct($productId, $limit, $start, &$total)
	{
		$query = "SELECT COUNT(`unit_id`) FROM `". $this->_name ."` WHERE `product_id` = $productId";
		$total = $this->getAdapter()->fetchOne($query);

		$select = $this->getAdapter()->select();
		$select->from(array('rpu' => $this->_name),
		array('rpu.*'))
		->where('rpu.product_id = ?', $productId)
		->limit($limit, $start);

		return $this->getAdapter()->fetchAll($select->__toString());
	}

	/**
	 * Update field of detail unit Product by id
	 * @author	trungpm
	 * @return array
	 */
	public function updateFieldUnitOfProduct($productId, $field, $value)
	{
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('product_id  = ?', $productId)));
		if (isset($row)) {
			$row = array(
			$field => $value,
				'last_modified_by_userid' => Quick::session()->userId,
				'date_last_modified' => Quick_Date::now()->toSQLString()
			);
			return $this->update($row, $db->quoteInto('product_id  = ?', $productId));
		}
		
		return false;
	}
}
