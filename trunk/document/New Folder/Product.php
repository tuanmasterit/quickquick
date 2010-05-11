<?php
/**
 *
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Core_Model_Definition_Product extends Quick_Db_Table
{
	protected $_name 									= 'definition_list_product';
	protected $_TABLE_DEFINITION_LIST_SUBJECT			= 'definition_list_subject';
	protected $_TABLE_DEFINITION_LIST_UNIT				= 'definition_list_unit';
	protected $_TABLE_DEFINITION_RELATION_PRODUCT_UNIT	= 'definition_relation_product_unit';
	protected $_IS_PRODUCER						= 1;
	protected $pageSize = 20;

	/**
	 * Retrieve Retrieve product list, limit, start
	 * @author	trungpm
	 * @return array
	 */
	public function getListProduct($limit, $start, $name, &$total)
	{
		$query = "SELECT COUNT(`product_id`) FROM `". $this->_name ."` WHERE `inactive` = 0 ";
		$total = $this->getAdapter()->fetchOne($query);

		$select = $this->getAdapter()->select();
		$select->from(array('lp' => $this->_name),
		array('lp.product_id', 'lp.product_code', 'lp.product_name', 'lp.product_model',
				'lp.product_picture', 'lp.product_description'))
		->joinLeft(
		array('lsb'=> $this->_TABLE_DEFINITION_LIST_SUBJECT),
				'lsb.subject_id = lp.producer_id',
		array('lsb.subject_name', 'lsb.subject_id AS producer_id'))
		->where('lp.inactive = ?', 0)
		->where('lsb.inactive = ?', 0)
		->where('lsb.is_producer = ?', $this->_IS_PRODUCER)
		->where("lp.product_name LIKE(?)", '%'. $name .'%')
		->limit($limit, $start);
		
		return $this->getAdapter()->fetchAll($select->__toString());
	}

	/**
	 * Update field of Product by id
	 * @author	trungpm
	 * @return array
	 */
	public function updateFieldOfProduct($productId, $field, $value)
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
		}else{
			$row = array(
			$field => $value,
				'inactive' => 0,
				'base_unit_id' => 1,
				'regular_unit_id' => 1,
				'created_by_userid' => Quick::session()->userId,
				'date_entered' => Quick_Date::now()->toSQLString(),
				'last_modified_by_userid' => Quick::session()->userId,
				'date_last_modified' => Quick_Date::now()->toSQLString()
			);
			return $this->insert($row);
		}
		return false;
	}

	/**
	 * Update Product by id
	 * @author	trungpm
	 * @return array
	 */
	public function getProductById($productId)
	{
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('product_id = ?', $productId),
		$db->quoteInto('inactive = ?', 0)));
		return $row->toArray();
	}
}
