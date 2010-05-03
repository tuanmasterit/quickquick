<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @author      trungpm
 */
class Quick_Accountant_Remoter_MaintenanceRemoter{

	/**
	 * Retrieve definition_list_account object by tree data id
	 *
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
					'icon' => '',
					'parent_id' => $account['account_parent_id']
			);
			$i++;
		}
		return $result;
	}
	
	/**
	 * Retrieve detail for accountant, definition_list_table
	 *
	 * @return array Functions|mixed
	 */
	public static function getListTables()
	{
		return Quick::single('core/definition_table')->cache()->getTables();
	}
	
	/**
	 * Retrieve detail of accountant object by id
	 *
	 * @return array Functions|mixed
	 */
	public static function getDetailOfNode($node)
	{
		return Quick::single('core/definition_account')->cache()->getDetailOfNode($node);
	}
	
	/**
	 * Retrieve detail for table id of accountant object by table id
	 *
	 * @return array Functions|mixed
	 */
	public static function getDetailAccountByTable($table, $node, $limit, $start, &$total)
	{
		
		return Quick::single('core/definition_account')->cache()->getDetailAccountByTable($table, $node, $limit, $start, &$total);
	}
	
	/**
	 * Update detail account by table, account, value
	 *
	 * @return boolean $result
	 */
	public static function updateDetailAccount($accountId, $tableId, $detailId, $value)
	{
		
		return Quick::single('core/definition_detail_account')->cache()->updateDetailAccount($accountId, $tableId, $detailId, $value);
	}
}
