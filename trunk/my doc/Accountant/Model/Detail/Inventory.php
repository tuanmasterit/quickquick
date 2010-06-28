<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Accountant_Model_Detail_Inventory extends Quick_Db_Table
{
	protected $_name 								= 'accountant_detail_inventory';
	protected $_TABLE_ACCOUNTANT_INVENTORY_VOUCHER	= 'accountant_inventory_voucher';
	protected $_TABLE_DEFINITION_LIST_CURRENCY		= 'definition_list_currency';
	protected $_TABLE_DEFINITION_LIST_UNIT			= 'definition_list_unit';
	protected $_TABLE_DEFINITION_LIST_PRODUCT		= 'definition_list_product';

	/**
	 * Insert list product for detail inventory voucher id
	 * @author	trungpm
	 * @return array
	 */
	public function insertListProduct($listProduct = array())
	{
		if(!empty($listProduct) && (count($listProduct) > 0)){
			foreach($listProduct as $item){
				$this->insert($item);
			}
			return true;
		}
		return false;
	}

	/**
	 * Retrieve detail inventory voucher by id
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public function getDetailInventoryVoucherById($inventoryVoucherId)
	{
		$select = $this->getAdapter()->select();
		$select->from(array('adi' => $this->_name),
		array('adi.*',
		'detail_inventory_id' => new Zend_Db_Expr('CONCAT(adi.product_id, \'_\', adi.unit_id)'), 
		'product_unit_name' => new Zend_Db_Expr('CONCAT(dlp.product_name, \' - \', dlu.unit_name)')))
		->joinLeft(
		array('dlp'=> $this->_TABLE_DEFINITION_LIST_PRODUCT),
				'dlp.product_id = adi.product_id',
		array('dlp.product_name'))
		->joinLeft(
		array('dlu'=> $this->_TABLE_DEFINITION_LIST_UNIT),
				'dlu.unit_id = adi.unit_id',
		array('dlu.unit_name', 'dlu.unit_id'))
		->joinLeft(
		array('aiv'=> $this->_TABLE_ACCOUNTANT_INVENTORY_VOUCHER),
				'aiv.inventory_voucher_id  = adi.inventory_voucher_id',
		array('aiv.forex_rate', 'aiv.currency_id'))
		->joinLeft(
		array('dlc'=> $this->_TABLE_DEFINITION_LIST_CURRENCY),
				'dlc.currency_id  = aiv.currency_id',
		array('dlc.currency_name'))
		->where('adi.inventory_voucher_id = ?', $inventoryVoucherId);

		return $this->getAdapter()->fetchAll($select->__toString());
	}

	/**
	 * Delete list product of inventory voucher
	 * @author trungpm
	 */
	public function deleteListProduct($inventoryVoucherId, $voucherId, $listProduct = array())
	{
		$db = $this->getAdapter();
		if(!empty($listProduct) && (count($listProduct) > 0)){
			foreach($listProduct as $item){
				$row = $this->fetchRow(array(
				$db->quoteInto('inventory_voucher_id = ?', $inventoryVoucherId),
				$db->quoteInto('product_id = ?', $item['product_id']),
				$db->quoteInto('unit_id = ?', $item['unit_id'])));
				if (isset($row)) {
					$this->delete(array(
					$db->quoteInto('inventory_voucher_id = ?', $inventoryVoucherId),
					$db->quoteInto('product_id = ?', $item['product_id']),
					$db->quoteInto('unit_id = ?', $item['unit_id'])));
				}
				// delete transaction entry of product
				$transactionEntry = Quick::single('accountant/inventory_voucher')->cache()->getTransactionEntryOfInventoryVoucherId($inventoryVoucherId, $voucherId, $item['product_id'], $item['unit_id']);
				foreach($transactionEntry as $itemEntry){
					Quick::single('accountant/transaction_entry')->cache()->deleteTransactionEntryById($itemEntry['entry_id']);
				}
			}
			return true;
		}
		return false;
	}

	/**
	 * Retrieve list detail inventory by inventory id
	 * @author	trungpm
	 * @return object
	 */
	public function getDetailInventoryById($inventoryVoucherId)
	{
		return $this->getAdapter()->fetchAll("SELECT * FROM  `". $this->_name ."` WHERE `inventory_voucher_id` = $inventoryVoucherId");
	}

	/**
	 * Update calculate forex_rate, quantity, price
	 * @author	trungpm
	 * @return array
	 */
	public function calculateFieldsOfDetail(
	$inventoryVoucherId, $product_id, $unitId,
	$forex_rate, $quantity, $price)
	{
		$db = $this->getAdapter();
		$amount = $quantity * $price;
		$converted_amount = $amount * $forex_rate;
		$row = array(
			'inventory_voucher_id' => $inventoryVoucherId,
			'product_id' => $product_id,
			'unit_id' => $unitId,
			'quantity' => $quantity,
			'price' => $price,
			'amount' => $amount,
			'converted_amount' => $converted_amount
		);
		if($this->update($row, array(
		$db->quoteInto('inventory_voucher_id = ?', $inventoryVoucherId),
		$db->quoteInto('product_id = ?', $product_id),
		$db->quoteInto('unit_id = ?', $unitId)))){
			$row['quantity'] = Quick_Number::formatNumber($row['quantity']);
			$row['price'] = Quick_Number::formatNumber($row['price']);
			$row['amount'] = Quick_Number::formatNumber($row['amount']);
			$row['converted_amount'] = Quick_Number::formatNumber($row['converted_amount']);
			return $row;
		}
		return false;
	}

	/**
	 * Retrieve update field of detail inventory voucher
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public function updateFieldOfDetailInventory($inventoryVoucherId, $voucherId, $recordId, $field, $value, $forexRate)
	{
		list($productId, $unitId) = explode('_', $recordId, 2);
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('inventory_voucher_id = ?', $inventoryVoucherId),
		$db->quoteInto('product_id  = ?', $productId),
		$db->quoteInto('unit_id = ?', $unitId)));
		$quantity = $row['quantity'];
		$price = $row['price'];

		if (isset($row)) {
			$row = array();
			if($field == 'unit_id'){
				$row[$field] = $value;
				$detailUnit = Quick::single('core/definition_relation_product_unit')->cache()->getDetailUnitOfProduct($productId, $value);
				$coefficient = $detailUnit['coefficient'];
				if(isset($coefficient) && !empty($coefficient)){
					$row['converted_quantity'] = $quantity * $coefficient;
				}
				$transactionEntry = Quick::single('accountant/inventory_voucher')->cache()->getTransactionEntryOfInventoryVoucherId($inventoryVoucherId, $voucherId, $productId, $unitId);
				Quick::single('accountant/detail_entry')->cache()->updateDetailEntryWithBatchIdAndTableId(
				$transactionEntry, Quick_Accountant_Remoter_StockManage:: DEFAULT_TABLE_UNIT_TYPE, $value);
				foreach($transactionEntry as $entry){
					Quick::single('accountant/detail_correspondence')->cache()->updateDetailCorrespondenceWithEntryIdAndTableId(
					$entry['entry_id'], Quick_Accountant_Remoter_StockManage:: DEFAULT_TABLE_UNIT_TYPE, $value);
				}
			}elseif($field == 'quantity'){
				$row[$field] = $value;

				// update transaction entry of purchase invoice
				$transactionEntry = Quick::single('accountant/inventory_voucher')->cache()->getTransactionEntryOfInventoryVoucherId($inventoryVoucherId, $voucherId, $productId, $unitId);
				$set = array(
						'original_amount' => $value * $price,
						'converted_amount' => $value * $price * $forexRate);
				Quick::single('accountant/transaction_entry')->cache()->updateTransactionEntryWithArrayEntryIdAndSet($transactionEntry, $set);
				$set = array(
						'original_amount' => 0.00,
						'converted_amount' => 0.00);
				Quick::single('accountant/transaction_correspondence')->cache()->updateTransactionCorrespondenceWithArrayEntryIdAndSet($transactionEntry, $set);
				// end update transaction entry

				return $this->calculateFieldsOfDetail($inventoryVoucherId, $productId, $unitId, $forexRate, $value, $price);
			}elseif($field == 'price'){
				$row[$field] = $value;

				// update transaction entry of purchase invoice
				$transactionEntry = Quick::single('accountant/inventory_voucher')->cache()->getTransactionEntryOfInventoryVoucherId($inventoryVoucherId, $voucherId, $productId, $unitId);
				$set = array(
						'original_amount' => $value * $quantity,
						'converted_amount' => $value * $quantity * $forexRate);
				Quick::single('accountant/transaction_entry')->cache()->updateTransactionEntryWithArrayEntryIdAndSet($transactionEntry, $set);
				$set = array(
						'original_amount' => 0.00,
						'converted_amount' => 0.00);
				Quick::single('accountant/transaction_correspondence')->cache()->updateTransactionCorrespondenceWithArrayEntryIdAndSet($transactionEntry, $set);
				// end update transaction entry

				return $this->calculateFieldsOfDetail($inventoryVoucherId, $productId, $unitId, $forexRate, $quantity, $value);
			}else{
				$row[$field] = $value;
			}
			if($this->update($row, array(
			$db->quoteInto('inventory_voucher_id = ?', $inventoryVoucherId),
			$db->quoteInto('product_id = ?', $productId),
			$db->quoteInto('unit_id = ?', $unitId)))){
				$row['product_id'] = $productId;
				return $row;
			}
		}
		return false;
	}
}
