<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Accountant_Model_Transaction_Entry extends Quick_Db_Table
{
	protected $_name 										= 'accountant_transaction_entry';
	protected $_TABLE_ACCOUNTANT_DETAIL_ENTRY				= 'accountant_detail_entry';
	protected $_TABLE_DEFINITION_LIST_PRODUCT				= 'definition_list_product';
	protected $_TABLE_DEFINITION_LIST_UNIT					= 'definition_list_unit';
	protected $_TABLE_ACCOUNTANT_TRANSACTION_BATCH			= 'accountant_transaction_batch';
	protected $_TABLE_ACCOUNTANT_TRANSACTION_ENTRY 			= 'accountant_transaction_entry';
	protected $_TABLE_DEFINITION_LIST_ACCOUNT				= 'definition_list_account';
	protected $_TABLE_DEFINITION_LIST_CURRENCY				= 'definition_list_currency';
	protected $_TABLE_ACCOUNTANT_TRANSACTION_CORRESPONDENCE = 'accountant_transaction_correspondence';
	protected $_TABLE_ACCOUNTANT_TRANSACTION_VOUCHER 		= 'accountant_transaction_voucher';
	protected $_TABLE_ACCOUNTANT_ASSETS_DEPRECIATION		= 'accountant_assets_depreciation';

	/**
	 * Retrieve detail transaction entry by batch id
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public function getDetailEntryByBatchId($batchId)
	{
		$query = "SELECT ate.entry_id, ate.master_account_id, ate.original_amount,
						 ate.forex_rate, ate.converted_amount, ate.debit_credit,
						 dla.account_name,
						 dlc.currency_name, dlc.currency_id,
						 ade.product_id, ade.unit_id, 
						 CONCAT(dlp.product_name, ' - ', dlu.unit_name) AS product_unit_name,
						 CONCAT(ade.product_id, '_', ade.unit_id) AS detail_purchase_id         
				  FROM `". $this->_name ."` AS ate  
				  LEFT JOIN `". $this->_TABLE_DEFINITION_LIST_ACCOUNT ."` AS dla 
				  ON dla.account_id = ate.master_account_id 				  				  
				  LEFT JOIN `". $this->_TABLE_DEFINITION_LIST_CURRENCY ."` AS dlc 
				  ON dlc.currency_id = ate.currency_id 
				  LEFT JOIN (
				  	SELECT ade1.entry_id, ade1.detail_id as product_id, ade2.unit_id  
				  	FROM accountant_detail_entry ade1 
				  	JOIN ( 
				  		SELECT ade3.entry_id, ade3.detail_id AS unit_id from accountant_detail_entry ade3
				  		WHERE ade3.table_id = " . Quick_Accountant_Remoter_BuyBilling::DEFAULT_TABLE_UNIT_TYPE ." ) ade2
				  	ON ade1.entry_id = ade2.entry_id 
				  	WHERE ade1.table_id = " . Quick_Accountant_Remoter_BuyBilling::DEFAULT_TABLE_PRODUCT_TYPE ."  
				  ) AS ade 
				  ON ade.entry_id = ate.entry_id 
				  LEFT JOIN `". $this->_TABLE_DEFINITION_LIST_PRODUCT ."` AS dlp 
				  ON dlp.product_id = ade.product_id 
				  LEFT JOIN `". $this->_TABLE_DEFINITION_LIST_UNIT ."` AS dlu 
				  ON dlu.unit_id = ade.unit_id    
				  WHERE ate.batch_id = $batchId";

		return $this->getAdapter()->fetchAll($query);
	}
	protected $_ACCOUNTANT_TRANSACTION_CORRESPONDENCE = 'accountant_transaction_correspondence';

	/**
	 * @author: bichttn
	 */
	public function getEntry($batchId, $limit, $start, &$total)
	{
		$query = "SELECT
						ate.entry_id AS entry_id, 
						ate.batch_id  AS batch_id,  
						ate.master_account_id As master_account_id,
						ate.debit_credit As debit_credit,
						ate.original_amount As original_amount,
						ate.currency_id  As currency_id,
						ate.forex_rate As forex_rate,
						ate.converted_amount As converted_amount
						
				  FROM  ". $this->_name ." AS ate ";
		$where = " WHERE ate.batch_id = ". $batchId;

		$query_data= $query." ". $where. " LIMIT $start, $limit";

		$query_total = "SELECT COUNT(entry_id) FROM  ". $this->_name ." AS ate ". $where;
		$total = $this->getAdapter()->fetchOne($query_total);

		return $this->getAdapter()->fetchAll($query_data);

	}

	/**
	 * @author: bichttn
	 */
	public function getEntryByVoucherId($voucherId)
	{
		$query = "SELECT
						ate.entry_id AS entry_id, 
						ate.batch_id  AS batch_id,  
						ate.master_account_id As master_account_id,
						ate.debit_credit As debit_credit,
						ate.original_amount As original_amount,
						ate.currency_id  As currency_id,
						ate.forex_rate As forex_rate,
						ate.converted_amount As converted_amount				
				  FROM  ". $this->_name ." AS ate 
				  INNER JOIN ". $this->_TABLE_ACCOUNTANT_TRANSACTION_BATCH. " AS atb
				  		ON 	ate.batch_id = atb.batch_id ";
		$where = " WHERE atb.voucher_id = ". $voucherId;
		$query_data = $query." ". $where;

		return $this->getAdapter()->fetchRow($query_data);

	}
	/**
	 * @author: bichttn
	 */
	public function getCorrespondenceByEntryId($entryId)
	{
		/*$select = $this->getAdapter()->select();
		 $select->from(array('atc' => $this->_ACCOUNTANT_TRANSACTION_CORRESPONDENCE),
		 array('correspondence_id', 'detail_account_id', 'debit_credit', 'currency_id', 'forex_rate', 'converted_amount'))
		 ->where('atc.entry_id = ?', $entryId);

		 return $this->getAdapter()->fetchAll($select->__toString());*/

		$query = "SELECT
						atc.correspondence_id AS correspondence_id,
						atc.detail_account_id AS detail_account_id,
						atc.debit_credit As debit_credit,
						atc.original_amount As original_amount,
						atc.currency_id  As currency_id,
						atc.forex_rate As forex_rate,
						atc.converted_amount As converted_amount
						
				  FROM  ". $this->_ACCOUNTANT_TRANSACTION_CORRESPONDENCE. " AS atc
				   
				  WHERE atc.entry_id = ". $entryId;
			

		return $this->getAdapter()->fetchAll($query);

	}


	/**
	 * Insert accountant transaction entry
	 * @author	bichttn
	 * @return array
	 */
	public function insertEntry($entry = array())
	{
		if(!empty($entry)){
			return $this->insert($entry);
		}
		return false;
	}

	/**
	 * @desc update entry
	 *
	 * @author bichttn
	 * @return array
	 */
	public function updateEntry($entryId, $field, $value)
	{
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('entry_id = ?', $entryId)));

		if (isset($row)) {
			$row = array(
			$field => $value
			);
			return $this->update($row, $db->quoteInto('entry_id = ?', $entryId));
		}

		return false;
	}

	/**
	 * Retrieve update field of transaction entry
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public function updateFieldOfEntry($entryId, $field, $value)
	{
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('entry_id  = ?', $entryId)));

		if (isset($row)) {
			$row = array($field => $value);
			return $this->update($row, $db->quoteInto('entry_id  = ?', $entryId));
		}
		return false;
	}

	/**
	 * Retrieve update record of transaction entry
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public function updateRecordTransactionEntry($row, $entryId)
	{
		$db = $this->getAdapter();
		if (isset($row)) {
			return $this->update($row, $db->quoteInto('entry_id = ?', $entryId));
		}
		return false;
	}

	/**
	 * 	Update TransactionEntry
	 *	@author datnh
	 */
	public function updateTransactionEntry($entry_id, $master_account_id, $debit_credit) {
		$db = $this->getAdapter();
		$row = $this->fetchRow(array($db->quoteInto('entry_id = ?', $entry_id)));
		if (isset($row)) {
			$row = array(
				'master_account_id' => $master_account_id,
				'debit_credit' => $debit_credit			
			);
			return $this->update($row, $db->quoteInto('entry_id = ?', $entry_id));
		}
	}

	/**
	 * Delete transaction entry with entry id
	 * @author trungpm
	 */
	public function deleteTransactionEntryById($entryId)
	{
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('entry_id = ?', $entryId)));
		if (isset($row)) {
			return $this->delete(array(
			$db->quoteInto('entry_id = ?', $entryId)));
		}
		return false;
	}

	/**
	 * Get transaction_entry by voucher_id
	 * @author datnh
	 *
	 */
	public function getTransactionEntryByVoucherId($voucher_id) {
		if($voucher_id == null || $voucher_id == 0) return false;
		$query = $this->getAdapter()->select();
		$query->from(array('ate' => $this->_name),
		array('atb.voucher_id',
					'ate.entry_id',
					'ate.batch_id',
					'ate.master_account_id',
					'ate.debit_credit',
					'ate.original_amount',
					'ate.currency_id',
					'ate.forex_rate',
					'ate.converted_amount',
					'dla.account_code',
					'dla.account_name',
					'dla.account_parent_id',
					'dla.account_note',
					'dla.debit_credit_balance',
					'dlc.currency_code',
					'dlc.currency_name'))	
		->joinLeft(
		array('atb'=> $this->_TABLE_ACCOUNTANT_TRANSACTION_BATCH),'ate.batch_id = atb.batch_id')
		->joinLeft(
		array('dla'=> $this->_TABLE_DEFINITION_LIST_ACCOUNT), 'ate.master_account_id = dla.account_id')
		->joinLeft(
		array('dlc'=> $this->_TABLE_DEFINITION_LIST_CURRENCY),'ate.currency_id = dlc.currency_id')
		->where('atb.voucher_id = ?', $voucher_id);

		return $this->getAdapter()->fetchAll($query->__toString());
	}

	/**
	 * Get entry_debit_credit list of depreciation by assets_voucher_id
	 * @author datnh
	 */
	public function getEntryDebitOfDepreciationByAssetVoucherId($assets_voucher_id) {
		if($assets_voucher_id == null || $assets_voucher_id == 0) return false;
		$query = "SELECT
				aad.assets_voucher_id,
				aad.depreciation_date,
				aad.voucher_id,
				aad.depreciation_note,
				aad.depreciation_amount,
				ate.entry_id,
				ate.batch_id,
				ate.debit_credit,
				if(aad.depreciation_amount=0 OR ate.forex_rate=0,0,aad.depreciation_amount/ate.forex_rate)AS original_amount,
				ate.currency_id,
				ate.forex_rate,
				aad.depreciation_amount AS converted_amount,
				dla.account_id,
				dla.account_code,
				dla.account_name,
				dla.account_parent_id,
				dla.account_note,
				dla.debit_credit_balance,
				dlc.currency_id,
				dlc.currency_code,
				dlc.currency_name,
				null AS correspondence_id,
				1 AS is_master,
				if(ate.debit_credit= -1,if(ate.master_account_id=1,null,ate.master_account_id), null ) AS debit_account_id,
				if(ate.debit_credit = -1,null, if(ate.master_account_id=1,null,ate.master_account_id) ) AS credit_account_id
			FROM
				accountant_assets_depreciation AS aad
				Left Join accountant_transaction_voucher AS atv ON aad.voucher_id = atv.voucher_id
				Left Join accountant_transaction_batch AS atb ON atv.voucher_id = atb.voucher_id
				Left Join accountant_transaction_entry AS ate ON atb.batch_id = ate.batch_id
				Left Join definition_list_account AS dla ON ate.master_account_id = dla.account_id
				Left Join definition_list_currency AS dlc ON ate.currency_id = dlc.currency_id";
		if($assets_voucher_id > 0) {
			$query .= " WHERE aad.assets_voucher_id = ".$assets_voucher_id;
		}
		$query .= "	UNION ALL
		
			SELECT
				aad.assets_voucher_id,
				aad.depreciation_date,
				aad.depreciation_note,
				aad.depreciation_amount,
				atb.voucher_id,
				atc.entry_id,
				ate.batch_id,
				atc.debit_credit,
				atc.original_amount,
				atc.currency_id,
				atc.forex_rate,
				atc.converted_amount,
				dla.account_id,
				dla.account_code,
				dla.account_name,
				dla.account_parent_id,
				dla.account_note,
				dla.debit_credit_balance,
				dlc.currency_id,
				dlc.currency_code,
				dlc.currency_name,
				atc.correspondence_id,
				0 AS is_master,
				if(atc.debit_credit =  -1,if(atc.detail_account_id=1,null,atc.detail_account_id), null ) AS debit_account_id,
				if(atc.debit_credit =  -1,null, if(atc.detail_account_id=1,null,atc.detail_account_id)) AS credit_account_id
			FROM
				accountant_transaction_correspondence AS atc
				Left Join accountant_transaction_entry AS ate ON atc.entry_id = ate.entry_id
				Left Join accountant_transaction_batch AS atb ON ate.batch_id = atb.batch_id
				Left Join accountant_transaction_voucher AS atv ON atb.voucher_id = atv.voucher_id
				Left Join accountant_assets_depreciation AS aad ON atv.voucher_id = aad.voucher_id
				Left Join definition_list_account AS dla ON atc.detail_account_id = dla.account_id
				Left Join definition_list_currency AS dlc ON atc.currency_id = dlc.currency_id";
		if($assets_voucher_id > 0) {
			$query .= " WHERE aad.assets_voucher_id = ".$assets_voucher_id;
		}
		$query .= " ORDER BY depreciation_date, entry_id, correspondence_id";
			
		return $this->getAdapter()->fetchAll($query);
	}

	/**
	 * Get entry_id from assets_voucher
	 * @author datnh
	 */
	public function getEntryIdByAssetVoucherId($assets_voucher_id) {
		$query = "SELECT ate.entry_id
					FROM
					accountant_assets_voucher AS aav
					Left Join accountant_transaction_voucher AS atv ON aav.voucher_id = atv.voucher_id
					Left Join accountant_transaction_batch AS atb ON atv.voucher_id = atb.voucher_id
					Inner Join accountant_transaction_entry AS ate ON atb.batch_id = ate.batch_id
					WHERE
					aav.assets_voucher_id =  ".$assets_voucher_id;
		return $this->getAdapter()->fetchRow($query);
	}

	/**
	 * Update transaction entry by asset voucher
	 * @author datnh
	 */
	public function updateEntryByAssetVoucher($data, $entry) {
		$db = $this->getAdapter();
		$row = $this->fetchRow(array(
		$db->quoteInto('entry_id = ?', $entry['entry_id'])));

		if (isset($row)) {
			$row = array(
				'original_amount' => $data['gross_cost'],
				'currency_id' => $data['currency_id'],
				'forex_rate' => $data['forex_rate'],
				'converted_amount' => $data['gross_cost'] * $data['forex_rate']
			);
			$this->update($row, $db->quoteInto('entry_id = ?', $entry['entry_id']));
		}

		return true;
	}

	/**
	 * Get all transascstion_entry by assets_voucher_id
	 * (entries of assets_voucher + entries of assets_depreciation)
	 * @author datnh
	 */
	public function getTransactionEntryByAssetsVoucherId($assets_voucher_id) {
		$query = "SELECT ate.*, 1 AS from_assets_voucher
			FROM
				accountant_assets_voucher AS aav
				Left Join accountant_transaction_voucher AS atv ON aav.voucher_id = atv.voucher_id
				Left Join accountant_transaction_batch AS atb ON atv.voucher_id = atb.voucher_id
				Left Join accountant_transaction_entry AS ate ON atb.batch_id = ate.batch_id
			WHERE
				aav.assets_voucher_id =  ".$assets_voucher_id;
			
		$query .= "	UNION ALL
			
			SELECT ate.*, 0 AS from_assets_voucher
			FROM
				accountant_assets_depreciation AS aad
				Inner Join accountant_transaction_voucher AS atv ON aad.voucher_id = atv.voucher_id
				Inner Join accountant_transaction_batch AS atb ON atv.voucher_id = atb.voucher_id
				Inner Join accountant_transaction_entry AS ate ON atb.batch_id = ate.batch_id
			WHERE
				aad.assets_voucher_id =  ".$assets_voucher_id;

		return $this->getAdapter()->fetchAll($query);
	}

	/**
	 * Delete transaction entry with entry id
	 * @author trungpm
	 */
	public function deleteTransactionEntryByBatchId($batchId)
	{
		$db = $this->getAdapter();
		if($db->fetchOne("SELECT count(batch_id) FROM `$this->_name` WHERE `batch_id` = $batchId") > 0){
			return $this->delete(array($db->quoteInto('batch_id = ?', $batchId)));
		}
		return true;
	}

	/**
	 * Get Entry by batch id, table id, debit or credit default null
	 * @author trungpm
	 *
	 */
	public function geTransactionEntryByBatchId($batchId) {
		$select = $this->getAdapter()->select();
		$select->from(array('ate' => $this->_name),
		array('ate.*'))
		->where('ate.batch_id = ?', $batchId);
		return $this->getAdapter()->fetchAll($select->__toString());
	}

	/**
	 * Update transaction entry with set, where
	 * @author	trungpm
	 * @return array
	 */
	public function updateTransactionEntryWithSetAndWhere($set, $where)
	{
		$db = $this->getAdapter();
		$db->update($this->_name, $set, $where);
	}

	/**
	 * Update transaction entry with set, where
	 * @author	trungpm
	 * @return array
	 */
	public function updateTransactionEntryWithArrayEntryIdAndSet($arrEntryId, $set)
	{
		if(count($arrEntryId)){
			$db = $this->getAdapter();
			$whereEntry = '(';
			foreach($arrEntryId as $entryId){
				if($whereEntry == '(') $whereEntry .= "entry_id = " . $entryId['entry_id'];
				else $whereEntry .= " OR entry_id = " . $entryId['entry_id'];
			}
			$whereEntry .= ')';
			return $db->update($this->_name, $set, $whereEntry);
		}
		return 0;
	}
}
