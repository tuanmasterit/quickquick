<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @author      trungpm
 */
class Quick_Accountant_Remoter_AccountSystem {

	/**
	 * Retrieve definition_list_account object by tree data id
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function getAccountOfNode($node)
	{
		$result = array();
		$accounts = Quick::single('core/definition_account')->cache()->getAccountOfNode($node);
		$i = 0;
		foreach ($accounts as $account) {
			$result[$i] = array(
                    'text' => $account['account_code'] . '-' . $account['account_name'],
                    'id' => $account['account_id'],
                    'name' => $account['account_id'],                   
                    'leaf' => false,
					'cls'=>'tree-new-icon',
					'parent_id' => $account['account_parent_id']
			);
			$i++;
		}
		return $result;
	}

	/**
	 * Retrieve detail for accountant, definition_list_table
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function getListTables()
	{
		return Quick::single('core/definition_table')->cache()->getTables();
	}

	/**
	 * Retrieve detail of accountant object by id
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function getDetailOfNode($node)
	{
		return Quick::single('core/definition_account')->cache()->getDetailOfNode($node);
	}

	/**
	 * Retrieve detail for table id of accountant object by table id
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function getDetailAccountByTable($table, $node, $limit, $start, &$total)
	{

		return Quick::single('core/definition_account')->cache()->getDetailAccountByTable($table, $node, $limit, $start, &$total);
	}

	/**
	 * Update detail account by table, account, value
	 * @author	trungpm
	 * @return boolean $result
	 */
	public static function updateDetailAccount($accountId, $tableId, $detailId, $value)
	{

		return Quick::single('core/definition_detail_account')->cache()->updateDetailAccount($accountId, $tableId, $detailId, $value);
	}

	/**
	 * Update field of Account by id
	 *
	 * @return array
	 */
	public static function updateFieldOfAccount($accountId, $field, $value)
	{

		return Quick::single('core/definition_account')->cache()->updateFieldOfAccount($accountId, $field, $value);
	}

	/**
	 * Insert Account by data array
	 * @author	trungpm
	 * @return array
	 */
	public static function insertAccount($accountCode, $accountName, $accountNote, $accountParentId)
	{
		$account = array(
			'account_code'=> $accountCode,
			'account_name' => $accountName,
			'account_parent_id' => $accountParentId,
			'account_note' => $accountNote,
			'inactive' => 0,
			'created_by_userid' => Quick::session()->userId,
			'date_entered' => Quick_Date::now()->toSQLString(),
			'last_modified_by_userid' => Quick::session()->userId,
			'date_last_modified' => Quick_Date::now()->toSQLString()
		);
		$newId = Quick::single('core/definition_account')->cache()->insertAccount($account);
		if($newId){
			$newAccount = array(
                    'text' => $accountCode . '-' . $accountName,
                    'id' => $newId,
                    'name' => $accountName,                   
                    'leaf' => false,
					'cls'=>'tree-new-icon',
					'parent_id' => $accountParentId
			);
			return $newAccount;
		}else{
			return null;
		}
	}

	/**
	 * Update parent account id of Account
	 * @author	trungpm
	 * @return true||false
	 */
	public static function updateAccountNode($sourceId, $targetId)
	{
		return Quick::single('core/definition_account')->cache()->updateAccountNode($sourceId, $targetId);
	}

	/**
	 * Delete account by id
	 * @author	trungpm
	 * @return true||false
	 */
	public static function deleteNode($accountId)
	{
		$accounts = Quick::single('core/definition_account')->cache()->getAccountOfNode($accountId);
		$status = false;
		foreach($accounts as $account){
			if(!self::deleteNode($account['account_id'])){
				$status = true;
				break;
			}
		}
		if($status){
			return false;
		}else{
			return Quick::single('core/definition_account')->cache()->deleteAccount($accountId); 
		}		
	}
}
