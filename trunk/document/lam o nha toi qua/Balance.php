<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Model
 * @author      tuvv
 */
class Quick_Accountant_Model_Account_Balance extends Quick_Db_Table
{
	protected $_name = 'accountant_account_balance';
	protected $_TABLE_DEFINITION_LIST_ACCOUNT	= 'definition_list_account';
	
	/**
	 * @desc get list balance credit
	 * @author tuvv
	 * @return array
	 */
	public function getBalance($limit, $start, $period_id, $debit_credit, &$total)
	{	
		// paging sixe
		if (!isset($start) && empty($start)) {
			$start = 0;
		}
		$pagingSize = '';
		if (isset($limit) && ($limit > 0)) {
			$pagingSize = " LIMIT $start, $limit";
		}
		// end paging size
		$sql = "SELECT aab.period_id, aab.account_id, aab.currency_id, aab.debit_credit, aab.original_amount, aab.converted_amount, ".
 				"dla.account_code , dla.account_name, dlc.currency_code, dlc.currency_name ".
				" FROM accountant_account_balance as aab ".
				" left join definition_list_account as dla on aab.account_id = dla.account_id ".
				" left join definition_list_currency as dlc on aab.currency_id = dlc.currency_id ".
				" where dla.inactive = 0 and dlc.inactive = 0 and aab.debit_credit = ".$debit_credit." and aab.period_id = ".$period_id;
		
		
		$total = count($this->getAdapter()->fetchAll($sql));
		$sql .= $pagingSize;
		
		$result = $this->getAdapter()->fetchAll($sql);		
		
		// filter data
		$result_new = array();
		$i = 0;
		foreach($result as $rs){
			$result_new[$i]['id'] = $rs['period_id'].'_'.$rs['account_id'].'_'.$rs['currency_id'];
			$result_new[$i]['period_id'] = $rs['period_id'];
			$result_new[$i]['account_id'] = $rs['account_id'];
			$result_new[$i]['currency_id'] = $rs['currency_id'];
			$result_new[$i]['debit_credit'] = $rs['debit_credit'];
			$result_new[$i]['original_amount'] = Quick_Number::formatNumber($rs['original_amount']);
			$result_new[$i]['converted_amount'] = Quick_Number::formatNumber($rs['converted_amount']);
			$result_new[$i]['account_code'] = $rs['account_code'];
			$result_new[$i]['account_name'] = $rs['account_name'];
			$result_new[$i]['currency_code'] = $rs['currency_code'];
			$result_new[$i]['currency_name'] = $rs['currency_name'];	
			$result_new[$i]['change'] = -1;
			$i++;
		}
		return $result_new;
	}
	
	/**
	 * Update field balance
	 * @author	tuvv
	 * @return array
	 */
	public function updateAccountBalance($arrBalance)
	{	
		$result = '';
		$db = $this->getAdapter();
		$arrTmp = array();
		
		for($i = 0; $i < count($arrBalance); $i++){
			list($period_id, $account_id, $currency_id) = explode('_', $arrBalance[$i]['id'], 3);
			
			$arrTmp['period_id'] = $arrBalance[$i]['period_id'];
			$arrTmp['account_id'] = $arrBalance[$i]['account_id'];
			$arrTmp['currency_id'] = $arrBalance[$i]['currency_id'];
			$arrTmp['debit_credit'] = $arrBalance[$i]['debit_credit'];
			$arrTmp['original_amount'] = $arrBalance[$i]['original_amount'];
			$arrTmp['converted_amount'] = $arrBalance[$i]['converted_amount'];
			
			$row = $this->fetchRow(array(
				$db->quoteInto('currency_id = ?', $currency_id),
				$db->quoteInto('account_id = ?', $account_id),
				$db->quoteInto('period_id = ?', $period_id)));
			if (isset($row)) {
				if($this->update($arrTmp, array($db->quoteInto('currency_id = ?', $currency_id),
												$db->quoteInto('account_id = ?', $account_id),
												$db->quoteInto('period_id = ?', $period_id)))){
					$result = $result." ".$arrTmp['period_id'].'_'.$arrTmp['account_id'].'_'.$arrTmp['currency_id'];														
				}
			}else{
				if($this->insert($arrTmp)){
					$result = $result." ".$arrTmp['period_id'].'_'.$arrTmp['account_id'].'_'.$arrTmp['currency_id'];
				}
			}
		}		
		return $result;
	}
	
	/**
	 * Delete Account Balance
	 * @author	tuvv
	 * @return array
	 */
	public function deleteAccountBalance($arrRecord)
	{	
		$db = $this->getAdapter();
		$success = array();
		$fail = array();
		for($i = 0; $i < count($arrRecord); $i++){
			list($period_id, $account_id, $currency_id) = explode('_', $arrRecord[$i]['id'], 3);
			
			$row = $this->fetchRow(array(
				$db->quoteInto('currency_id = ?', $currency_id),
				$db->quoteInto('account_id = ?', $account_id),
				$db->quoteInto('period_id = ?', $period_id)));
				
			if (isset($row)) {
				if($this->delete(array($db->quoteInto('currency_id = ?', $currency_id),
												$db->quoteInto('account_id = ?', $account_id),
												$db->quoteInto('period_id = ?', $period_id)))){
					$success[count($success)] = $arrRecord[$i]['id'];
				}else{
					$fail[count($fail)] = $arrRecord[$i]['id'];
				}
			}else{
				$fail[count($fail)] = $arrRecord[$i]['id'];
			}
		}
		
		$result = array(
			'success' => $success,
			'fail' => $fail
		);
		
		return $result;
	}
	
	/**
     * bang can doi tai khoan
     * @author trungpm
     * @return array
     */
    public function getAccountBalance() 
	{
        $query = "select listAcc.account_id, listAcc.account_code, listAcc.account_name, tk.* from definition_list_account as listAcc 

					left join (
					select account_id, sum(phatsinhno) as sum_phatsinh_no, sum(phatsinhco) as sum_phatsinh_co  from (
					
					select detail.account_id, debit_credit, 
					if(debit_credit = -1, sum(amount), 0) as phatsinhno,
					if(debit_credit = 1, sum(amount), 0) as phatsinhco
					
					 from (
					select master_account_id as account_id, debit_credit, sum(converted_amount) as amount
					
					from accountant_transaction_entry
					
					group by batch_id, master_account_id, debit_credit 
					
					union all
					
					select detail_account_id as account_id, debit_credit, sum(converted_amount) as amount
					
					from accountant_transaction_correspondence
					group by detail_account_id, debit_credit ) as detail
					group by account_id, debit_credit) as detail2
					
					group by account_id) as tk
					
					on tk.account_id = listAcc.account_id
					
					order by listAcc.account_id
					
					";

        return $this->getAdapter()->fetchAll($query);
    }
}
?>