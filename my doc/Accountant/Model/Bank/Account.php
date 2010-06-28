<?php
class Quick_Accountant_Model_Bank_Account extends Quick_Db_Table
{
	protected $_name = 'accountant_bank_account';

	public function getBankAccountByBankId($bankId)
	{
		$select = $this->getAdapter()->select();
		$select->from(array('aba' => $this->_name), 
			array('bank_account_id','bank_id', 'bank_account_number'))
		->where('aba.bank_id = ?', $bankId);
		
		return $this->getAdapter()->fetchAll($select->__toString());
	}
}