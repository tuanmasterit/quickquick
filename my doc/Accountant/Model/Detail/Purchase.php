<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Accountant_Model_Detail_Purchase extends Quick_Db_Table
{
	protected $_name 								= 'accountant_detail_purchase';
	protected $_TABLE_ACCOUNTANT_PURCHASE_INVOICE	= 'accountant_purchase_invoice';
	protected $_TABLE_DEFINITION_LIST_CURRENCY		= 'definition_list_currency';
	protected $_TABLE_DEFINITION_LIST_UNIT			= 'definition_list_unit';
	protected $_TABLE_DEFINITION_LIST_PRODUCT		= 'definition_list_product';

	/**
	 * Retrieve detail purchase invoice by id
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public function getDetailPurchaseInvoiceById($purchaseInvoiceId)
	{
		$select = $this->getAdapter()->select();
		$select->from(array('adpin' => $this->_name),
		array('adpin.*',
		'detail_purchase_id' => new Zend_Db_Expr('CONCAT(adpin.product_id, \'_\', adpin.unit_id)'), 
		'product_unit_name' => new Zend_Db_Expr('CONCAT(dlp.product_name, \' - \', dlu.unit_name)')))
		->joinLeft(
		array('dlp'=> $this->_TABLE_DEFINITION_LIST_PRODUCT),
				'dlp.product_id = adpin.product_id',
		array('dlp.product_name'))
		->joinLeft(
		array('dlu'=> $this->_TABLE_DEFINITION_LIST_UNIT),
				'dlu.unit_id = adpin.unit_id',
		array('dlu.unit_name', 'dlu.unit_id'))
		->joinLeft(
		array('api'=> $this->_TABLE_ACCOUNTANT_PURCHASE_INVOICE),
				'api.purchase_invoice_id  = adpin.purchase_invoice_id',
		array('api.forex_rate', 'api.currency_id'))
		->joinLeft(
		array('dlc'=> $this->_TABLE_DEFINITION_LIST_CURRENCY),
				'dlc.currency_id  = api.currency_id',
		array('dlc.currency_name'))
		->where('adpin.purchase_invoice_id = ?', $purchaseInvoiceId);

		return $this->getAdapter()->fetchAll($select->__toString());
	}

	/**
	 * Retrieve list detail purchase by purchase id
	 * @author	trungpm
	 * @return object
	 */
	public function getDetailPurchaseById($purchaseInvoiceId)
	{
		return $this->getAdapter()->fetchAll("SELECT * FROM  `". $this->_name ."` WHERE `purchase_invoice_id` = $purchaseInvoiceId");
	}

	/**
	 * Update calculate forex_rate, quantity, price
	 * @author	trungpm
	 * @return array
	 */
	public function calculateFieldsOfDetail(
	$purchaseInvoiceId, $product_id, $unitId,
	$forex_rate, $quantity, $price,
	$import_rate_id, $import_rate, $excise_rate_id, $excise_rate, $vat_rate_id, $vat_rate)
	{
		$db = $this->getAdapter();
		$amount = $quantity * $price;
		$converted_amount = $amount * $forex_rate;
		$import_amount = $import_rate/100 * $converted_amount;
		$excise_amount = $excise_rate/100 * $converted_amount * (1 + $import_rate/100);
		$vat_amount = $vat_rate/100 * $converted_amount * (1 + $import_rate/100) * (1 + $excise_rate/100);
		$total_amount = $converted_amount + $import_amount + $excise_amount + $vat_amount;
		$row = array(
			'purchase_invoice_id' => $purchaseInvoiceId,
			'product_id' => $product_id,
			'unit_id' => $unitId,
			'quantity' => $quantity,
			'price' => $price,
			'amount' => $amount,
			'converted_amount' => $converted_amount,
			'import_rate_id' => $import_rate_id,
			'import_rate' => $import_rate,
			'import_amount' => $import_amount,
			'vat_rate_id' => $vat_rate_id,
			'vat_rate' => $vat_rate,
			'vat_amount' => $vat_amount,
			'excise_rate_id' => $excise_rate_id,
			'excise_rate' => $excise_rate,
			'excise_amount' => $excise_amount,
			'total_amount' => $total_amount
		);
		if($this->update($row, array(
		$db->quoteInto('purchase_invoice_id = ?', $purchaseInvoiceId),
		$db->quoteInto('product_id = ?', $product_id),
		$db->quoteInto('unit_id = ?', $unitId)))){
			$row['quantity'] = Quick_Number::formatNumber($row['quantity']);
			$row['price'] = Quick_Number::formatNumber($row['price']);
			$row['amount'] = Quick_Number::formatNumber($row['amount']);
			$row['converted_amount'] = Quick_Number::formatNumber($row['converted_amount']);
			$row['import_amount'] = Quick_Number::formatNumber($row['import_amount']);
			$row['vat_amount'] = Quick_Number::formatNumber($row['vat_amount']);
			$row['excise_amount'] = Quick_Number::formatNumber($row['excise_amount']);
			$row['total_amount'] = Quick_Number::formatNumber($row['total_amount']);
			return $row;
		}
		return false;
	}

	/**
	 * Retrieve update field of detail purchase invoice
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public function updateFieldOfDetailPurchase($purchaseInvoiceId, $recordId, $field, $value, $forexRate)
	{
		list($productId, $unitId) = explode('_', $recordId, 2);

		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('purchase_invoice_id  = ?', $purchaseInvoiceId),
		$db->quoteInto('product_id  = ?', $productId),
		$db->quoteInto('unit_id = ?', $unitId)));
		$quantity = $row['quantity'];
		$price = $row['price'];
		$importRateId = $row['import_rate_id'];
		$importRate = $row['import_rate'];
		$exciseRateId = $row['excise_rate_id'];
		$exciseRate = $row['excise_rate'];
		$vatRateId = $row['vat_rate_id'];
		$vatRate = $row['vat_rate'];

		if (isset($row)) {
			$row = array();
			if($field == 'unit_id'){
				$row[$field] = $value;
				$detailUnit = Quick::single('core/definition_relation_product_unit')->cache()->getDetailUnitOfProduct($productId, $value);
				$coefficient = $detailUnit['coefficient'];
				if(isset($coefficient) && !empty($coefficient)){
					$row['converted_quantity'] = $quantity * $coefficient;
				}
			}elseif($field == 'quantity'){
				$row[$field] = $value;

				// update transaction entry of purchase invoice
				$transactionEntry = Quick::single('accountant/purchase_invoice')->cache()->getTransactionEntryOfPurchaseInvoiceId($purchaseInvoiceId, $productId, $unitId);
				foreach($transactionEntry as $item){
					$item['original_amount'] = $value * $price;
					$item['converted_amount'] = $value * $price * $forexRate;
					Quick::single('accountant/transaction_entry')->cache()->updateRecordTransactionEntry($item, $item['entry_id']);

					$transactionCorrespondence = Quick::single('accountant/transaction_correspondence')->cache()->getTransactionCorrespondenceByEntryId($item['entry_id']);
					foreach($transactionCorrespondence as $itemCorr){
						$itemCorr['original_amount'] = 0.0;
						$itemCorr['converted_amount'] = 0.0;
						Quick::single('accountant/transaction_correspondence')->cache()->updateRecordTransactionCorrespondence($itemCorr, $itemCorr['correspondence_id']);
					}
				}
				// end update transaction entry

				return $this->calculateFieldsOfDetail($purchaseInvoiceId, $productId, $unitId, $forexRate,
				$value, $price, $importRateId, $importRate, $exciseRateId, $exciseRate, $vatRateId, $vatRate);
			}elseif($field == 'price'){
				$row[$field] = $value;

				// update transaction entry of purchase invoice
				$transactionEntry = Quick::single('accountant/purchase_invoice')->cache()->getTransactionEntryOfPurchaseInvoiceId($purchaseInvoiceId, $productId, $unitId);
				foreach($transactionEntry as $item){
					$item['original_amount'] = $value * $quantity;
					$item['converted_amount'] = $value * $quantity * $forexRate;
					Quick::single('accountant/transaction_entry')->cache()->updateRecordTransactionEntry($item, $item['entry_id']);

					$transactionCorrespondence = Quick::single('accountant/transaction_correspondence')->cache()->getTransactionCorrespondenceByEntryId($item['entry_id']);
					foreach($transactionCorrespondence as $itemCorr){
						$itemCorr['original_amount'] = 0.0;
						$itemCorr['converted_amount'] = 0.0;
						Quick::single('accountant/transaction_correspondence')->cache()->updateRecordTransactionCorrespondence($itemCorr, $itemCorr['correspondence_id']);
					}
				}

				return $this->calculateFieldsOfDetail($purchaseInvoiceId, $productId, $unitId, $forexRate,
				$quantity, $value, $importRateId, $importRate, $exciseRateId, $exciseRate, $vatRateId, $vatRate);
			}elseif($field == 'import_rate_id' || $field == 'excise_rate_id' || $field == 'vat_rate_id'){
				list($taxRateId, $rate) = explode('_', $value, 2);
				$result;
				switch($field){
					case 'import_rate_id' : $result = $this->calculateFieldsOfDetail($purchaseInvoiceId, $productId, $unitId, $forexRate,
					$quantity, $price, $taxRateId, $rate, $exciseRateId, $exciseRate, $vatRateId, $vatRate); break;
					case 'excise_rate_id' : $result = $this->calculateFieldsOfDetail($purchaseInvoiceId, $productId, $unitId, $forexRate,
					$quantity, $price, $importRateId, $importRate, $taxRateId, $rate, $vatRateId, $vatRate); break;
					case 'vat_rate_id' : $result = $this->calculateFieldsOfDetail($purchaseInvoiceId, $productId, $unitId, $forexRate,
					$quantity, $price, $importRateId, $importRate, $exciseRateId, $exciseRate, $taxRateId, $rate); break;
					default: break;
				}
				return $result;
			}else{
				$row[$field] = $value;
			}
			return $this->update($row, array(
			$db->quoteInto('purchase_invoice_id = ?', $purchaseInvoiceId),
			$db->quoteInto('product_id = ?', $productId),
			$db->quoteInto('unit_id = ?', $unitId)));
		}
		return false;
	}

	/**
	 * get total amount of purchase invoice by id
	 * @author	trungpm
	 * @return array
	 */
	public function getTotalAmountPurchaseInvoice($purchaseInvoiceId)
	{
		$select = $this->getAdapter()->select();
		$select->from(array('adpin' => $this->_name),
		array('total_amount' => new Zend_Db_Expr('SUM( total_amount )')))
		->where('adpin.purchase_invoice_id = ?', $purchaseInvoiceId);

		return $this->getAdapter()->fetchOne($select->__toString());
	}

	/**
	 * Insert list product for detail purchase invoice id
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
	 * Delete list product of purchase invoice
	 * @author trungpm
	 */
	public function deleteListProduct($purchaseInvoiceId, $voucherId, $listProduct = array())
	{
		$db = $this->getAdapter();
		if(!empty($listProduct) && (count($listProduct) > 0)){
			foreach($listProduct as $item){
				$row = $this->fetchRow(array(
				$db->quoteInto('purchase_invoice_id = ?', $purchaseInvoiceId),
				$db->quoteInto('product_id = ?', $item['product_id']),
				$db->quoteInto('unit_id = ?', $item['unit_id'])));
				if (isset($row)) {
					$this->delete(array(
					$db->quoteInto('purchase_invoice_id = ?', $purchaseInvoiceId),
					$db->quoteInto('product_id = ?', $item['product_id']),
					$db->quoteInto('unit_id = ?', $item['unit_id'])));
				}
				// delete transaction entry of product
				$transactionEntry = Quick::single('accountant/purchase_invoice')->cache()->getTransactionEntryOfPurchaseInvoiceId($purchaseInvoiceId, $voucherId, $item['product_id'], $item['unit_id']);
				foreach($transactionEntry as $itemEntry){
					Quick::single('accountant/transaction_entry')->cache()->deleteTransactionEntryById($itemEntry['entry_id']);
				}
			}
			return true;
		}
		return false;
	}

}
